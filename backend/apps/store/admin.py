from django.contrib import admin
from .models import Category, Commerce, Product, Order, OrderItem


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'created_at']
    list_filter = ['is_active']
    search_fields = ['name']


@admin.register(Commerce)
class CommerceAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'business_type', 'phone', 'menu_pdf', 'is_active', 'created_at']
    list_filter = ['category', 'business_type', 'is_active']
    search_fields = ['name', 'description']


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'commerce', 'price', 'is_available']
    list_filter = ['is_available', 'commerce']
    search_fields = ['name']


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = ['subtotal']


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'client', 'commerce', 'status', 'total', 'via_runners', 'created_at']
    list_filter = ['status', 'via_runners', 'created_at']
    search_fields = ['client__email', 'commerce__name']
    inlines = [OrderItemInline]
