from rest_framework import serializers
from .models import Category, Commerce, Product, Order, OrderItem, CommerceMenuFile


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
    menu_pdf = serializers.SerializerMethodField()

    class Meta:
        model = Commerce
        fields = [
            'id', 'category', 'category_name', 'name', 'description', 'phone', 'address',
            'image', 'menu_pdf', 'is_active', 'products_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'products_count', 'category_name']

    def get_products_count(self, obj):
        return obj.products.filter(is_available=True).count()

    def get_menu_pdf(self, obj):
        # Prefer explicit legacy `menu_pdf` field; otherwise, use the first
        # attached `CommerceMenuFile`'s file URL (if any). Keeps list endpoint
        # useful for quick UI rendering without fetching detail.
        try:
            if obj.menu_pdf:
                # FileField -> return URL
                return obj.menu_pdf.url if hasattr(obj.menu_pdf, 'url') else obj.menu_pdf
        except Exception:
            # ignore and try menu_files
            pass
        first = obj.menu_files.order_by('-created_at').first() if hasattr(obj, 'menu_files') else None
        if first and getattr(first, 'file', None):
            try:
                return first.file.url
            except Exception:
                return None
        return None


class CommerceDetailSerializer(CommerceSerializer):
    products = ProductSerializer(many=True, read_only=True)
    menu_files = serializers.SerializerMethodField()

    class Meta(CommerceSerializer.Meta):
        fields = CommerceSerializer.Meta.fields + ['products', 'menu_files']

    def get_menu_files(self, obj):
        files = obj.menu_files.all().order_by('-created_at')
        return [
            {
                'id': f.id,
                'url': f.file.url if f.file else None,
                'filename': f.file.name.split('/')[-1] if f.file else None,
                'file_type': f.file_type,
                'created_at': f.created_at,
            }
            for f in files
        ]


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
        fields = [
            'id', 'client', 'client_name', 'commerce', 'commerce_name',
            'status', 'products_subtotal', 'delivery_total', 'total',
            'notes', 'via_runners', 'items', 'created_at'
        ]
        read_only_fields = ['id', 'client', 'products_subtotal', 'delivery_total', 'total', 'via_runners', 'created_at']


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


class CommerceMenuFileSerializer(serializers.ModelSerializer):
    filename = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = CommerceMenuFile
        fields = ['id', 'commerce', 'file', 'filename', 'file_type', 'created_at']
        read_only_fields = ['id', 'filename', 'created_at', 'commerce']

    def get_filename(self, obj):
        return obj.file.name.split('/')[-1] if obj.file else None
