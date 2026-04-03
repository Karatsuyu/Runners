from decimal import Decimal

from django.db.models import Q
from django.utils import timezone
from rest_framework import generics, permissions, serializers, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from apps.store.models import Commerce
from apps.users.models import User
from apps.users.permissions import IsAdmin, IsDomiciliario
from .models import (
    Deliverer,
    DeliveryCommerceHistory,
    DeliveryPricingRule,
    DeliveryRequest,
    DeliveryZone,
    FinancialRecord,
    SystemConfig,
)


# ── Serializers ──────────────────────────────────────────────────────────────


class DelivererSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    balance = serializers.DecimalField(source='current_balance', max_digits=10, decimal_places=2, read_only=True)

    class Meta:
        model = Deliverer
        fields = ['id', 'user', 'user_name', 'phone', 'assigned_number', 'status', 'work_type', 'is_active', 'balance']
        read_only_fields = ['id', 'user']


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


class FinancialRecordSerializer(serializers.ModelSerializer):
    deliverer_name = serializers.CharField(source='deliverer.user.get_full_name', read_only=True)

    class Meta:
        model = FinancialRecord
        fields = [
            'id', 'deliverer', 'deliverer_name', 'record_type', 'classification', 'reason',
            'amount', 'description', 'affects_balance', 'runners_commission',
            'related_delivery', 'created_at'
        ]
        read_only_fields = ['id', 'deliverer_name', 'runners_commission', 'created_at']


class DeliveryRequestSerializer(serializers.ModelSerializer):
    client_name = serializers.CharField(source='client.get_full_name', read_only=True)
    deliverer_name = serializers.SerializerMethodField()
    deliverer_number = serializers.SerializerMethodField()
    commerce_name = serializers.CharField(source='commerce.name', read_only=True)
    zone_name = serializers.CharField(source='zone.name', read_only=True)
    pricing_rule_name = serializers.CharField(source='pricing_rule.name', read_only=True)

    class Meta:
        model = DeliveryRequest
        fields = [
            'id', 'client', 'client_name', 'deliverer', 'deliverer_name', 'deliverer_number',
            'description', 'source_type', 'request_kind', 'commerce', 'commerce_name',
            'zone', 'zone_name', 'points_count', 'items_count',
            'is_transfer_payment', 'product_amount', 'transfer_surcharge',
            'pickup_address', 'delivery_address', 'status', 'delivery_fee',
            'pricing_rule', 'pricing_rule_name', 'associated_by', 'association_notes',
            'completed_at', 'created_at', 'updated_at',
        ]
        read_only_fields = [
            'id', 'client', 'deliverer', 'status', 'delivery_fee',
            'pricing_rule', 'associated_by', 'completed_at', 'created_at', 'updated_at',
        ]

    def get_deliverer_name(self, obj):
        return obj.deliverer.user.get_full_name() if obj.deliverer else None

    def get_deliverer_number(self, obj):
        return obj.deliverer.assigned_number if obj.deliverer else None


class DeliveryRequestCreateSerializer(serializers.ModelSerializer):
    commerce = serializers.PrimaryKeyRelatedField(
        queryset=Commerce.objects.filter(is_active=True),
        required=False,
        allow_null=True,
    )

    class Meta:
        model = DeliveryRequest
        fields = [
            'description', 'pickup_address', 'delivery_address', 'source_type',
            'request_kind', 'commerce', 'zone', 'points_count', 'items_count',
            'is_transfer_payment', 'product_amount'
        ]

    def validate(self, attrs):
        source_type = attrs.get('source_type', DeliveryRequest.SourceType.GENERAL)
        if source_type == DeliveryRequest.SourceType.STORE and not attrs.get('commerce'):
            raise serializers.ValidationError({'commerce': 'Debes indicar el negocio cuando el domicilio es tipo STORE.'})

        if attrs.get('points_count', 1) < 1:
            raise serializers.ValidationError({'points_count': 'Debe ser al menos 1.'})

        if attrs.get('items_count', 1) < 1:
            raise serializers.ValidationError({'items_count': 'Debe ser al menos 1.'})

        return attrs


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
        read_only_fields = ['id', 'delivery_request', 'previous_commerce', 'changed_by', 'created_at']


def _match_rule(rule, items_count, points_count):
    if rule.min_items is not None and items_count < rule.min_items:
        return False
    if rule.max_items is not None and items_count > rule.max_items:
        return False
    if rule.min_points is not None and points_count < rule.min_points:
        return False
    if rule.max_points is not None and points_count > rule.max_points:
        return False
    return True


def _select_pricing_rule(request_kind, zone, items_count, points_count):
    queryset = DeliveryPricingRule.objects.filter(is_active=True, request_kind=request_kind)
    if zone:
        queryset = queryset.filter(Q(zone=zone) | Q(zone__isnull=True))
    else:
        queryset = queryset.filter(zone__isnull=True)

    for rule in queryset.order_by('priority', 'id'):
        if _match_rule(rule, items_count, points_count):
            return rule

    return None


def _transfer_config():
    threshold = Decimal(SystemConfig.objects.filter(key='transfer_surcharge_threshold').values_list('value', flat=True).first() or '15000')
    amount = Decimal(SystemConfig.objects.filter(key='transfer_surcharge_amount').values_list('value', flat=True).first() or '2000')
    return threshold, amount


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
            deliverer = Deliverer.objects.get(user=user)

        amount = serializer.validated_data.get('amount', Decimal('0'))
        reason = serializer.validated_data.get('reason')

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


class DeliveryRequestListCreateView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return DeliveryRequestCreateSerializer
        return DeliveryRequestSerializer

    def get_queryset(self):
        user = self.request.user
        queryset = DeliveryRequest.objects.select_related(
            'client', 'deliverer__user', 'commerce', 'zone', 'pricing_rule'
        )

        if user.role == User.Role.ADMIN:
            source_type = self.request.query_params.get('source_type')
            if source_type:
                queryset = queryset.filter(source_type=source_type)
            return queryset
        if user.role == User.Role.DOMICILIARIO:
            try:
                deliverer = Deliverer.objects.get(user=user)
                return queryset.filter(deliverer=deliverer)
            except Deliverer.DoesNotExist:
                return DeliveryRequest.objects.none()
        return queryset.filter(client=user)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        items_count = data.get('items_count', 1)
        points_count = data.get('points_count', 1)
        request_kind = data.get('request_kind', DeliveryRequest.RequestKind.RECOGER_ENTREGAR)
        zone = data.get('zone')

        rule = _select_pricing_rule(request_kind, zone, items_count, points_count)
        delivery_fee = rule.fee_amount if rule else Decimal('0')

        transfer_surcharge = Decimal('0')
        if data.get('is_transfer_payment'):
            threshold, surcharge = _transfer_config()
            if data.get('product_amount', Decimal('0')) > threshold:
                transfer_surcharge = surcharge

        total_fee = delivery_fee + transfer_surcharge

        available = Deliverer.objects.filter(
            is_active=True,
            status=Deliverer.Status.DISPONIBLE,
        ).order_by('assigned_number')

        if not available.exists():
            return Response(
                {'error': 'No hay domiciliarios disponibles en este momento. Intenta más tarde.'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )

        deliverer = available.first()
        delivery_request = serializer.save(
            client=request.user,
            deliverer=deliverer,
            status=DeliveryRequest.Status.ACEPTADO,
            pricing_rule=rule,
            delivery_fee=total_fee,
            transfer_surcharge=transfer_surcharge,
        )

        deliverer.status = Deliverer.Status.OCUPADO
        deliverer.save(update_fields=['status'])

        if transfer_surcharge > 0:
            FinancialRecord.objects.create(
                deliverer=deliverer,
                record_type=FinancialRecord.RecordType.EGRESO,
                classification=FinancialRecord.Classification.AZUL,
                reason=FinancialRecord.Reason.RECARGO_TRANSFERENCIA,
                amount=transfer_surcharge,
                description='Recargo por transferencia (> umbral) a favor de Runners',
                runners_commission=transfer_surcharge,
                affects_balance=False,
                related_delivery=delivery_request,
            )

        return Response(
            DeliveryRequestSerializer(delivery_request).data,
            status=status.HTTP_201_CREATED,
        )


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

    if delivery.status == DeliveryRequest.Status.ENTREGADO:
        return Response({'error': 'Este domicilio ya fue completado.'}, status=status.HTTP_400_BAD_REQUEST)

    if delivery.status == DeliveryRequest.Status.CANCELADO:
        return Response({'error': 'Este domicilio fue cancelado.'}, status=status.HTTP_400_BAD_REQUEST)

    delivery.status = DeliveryRequest.Status.ENTREGADO
    delivery.completed_at = timezone.now()
    delivery.save(update_fields=['status', 'completed_at', 'updated_at'])

    if delivery.deliverer:
        delivery.deliverer.status = Deliverer.Status.DISPONIBLE
        delivery.deliverer.save(update_fields=['status'])

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
