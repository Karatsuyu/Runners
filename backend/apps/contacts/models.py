from django.db import models


class Contact(models.Model):
    class ContactType(models.TextChoices):
        EMERGENCIA = 'EMERGENCIA', 'Emergencia'
        PROFESIONAL = 'PROFESIONAL', 'Profesional'
        COMERCIO = 'COMERCIO', 'Comercio'
        OTRO = 'OTRO', 'Otro'

    class AvailabilityStatus(models.TextChoices):
        EN_SERVICIO = 'EN_SERVICIO', 'En Servicio'
        FUERA_DE_SERVICIO = 'FUERA_DE_SERVICIO', 'Fuera de Servicio'

    name = models.CharField(max_length=200)
    phone = models.CharField(max_length=20)
    description = models.TextField(blank=True)
    contact_type = models.CharField(max_length=20, choices=ContactType.choices, default=ContactType.PROFESIONAL)
    availability = models.CharField(
        max_length=25,
        choices=AvailabilityStatus.choices,
        default=AvailabilityStatus.EN_SERVICIO
    )
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'contacts'
        verbose_name = 'Contacto'
        verbose_name_plural = 'Contactos'
        ordering = ['contact_type', 'name']

    def __str__(self):
        return f'{self.name} ({self.contact_type}) - {self.phone}'
