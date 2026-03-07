from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import Category, Commerce, Product, Order
from .serializers import (
    CategorySerializer, CommerceSerializer, CommerceDetailSerializer,
    ProductSerializer, OrderSerializer, OrderCreateSerializer
)
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
        if category:
            queryset = queryset.filter(category_id=category)
        return queryset


class CommerceDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Commerce.objects.all()
    permission_classes = [IsAdminOrReadOnly]

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return CommerceDetailSerializer
        return CommerceSerializer


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
