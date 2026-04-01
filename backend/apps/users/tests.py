from django.test import TestCase, override_settings
from django.urls import reverse
from django.core import mail
from rest_framework.test import APIClient
from .models import User, PasswordResetCode


@override_settings(EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend')
class PasswordResetFlowTests(TestCase):
	def setUp(self):
		self.client = APIClient()
		self.user = User.objects.create_user(
			email='cliente@test.com',
			first_name='Cliente',
			last_name='Demo',
			password='SecurePass123!',
		)

	def test_request_password_reset_sends_code_by_email(self):
		url = reverse('password_reset_request')
		response = self.client.post(url, {'email': self.user.email}, format='json')

		self.assertEqual(response.status_code, 200)
		self.assertEqual(PasswordResetCode.objects.filter(user=self.user).count(), 1)
		self.assertEqual(len(mail.outbox), 1)
		self.assertIn('Codigo de recuperacion', mail.outbox[0].subject)

	def test_confirm_password_reset_updates_password(self):
		reset_code = PasswordResetCode.create_for_user(self.user)
		url = reverse('password_reset_confirm')
		payload = {
			'email': self.user.email,
			'code': reset_code.code,
			'new_password': 'NuevaClave123!',
			'new_password2': 'NuevaClave123!',
		}

		response = self.client.post(url, payload, format='json')

		self.assertEqual(response.status_code, 200)
		reset_code.refresh_from_db()
		self.assertTrue(reset_code.is_used)

		self.user.refresh_from_db()
		self.assertTrue(self.user.check_password('NuevaClave123!'))
