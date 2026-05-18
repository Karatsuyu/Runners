from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import Category, Commerce, Product, Order
from apps.users.models import User
from .serializers import (
    CategorySerializer, CommerceSerializer, CommerceDetailSerializer,
    ProductSerializer, OrderSerializer, OrderCreateSerializer
)
from .serializers import CommerceMenuFileSerializer
from .models import CommerceMenuFile
from apps.users.permissions import IsAdmin, IsAdminOrReadOnly


class CategoryListView(generics.ListCreateAPIView):
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [IsAdminOrReadOnly]


class CategoryDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [IsAdmin]


class CommerceListView(generics.ListCreateAPIView):
    serializer_class = CommerceSerializer
    permission_classes = [IsAdminOrReadOnly]

    def get_queryset(self):
        queryset = Commerce.objects.filter(is_active=True)
        category = self.request.query_params.get('category')
        business_type = self.request.query_params.get('business_type')
        if category:
            queryset = queryset.filter(category_id=category)
        if business_type:
            queryset = queryset.filter(business_type=business_type)
        return queryset


class CommerceDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Commerce.objects.all()
    permission_classes = [IsAdminOrReadOnly]

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return CommerceDetailSerializer
        return CommerceSerializer


class CommerceAdminListView(generics.ListCreateAPIView):
    """Vista para administradores: acceso total a todas las tiendas (activas e inactivas)"""
    queryset = Commerce.objects.all()
    serializer_class = CommerceSerializer
    permission_classes = [IsAdmin]

    def get_queryset(self):
        queryset = Commerce.objects.all()
        category = self.request.query_params.get('category')
        is_active = self.request.query_params.get('is_active')
        
        if category:
            queryset = queryset.filter(category_id=category)
        if is_active is not None:
            queryset = queryset.filter(is_active=is_active.lower() == 'true')
        
        return queryset.order_by('-created_at')


class CommerceAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Vista para administradores: edición/eliminación completa de tiendas"""
    queryset = Commerce.objects.all()
    serializer_class = CommerceSerializer
    permission_classes = [IsAdmin]


class ProductListView(generics.ListCreateAPIView):
    serializer_class = ProductSerializer
    permission_classes = [IsAdminOrReadOnly]

    def get_queryset(self):
        commerce_id = self.kwargs.get('commerce_pk')
        return Product.objects.filter(commerce_id=commerce_id, is_available=True)


class ProductDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAdminOrReadOnly]


class OrderCreateView(generics.CreateAPIView):
    serializer_class = OrderCreateSerializer
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        order = serializer.save()
        return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)


class OrderListView(generics.ListAPIView):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        from apps.users.models import User
        if user.role == User.Role.ADMIN:
            queryset = Order.objects.all()
            commerce = self.request.query_params.get('commerce')
            if commerce:
                queryset = queryset.filter(commerce_id=commerce)
        else:
            queryset = Order.objects.filter(client=user)

        status_filter = self.request.query_params.get('status')
        if status_filter:
            queryset = queryset.filter(status=status_filter)
        return queryset


class OrderDetailView(generics.RetrieveUpdateAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        order = super().get_object()
        from apps.users.models import User
        if self.request.user.role != User.Role.ADMIN and order.client != self.request.user:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied('No tienes permiso para ver este pedido.')
        return order


class CommerceMenuFileListCreateView(generics.ListCreateAPIView):
    serializer_class = CommerceMenuFileSerializer
    permission_classes = [IsAdminOrReadOnly]

    def get_queryset(self):
        commerce_id = self.kwargs.get('commerce_pk')
        return CommerceMenuFile.objects.filter(commerce_id=commerce_id).order_by('-created_at')

    def perform_create(self, serializer):
        commerce_id = self.kwargs.get('commerce_pk')
        commerce = Commerce.objects.get(pk=commerce_id)
        # infer file_type from extension
        file = self.request.FILES.get('file')
        file_type = None
        if file:
            name = file.name.lower()
            if name.endswith('.pdf'):
                file_type = CommerceMenuFile.FileType.PDF
            else:
                file_type = CommerceMenuFile.FileType.IMAGE
        obj = serializer.save(commerce=commerce, file_type=file_type)
        try:
            print(f"[DEBUG] CommerceMenuFile saved id={getattr(obj, 'id', None)} file_name={getattr(obj.file, 'name', None)} file_path={getattr(obj.file, 'path', None)}")
        except Exception as e:
            print(f"[DEBUG] CommerceMenuFile saved but error printing file info: {e}")

    def create(self, request, *args, **kwargs):
        # Debugging: log incoming data and files to help diagnose 400s
        try:
            commerce_id = self.kwargs.get('commerce_pk')
            print(f"[DEBUG] CommerceMenuFileListCreateView.create called for commerce={commerce_id}")
            print(f"[DEBUG] request.data keys: {list(request.data.keys())}")
            print(f"[DEBUG] request.FILES keys: {list(request.FILES.keys())}")
        except Exception as e:
            print(f"[DEBUG] error logging request: {e}")
        return super().create(request, *args, **kwargs)


class CommerceMenuFileDetailView(generics.RetrieveDestroyAPIView):
    queryset = CommerceMenuFile.objects.all()
    serializer_class = CommerceMenuFileSerializer
    permission_classes = [IsAdmin]
    def destroy(self, request, *args, **kwargs):
        # Robust destroy: lookup by commerce_pk and pk to avoid get_object surprises
        commerce_pk = kwargs.get('commerce_pk') or request.parser_context.get('kwargs', {}).get('commerce_pk')
        pk = kwargs.get('pk') or request.parser_context.get('kwargs', {}).get('pk')
        print(f"[DEBUG] CommerceMenuFileDetailView.destroy called commerce_pk={commerce_pk} pk={pk}")

        try:
            user = request.user
            user_info = f"user={getattr(user, 'id', None)} username={getattr(user, 'username', None)} role={getattr(user, 'role', None)}"
        except Exception:
            user_info = 'user=unknown'
        print(f"[DEBUG] Request user: {user_info}")

        if commerce_pk is None or pk is None:
            return Response({'detail': 'commerce_pk and pk are required in URL.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            obj = CommerceMenuFile.objects.get(id=pk, commerce_id=commerce_pk)
        except CommerceMenuFile.DoesNotExist:
            print(f"[DEBUG] CommerceMenuFile not found for commerce={commerce_pk} id={pk}")
            return Response({'detail': 'Archivo no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

        # Permission check: ensure user is admin
        try:
            if not (request.user.is_authenticated and getattr(request.user, 'role', None) == getattr(User.Role, 'ADMIN')):
                print(f"[DEBUG] Permission denied for user: {user_info}")
                return Response({'detail': 'No tienes permiso para eliminar este archivo.'}, status=status.HTTP_403_FORBIDDEN)
        except Exception:
            # Fallback to deny
            return Response({'detail': 'No tienes permiso para eliminar este archivo.'}, status=status.HTTP_403_FORBIDDEN)

        # Log object and attempt deletion
        try:
            print(f"[DEBUG] Deleting CommerceMenuFile id={obj.id} commerce_id={obj.commerce_id} file={getattr(obj.file, 'name', None)}")
            obj.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            print(f"[DEBUG] error during delete: {e}")
            return Response({'detail': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    
