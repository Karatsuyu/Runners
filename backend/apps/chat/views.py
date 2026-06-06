from django.utils import timezone
from rest_framework.exceptions import PermissionDenied
from rest_framework import generics, permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from apps.deliveries.models import DeliveryRequest
from apps.services.models import ServiceRequest
from apps.users.models import User
from .models import ChatMessage, ChatThread
from .serializers import ChatMessageSerializer, ChatThreadSerializer


def _get_or_create_delivery_thread(delivery, request_user):
    thread, created = ChatThread.objects.get_or_create(
        thread_type=ChatThread.ThreadType.DELIVERY,
        delivery_request=delivery,
        defaults={'created_by': request_user},
    )

    participants = [delivery.client]
    if delivery.deliverer and delivery.deliverer.user:
        participants.append(delivery.deliverer.user)

    admins = User.objects.filter(role=User.Role.ADMIN, is_active=True)

    for participant in participants:
        if participant:
            thread.participants.add(participant)

    for admin in admins:
        thread.participants.add(admin)

    return thread, created


def _get_or_create_service_thread(service, request_user):
    thread, created = ChatThread.objects.get_or_create(
        thread_type=ChatThread.ThreadType.SERVICE,
        service_request=service,
        defaults={'created_by': request_user},
    )

    participants = [service.client]
    if service.provider and service.provider.user:
        participants.append(service.provider.user)

    admins = User.objects.filter(role=User.Role.ADMIN, is_active=True)

    for participant in participants:
        if participant:
            thread.participants.add(participant)

    for admin in admins:
        thread.participants.add(admin)

    return thread, created


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def open_context_thread(request):
    delivery_id = request.data.get('delivery_request_id')
    service_id = request.data.get('service_request_id')

    if not delivery_id and not service_id:
        return Response({'error': 'Debes enviar delivery_request_id o service_request_id.'}, status=status.HTTP_400_BAD_REQUEST)

    if delivery_id and service_id:
        return Response({'error': 'Solo puedes abrir un contexto por solicitud.'}, status=status.HTTP_400_BAD_REQUEST)

    if delivery_id:
        try:
            delivery = DeliveryRequest.objects.select_related('client', 'deliverer__user').get(pk=delivery_id)
        except DeliveryRequest.DoesNotExist:
            return Response({'error': 'Domicilio no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

        if request.user.role != User.Role.ADMIN and request.user != delivery.client and (not delivery.deliverer or request.user != delivery.deliverer.user):
            return Response({'error': 'Sin permiso para abrir este chat.'}, status=status.HTTP_403_FORBIDDEN)

        thread, _ = _get_or_create_delivery_thread(delivery, request.user)
        return Response(ChatThreadSerializer(thread).data)

    try:
        service = ServiceRequest.objects.select_related('client', 'provider__user').get(pk=service_id)
    except ServiceRequest.DoesNotExist:
        return Response({'error': 'Servicio no encontrado.'}, status=status.HTTP_404_NOT_FOUND)

    if request.user.role != User.Role.ADMIN and request.user != service.client and request.user != service.provider.user:
        return Response({'error': 'Sin permiso para abrir este chat.'}, status=status.HTTP_403_FORBIDDEN)

    thread, _ = _get_or_create_service_thread(service, request.user)
    return Response(ChatThreadSerializer(thread).data)


class ChatThreadListView(generics.ListAPIView):
    serializer_class = ChatThreadSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return ChatThread.objects.filter(participants=self.request.user).prefetch_related('participants', 'messages')


class ChatMessageListCreateView(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        thread = ChatThread.objects.filter(pk=self.kwargs['thread_pk'], participants=self.request.user).first()
        if not thread:
            return ChatMessage.objects.none()
        return thread.messages.select_related('sender')

    def perform_create(self, serializer):
        thread = ChatThread.objects.filter(pk=self.kwargs['thread_pk'], participants=self.request.user).first()
        if not thread:
            raise PermissionDenied('No tienes permiso para enviar mensajes en este chat.')

        serializer.save(thread=thread, sender=self.request.user)
        thread.last_message_at = timezone.now()
        thread.save(update_fields=['last_message_at'])
