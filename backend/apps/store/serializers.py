from rest_framework import serializers
from .models import Category, Commerce, Product, Order, OrderItem


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name', 'description', 'icon', 'is_active']


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'commerce', 'name', 'description', 'price', 'image', 'is_available']
        read_only_fields = ['id']

    def validate_price(self, value):
        if value <= 0:
            raise serializers.ValidationError('El precio debe ser mayor a cero.')
        return value


class CommerceSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    products_count = serializers.SerializerMethodField()

    class Meta:
        model = Commerce
        fields = ['id', 'category', 'category_name', 'name', 'description', 'phone', 'address', 'image', 'is_active', 'products_count']
        read_only_fields = ['id']

    def get_products_count(self, obj):
        return obj.products.filter(is_available=True).count()


class CommerceDetailSerializer(CommerceSerializer):
    products = ProductSerializer(many=True, read_only=True)

    class Meta(CommerceSerializer.Meta):
        fields = CommerceSerializer.Meta.fields + ['products']


class OrderItemSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)
    subtotal = serializers.ReadOnlyField()

    class Meta:
        model = OrderItem
        fields = ['id', 'product', 'product_name', 'quantity', 'unit_price', 'subtotal']


class OrderItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = ['product', 'quantity']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    client_name = serializers.CharField(source='client.get_full_name', read_only=True)
    commerce_name = serializers.CharField(source='commerce.name', read_only=True)

    class Meta:
        model = Order
        fields = ['id', 'client', 'client_name', 'commerce', 'commerce_name', 'status', 'total', 'notes', 'via_runners', 'items', 'created_at']
        read_only_fields = ['id', 'client', 'total', 'via_runners', 'created_at']


class OrderCreateSerializer(serializers.Serializer):
    commerce_id = serializers.IntegerField()
    items = OrderItemCreateSerializer(many=True)
    notes = serializers.CharField(required=False, allow_blank=True)

    def validate_items(self, value):
        if not value:
            raise serializers.ValidationError('El pedido debe tener al menos un producto.')
        return value

    def create(self, validated_data):
        from .models import Commerce, Product
        request = self.context['request']
        commerce_id = validated_data['commerce_id']

        try:
            commerce = Commerce.objects.get(pk=commerce_id, is_active=True)
        except Commerce.DoesNotExist:
            raise serializers.ValidationError({'commerce_id': 'Comercio no encontrado o inactivo.'})

        order = Order.objects.create(
            client=request.user,
            commerce=commerce,
            notes=validated_data.get('notes', ''),
            via_runners=True
        )

        for item_data in validated_data['items']:
            product = item_data['product']
            if not product.is_available:
                raise serializers.ValidationError(f'El producto {product.name} no está disponible.')
            OrderItem.objects.create(
                order=order,
                product=product,
                quantity=item_data['quantity'],
                unit_price=product.price
            )

        order.calculate_total()
        return order
