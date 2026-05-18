from django.conf import settings
from django.db import models


class ChatThread(models.Model):
    class ThreadType(models.TextChoices):
        DELIVERY = 'DELIVERY', 'Domicilio'
        SERVICE = 'SERVICE', 'Servicio'

    thread_type = models.CharField(max_length=20, choices=ThreadType.choices)
    delivery_request = models.OneToOneField(
        'deliveries.DeliveryRequest',
        on_delete=models.CASCADE,
        related_name='chat_thread',
        null=True,
        blank=True,
    )
    service_request = models.OneToOneField(
        'services.ServiceRequest',
        on_delete=models.CASCADE,
        related_name='chat_thread',
        null=True,
        blank=True,
    )
    participants = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='chat_threads')
    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        related_name='created_chat_threads',
        null=True,
        blank=True,
    )
    last_message_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'chat_threads'
        ordering = ['-last_message_at', '-created_at']

    def __str__(self):
        return f'Thread #{self.id} ({self.thread_type})'


class ChatMessage(models.Model):
    thread = models.ForeignKey(ChatThread, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='chat_messages')
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'chat_messages'
        ordering = ['created_at']

    def __str__(self):
        return f'Msg #{self.id} T{self.thread_id} U{self.sender_id}'
