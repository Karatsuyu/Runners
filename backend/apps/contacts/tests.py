from django.test import TestCase
from rest_framework.test import APIClient
from apps.contacts.models import Contact


class ContactPublicAccessTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        Contact.objects.create(name='Test Contact', phone='3000000000', contact_type=Contact.ContactType.EMERGENCIA)

    def test_contacts_list_is_public(self):
        response = self.client.get('/api/v1/contacts/')
        self.assertEqual(response.status_code, 200)
        self.assertIsInstance(response.data, dict)
        self.assertIn('results', response.data)
        self.assertGreaterEqual(len(response.data['results']), 1)

