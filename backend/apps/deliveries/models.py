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
        incomes = self.financial_records.filter(record_type='INGRESO').aggregate(total=Sum('amount'))['total'] or 0
        expenses = self.financial_records.filter(record_type='EGRESO').aggregate(total=Sum('amount'))['total'] or 0
        return incomes - expenses


class DeliveryRequest(models.Model):
    class Status(models.TextChoices):
        SOLICITADO = 'SOLICITADO', 'Solicitado'
        ACEPTADO = 'ACEPTADO', 'Aceptado'
        EN_CAMINO = 'EN_CAMINO', 'En Camino'
        ENTREGADO = 'ENTREGADO', 'Entregado'
        CANCELADO = 'CANCELADO', 'Cancelado'

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
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.SOLICITADO)
    pickup_address = models.CharField(max_length=255, blank=True)
    delivery_address = models.CharField(max_length=255, blank=True)
    delivery_fee = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'deliveries_requests'
        verbose_name = 'Solicitud de Domicilio'
        ordering = ['-created_at']


class FinancialRecord(models.Model):
    """Control de ingresos y egresos de cada domiciliario."""
    class RecordType(models.TextChoices):
        INGRESO = 'INGRESO', 'Ingreso'
        EGRESO = 'EGRESO', 'Egreso'

    deliverer = models.ForeignKey(Deliverer, on_delete=models.CASCADE, related_name='financial_records')
    record_type = models.CharField(max_length=10, choices=RecordType.choices)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.CharField(max_length=255)
    runners_commission = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=0,
        help_text='Porción que corresponde a Runners'
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
