from decimal import Decimal
from rest_framework import generics, status, permissions, serializers
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.utils import timezone
from .models import (
    Deliverer,
    DeliveryRequest,
    FinancialRecord,
    SystemConfig,
    DeliveryChatMessage,
)
from apps.users.permissions import IsAdmin, IsDomiciliario
from apps.users.models import User
from django.db import transaction


# ── Serializers ──────────────────────────────────────────────────────────────


class DelivererSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    user_email = serializers.EmailField(source='user.email', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    balance = serializers.DecimalField(source='current_balance', max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Deliverer
        fields = ['id', 'user', 'user_name', 'user_email', 'phone', 'assigned_number', 'status', 'work_type', 'is_active', 'balance']
        read_only_fields = ['id', 'user']


class DelivererAdminSerializer(serializers.ModelSerializer):
    first_name = serializers.CharField(write_only=True)
    last_name = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    phone = serializers.CharField(write_only=True, required=False, allow_blank=True, allow_null=True)
    username = serializers.CharField(write_only=True, required=False, allow_blank=True, allow_null=True)
    password = serializers.CharField(write_only=True, required=False, allow_blank=True, allow_null=True)
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    user_email = serializers.EmailField(source='user.email', read_only=True)
    user_username = serializers.CharField(source='user.username', read_only=True)
    user_phone = serializers.CharField(source='user.phone', read_only=True)

    class Meta:
        model = Deliverer
        fields = [
            'id',
            'first_name',
            'last_name',
            'email',
            'phone',
            'username',
            'password',
            'assigned_number',
            'status',
            'work_type',
            'is_active',
            'user_name',
            'user_email',
            'user_username',
            'user_phone',
        ]
        read_only_fields = ['id', 'user_name', 'user_email', 'user_username', 'user_phone']

    def validate_assigned_number(self, value):
        qs = Deliverer.objects.filter(assigned_number=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError('Este número de domiciliario ya está en uso.')
        return value

    def validate_email(self, value):
        qs = User.objects.filter(email__iexact=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.user_id)
        if qs.exists():
            raise serializers.ValidationError('Este correo ya está en uso.')
        return value

    def validate_username(self, value):
        if not value:
            return value
        qs = User.objects.filter(username__iexact=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.user_id)
        if qs.exists():
            raise serializers.ValidationError('Este usuario ya está en uso.')
        return value

    @transaction.atomic
    def create(self, validated_data):
        user_data = self._extract_user_data(validated_data)
        password = user_data.pop('password', None)
        if not password:
            password = User.objects.make_random_password(length=10)

        user = User.objects.create_user(
            email=user_data['email'],
            password=password,
            first_name=user_data['first_name'],
            last_name=user_data['last_name'],
            phone=user_data.get('phone') or '',
            username=user_data.get('username') or None,
            role=User.Role.DOMICILIARIO,
        )

        deliverer = Deliverer.objects.create(user=user, **validated_data)
        deliverer._plain_password = password
        return deliverer

    @transaction.atomic
    def update(self, instance, validated_data):
        user_data = self._extract_user_data(validated_data)
        password = user_data.pop('password', None)

        user = instance.user
        user.email = user_data['email']
        user.first_name = user_data['first_name']
        user.last_name = user_data['last_name']
        user.phone = user_data.get('phone') or ''
        if user_data.get('username') not in (None, ''):
            user.username = user_data['username']
        user.role = User.Role.DOMICILIARIO
        if password:
            user.set_password(password)
        user.save()

        for field in ['assigned_number', 'status', 'work_type', 'is_active']:
            if field in validated_data:
                setattr(instance, field, validated_data[field])
        instance.save()
        return instance

    def _extract_user_data(self, validated_data):
        user_fields = ['first_name', 'last_name', 'email', 'phone', 'username', 'password']
        return {field: validated_data.pop(field, None) for field in user_fields}


class FinancialRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = FinancialRecord
        fields = ['id', 'record_type', 'amount', 'description', 'runners_commission', 'created_at', 'related_delivery']
        read_only_fields = ['id', 'runners_commission', 'created_at']


class DeliveryRequestSerializer(serializers.ModelSerializer):
    client_name = serializers.CharField(source='client.get_full_name', read_only=True)
    client_email = serializers.EmailField(source='client.email', read_only=True)
    client_phone = serializers.CharField(source='client.phone', read_only=True)
    deliverer_name = serializers.SerializerMethodField()
    deliverer_number = serializers.SerializerMethodField()
    deliverer_email = serializers.SerializerMethodField()
    deliverer_phone = serializers.SerializerMethodField()

    approval_status = serializers.CharField(read_only=True)
    is_delivered = serializers.BooleanField(read_only=True)
    is_paid = serializers.BooleanField(read_only=True)

    class Meta:
        model = DeliveryRequest
        fields = [
            'id', 'client', 'client_name', 'client_email', 'client_phone',
            'deliverer', 'deliverer_name', 'deliverer_number', 'deliverer_email', 'deliverer_phone',
            'description', 'pickup_address', 'delivery_address',
            'status', 'approval_status', 'delivery_fee', 'admin_delivery_fee',
            'is_delivered', 'is_paid', 'order', 'approved_at',
            'completed_at', 'created_at', 'updated_at',
        ]
        read_only_fields = [
            'id', 'client', 'deliverer', 'status', 'delivery_fee',
            'admin_delivery_fee', 'approval_status', 'approved_at',
            'is_delivered', 'is_paid', 'completed_at', 'created_at', 'updated_at',
        ]

    def get_deliverer_name(self, obj):
        return obj.deliverer.user.get_full_name() if obj.deliverer else None

    def get_deliverer_number(self, obj):
        return obj.deliverer.assigned_number if obj.deliverer else None

    def get_deliverer_email(self, obj):
        return obj.deliverer.user.email if obj.deliverer else None

    def get_deliverer_phone(self, obj):
        return obj.deliverer.user.phone if obj.deliverer else None


class DeliveryRequestCreateSerializer(serializers.ModelSerializer):
    order_id = serializers.IntegerField(required=False, allow_null=True)

    class Meta:
        model = DeliveryRequest
        fields = ['description', 'pickup_address', 'delivery_address', 'order_id']


class DeliveryApprovalSerializer(serializers.Serializer):
    admin_delivery_fee = serializers.DecimalField(max_digits=10, decimal_places=2)
    approved = serializers.BooleanField(default=True)


class DeliveryStatusToggleSerializer(serializers.Serializer):
    is_delivered = serializers.BooleanField(required=False)
    is_paid = serializers.BooleanField(required=False)

    def validate(self, attrs):
        if 'is_delivered' not in attrs and 'is_paid' not in attrs:
            raise serializers.ValidationError('Debes enviar is_delivered o is_paid.')
        return attrs


class DeliveryChatMessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(source='sender.get_full_name', read_only=True)

    class Meta:
        model = DeliveryChatMessage
        fields = ['id', 'delivery_request', 'sender', 'sender_name', 'recipient_role', 'message', 'created_at']
        read_only_fields = ['id', 'delivery_request', 'sender', 'sender_name', 'created_at']


class DelivererListView(generics.ListAPIView):
    serializer_class = DelivererSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return Deliverer.objects.all().order_by('assigned_number')
        return Deliverer.objects.filter(is_active=True, status='DISPONIBLE')


class DelivererCreateView(generics.CreateAPIView):
    serializer_class = DelivererSerializer
    permission_classes = [IsAdmin]

    def perform_create(self, serializer):
        serializer.save()


class DelivererAdminListCreateView(generics.ListCreateAPIView):
    serializer_class = DelivererAdminSerializer
    permission_classes = [IsAdmin]

    def get_queryset(self):
        return Deliverer.objects.select_related('user').all().order_by('assigned_number')

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        deliverer = serializer.save()
        headers = self.get_success_headers(serializer.data)
        response_data = self.get_serializer(deliverer).data
        if hasattr(deliverer, '_plain_password'):
            response_data['temporary_password'] = deliverer._plain_password
        return Response(response_data, status=status.HTTP_201_CREATED, headers=headers)


class DelivererAdminDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = DelivererAdminSerializer
    permission_classes = [IsAdmin]

    def get_queryset(self):
        return Deliverer.objects.select_related('user').all().order_by('assigned_number')

    def perform_destroy(self, instance):
        user = instance.user
        instance.delete()
        user.delete()


@api_view(['POST'])
@permission_classes([IsAdmin])
def toggle_deliverer_status(request, pk):
    try:
        deliverer = Deliverer.objects.get(pk=pk)
    except Deliverer.DoesNotExist:
        return Response({'error': 'Domiciliario no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    deliverer.is_active = not deliverer.is_active
    deliverer.save(update_fields=['is_active'])

    if not deliverer.is_active and deliverer.status == Deliverer.Status.OCUPADO:
        deliverer.status = Deliverer.Status.INACTIVO
        deliverer.save(update_fields=['status'])

    action = 'activado' if deliverer.is_active else 'desactivado'
    return Response({'message': f'Domiciliario {action} exitosamente.', 'is_active': deliverer.is_active})


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


class DeliveryRequestListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return DeliveryRequestCreateSerializer
        return DeliveryRequestSerializer

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return DeliveryRequest.objects.all()
        if user.role == User.Role.DOMICILIARIO:
            try:
                deliverer = Deliverer.objects.get(user=user)
                return DeliveryRequest.objects.filter(deliverer=deliverer)
            except Deliverer.DoesNotExist:
                return DeliveryRequest.objects.none()
        return DeliveryRequest.objects.filter(client=user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        order = None
        order_id = serializer.validated_data.pop('order_id', None)
        if order_id:
            from apps.store.models import Order
            try:
                order = Order.objects.get(pk=order_id, client=request.user)
            except Order.DoesNotExist:
                return Response({'error': 'Pedido no encontrado para este usuario.'}, status=status.HTTP_400_BAD_REQUEST)

        delivery_request = serializer.save(
            client=request.user,
            order=order,
            status=DeliveryRequest.Status.SOLICITADO,
            approval_status=DeliveryRequest.ApprovalStatus.PENDIENTE,
        )

        return Response(
            DeliveryRequestSerializer(delivery_request).data,
            status=status.HTTP_201_CREATED,
        )


class DeliveryRequestApproveView(generics.UpdateAPIView):
    permission_classes = [IsAdmin]
    serializer_class = DeliveryApprovalSerializer
    queryset = DeliveryRequest.objects.all()

    def update(self, request, *args, **kwargs):
        delivery = self.get_object()
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        available = Deliverer.objects.filter(
            is_active=True,
            status=Deliverer.Status.DISPONIBLE,
        ).order_by('assigned_number')
        if not available.exists():
            return Response({'error': 'No hay domiciliarios disponibles.'}, status=status.HTTP_409_CONFLICT)

        approved = serializer.validated_data['approved']
        fee = serializer.validated_data['admin_delivery_fee']
        if approved:
            delivery.approval_status = DeliveryRequest.ApprovalStatus.AUTORIZADO
            delivery.status = DeliveryRequest.Status.ACEPTADO
            delivery.deliverer = available.first()
            delivery.deliverer.status = Deliverer.Status.OCUPADO
            delivery.deliverer.save(update_fields=['status'])
        else:
            delivery.approval_status = DeliveryRequest.ApprovalStatus.RECHAZADO
            delivery.status = DeliveryRequest.Status.CANCELADO

        delivery.admin_delivery_fee = fee
        delivery.delivery_fee = fee
        delivery.approved_by = request.user
        delivery.approved_at = timezone.now()
        delivery.save()

        if approved and delivery.order:
            delivery.order.delivery_total = fee
            delivery.order.total = (delivery.order.products_subtotal or Decimal('0')) + fee
            delivery.order.save(update_fields=['delivery_total', 'total', 'updated_at'])

        return Response(DeliveryRequestSerializer(delivery).data)


class DeliveryChatListCreateView(generics.ListCreateAPIView):
    serializer_class = DeliveryChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def _can_access_delivery(self, delivery):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return True
        if delivery.client_id == user.id:
            return True
        return delivery.deliverer and delivery.deliverer.user_id == user.id

    def get_delivery(self):
        delivery = DeliveryRequest.objects.filter(pk=self.kwargs['pk']).first()
        if not delivery:
            raise serializers.ValidationError('Solicitud no encontrada.')
        if not self._can_access_delivery(delivery):
            raise serializers.ValidationError('Sin permiso para este chat.')
        return delivery

    def get_queryset(self):
        delivery = self.get_delivery()
        return delivery.chat_messages.select_related('sender').all()

    def perform_create(self, serializer):
        delivery = self.get_delivery()
        sender_role = self.request.user.role
        recipient_role = serializer.validated_data['recipient_role']
        allowed_pairs = {
            (User.Role.CLIENTE, User.Role.ADMIN),
            (User.Role.ADMIN, User.Role.CLIENTE),
            (User.Role.ADMIN, User.Role.DOMICILIARIO),
            (User.Role.DOMICILIARIO, User.Role.ADMIN),
        }
        if (sender_role, recipient_role) not in allowed_pairs:
            raise serializers.ValidationError('Combinación de roles no permitida para chat.')
        serializer.save(delivery_request=delivery, sender=self.request.user)


@api_view(['GET'])
@permission_classes([IsDomiciliario])
def my_deliverer_profile(request):
    try:
        deliverer = Deliverer.objects.get(user=request.user)
    except Deliverer.DoesNotExist:
        return Response({'error': 'Perfil no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    completed_count = DeliveryRequest.objects.filter(
        deliverer=deliverer,
        status=DeliveryRequest.Status.ENTREGADO
    ).count()
    payload = DelivererSerializer(deliverer).data
    payload['full_name'] = request.user.get_full_name()
    payload['total_earnings'] = float(deliverer.current_balance)
    payload['completed_deliveries'] = completed_count
    return Response(payload)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def complete_delivery(request, pk):
    try:
        delivery = DeliveryRequest.objects.get(pk=pk)
    except DeliveryRequest.DoesNotExist:
        return Response({'error': 'Solicitud no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

    is_admin = request.user.role == User.Role.ADMIN
    is_assigned_deliverer = (
        request.user.role == User.Role.DOMICILIARIO
        and delivery.deliverer
        and delivery.deliverer.user == request.user
    )

    if not (is_admin or is_assigned_deliverer):
        return Response({'error': 'Sin permiso para completar este domicilio.'}, status=status.HTTP_403_FORBIDDEN)

    serializer = DeliveryStatusToggleSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    data = serializer.validated_data

    if 'is_delivered' in data:
        delivery.is_delivered = data['is_delivered']
        if delivery.is_delivered:
            delivery.status = DeliveryRequest.Status.ENTREGADO
            delivery.completed_at = timezone.now()
            if delivery.deliverer:
                delivery.deliverer.status = Deliverer.Status.DISPONIBLE
                delivery.deliverer.save(update_fields=['status'])
        else:
            delivery.status = DeliveryRequest.Status.EN_CAMINO
            delivery.completed_at = None
            delivery.is_paid = False
            delivery.paid_at = None

    if 'is_paid' in data:
        if not delivery.is_delivered:
            return Response({'error': 'No puedes marcar pago sin entrega.'}, status=status.HTTP_400_BAD_REQUEST)
        delivery.is_paid = data['is_paid']
        delivery.paid_at = timezone.now() if delivery.is_paid else None

    delivery.save()
    return Response(DeliveryRequestSerializer(delivery).data)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def cancel_delivery(request, pk):
    try:
        delivery = DeliveryRequest.objects.get(pk=pk)
    except DeliveryRequest.DoesNotExist:
        return Response({'error': 'Solicitud no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

    is_admin = request.user.role == User.Role.ADMIN
    is_client = delivery.client == request.user

    if not (is_admin or is_client):
        return Response({'error': 'Sin permiso para cancelar este domicilio.'}, status=status.HTTP_403_FORBIDDEN)

    if delivery.status in [DeliveryRequest.Status.ENTREGADO, DeliveryRequest.Status.CANCELADO]:
        return Response(
            {'error': 'El domicilio no puede cancelarse en su estado actual.'},
            status=status.HTTP_400_BAD_REQUEST,
        )

    delivery.status = DeliveryRequest.Status.CANCELADO
    delivery.save(update_fields=['status', 'updated_at'])

    if delivery.deliverer and delivery.deliverer.status == Deliverer.Status.OCUPADO:
        delivery.deliverer.status = Deliverer.Status.DISPONIBLE
        delivery.deliverer.save(update_fields=['status'])

    return Response(DeliveryRequestSerializer(delivery).data)
