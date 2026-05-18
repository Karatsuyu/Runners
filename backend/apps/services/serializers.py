from rest_framework import serializers
from .models import ServiceCategory, ServiceProvider, ServiceRequest
from apps.users.serializers import UserProfileSerializer


class ServiceCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceCategory
        fields = ['id', 'name', 'description', 'is_active']


class ServiceProviderSerializer(serializers.ModelSerializer):
    user_info = UserProfileSerializer(source='user', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)

    class Meta:
        model = ServiceProvider
        fields = ['id', 'user', 'user_info', 'full_name', 'category', 'category_name',
                  'description', 'photo', 'resume', 'status', 'approval_status',
                  'terms_accepted', 'created_at']
        read_only_fields = ['id', 'approval_status', 'approved_by', 'approved_at', 'created_at']


class ServiceProviderRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceProvider
        fields = ['category', 'description', 'photo', 'resume', 'terms_accepted']

    def validate_terms_accepted(self, value):
        if not value:
            raise serializers.ValidationError('Debes aceptar los términos y condiciones.')
        return value

    def create(self, validated_data):
        user = self.context['request'].user
        return ServiceProvider.objects.create(user=user, **validated_data)


class ServiceRequestSerializer(serializers.ModelSerializer):
    client_name = serializers.CharField(source='client.get_full_name', read_only=True)
    provider_name = serializers.CharField(source='provider.user.get_full_name', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = ServiceRequest
        fields = ['id', 'client', 'client_name', 'provider', 'provider_name',
                  'category', 'category_name', 'description', 'status',
                  'provider_fee', 'runners_fee', 'client_total', 'created_at']
        read_only_fields = ['id', 'client', 'status', 'runners_fee', 'client_total', 'created_at']

    def validate(self, attrs):
        provider = attrs.get('provider')
        category = attrs.get('category')

        if provider.approval_status != ServiceProvider.ApprovalStatus.APROBADO:
            raise serializers.ValidationError({'provider': 'El prestador seleccionado no está aprobado.'})

        if provider.status != ServiceProvider.Status.DISPONIBLE:
            raise serializers.ValidationError({'provider': 'El prestador seleccionado no está disponible.'})

        if provider.category_id != category.id:
            raise serializers.ValidationError({'category': 'La categoría no coincide con el prestador seleccionado.'})

        return attrs
