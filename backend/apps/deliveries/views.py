from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import Deliverer, DeliveryRequest, FinancialRecord, SystemConfig
from apps.users.permissions import IsAdmin, IsDomiciliario
from apps.users.models import User
from rest_framework import serializers


class DelivererSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    balance = serializers.DecimalField(source='current_balance', max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Deliverer
        fields = ['id', 'user', 'user_name', 'phone', 'assigned_number', 'status', 'work_type', 'is_active', 'balance']
        read_only_fields = ['id', 'user']


class FinancialRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = FinancialRecord
        fields = ['id', 'record_type', 'amount', 'description', 'runners_commission', 'created_at']
        read_only_fields = ['id', 'runners_commission', 'created_at']


class DelivererListView(generics.ListAPIView):
    serializer_class = DelivererSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return Deliverer.objects.filter(is_active=True)
        return Deliverer.objects.filter(is_active=True, status='DISPONIBLE')


class DelivererCreateView(generics.CreateAPIView):
    serializer_class = DelivererSerializer
    permission_classes = [IsAdmin]

    def perform_create(self, serializer):
        serializer.save()


class DelivererStatusView(generics.UpdateAPIView):
    permission_classes = [IsDomiciliario]

    def update(self, request, *args, **kwargs):
        try:
            deliverer = Deliverer.objects.get(user=request.user)
        except Deliverer.DoesNotExist:
            return Response({'error': 'Perfil de domiciliario no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

        new_status = request.data.get('status')
        valid = [s[0] for s in Deliverer.Status.choices]
        if new_status not in valid:
            return Response({'error': 'Estado inválido.'}, status=status.HTTP_400_BAD_REQUEST)

        deliverer.status = new_status
        deliverer.save(update_fields=['status'])
        return Response({'status': deliverer.status})


class FinancialRecordListCreateView(generics.ListCreateAPIView):
    serializer_class = FinancialRecordSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            deliverer_id = self.kwargs.get('deliverer_pk')
            return FinancialRecord.objects.filter(deliverer_id=deliverer_id)
        try:
            deliverer = Deliverer.objects.get(user=user)
            return FinancialRecord.objects.filter(deliverer=deliverer)
        except Deliverer.DoesNotExist:
            return FinancialRecord.objects.none()

    def perform_create(self, serializer):
        deliverer = Deliverer.objects.get(user=self.request.user)
        # Calcular comisión de Runners
        amount = serializer.validated_data.get('amount', 0)
        commission_pct = float(SystemConfig.objects.filter(key='runners_commission_pct').values_list('value', flat=True).first() or 10)
        runners_commission = amount * commission_pct / 100 if serializer.validated_data.get('record_type') == 'INGRESO' else 0
        serializer.save(deliverer=deliverer, runners_commission=runners_commission)
