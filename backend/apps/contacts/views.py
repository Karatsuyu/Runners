from rest_framework import generics, permissions, filters, status
from rest_framework import serializers as drf_serializers
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.utils import timezone
from .models import Contact
from apps.users.permissions import IsAdmin


class ContactSerializer(drf_serializers.ModelSerializer):
    type = drf_serializers.SerializerMethodField()
    image_url = drf_serializers.SerializerMethodField()
    owner_id = drf_serializers.IntegerField(source='owner.id', read_only=True)
    approval_status = drf_serializers.CharField(read_only=True)
    rejection_reason = drf_serializers.CharField(read_only=True)

    class Meta:
        model = Contact
        fields = [
            'id',
            'name',
            'phone',
            'email',
            'description',
            'type',
            'contact_type',
            'image',
            'image_url',
            'owner_id',
            'approval_status',
            'rejection_reason',
            'is_active',
            'created_at',
        ]
        read_only_fields = ['id', 'created_at']
        extra_kwargs = {
            'contact_type': {'required': False},
            'image': {'required': False},
        }

    def get_type(self, obj):
        mapping = {
            Contact.ContactType.EMERGENCIA: 'emergency',
            Contact.ContactType.PROFESIONAL: 'professional',
            Contact.ContactType.COMERCIO: 'commerce',
        }
        return mapping.get(obj.contact_type, 'other')

    def get_image_url(self, obj):
        if not obj.image:
            return None
        request = self.context.get('request')
        if request is None:
            return obj.image.url
        return request.build_absolute_uri(obj.image.url)

    def validate(self, attrs):
        raw_type = self.initial_data.get('type')
        raw_contact_type = self.initial_data.get('contact_type')
        selected_type = raw_type or raw_contact_type
        mapping = {
            'emergency': Contact.ContactType.EMERGENCIA,
            'professional': Contact.ContactType.PROFESIONAL,
            'commerce': Contact.ContactType.COMERCIO,
            'other': Contact.ContactType.OTRO,
            Contact.ContactType.EMERGENCIA: Contact.ContactType.EMERGENCIA,
            Contact.ContactType.PROFESIONAL: Contact.ContactType.PROFESIONAL,
            Contact.ContactType.COMERCIO: Contact.ContactType.COMERCIO,
            Contact.ContactType.OTRO: Contact.ContactType.OTRO,
        }
        if selected_type:
            mapped = mapping.get(str(selected_type).strip())
            if not mapped:
                raise drf_serializers.ValidationError(
                    {'type': 'Tipo de contacto inválido.'}
                )
            attrs['contact_type'] = mapped
        return attrs


class ContactListView(generics.ListCreateAPIView):
    serializer_class = ContactSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'description', 'phone']
    ordering_fields = ['name', 'contact_type']

    def get_queryset(self):
        queryset = Contact.objects.filter(is_active=True)
        user = self.request.user
        if user.role != user.Role.ADMIN:
            queryset = (
                Contact.objects.filter(
                    is_active=True,
                    approval_status=Contact.ApprovalStatus.APROBADO,
                )
                | Contact.objects.filter(owner=user)
            ).distinct()
        contact_type = self.request.query_params.get('type')
        if contact_type:
            query_mapping = {
                'emergency': Contact.ContactType.EMERGENCIA,
                'professional': Contact.ContactType.PROFESIONAL,
                'commerce': Contact.ContactType.COMERCIO,
                'other': Contact.ContactType.OTRO,
            }
            queryset = queryset.filter(
                contact_type=query_mapping.get(contact_type, contact_type)
            )
        return queryset

    def perform_create(self, serializer):
        user = self.request.user
        if user.role == user.Role.ADMIN:
            serializer.save(
                approval_status=Contact.ApprovalStatus.APROBADO,
                reviewed_by=user,
                reviewed_at=timezone.now(),
            )
            return
        serializer.save(
            owner=user,
            approval_status=Contact.ApprovalStatus.PENDIENTE,
        )


class ContactDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Contact.objects.all()
    serializer_class = ContactSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == user.Role.ADMIN:
            return Contact.objects.all()
        return Contact.objects.filter(owner=user)

    def update(self, request, *args, **kwargs):
        contact = self.get_object()
        user = request.user
        if user.role == user.Role.ADMIN:
            return super().update(request, *args, **kwargs)
        if contact.approval_status != Contact.ApprovalStatus.APROBADO:
            return Response(
                {'error': 'Solo puedes editar tu contacto cuando esté aprobado.'},
                status=status.HTTP_403_FORBIDDEN,
            )
        allowed_keys = {'phone', 'image'}
        payload_keys = set(request.data.keys())
        if not payload_keys.issubset(allowed_keys):
            return Response(
                {'error': 'Solo puedes modificar teléfono y foto.'},
                status=status.HTTP_403_FORBIDDEN,
            )
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        if request.user.role != request.user.Role.ADMIN:
            return Response(
                {'error': 'Solo el administrador puede eliminar contactos.'},
                status=status.HTTP_403_FORBIDDEN,
            )
        return super().destroy(request, *args, **kwargs)


@api_view(['POST'])
@permission_classes([IsAdmin])
def review_contact(request, pk):
    try:
        contact = Contact.objects.get(pk=pk)
    except Contact.DoesNotExist:
        return Response({'error': 'Contacto no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    action = request.data.get('action')
    if action == 'approve':
        contact.approval_status = Contact.ApprovalStatus.APROBADO
        contact.rejection_reason = ''
    elif action == 'reject':
        contact.approval_status = Contact.ApprovalStatus.RECHAZADO
        contact.rejection_reason = request.data.get('reason', '')
    else:
        return Response(
            {'error': 'Acción inválida. Use "approve" o "reject".'},
            status=status.HTTP_400_BAD_REQUEST,
        )

    contact.reviewed_by = request.user
    contact.reviewed_at = timezone.now()
    contact.save()
    return Response(ContactSerializer(contact, context={'request': request}).data)
