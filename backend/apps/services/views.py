from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.utils import timezone
from .models import ServiceCategory, ServiceProvider, ServiceRequest
from .serializers import (
    ServiceCategorySerializer, ServiceProviderSerializer,
    ServiceProviderRegisterSerializer, ServiceRequestSerializer
)
from apps.users.permissions import IsAdmin, IsAdminOrReadOnly, IsPrestador
from apps.users.models import User


class ServiceCategoryListView(generics.ListCreateAPIView):
    queryset = ServiceCategory.objects.filter(is_active=True)
    serializer_class = ServiceCategorySerializer
    permission_classes = [IsAdminOrReadOnly]


class ServiceProviderListView(generics.ListAPIView):
    serializer_class = ServiceProviderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        queryset = ServiceProvider.objects.filter(approval_status='APROBADO', status='DISPONIBLE')
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category_id=category)
        return queryset


class RegisterAsProviderView(generics.CreateAPIView):
    serializer_class = ServiceProviderRegisterSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save()
        # Actualizar rol del usuario
        user = self.request.user
        user.role = User.Role.PRESTADOR
        user.save(update_fields=['role'])


class ProviderStatusView(generics.UpdateAPIView):
    queryset = ServiceProvider.objects.all()
    permission_classes = [IsPrestador]

    def get_object(self):
        return ServiceProvider.objects.get(user=self.request.user)

    def update(self, request, *args, **kwargs):
        provider = self.get_object()
        new_status = request.data.get('status')
        valid_statuses = [s[0] for s in ServiceProvider.Status.choices]
        if new_status not in valid_statuses:
            return Response({'error': 'Estado inválido.'}, status=status.HTTP_400_BAD_REQUEST)
        provider.status = new_status
        provider.save(update_fields=['status'])
        return Response({'status': provider.status})


@api_view(['POST'])
@permission_classes([IsAdmin])
def approve_provider(request, pk):
    try:
        provider = ServiceProvider.objects.get(pk=pk)
    except ServiceProvider.DoesNotExist:
        return Response({'error': 'Prestador no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    action = request.data.get('action')  # 'approve' o 'reject'
    if action == 'approve':
        provider.approval_status = ServiceProvider.ApprovalStatus.APROBADO
        provider.status = ServiceProvider.Status.DISPONIBLE
        provider.approved_by = request.user
        provider.approved_at = timezone.now()
    elif action == 'reject':
        provider.approval_status = ServiceProvider.ApprovalStatus.RECHAZADO
        provider.rejection_reason = request.data.get('reason', '')
    else:
        return Response({'error': 'Acción inválida. Use "approve" o "reject".'}, status=status.HTTP_400_BAD_REQUEST)

    provider.save()
    return Response(ServiceProviderSerializer(provider).data)


class ServiceRequestCreateView(generics.CreateAPIView):
    serializer_class = ServiceRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(client=self.request.user)


class ServiceRequestListView(generics.ListAPIView):
    serializer_class = ServiceRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return ServiceRequest.objects.all()
        elif user.role == User.Role.PRESTADOR:
            return ServiceRequest.objects.filter(provider__user=user)
        return ServiceRequest.objects.filter(client=user)
