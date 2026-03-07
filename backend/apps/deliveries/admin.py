from django.contrib import admin
from .models import Deliverer, DeliveryRequest, FinancialRecord, SystemConfig


@admin.register(Deliverer)
class DelivererAdmin(admin.ModelAdmin):
    list_display = ['assigned_number', 'user', 'status', 'work_type', 'is_active']
    list_filter = ['status', 'work_type', 'is_active']
    search_fields = ['user__email', 'user__first_name', 'user__last_name']


@admin.register(DeliveryRequest)
class DeliveryRequestAdmin(admin.ModelAdmin):
    list_display = ['id', 'client', 'deliverer', 'status', 'created_at']
    list_filter = ['status']
    search_fields = ['client__email', 'description']


@admin.register(FinancialRecord)
class FinancialRecordAdmin(admin.ModelAdmin):
    list_display = ['id', 'deliverer', 'record_type', 'amount', 'runners_commission', 'created_at']
    list_filter = ['record_type']
    search_fields = ['deliverer__user__email', 'description']


@admin.register(SystemConfig)
class SystemConfigAdmin(admin.ModelAdmin):
    list_display = ['key', 'value', 'updated_at']
    search_fields = ['key']
