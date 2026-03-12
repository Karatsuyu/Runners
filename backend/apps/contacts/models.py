from django.db import models


class Contact(models.Model):
    class ContactType(models.TextChoices):
        EMERGENCIA = 'EMERGENCIA', 'Emergencia'
        PROFESIONAL = 'PROFESIONAL', 'Profesional'
        COMERCIO = 'COMERCIO', 'Comercio'
        OTRO = 'OTRO', 'Otro'

    name = models.CharField(max_length=200)
    phone = models.CharField(max_length=20)
    description = models.TextField(blank=True)
    contact_type = models.CharField(max_length=20, choices=ContactType.choices, default=ContactType.PROFESIONAL)
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
