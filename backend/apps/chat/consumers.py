# pyright: reportMissingImports=false

from urllib.parse import parse_qs

from asgiref.sync import sync_to_async
from channels.generic.websocket import AsyncJsonWebsocketConsumer  # type: ignore
from rest_framework_simplejwt.tokens import AccessToken

from apps.users.models import User
from .models import ChatMessage, ChatThread


class ChatConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        self.thread_id = self.scope['url_route']['kwargs']['thread_id']
        token = self._get_token_from_query()

        if not token:
            await self.close(code=4001)
            return

        user = await self._get_user_from_token(token)
        if not user:
            await self.close(code=4002)
            return

        can_access = await self._user_in_thread(user.id, self.thread_id)
        if not can_access:
            await self.close(code=4003)
            return

        self.user = user
        self.group_name = f'chat_thread_{self.thread_id}'

        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, 'group_name'):
            await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive_json(self, content, **kwargs):
        message = (content.get('message') or '').strip()
        if not message:
            await self.send_json({'error': 'Mensaje vacío.'})
            return

        payload = await self._create_message(self.thread_id, self.user.id, message)

        await self.channel_layer.group_send(
            self.group_name,
            {
                'type': 'chat.message',
                'payload': payload,
            },
        )

    async def chat_message(self, event):
        await self.send_json(event['payload'])

    def _get_token_from_query(self):
        query = self.scope.get('query_string', b'').decode()
        params = parse_qs(query)
        token_list = params.get('token', [])
        return token_list[0] if token_list else None

    @sync_to_async
    def _get_user_from_token(self, token):
        try:
            access = AccessToken(token)
            user_id = access.get('user_id')
            if not user_id:
                return None
            return User.objects.filter(id=user_id, is_active=True).first()
        except Exception:
            return None

    @sync_to_async
    def _user_in_thread(self, user_id, thread_id):
        return ChatThread.objects.filter(id=thread_id, participants__id=user_id).exists()

    @sync_to_async
    def _create_message(self, thread_id, user_id, body):
        thread = ChatThread.objects.get(id=thread_id)
        user = User.objects.get(id=user_id)
        message = ChatMessage.objects.create(thread=thread, sender=user, message=body)
        thread.last_message_at = message.created_at
        thread.save(update_fields=['last_message_at'])

        return {
            'id': message.id,
            'thread_id': thread_id,
            'sender_id': user_id,
            'sender_name': user.get_full_name(),
            'message': message.message,
            'created_at': message.created_at.isoformat(),
        }
