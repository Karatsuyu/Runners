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
    category_name = drf_serializers.SerializerMethodField()
    owner_id = drf_serializers.IntegerField(source='owner.id', read_only=True)
    category = drf_serializers.IntegerField(required=False, allow_null=True, write_only=True)
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
            'category_name',
            'contact_type',
            'image',
            'image_url',
            'owner_id',
            'approval_status',
            'rejection_reason',
            'is_active',
            'category',
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
            Contact.ContactType.CONTACTO: 'contacto',
            Contact.ContactType.SERVICIO: 'servicio',
        }
        return mapping.get(obj.contact_type, 'other')

    def get_image_url(self, obj):
        if not obj.image:
            return None
        request = self.context.get('request')
        if request is None:
            return obj.image.url
        return request.build_absolute_uri(obj.image.url)

    def get_category_name(self, obj):
        return obj.category.name if obj.category else None

    def validate(self, attrs):
        raw_type = self.initial_data.get('type')
        raw_contact_type = self.initial_data.get('contact_type')
        # Prefer explicit `contact_type` (backend enum) over the user-facing
        # `type` value which may be custom and cause validation errors.
        selected_type = raw_contact_type or raw_type
        try:
            print(f"[CONTACTS DEBUG] serializer.validate raw_type={raw_type} raw_contact_type={raw_contact_type}")
        except Exception:
            pass
        mapping = {
            'emergency': Contact.ContactType.EMERGENCIA,
            'professional': Contact.ContactType.PROFESIONAL,
            'commerce': Contact.ContactType.COMERCIO,
            'contacto': Contact.ContactType.CONTACTO,
            'servicio': Contact.ContactType.SERVICIO,
            'other': Contact.ContactType.OTRO,
            Contact.ContactType.EMERGENCIA: Contact.ContactType.EMERGENCIA,
            Contact.ContactType.PROFESIONAL: Contact.ContactType.PROFESIONAL,
            Contact.ContactType.COMERCIO: Contact.ContactType.COMERCIO,
            Contact.ContactType.CONTACTO: Contact.ContactType.CONTACTO,
            Contact.ContactType.SERVICIO: Contact.ContactType.SERVICIO,
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

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        request = self.context.get('request')
        user = getattr(request, 'user', None)

        if instance.contact_type == Contact.ContactType.SERVICIO:
            is_admin = user and user.is_authenticated and user.role == user.Role.ADMIN
            is_owner = user and user.is_authenticated and instance.owner_id == user.id
            if not is_admin and not is_owner:
                ret['phone'] = 'Privado'

        if instance.category:
            ret['category_name'] = instance.category.name

        return ret


class ContactListView(generics.ListCreateAPIView):
    serializer_class = ContactSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'description', 'phone']
    ordering_fields = ['name', 'contact_type']

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            queryset = Contact.objects.filter(
                is_active=True,
                approval_status=Contact.ApprovalStatus.APROBADO,
            )
        elif user.role == user.Role.ADMIN:
            # Allow admins to see all contacts (active and inactive)
            queryset = Contact.objects.all()
        else:
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
        # Debug logging: print incoming request user and payload
        try:
            print(f"[CONTACTS DEBUG] perform_create called by user={getattr(user, 'id', None)} role={getattr(user, 'role', None)}")
            print(f"[CONTACTS DEBUG] payload keys: {list(self.request.data.keys())}")
        except Exception:
            pass

        # Only enforce "one contact per user" for non-admin users
        if user.role != user.Role.ADMIN:
            # Validación de unicidad
            if Contact.objects.filter(owner=user).exists():
                from rest_framework.exceptions import ValidationError
                raise ValidationError({'detail': 'Ya tienes un contacto creado. Solo se permite uno por usuario.'})

        if user.role == user.Role.ADMIN:
            serializer.save(
                owner=user,
                approval_status=Contact.ApprovalStatus.APROBADO,
                reviewed_by=user,
                reviewed_at=timezone.now(),
                is_active=True,
            )
            try:
                inst = getattr(serializer, 'instance', None)
                print(f"[CONTACTS DEBUG] created id={getattr(inst,'id',None)} owner_id={getattr(inst,'owner_id',None)} is_active={getattr(inst,'is_active',None)}")
            except Exception:
                pass
            return

        serializer.save(
            owner=user,
            approval_status=Contact.ApprovalStatus.PENDIENTE,
            is_active=True,
        )
        try:
            inst = getattr(serializer, 'instance', None)
            print(f"[CONTACTS DEBUG] created id={getattr(inst,'id',None)} owner_id={getattr(inst,'owner_id',None)} is_active={getattr(inst,'is_active',None)}")
        except Exception:
            pass


class ContactDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Contact.objects.all()
    serializer_class = ContactSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        user = self.request.user
        if not user.is_authenticated:
            return Contact.objects.filter(
                is_active=True,
                approval_status=Contact.ApprovalStatus.APROBADO,
            )
        if user.role == user.Role.ADMIN:
            return Contact.objects.all()
        return Contact.objects.filter(owner=user)

    def update(self, request, *args, **kwargs):
        contact = self.get_object()
        try:
            print(f"[CONTACTS DEBUG] update called for id={contact.id} before is_active={contact.is_active} approval_status={contact.approval_status} owner_id={getattr(contact,'owner_id',None)}")
            print(f"[CONTACTS DEBUG] update payload keys: {list(request.data.keys())}")
        except Exception:
            pass
        user = request.user
        if user.role == user.Role.ADMIN:
            res = super().update(request, *args, **kwargs)
            try:
                inst = self.get_object()
                print(f"[CONTACTS DEBUG] update result for id={inst.id} after is_active={inst.is_active} approval_status={inst.approval_status} owner_id={getattr(inst,'owner_id',None)}")
            except Exception:
                pass
            return res
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
        res = super().update(request, *args, **kwargs)
        try:
            inst = self.get_object()
            print(f"[CONTACTS DEBUG] update result for id={inst.id} after is_active={inst.is_active} approval_status={inst.approval_status} owner_id={getattr(inst,'owner_id',None)}")
        except Exception:
            pass
        return res

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


@api_view(['POST'])
@permission_classes([IsAdmin])
def toggle_contact_status(request, pk):
    try:
        contact = Contact.objects.get(pk=pk)
    except Contact.DoesNotExist:
        return Response({'error': 'Contacto no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    contact.is_active = not contact.is_active
    contact.save(update_fields=['is_active', 'updated_at'])

    state = 'activado' if contact.is_active else 'desactivado'
    return Response(
        {
            'message': f'Contacto {state} exitosamente.',
            'id': contact.id,
            'is_active': contact.is_active,
        },
        status=status.HTTP_200_OK,
    )
