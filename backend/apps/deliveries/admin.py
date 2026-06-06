from django.contrib import admin
from .models import (
    Deliverer,
    DeliveryCommerceHistory,
    DeliveryPricingRule,
    DeliveryRequest,
    DeliveryZone,
    FinancialRecord,
    SystemConfig,
)


@admin.register(Deliverer)
class DelivererAdmin(admin.ModelAdmin):
    list_display = ['assigned_number', 'user', 'status', 'work_type', 'is_active']
    list_filter = ['status', 'work_type', 'is_active']
    search_fields = ['user__email', 'user__first_name', 'user__last_name']


@admin.register(DeliveryRequest)
class DeliveryRequestAdmin(admin.ModelAdmin):
    list_display = ['id', 'client', 'deliverer', 'source_type', 'commerce', 'zone', 'status', 'delivery_fee', 'created_at']
    list_filter = ['status', 'source_type', 'request_kind', 'zone']
    search_fields = ['client__email', 'description']


@admin.register(FinancialRecord)
class FinancialRecordAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'deliverer', 'record_type', 'classification', 'reason',
        'amount', 'affects_balance', 'runners_commission', 'created_at'
    ]
    list_filter = ['record_type', 'classification', 'reason', 'affects_balance']
    search_fields = ['deliverer__user__email', 'description']


@admin.register(DeliveryZone)
class DeliveryZoneAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active']
    list_filter = ['is_active']
    search_fields = ['name', 'description']


@admin.register(DeliveryPricingRule)
class DeliveryPricingRuleAdmin(admin.ModelAdmin):
    list_display = ['name', 'request_kind', 'zone', 'fee_amount', 'priority', 'is_active']
    list_filter = ['request_kind', 'zone', 'is_active']
    search_fields = ['name']


@admin.register(DeliveryCommerceHistory)
class DeliveryCommerceHistoryAdmin(admin.ModelAdmin):
    list_display = ['delivery_request', 'previous_commerce', 'new_commerce', 'changed_by', 'created_at']
    list_filter = ['created_at']
    search_fields = ['delivery_request__id']


@admin.register(SystemConfig)
class SystemConfigAdmin(admin.ModelAdmin):
    list_display = ['key', 'value', 'updated_at']
    search_fields = ['key']
