from django.contrib import admin
from .models import ServiceCategory, ServiceProvider, ServiceRequest


@admin.register(ServiceCategory)
class ServiceCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active']
    list_filter = ['is_active']
    search_fields = ['name']


@admin.register(ServiceProvider)
class ServiceProviderAdmin(admin.ModelAdmin):
    list_display = ['user', 'category', 'status', 'approval_status', 'created_at']
    list_filter = ['status', 'approval_status', 'category']
    search_fields = ['user__email', 'user__first_name', 'user__last_name']
    readonly_fields = ['approved_by', 'approved_at', 'created_at', 'updated_at']


@admin.register(ServiceRequest)
class ServiceRequestAdmin(admin.ModelAdmin):
    list_display = ['id', 'client', 'provider', 'category', 'status', 'created_at']
    list_filter = ['status', 'category']
    search_fields = ['client__email', 'description']
