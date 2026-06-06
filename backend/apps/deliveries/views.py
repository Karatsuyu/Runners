from decimal import Decimal
from datetime import timedelta
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
    DeliveryZone,
    DeliveryPricingRule,
    DeliveryCommerceHistory,
)
from apps.users.permissions import IsAdmin, IsDomiciliario
from apps.users.models import User
from django.db import transaction, models


@api_view(['GET'])
def debug_auth_header(request):
    """Devuelve si la cabecera Authorization fue recibida y el usuario autenticado (si lo hay)."""
    auth_header = request.META.get('HTTP_AUTHORIZATION')
    user_info = None
    try:
        if request.user and request.user.is_authenticated:
            user_info = {
                'id': request.user.id,
                'email': getattr(request.user, 'email', None),
                'role': getattr(request.user, 'role', None),
            }
    except Exception:
        user_info = None

    return Response({'authorization_present': bool(auth_header), 'user': user_info})


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
    deliverer_name = serializers.CharField(source='deliverer.user.get_full_name', read_only=True)

    class Meta:
        model = FinancialRecord
        fields = ['id', 'deliverer_name', 'record_type', 'amount', 'description', 'runners_commission', 'created_at', 'related_delivery']
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
    request_kind = serializers.ChoiceField(choices=DeliveryRequest.RequestKind.choices, required=False)
    items_count = serializers.IntegerField(required=False, default=1)
    points_count = serializers.IntegerField(required=False, default=1)
    is_transfer_payment = serializers.BooleanField(required=False, default=False)
    product_amount = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, default=Decimal('0'))

    class Meta:
        model = DeliveryRequest
        fields = [
            'description', 'pickup_address', 'delivery_address', 'order_id',
            'request_kind', 'items_count', 'points_count', 'is_transfer_payment', 'product_amount'
        ]


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
    sender_role = serializers.CharField(source='sender.role', read_only=True)

    class Meta:
        model = DeliveryChatMessage
        fields = [
            'id', 'delivery_request', 'sender', 'sender_name', 'sender_role',
            'recipient_role', 'message', 'created_at',
        ]
        read_only_fields = ['id', 'delivery_request', 'sender', 'sender_name', 'sender_role', 'created_at']


class DeliveryZoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = DeliveryZone
        fields = ['id', 'name', 'description', 'is_active']
        read_only_fields = ['id']


class DeliveryPricingRuleSerializer(serializers.ModelSerializer):
    zone_name = serializers.CharField(source='zone.name', read_only=True)

    class Meta:
        model = DeliveryPricingRule
        fields = [
            'id', 'name', 'request_kind', 'zone', 'zone_name',
            'min_items', 'max_items', 'min_points', 'max_points',
            'fee_amount', 'priority', 'is_active'
        ]
        read_only_fields = ['id']


class DeliveryCommerceHistorySerializer(serializers.ModelSerializer):
    previous_commerce_name = serializers.CharField(source='previous_commerce.name', read_only=True)
    new_commerce_name = serializers.CharField(source='new_commerce.name', read_only=True)
    changed_by_name = serializers.CharField(source='changed_by.get_full_name', read_only=True)

    class Meta:
        model = DeliveryCommerceHistory
        fields = [
            'id', 'delivery_request', 'previous_commerce', 'previous_commerce_name',
            'new_commerce', 'new_commerce_name', 'changed_by', 'changed_by_name',
            'notes', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']


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
            if not deliverer_id:
                return FinancialRecord.objects.all()
            return FinancialRecord.objects.filter(deliverer_id=deliverer_id)
        try:
            deliverer = Deliverer.objects.get(user=user)
            return FinancialRecord.objects.filter(deliverer=deliverer)
        except Deliverer.DoesNotExist:
            return FinancialRecord.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        if user.role == User.Role.ADMIN and self.kwargs.get('deliverer_pk'):
            deliverer = Deliverer.objects.get(pk=self.kwargs['deliverer_pk'])
        else:
            try:
                deliverer = Deliverer.objects.get(user=user)
            except Deliverer.DoesNotExist:
                raise serializers.ValidationError('Perfil de domiciliario no encontrado.')

        amount = serializer.validated_data.get('amount', Decimal('0'))
        reason = serializer.validated_data.get('reason')

        # Evitar duplicados por reintentos: si existe un registro reciente con same deliverer, amount y description
        description = serializer.validated_data.get('description', '')
        recent_threshold = timezone.now() - timedelta(seconds=5)
        if FinancialRecord.objects.filter(deliverer=deliverer, amount=amount, description=description, created_at__gte=recent_threshold).exists():
            raise serializers.ValidationError('Registro duplicado detectado (petición reciente).')

        runners_commission = Decimal('0')
        if reason == FinancialRecord.Reason.RECARGO_TRANSFERENCIA:
            runners_commission = amount

        serializer.save(deliverer=deliverer, runners_commission=runners_commission)


class DeliveryZoneListCreateView(generics.ListCreateAPIView):
    queryset = DeliveryZone.objects.filter(is_active=True)
    serializer_class = DeliveryZoneSerializer

    def get_permissions(self):
        if self.request.method == 'GET':
            return [permissions.IsAuthenticated()]
        return [IsAdmin()]


class DeliveryZoneDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = DeliveryZone.objects.all()
    serializer_class = DeliveryZoneSerializer
    permission_classes = [IsAdmin]


class DeliveryPricingRuleListCreateView(generics.ListCreateAPIView):
    queryset = DeliveryPricingRule.objects.filter(is_active=True)
    serializer_class = DeliveryPricingRuleSerializer

    def get_permissions(self):
        if self.request.method == 'GET':
            return [permissions.IsAuthenticated()]
        return [IsAdmin()]


class DeliveryPricingRuleDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = DeliveryPricingRule.objects.all()
    serializer_class = DeliveryPricingRuleSerializer
    permission_classes = [IsAdmin]


class DeliveryEstimateSerializer(serializers.Serializer):
    request_kind = serializers.ChoiceField(choices=DeliveryRequest.RequestKind.choices)
    zone = serializers.IntegerField(required=False, allow_null=True)
    items_count = serializers.IntegerField(required=False, default=1)
    points_count = serializers.IntegerField(required=False, default=1)
    product_amount = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, default=Decimal('0'))
    is_transfer_payment = serializers.BooleanField(required=False, default=False)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def estimate_delivery_fee(request):
    """Estima la tarifa de un domicilio según reglas y posibles recargos."""
    serializer = DeliveryEstimateSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    data = serializer.validated_data

    request_kind = data.get('request_kind')
    zone_id = data.get('zone')
    items = data.get('items_count') or 1
    points = data.get('points_count') or 1
    product_amount = data.get('product_amount') or Decimal('0')
    is_transfer = data.get('is_transfer_payment')

    # Filtrar reglas aplicables
    rules = DeliveryPricingRule.objects.filter(request_kind=request_kind, is_active=True).order_by('priority', 'id')
    if zone_id:
        rules = rules.filter(models.Q(zone_id=zone_id) | models.Q(zone__isnull=True))
    else:
        rules = rules.filter(zone__isnull=True)

    matched = None
    for r in rules:
        if r.min_items and items < r.min_items:
            continue
        if r.max_items and items > r.max_items:
            continue
        if r.min_points and points < r.min_points:
            continue
        if r.max_points and points > r.max_points:
            continue
        matched = r
        break

    base_fee = matched.fee_amount if matched else Decimal('0')

    # Transfer surcharge configurable
    transfer_threshold = SystemConfig.objects.filter(key='transfer_surcharge_threshold').first()
    transfer_amount = SystemConfig.objects.filter(key='transfer_surcharge_amount').first()
    surcharge = Decimal('0')
    try:
        threshold = Decimal(transfer_threshold.value) if transfer_threshold else Decimal('0')
        surcharge_val = Decimal(transfer_amount.value) if transfer_amount else Decimal('0')
    except Exception:
        threshold = Decimal('0')
        surcharge_val = Decimal('0')

    if is_transfer and product_amount >= threshold and surcharge_val > 0:
        surcharge = surcharge_val

    total = (Decimal(base_fee) + surcharge)

    return Response({
        'base_fee': float(base_fee),
        'surcharge': float(surcharge),
        'total': float(total),
        'rule_id': matched.id if matched else None,
        'rule_name': matched.name if matched else None,
    })


class DeliveryRequestListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return DeliveryRequestCreateSerializer
        return DeliveryRequestSerializer

    def get_queryset(self):
        try:
            user = self.request.user
            queryset = DeliveryRequest.objects.select_related(
                'client', 'deliverer__user', 'commerce', 'zone'
            )

            if user.role == User.Role.ADMIN:
                # Admin: by default exclude cancelled requests, unless explicitly requested
                include_cancelled = self.request.query_params.get('include_cancelled', 'false').lower() in ('1', 'true', 'yes')
                source_type = self.request.query_params.get('source_type')
                if source_type:
                    queryset = queryset.filter(source_type=source_type)
                if not include_cancelled:
                    queryset = queryset.exclude(status=DeliveryRequest.Status.CANCELADO)
                return queryset
            if user.role == User.Role.DOMICILIARIO:
                try:
                    deliverer = Deliverer.objects.get(user=user)
                    # Excluir solicitudes canceladas para la vista del domiciliario
                    return queryset.filter(deliverer=deliverer).exclude(status=DeliveryRequest.Status.CANCELADO)
                except Deliverer.DoesNotExist:
                    return DeliveryRequest.objects.none()
                except Exception as e:
                    import logging
                    logging.exception('Error obteniendo perfil de domiciliario para user=%s: %s', user.id, e)
                    return DeliveryRequest.objects.none()
            # Para clientes, excluir solicitudes canceladas de la lista
            return queryset.filter(client=user).exclude(status=DeliveryRequest.Status.CANCELADO)
        except Exception as e:
            # Evitar 500 inesperados en list/create de solicitudes
            import logging
            logging.exception('Error en DeliveryRequestListCreateView.get_queryset: %s', e)
            return DeliveryRequest.objects.none()

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

        # Intentar asignar automáticamente al primer domiciliario disponible.
        try:
            available = Deliverer.objects.filter(
                is_active=True,
                status=Deliverer.Status.DISPONIBLE,
            ).order_by('assigned_number')
            if available.exists():
                candidate = available.first()
                delivery_request.deliverer = candidate
                delivery_request.assigned_at = timezone.now()
                delivery_request.save(update_fields=['deliverer', 'assigned_at'])
                # Notificar mediante chat interno al domiciliario y al cliente
                try:
                    DeliveryChatMessage.objects.create(
                        delivery_request=delivery_request,
                        sender=request.user,
                        recipient_role=User.Role.DOMICILIARIO,
                        message=(
                            f'Tienes una nueva solicitud de domicilio asignada provisionalmente: #{delivery_request.id}. '
                            'Por favor acepta o rechaza.'
                        ),
                    )
                except Exception:
                    pass
        except Exception:
            # No bloquear la creación si la lógica de asignación falla
            pass

        return Response(
            DeliveryRequestSerializer(delivery_request).data,
            status=status.HTTP_201_CREATED,
        )


class AvailableDeliveryRequestsView(generics.ListAPIView):
    """Lista solicitudes disponibles (pendientes y sin domiciliario)."""
    serializer_class = DeliveryRequestSerializer
    permission_classes = [IsDomiciliario]

    def get_queryset(self):
        return DeliveryRequest.objects.select_related(
            'client', 'commerce', 'zone'
        ).filter(status=DeliveryRequest.Status.SOLICITADO, deliverer__isnull=True)


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

            # Enviar notificaciones de chat: informar al cliente y al domiciliario asignado
            try:
                if approved and delivery.deliverer:
                    assigned = delivery.deliverer
                    client_msg = (
                        f'Se ha asignado el domiciliario {assigned.user.get_full_name()} (#{assigned.assigned_number}). '
                        'Tu pedido está en proceso.'
                    )
                    # Mensaje dirigido al cliente (ADMIN -> CLIENTE)
                    DeliveryChatMessage.objects.create(
                        delivery_request=delivery,
                        sender=request.user,
                        recipient_role=User.Role.CLIENTE,
                        message=client_msg,
                    )

                    # Mensaje dirigido al domiciliario (ADMIN -> DOMICILIARIO)
                    deliverer_msg = (
                        f'Tienes un nuevo domicilio asignado: pedido #{delivery.id}. Revisa los detalles y confirma.'
                    )
                    DeliveryChatMessage.objects.create(
                        delivery_request=delivery,
                        sender=request.user,
                        recipient_role=User.Role.DOMICILIARIO,
                        message=deliverer_msg,
                    )
            except Exception:
                # No bloquear el flujo principal si falla la creación de mensajes
                pass

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
            (User.Role.CLIENTE, User.Role.DOMICILIARIO),
            (User.Role.DOMICILIARIO, User.Role.CLIENTE),
        }
        if (sender_role, recipient_role) not in allowed_pairs:
            raise serializers.ValidationError('Combinación de roles no permitida para chat.')
        if sender_role in (User.Role.CLIENTE, User.Role.DOMICILIARIO):
            if not delivery.deliverer_id:
                raise serializers.ValidationError(
                    'El chat con el repartidor estará disponible cuando se asigne un domiciliario.'
                )
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
@permission_classes([IsAdmin])
def associate_delivery_commerce(request, pk):
    try:
        delivery = DeliveryRequest.objects.get(pk=pk)
    except DeliveryRequest.DoesNotExist:
        return Response({'error': 'Solicitud no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

    commerce_id = request.data.get('commerce_id')
    notes = request.data.get('notes', '')

    if commerce_id in (None, ''):
        new_commerce = None
    else:
        try:
            new_commerce = Commerce.objects.get(pk=commerce_id)
        except Commerce.DoesNotExist:
            return Response({'error': 'Negocio no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    previous = delivery.commerce

    DeliveryCommerceHistory.objects.create(
        delivery_request=delivery,
        previous_commerce=previous,
        new_commerce=new_commerce,
        changed_by=request.user,
        notes=notes,
    )

    delivery.commerce = new_commerce
    delivery.associated_by = request.user
    delivery.association_notes = notes
    delivery.source_type = DeliveryRequest.SourceType.STORE if new_commerce else DeliveryRequest.SourceType.GENERAL
    delivery.save(update_fields=['commerce', 'associated_by', 'association_notes', 'source_type', 'updated_at'])

    return Response(DeliveryRequestSerializer(delivery).data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def delivery_commerce_history(request, pk):
    try:
        delivery = DeliveryRequest.objects.get(pk=pk)
    except DeliveryRequest.DoesNotExist:
        return Response({'error': 'Solicitud no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

    if request.user.role != User.Role.ADMIN and delivery.client_id != request.user.id:
        return Response({'error': 'Sin permiso para ver este historial.'}, status=status.HTTP_403_FORBIDDEN)

    history = DeliveryCommerceHistory.objects.filter(delivery_request=delivery)
    return Response(DeliveryCommerceHistorySerializer(history, many=True).data)


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


@api_view(['POST'])
@permission_classes([IsDomiciliario])
def assign_delivery(request, pk):
    """Asignar/aceptar una solicitud por el domiciliario actual.

    Se asegura de que la solicitud esté pendiente y sin domiciliario, y la marca
    como aceptada asignando al domiciliario actual de forma transaccional.
    """
    try:
        with transaction.atomic():
            delivery = DeliveryRequest.objects.select_for_update().filter(pk=pk).first()
            if not delivery:
                return Response({'error': 'Solicitud no encontrada.'}, status=status.HTTP_404_NOT_FOUND)

            # Si la solicitud ya fue aceptada o cancelada, no se puede asignar
            if delivery.status != DeliveryRequest.Status.SOLICITADO:
                return Response({'error': 'La solicitud ya no está disponible.'}, status=status.HTTP_409_CONFLICT)

            try:
                deliverer = Deliverer.objects.get(user=request.user)
            except Deliverer.DoesNotExist:
                return Response({'error': 'Perfil de domiciliario no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

            # Si la solicitud ya tiene un domiciliario candidato distinto, no permitir la asignación
            if delivery.deliverer_id and delivery.deliverer.user_id != request.user.id:
                return Response({'error': 'La solicitud ya fue asignada a otro domiciliario.'}, status=status.HTTP_409_CONFLICT)

            # Si no tenía domiciliario, asignarlo ahora; si ya estaba asignada al mismo usuario, proceder a aceptar
            if not delivery.deliverer_id:
                delivery.deliverer = deliverer
            # Marcar como aceptado por el domiciliario actual
            delivery.status = DeliveryRequest.Status.ACEPTADO
            delivery.approval_status = DeliveryRequest.ApprovalStatus.AUTORIZADO
            delivery.save()
            deliverer.status = Deliverer.Status.OCUPADO
            deliverer.save(update_fields=['status'])

            # Mensajes de sistema: notificar al cliente
            try:
                client_msg = (
                    f'Su domicilio #{delivery.id} ha sido aceptado por {deliverer.user.get_full_name()} (#{deliverer.assigned_number}).'
                )
                DeliveryChatMessage.objects.create(
                    delivery_request=delivery,
                    sender=request.user,
                    recipient_role=User.Role.CLIENTE,
                    message=client_msg,
                )
            except Exception:
                pass

            return Response(DeliveryRequestSerializer(delivery).data)
    except Exception as e:
        import logging
        logging.exception('Error en assign_delivery pk=%s: %s', pk, e)
        return Response({'error': 'Error asignando la solicitud.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
