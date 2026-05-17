from django.contrib import admin
from .models import Category, Commerce, Product, Order, OrderItem
from .models import CommerceMenuFile


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'is_active', 'created_at']
    list_filter = ['is_active']
    search_fields = ['name']


@admin.register(Commerce)
class CommerceAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'phone', 'menu_pdf_display', 'is_active', 'created_at']
    list_filter = ['category', 'is_active']
    search_fields = ['name', 'description']
    fieldsets = (
        ('Información General', {
            'fields': ('name', 'category', 'description', 'phone', 'address', 'is_active')
        }),
        ('Medios', {
            'fields': ('image', 'menu_pdf')
        }),
    )
    readonly_fields = ['created_at', 'updated_at']
    
    def menu_pdf_display(self, obj):
        if obj.menu_pdf:
            return '✓ PDF'
        return '-'
    menu_pdf_display.short_description = 'Menú PDF'


class CommerceMenuFileInline(admin.TabularInline):
    model = CommerceMenuFile
    extra = 0
    readonly_fields = ['created_at']

    def filename(self, obj):
        return obj.file.name.split('/')[-1]

    filename.short_description = 'Archivo'

# add inline to CommerceAdmin (ensure tuple concatenation)
existing_inlines = getattr(CommerceAdmin, 'inlines', ())
if not isinstance(existing_inlines, tuple):
    existing_inlines = tuple(existing_inlines)
CommerceAdmin.inlines = existing_inlines + (CommerceMenuFileInline,)


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
