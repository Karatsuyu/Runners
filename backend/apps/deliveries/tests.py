from decimal import Decimal
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from apps.users.models import User
from apps.deliveries.models import Deliverer, DeliveryRequest
from apps.store.models import Category, Commerce, Order


class DeliveryFlowTests(APITestCase):
    def setUp(self):
        self.client_user = User.objects.create_user(
            email='cliente@test.com',
            password='123456',
            first_name='Cliente',
            last_name='Uno',
            role=User.Role.CLIENTE,
        )
        self.admin_user = User.objects.create_user(
            email='admin@test.com',
            password='123456',
            first_name='Admin',
            last_name='Uno',
            role=User.Role.ADMIN,
        )
        deliverer_user = User.objects.create_user(
            email='domi@test.com',
            password='123456',
            first_name='Domi',
            last_name='Uno',
            role=User.Role.DOMICILIARIO,
        )
        self.deliverer = Deliverer.objects.create(
            user=deliverer_user,
            assigned_number=1,
            status=Deliverer.Status.DISPONIBLE,
        )
        category = Category.objects.create(name='Comidas')
        commerce = Commerce.objects.create(category=category, name='Restaurante Central')
        self.order = Order.objects.create(
            client=self.client_user,
            commerce=commerce,
            products_subtotal=Decimal('12000'),
            total=Decimal('12000'),
        )

    def test_admin_approval_updates_order_total(self):
        self.client.force_authenticate(self.client_user)
        create_res = self.client.post(
            reverse('delivery_request_create'),
            {
                'description': 'Pedido principal',
                'pickup_address': 'Calle 1',
                'delivery_address': 'Calle 2',
                'order_id': self.order.id,
            },
            format='json',
        )
        self.assertEqual(create_res.status_code, status.HTTP_201_CREATED)
        request_id = create_res.data['id']

        self.client.force_authenticate(self.admin_user)
        approve_res = self.client.patch(
            reverse('delivery_request_approve', kwargs={'pk': request_id}),
            {'admin_delivery_fee': '3500', 'approved': True},
            format='json',
        )
        self.assertEqual(approve_res.status_code, status.HTTP_200_OK)

        self.order.refresh_from_db()
        self.assertEqual(self.order.delivery_total, Decimal('3500'))
        self.assertEqual(self.order.total, Decimal('15500'))

    def test_paid_toggle_requires_delivered(self):
        delivery = DeliveryRequest.objects.create(
            client=self.client_user,
            deliverer=self.deliverer,
            description='Paquete',
            pickup_address='A',
            delivery_address='B',
            status=DeliveryRequest.Status.ACEPTADO,
            approval_status=DeliveryRequest.ApprovalStatus.AUTORIZADO,
        )
        self.client.force_authenticate(self.deliverer.user)
        paid_res = self.client.post(
            reverse('delivery_request_complete', kwargs={'pk': delivery.id}),
            {'is_paid': True},
            format='json',
        )
        self.assertEqual(paid_res.status_code, status.HTTP_400_BAD_REQUEST)
