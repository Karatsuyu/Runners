from rest_framework import serializers

from .models import ChatMessage, ChatThread


class ChatMessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(source='sender.get_full_name', read_only=True)

    class Meta:
        model = ChatMessage
        fields = ['id', 'thread', 'sender', 'sender_name', 'message', 'created_at']
        read_only_fields = ['id', 'thread', 'sender', 'sender_name', 'created_at']


class ChatThreadSerializer(serializers.ModelSerializer):
    participants = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    participants_names = serializers.SerializerMethodField()
    last_message = serializers.SerializerMethodField()

    class Meta:
        model = ChatThread
        fields = [
            'id', 'thread_type', 'delivery_request', 'service_request',
            'participants', 'participants_names', 'last_message_at', 'last_message', 'created_at'
        ]
        read_only_fields = fields

    def get_participants_names(self, obj):
        return [p.get_full_name() for p in obj.participants.all()]

    def get_last_message(self, obj):
        msg = obj.messages.order_by('-created_at').first()
        if not msg:
            return None
        return {
            'id': msg.id,
            'sender': msg.sender.get_full_name(),
            'message': msg.message,
            'created_at': msg.created_at,
        }
