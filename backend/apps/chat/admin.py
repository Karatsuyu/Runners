from django.contrib import admin

from .models import ChatMessage, ChatThread


@admin.register(ChatThread)
class ChatThreadAdmin(admin.ModelAdmin):
    list_display = ['id', 'thread_type', 'delivery_request', 'service_request', 'last_message_at', 'created_at']
    list_filter = ['thread_type']
    search_fields = ['id']


@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ['id', 'thread', 'sender', 'created_at']
    list_filter = ['created_at']
    search_fields = ['thread__id', 'sender__email', 'message']
