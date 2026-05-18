from django.db import models
from apps.users.models import User


class ServiceCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'services_categories'
        verbose_name = 'Categoría de Servicio'

    def __str__(self):
        return self.name


class ServiceProvider(models.Model):
    class Status(models.TextChoices):
        DISPONIBLE = 'DISPONIBLE', 'Disponible'
        OCUPADO = 'OCUPADO', 'Ocupado'
        INACTIVO = 'INACTIVO', 'Inactivo'

    class ApprovalStatus(models.TextChoices):
        PENDIENTE = 'PENDIENTE', 'Pendiente'
        APROBADO = 'APROBADO', 'Aprobado'
        RECHAZADO = 'RECHAZADO', 'Rechazado'

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='provider_profile')
    category = models.ForeignKey(ServiceCategory, on_delete=models.PROTECT, related_name='providers')
    description = models.TextField(help_text='Descripción de los servicios que ofrece')
    photo = models.ImageField(upload_to='services/providers/photos/', blank=True, null=True, help_text='Foto de perfil del prestador')
    resume = models.FileField(upload_to='services/resumes/', help_text='Hoja de vida (PDF o imagen)')
    terms_accepted = models.BooleanField(default=False)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.INACTIVO)
    approval_status = models.CharField(
        max_length=20,
        choices=ApprovalStatus.choices,
        default=ApprovalStatus.PENDIENTE
    )
    rejection_reason = models.TextField(blank=True, null=True)
    approved_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='approved_providers'
    )
    approved_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'services_providers'
        verbose_name = 'Prestador de Servicio'
        verbose_name_plural = 'Prestadores de Servicio'

    def __str__(self):
        return f'{self.user.get_full_name()} - {self.category.name}'


class ServiceRequest(models.Model):
    class Status(models.TextChoices):
        REGISTRADA = 'REGISTRADA', 'Registrada'
        ASIGNADA = 'ASIGNADA', 'Asignada'
        EN_PROCESO = 'EN_PROCESO', 'En Proceso'
        COMPLETADA = 'COMPLETADA', 'Completada'
        CANCELADA = 'CANCELADA', 'Cancelada'

    client = models.ForeignKey(User, on_delete=models.PROTECT, related_name='service_requests')
    provider = models.ForeignKey(ServiceProvider, on_delete=models.PROTECT, related_name='requests')
    category = models.ForeignKey(ServiceCategory, on_delete=models.PROTECT)
    description = models.TextField(help_text='Descripción del trabajo requerido')
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.REGISTRADA)
    # Comisión informativa (no se procesa pago en esta versión)
    provider_fee = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    runners_fee = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    client_total = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'services_requests'
        verbose_name = 'Solicitud de Servicio'
        ordering = ['-created_at']
