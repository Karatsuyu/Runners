from django.db import models
from apps.users.models import User


class Deliverer(models.Model):
    class Status(models.TextChoices):
        DISPONIBLE = 'DISPONIBLE', 'Disponible'
        OCUPADO = 'OCUPADO', 'Ocupado'
        INACTIVO = 'INACTIVO', 'Inactivo'

    class WorkType(models.TextChoices):
        INDEPENDIENTE = 'INDEPENDIENTE', 'Independiente'
        EMPRESA = 'EMPRESA', 'Con la Empresa'

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='deliverer_profile')
    assigned_number = models.PositiveIntegerField(unique=True, help_text='Número identificador del domiciliario')
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.DISPONIBLE)
    work_type = models.CharField(max_length=20, choices=WorkType.choices, default=WorkType.INDEPENDIENTE)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'deliveries_deliverers'
        verbose_name = 'Domiciliario'
        verbose_name_plural = 'Domiciliarios'
        ordering = ['assigned_number']

    def __str__(self):
        return f'Domiciliario #{self.assigned_number} - {self.user.get_full_name()}'

    @property
    def current_balance(self):
        """Calcula el balance actual del domiciliario."""
        from django.db.models import Sum
        incomes = self.financial_records.filter(record_type='INGRESO', affects_balance=True).aggregate(total=Sum('amount'))['total'] or 0
        expenses = self.financial_records.filter(record_type='EGRESO', affects_balance=True).aggregate(total=Sum('amount'))['total'] or 0
        return incomes - expenses


class DeliveryZone(models.Model):
    name = models.CharField(max_length=120, unique=True)
    description = models.CharField(max_length=255, blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'deliveries_zones'
        verbose_name = 'Zona de Domicilio'
        verbose_name_plural = 'Zonas de Domicilio'
        ordering = ['name']

    def __str__(self):
        return self.name


class DeliveryPricingRule(models.Model):
    class RequestKind(models.TextChoices):
        RECOGER_ENTREGAR = 'RECOGER_ENTREGAR', 'Recoger y Entregar'
        COMPRA_SENCILLA = 'COMPRA_SENCILLA', 'Compra Sencilla'
        SUPERMERCADO = 'SUPERMERCADO', 'Supermercado'
        MULTIPUNTO = 'MULTIPUNTO', 'Multipunto'

    name = models.CharField(max_length=140)
    request_kind = models.CharField(max_length=30, choices=RequestKind.choices)
    zone = models.ForeignKey(
        DeliveryZone,
        on_delete=models.PROTECT,
        related_name='pricing_rules',
        null=True,
        blank=True,
        help_text='Si está vacío, aplica para cualquier zona.'
    )
    min_items = models.PositiveIntegerField(null=True, blank=True)
    max_items = models.PositiveIntegerField(null=True, blank=True)
    min_points = models.PositiveIntegerField(null=True, blank=True)
    max_points = models.PositiveIntegerField(null=True, blank=True)
    fee_amount = models.DecimalField(max_digits=10, decimal_places=2)
    priority = models.PositiveIntegerField(default=100)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'deliveries_pricing_rules'
        verbose_name = 'Regla de Tarifa'
        verbose_name_plural = 'Reglas de Tarifas'
        ordering = ['priority', 'id']

    def __str__(self):
        scope = self.zone.name if self.zone else 'General'
        return f'{self.name} ({scope})'


class DeliveryRequest(models.Model):
    class Status(models.TextChoices):
        SOLICITADO = 'SOLICITADO', 'Solicitado'
        ACEPTADO = 'ACEPTADO', 'Aceptado'
        EN_CAMINO = 'EN_CAMINO', 'En Camino'
        ENTREGADO = 'ENTREGADO', 'Entregado'
        CANCELADO = 'CANCELADO', 'Cancelado'

    class SourceType(models.TextChoices):
        GENERAL = 'GENERAL', 'General'
        STORE = 'STORE', 'Desde Tienda'

    class RequestKind(models.TextChoices):
        RECOGER_ENTREGAR = 'RECOGER_ENTREGAR', 'Recoger y Entregar'
        COMPRA_SENCILLA = 'COMPRA_SENCILLA', 'Compra Sencilla'
        SUPERMERCADO = 'SUPERMERCADO', 'Supermercado'
        MULTIPUNTO = 'MULTIPUNTO', 'Multipunto'

    client = models.ForeignKey(User, on_delete=models.PROTECT, related_name='delivery_requests')
    deliverer = models.ForeignKey(
        Deliverer,
        on_delete=models.PROTECT,
        related_name='delivery_requests',
        null=True,
        blank=True,
        help_text='Se asigna automáticamente al crear la solicitud'
    )
    description = models.TextField(help_text='Descripción del domicilio o favor')
    source_type = models.CharField(max_length=20, choices=SourceType.choices, default=SourceType.GENERAL)
    request_kind = models.CharField(max_length=30, choices=RequestKind.choices, default=RequestKind.RECOGER_ENTREGAR)
    commerce = models.ForeignKey(
        'store.Commerce',
        on_delete=models.SET_NULL,
        related_name='delivery_requests',
        null=True,
        blank=True,
        help_text='Negocio asociado al domicilio cuando aplica.'
    )
    zone = models.ForeignKey(
        DeliveryZone,
        on_delete=models.SET_NULL,
        related_name='delivery_requests',
        null=True,
        blank=True
    )
    points_count = models.PositiveIntegerField(default=1, help_text='Cantidad de puntos/establecimientos del recorrido')
    items_count = models.PositiveIntegerField(default=1, help_text='Cantidad estimada de productos')
    is_transfer_payment = models.BooleanField(default=False)
    product_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    transfer_surcharge = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.SOLICITADO)
    pickup_address = models.CharField(max_length=255, blank=True)
    delivery_address = models.CharField(max_length=255, blank=True)
    delivery_fee = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    pricing_rule = models.ForeignKey(
        DeliveryPricingRule,
        on_delete=models.SET_NULL,
        related_name='delivery_requests',
        null=True,
        blank=True
    )
    associated_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        related_name='associated_delivery_requests',
        null=True,
        blank=True
    )
    association_notes = models.CharField(max_length=255, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'deliveries_requests'
        verbose_name = 'Solicitud de Domicilio'
        ordering = ['-created_at']


class DeliveryCommerceHistory(models.Model):
    delivery_request = models.ForeignKey(
        DeliveryRequest,
        on_delete=models.CASCADE,
        related_name='commerce_history'
    )
    previous_commerce = models.ForeignKey(
        'store.Commerce',
        on_delete=models.SET_NULL,
        related_name='+',
        null=True,
        blank=True
    )
    new_commerce = models.ForeignKey(
        'store.Commerce',
        on_delete=models.SET_NULL,
        related_name='+',
        null=True,
        blank=True
    )
    changed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    notes = models.CharField(max_length=255, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'deliveries_commerce_history'
        verbose_name = 'Historial de Asociación de Negocio'
        verbose_name_plural = 'Historial de Asociación de Negocio'
        ordering = ['-created_at']


class FinancialRecord(models.Model):
    """Control de ingresos y egresos de cada domiciliario."""
    class RecordType(models.TextChoices):
        INGRESO = 'INGRESO', 'Ingreso'
        EGRESO = 'EGRESO', 'Egreso'

    class Classification(models.TextChoices):
        NEGRO = 'NEGRO', 'Transacción Normal'
        ROJO = 'ROJO', 'Deuda a favor del Domiciliario'
        AZUL = 'AZUL', 'Saldo Extra en Caja del Domiciliario'

    class Reason(models.TextChoices):
        PRODUCTO = 'PRODUCTO', 'Producto'
        DOMICILIO = 'DOMICILIO', 'Domicilio'
        RECARGO_TRANSFERENCIA = 'RECARGO_TRANSFERENCIA', 'Recargo por Transferencia (Runners)'
        CONSIGNACION_BASE = 'CONSIGNACION_BASE', 'Consignación de Base'
        COBRO_DEUDA_CLIENTE = 'COBRO_DEUDA_CLIENTE', 'Cobro de Deuda de Cliente'
        AJUSTE_MANUAL = 'AJUSTE_MANUAL', 'Ajuste Manual'

    deliverer = models.ForeignKey(Deliverer, on_delete=models.CASCADE, related_name='financial_records')
    record_type = models.CharField(max_length=10, choices=RecordType.choices)
    classification = models.CharField(max_length=10, choices=Classification.choices, default=Classification.NEGRO)
    reason = models.CharField(max_length=30, choices=Reason.choices, default=Reason.AJUSTE_MANUAL)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.CharField(max_length=255)
    runners_commission = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=0,
        help_text='Porción que corresponde a Runners'
    )
    affects_balance = models.BooleanField(
        default=True,
        help_text='Si está activo, afecta el balance del domiciliario (INGRESO - EGRESO).'
    )
    related_delivery = models.ForeignKey(
        DeliveryRequest,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='financial_records'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'deliveries_financial_records'
        verbose_name = 'Registro Financiero'
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.record_type} - ${self.amount} ({self.deliverer})'


class SystemConfig(models.Model):
    """Parámetros configurables del sistema (comisiones, etc.)."""
    key = models.CharField(max_length=100, unique=True)
    value = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'system_config'
        verbose_name = 'Configuración del Sistema'

    def __str__(self):
        return f'{self.key}: {self.value}'
