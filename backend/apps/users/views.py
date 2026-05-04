from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.mail import send_mail
from django.conf import settings
from .models import User, PasswordResetCode
from .serializers import (
    UserRegisterSerializer,
    UserProfileSerializer,
    UserAdminSerializer,
    PasswordResetRequestSerializer,
    PasswordResetConfirmSerializer,
)
from .permissions import IsAdmin, IsOwnerOrAdmin


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegisterSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        # Generar tokens automáticamente al registrar
        refresh = RefreshToken.for_user(user)
        return Response({
            'user': UserProfileSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)


class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [JSONParser, FormParser, MultiPartParser]

    def get_object(self):
        return self.request.user


class UserListView(generics.ListAPIView):
    """Solo para administradores."""
    serializer_class = UserAdminSerializer
    permission_classes = [IsAdmin]

    def get_queryset(self):
        queryset = User.objects.all()
        role = self.request.query_params.get('role')
        if role:
            queryset = queryset.filter(role=role)
        is_active = self.request.query_params.get('is_active')
        if is_active is not None:
            queryset = queryset.filter(is_active=is_active == 'true')
        return queryset


class UserDetailAdminView(generics.RetrieveUpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserAdminSerializer
    permission_classes = [IsAdmin]


@api_view(['POST'])
@permission_classes([IsAdmin])
def toggle_user_status(request, pk):
    """Activar o suspender un usuario."""
    try:
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return Response({'error': 'Usuario no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    if user == request.user:
        return Response({'error': 'No puedes suspenderte a ti mismo.'}, status=status.HTTP_400_BAD_REQUEST)

    user.is_active = not user.is_active
    user.save(update_fields=['is_active'])
    action = 'activado' if user.is_active else 'suspendido'
    return Response({'message': f'Usuario {action} exitosamente.', 'is_active': user.is_active})


class PasswordResetRequestView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = PasswordResetRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        email = serializer.validated_data['email']
        user = User.objects.filter(email=email, is_active=True).first()

        if user:
            reset_code = PasswordResetCode.create_for_user(user)
            app_name = getattr(settings, 'APP_NAME', 'Runners')
            send_mail(
                subject=f'Codigo de recuperacion - {app_name}',
                message=(
                    f'Hola {user.first_name},\n\n'
                    f'Tu codigo de recuperacion es: {reset_code.code}\n'
                    'Este codigo vence en 10 minutos.\n\n'
                    'Si no solicitaste este cambio, ignora este mensaje.'
                ),
                from_email=getattr(settings, 'DEFAULT_FROM_EMAIL', 'no-reply@runners.local'),
                recipient_list=[user.email],
                fail_silently=False,
            )

        return Response(
            {'message': 'Si el correo existe, enviamos un codigo de verificacion.'},
            status=status.HTTP_200_OK,
        )


class PasswordResetConfirmView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = PasswordResetConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        user = serializer.validated_data['user']
        reset_code = serializer.validated_data['reset_code']
        new_password = serializer.validated_data['new_password']

        user.set_password(new_password)
        user.save(update_fields=['password'])

        reset_code.is_used = True
        reset_code.save(update_fields=['is_used'])

        return Response(
            {'message': 'Contrasena actualizada exitosamente.'},
            status=status.HTTP_200_OK,
        )
