from django.db import models
from apps.users.models import User


class Contact(models.Model):
    class ContactType(models.TextChoices):
        EMERGENCIA = 'EMERGENCIA', 'Emergencia'
        PROFESIONAL = 'PROFESIONAL', 'Profesional'
        COMERCIO = 'COMERCIO', 'Comercio'
        OTRO = 'OTRO', 'Otro'

    class ApprovalStatus(models.TextChoices):
        PENDIENTE = 'PENDIENTE', 'Pendiente'
        APROBADO = 'APROBADO', 'Aprobado'
        RECHAZADO = 'RECHAZADO', 'Rechazado'

    name = models.CharField(max_length=200)
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True)
    image = models.ImageField(upload_to='contacts/', blank=True, null=True)
    description = models.TextField(blank=True)
    contact_type = models.CharField(max_length=20, choices=ContactType.choices, default=ContactType.PROFESIONAL)
    is_active = models.BooleanField(default=True)
    owner = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        related_name='contacts',
        null=True,
        blank=True,
    )
    approval_status = models.CharField(
        max_length=20,
        choices=ApprovalStatus.choices,
        default=ApprovalStatus.APROBADO,
    )
    reviewed_by = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        related_name='reviewed_contacts',
        null=True,
        blank=True,
    )
    reviewed_at = models.DateTimeField(null=True, blank=True)
    rejection_reason = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'contacts'
        verbose_name = 'Contacto'
        verbose_name_plural = 'Contactos'
        ordering = ['contact_type', 'name']

    def __str__(self):
        return f'{self.name} ({self.contact_type}) - {self.phone}'
