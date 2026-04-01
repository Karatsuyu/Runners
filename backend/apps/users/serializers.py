from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import User, PasswordResetCode


class UserRegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, label='Confirmar contraseña')

    class Meta:
        model = User
        fields = ['email', 'username', 'first_name', 'last_name', 'phone', 'password', 'password2']
        extra_kwargs = {
            'username': {'required': False, 'allow_blank': True, 'allow_null': True},
        }

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({'password': 'Las contraseñas no coinciden.'})
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(**validated_data)
        return user


class UserProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    profile_image_url = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id',
            'email',
            'username',
            'first_name',
            'last_name',
            'full_name',
            'phone',
            'profile_image',
            'profile_image_url',
            'role',
            'date_joined',
        ]
        read_only_fields = ['id', 'email', 'role', 'date_joined']

    def get_full_name(self, obj):
        return obj.get_full_name()

    def get_profile_image_url(self, obj):
        if not obj.profile_image:
            return None
        request = self.context.get('request')
        if request:
            return request.build_absolute_uri(obj.profile_image.url)
        return obj.profile_image.url

    def validate_username(self, value):
        if not value:
            return value
        qs = User.objects.filter(username__iexact=value)
        if self.instance:
            qs = qs.exclude(pk=self.instance.pk)
        if qs.exists():
            raise serializers.ValidationError('Este nombre de usuario ya está en uso.')
        return value


class UserAdminSerializer(serializers.ModelSerializer):
    """Serializer con más información para el panel de administración."""
    class Meta:
        model = User
        fields = ['id', 'email', 'first_name', 'last_name', 'phone', 'role', 'is_active', 'date_joined']
        read_only_fields = ['id', 'date_joined']


class PasswordResetRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()


class PasswordResetConfirmSerializer(serializers.Serializer):
    email = serializers.EmailField()
    code = serializers.CharField(max_length=6, min_length=6)
    new_password = serializers.CharField(write_only=True, validators=[validate_password])
    new_password2 = serializers.CharField(write_only=True, label='Confirmar nueva contraseña')

    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password2']:
            raise serializers.ValidationError({'new_password': 'Las contraseñas no coinciden.'})

        user = User.objects.filter(email=attrs['email']).first()
        if not user:
            raise serializers.ValidationError({'code': 'Codigo invalido o expirado.'})

        reset_code = PasswordResetCode.objects.filter(
            user=user,
            code=attrs['code'],
            is_used=False,
        ).order_by('-created_at').first()

        if not reset_code or reset_code.is_expired:
            raise serializers.ValidationError({'code': 'Codigo invalido o expirado.'})

        attrs['user'] = user
        attrs['reset_code'] = reset_code
        return attrs
