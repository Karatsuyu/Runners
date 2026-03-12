from django.db import models
from apps.users.models import User


class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=50, blank=True)  # Nombre de ícono o clase CSS
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'store_categories'
        verbose_name = 'Categoría'
        verbose_name_plural = 'Categorías'

    def __str__(self):
        return self.name


class Commerce(models.Model):
    """Representa un restaurante o almacén registrado en la tienda."""
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name='commerces')
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    phone = models.CharField(max_length=20, blank=True)
    address = models.CharField(max_length=255, blank=True)
    image = models.ImageField(upload_to='store/commerces/', blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'store_commerces'
        verbose_name = 'Comercio'
        verbose_name_plural = 'Comercios'
        ordering = ['name']

    def __str__(self):
        return f'{self.name} - {self.category.name}'


class Product(models.Model):
    commerce = models.ForeignKey(Commerce, on_delete=models.CASCADE, related_name='products')
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='store/products/', blank=True, null=True)
    is_available = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'store_products'
        verbose_name = 'Producto'
        verbose_name_plural = 'Productos'
        ordering = ['name']

    def __str__(self):
        return f'{self.name} - ${self.price}'


class Order(models.Model):
    class Status(models.TextChoices):
        PENDIENTE = 'PENDIENTE', 'Pendiente'
        CONFIRMADO = 'CONFIRMADO', 'Confirmado'
        EN_PREPARACION = 'EN_PREPARACION', 'En Preparación'
        EN_CAMINO = 'EN_CAMINO', 'En Camino'
        ENTREGADO = 'ENTREGADO', 'Entregado'
        CANCELADO = 'CANCELADO', 'Cancelado'

    client = models.ForeignKey(User, on_delete=models.PROTECT, related_name='orders')
    commerce = models.ForeignKey(Commerce, on_delete=models.PROTECT, related_name='orders')
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDIENTE)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    notes = models.TextField(blank=True)
    via_runners = models.BooleanField(default=True)  # Trazabilidad: siempre True si viene de la plataforma
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'store_orders'
        verbose_name = 'Pedido'
        verbose_name_plural = 'Pedidos'
        ordering = ['-created_at']

    def __str__(self):
        return f'Pedido #{self.id} - {self.client.get_full_name()} → {self.commerce.name}'

    def calculate_total(self):
        self.total = sum(item.subtotal for item in self.items.all())
        self.save(update_fields=['total'])


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField(default=1)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)  # Precio al momento del pedido

    class Meta:
        db_table = 'store_order_items'
        verbose_name = 'Ítem de Pedido'

    @property
    def subtotal(self):
        return self.unit_price * self.quantity
