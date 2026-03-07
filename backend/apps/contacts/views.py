from rest_framework import generics, permissions, filters
from rest_framework import serializers as drf_serializers
from .models import Contact
from apps.users.permissions import IsAdminOrReadOnly


class ContactSerializer(drf_serializers.ModelSerializer):
    class Meta:
        model = Contact
        fields = ['id', 'name', 'phone', 'description', 'contact_type', 'availability', 'is_active', 'created_at']
        read_only_fields = ['id', 'created_at']


class ContactListView(generics.ListCreateAPIView):
    serializer_class = ContactSerializer
    permission_classes = [IsAdminOrReadOnly]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'description', 'phone']
    ordering_fields = ['name', 'contact_type']

    def get_queryset(self):
        queryset = Contact.objects.filter(is_active=True)
        contact_type = self.request.query_params.get('type')
        if contact_type:
            queryset = queryset.filter(contact_type=contact_type)
        availability = self.request.query_params.get('availability')
        if availability:
            queryset = queryset.filter(availability=availability)
        return queryset


class ContactDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Contact.objects.all()
    serializer_class = ContactSerializer
    permission_classes = [IsAdminOrReadOnly]
