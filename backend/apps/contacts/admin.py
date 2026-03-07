from django.contrib import admin
from .models import Contact


@admin.register(Contact)
class ContactAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'contact_type', 'availability', 'is_active']
    list_filter = ['contact_type', 'availability', 'is_active']
    search_fields = ['name', 'phone', 'description']
