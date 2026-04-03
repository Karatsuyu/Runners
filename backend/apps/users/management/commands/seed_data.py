"""
Comando de datos semilla para Runners – Caicedonia, Valle del Cauca.

Uso:
    python manage.py seed_data            # carga todo
    python manage.py seed_data --clear    # borra y recarga todo
"""
from django.core.management.base import BaseCommand
from django.db import transaction


class Command(BaseCommand):
    help = 'Carga datos iniciales de prueba para el proyecto Runners.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--clear',
            action='store_true',
            help='Elimina los datos existentes antes de insertar.',
        )

    def handle(self, *args, **options):
        if options['clear']:
            self._clear_data()

        with transaction.atomic():
            self._seed_users()
            self._seed_store()
            self._seed_services()
            self._seed_deliveries()
            self._seed_contacts()
            self._seed_system_config()

        self.stdout.write(self.style.SUCCESS('✅  Datos semilla cargados correctamente.'))

    # ── Clear ────────────────────────────────────────────────────────────────

    def _clear_data(self):
        from apps.contacts.models import Contact
        from apps.deliveries.models import (
            Deliverer,
            DeliveryCommerceHistory,
            DeliveryPricingRule,
            DeliveryRequest,
            DeliveryZone,
            FinancialRecord,
            SystemConfig,
        )
        from apps.chat.models import ChatMessage, ChatThread
        from apps.services.models import ServiceCategory, ServiceProvider, ServiceRequest
        from apps.store.models import Category, Commerce, Product, Order, OrderItem
        from apps.users.models import User

        self.stdout.write('🗑  Limpiando datos anteriores...')
        ChatMessage.objects.all().delete()
        ChatThread.objects.all().delete()
        DeliveryCommerceHistory.objects.all().delete()
        OrderItem.objects.all().delete()
        Order.objects.all().delete()
        FinancialRecord.objects.all().delete()
        DeliveryRequest.objects.all().delete()
        DeliveryPricingRule.objects.all().delete()
        DeliveryZone.objects.all().delete()
        Deliverer.objects.all().delete()
        ServiceRequest.objects.all().delete()
        ServiceProvider.objects.all().delete()
        ServiceCategory.objects.all().delete()
        Product.objects.all().delete()
        Commerce.objects.all().delete()
        Category.objects.all().delete()
        Contact.objects.all().delete()
        SystemConfig.objects.all().delete()
        User.objects.filter(is_superuser=False).delete()

    # ── Usuarios ─────────────────────────────────────────────────────────────

    def _seed_users(self):
        from apps.users.models import User

        self.stdout.write('👤  Creando usuarios...')

        users_data = [
            # Clientes
            {'email': 'cliente1@runners.co', 'first_name': 'Carlos',    'last_name': 'Muñoz',    'phone': '3101234567', 'role': User.Role.CLIENTE,       'password': 'Runners2024!'},
            {'email': 'cliente2@runners.co', 'first_name': 'María',     'last_name': 'González', 'phone': '3112345678', 'role': User.Role.CLIENTE,       'password': 'Runners2024!'},
            {'email': 'cliente3@runners.co', 'first_name': 'Luisa',     'last_name': 'Herrera',  'phone': '3123456789', 'role': User.Role.CLIENTE,       'password': 'Runners2024!'},
            # Domiciliarios
            {'email': 'domi1@runners.co',    'first_name': 'Andrés',    'last_name': 'Ríos',     'phone': '3201112233', 'role': User.Role.DOMICILIARIO,  'password': 'Runners2024!'},
            {'email': 'domi2@runners.co',    'first_name': 'Felipe',    'last_name': 'Castro',   'phone': '3202223344', 'role': User.Role.DOMICILIARIO,  'password': 'Runners2024!'},
            {'email': 'domi3@runners.co',    'first_name': 'Sebastián', 'last_name': 'Morales',  'phone': '3203334455', 'role': User.Role.DOMICILIARIO,  'password': 'Runners2024!'},
            # Prestadores
            {'email': 'prest1@runners.co',   'first_name': 'Patricia',  'last_name': 'Salazar',  'phone': '3154445566', 'role': User.Role.PRESTADOR,     'password': 'Runners2024!'},
            {'email': 'prest2@runners.co',   'first_name': 'Ricardo',   'last_name': 'Vargas',   'phone': '3155556677', 'role': User.Role.PRESTADOR,     'password': 'Runners2024!'},
            {'email': 'prest3@runners.co',   'first_name': 'Valentina', 'last_name': 'López',    'phone': '3156667788', 'role': User.Role.PRESTADOR,     'password': 'Runners2024!'},
        ]

        self._users = {}
        for data in users_data:
            password = data.pop('password')
            user, created = User.objects.get_or_create(email=data['email'], defaults=data)
            if created:
                user.set_password(password)
                user.save()
            self._users[data['email']] = user

    # ── Tienda ────────────────────────────────────────────────────────────────

    def _seed_store(self):
        from apps.store.models import Category, Commerce, Product

        self.stdout.write('🛒  Creando tienda...')

        # Categorías
        cat_rest, _ = Category.objects.get_or_create(name='Restaurantes',   defaults={'description': 'Comida y bebidas', 'icon': 'restaurant'})
        cat_farm, _ = Category.objects.get_or_create(name='Farmacias',      defaults={'description': 'Medicamentos y salud', 'icon': 'local_pharmacy'})
        cat_merc, _ = Category.objects.get_or_create(name='Mercado',        defaults={'description': 'Abarrotes y verduras', 'icon': 'shopping_cart'})
        cat_bak,  _ = Category.objects.get_or_create(name='Panadería',      defaults={'description': 'Pan y repostería', 'icon': 'bakery_dining'})

        # Comercios
        asadero, _ = Commerce.objects.get_or_create(
            name='Asadero El Rincón Paisa',
            defaults={'category': cat_rest, 'description': 'Carnes asadas y fritanga', 'phone': '3201001001', 'address': 'Calle 5 # 4-30'},
        )
        farmacia, _ = Commerce.objects.get_or_create(
            name='Droguería Central',
            defaults={'category': cat_farm, 'description': 'Farmacia con domicilio', 'phone': '3201002002', 'address': 'Carrera 6 # 7-15'},
        )
        tienda, _ = Commerce.objects.get_or_create(
            name='Tienda Doña Rosa',
            defaults={'category': cat_merc, 'description': 'Mercado de barrio', 'phone': '3201003003', 'address': 'Barrio Santander'},
        )
        panaderia, _ = Commerce.objects.get_or_create(
            name='Panadería La Espiga',
            defaults={'category': cat_bak, 'description': 'Pan artesanal y tortas', 'phone': '3201004004', 'address': 'Calle 3 # 5-12'},
        )

        # Productos
        products_data = [
            # Asadero
            (asadero, 'Bandeja Paisa',       'Fríjoles, chicharrón, carne, aguacate',  22000),
            (asadero, 'Costillas BBQ',        'Costillas de cerdo con salsa bbq',        18000),
            (asadero, 'Pechuga a la Plancha', 'Pechuga de pollo con arroz y ensalada',  15000),
            (asadero, 'Gaseosa 400ml',        'Coca-Cola, Sprite o Manzana',              3000),
            # Farmacia
            (farmacia, 'Acetaminofén 500mg x10', 'Analgésico de venta libre',            4500),
            (farmacia, 'Ibuprofeno 400mg x10',   'Antiinflamatorio',                     6000),
            (farmacia, 'Tapabocas x5',            'Mascarilla desechable',                5000),
            # Tienda
            (tienda, 'Leche entera 1L',       'Leche Alquería',                           3200),
            (tienda, 'Huevos x6',             'Huevos de gallina campesina',              5000),
            (tienda, 'Arroz 1kg',             'Arroz blanco',                             3500),
            # Panadería
            (panaderia, 'Pan de bono x4',     'Recién horneado',                          4000),
            (panaderia, 'Roscón de guayaba',  'Ponqué relleno',                           8000),
        ]

        for commerce, name, desc, price in products_data:
            Product.objects.get_or_create(
                commerce=commerce, name=name,
                defaults={'description': desc, 'price': price, 'is_available': True},
            )

    # ── Servicios ─────────────────────────────────────────────────────────────

    def _seed_services(self):
        from apps.services.models import ServiceCategory, ServiceProvider
        from django.utils import timezone

        self.stdout.write('🔧  Creando servicios...')

        # Categorías de servicio
        cat_elec, _ = ServiceCategory.objects.get_or_create(name='Electricista', defaults={'description': 'Instalaciones eléctricas'})
        cat_plom, _ = ServiceCategory.objects.get_or_create(name='Plomero',      defaults={'description': 'Fontanería y tuberías'})
        cat_mec,  _ = ServiceCategory.objects.get_or_create(name='Mecánico',     defaults={'description': 'Mecánica automotriz'})
        cat_pint, _ = ServiceCategory.objects.get_or_create(name='Pintor',       defaults={'description': 'Pintura de interiores y exteriores'})

        admin_user = __import__('apps.users.models', fromlist=['User']).User.objects.filter(is_superuser=True).first()

        providers_data = [
            (self._users.get('prest1@runners.co'), cat_elec, 'Electricista con 10 años de experiencia en instalaciones residenciales y comerciales.'),
            (self._users.get('prest2@runners.co'), cat_plom, 'Plomero certificado, especializado en reparaciones urgentes y detección de fugas.'),
            (self._users.get('prest3@runners.co'), cat_mec,  'Mecánico automotriz, atención a domicilio para carros y motos.'),
        ]

        for user, category, description in providers_data:
            if user is None:
                continue
            provider, created = ServiceProvider.objects.get_or_create(
                user=user,
                defaults={
                    'category': category,
                    'description': description,
                    'resume': '',
                    'terms_accepted': True,
                    'approval_status': ServiceProvider.ApprovalStatus.APROBADO,
                    'status': ServiceProvider.Status.DISPONIBLE,
                    'approved_by': admin_user,
                    'approved_at': timezone.now(),
                },
            )

    # ── Domicilios ────────────────────────────────────────────────────────────

    def _seed_deliveries(self):
        from apps.deliveries.models import Deliverer, DeliveryPricingRule, DeliveryZone

        self.stdout.write('🛵  Creando domiciliarios...')

        deliverers_data = [
            ('domi1@runners.co', 1, Deliverer.WorkType.EMPRESA),
            ('domi2@runners.co', 2, Deliverer.WorkType.EMPRESA),
            ('domi3@runners.co', 3, Deliverer.WorkType.INDEPENDIENTE),
        ]

        for email, number, work_type in deliverers_data:
            user = self._users.get(email)
            if user is None:
                continue
            Deliverer.objects.get_or_create(
                user=user,
                defaults={
                    'assigned_number': number,
                    'status': Deliverer.Status.DISPONIBLE,
                    'work_type': work_type,
                    'is_active': True,
                },
            )

        self.stdout.write('🧭  Creando zonas de domicilios...')

        zona_caicedonia, _ = DeliveryZone.objects.get_or_create(name='Caicedonia', defaults={'description': 'Cobertura urbana principal'})
        zona_barragan_antes, _ = DeliveryZone.objects.get_or_create(name='Barragán (antes del puente)')
        zona_barragan_despues, _ = DeliveryZone.objects.get_or_create(name='Barragán (después del puente)')
        zona_condominios_barragan, _ = DeliveryZone.objects.get_or_create(name='Condominios de Barragán')
        zona_camelia, _ = DeliveryZone.objects.get_or_create(name='La Camelia')
        zona_club, _ = DeliveryZone.objects.get_or_create(name='Club Casa y Pesca')
        zona_delicias, _ = DeliveryZone.objects.get_or_create(name='Delicias / Las Delicias')

        self.stdout.write('💰  Creando reglas de tarifas de domicilios...')

        rules = [
            ('Recoger y entregar - Caicedonia', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_caicedonia, None, None, 1, 1, 3000, 10),
            ('Compra sencilla - base', DeliveryPricingRule.RequestKind.COMPRA_SENCILLA, None, None, None, 1, 1, 4000, 20),
            ('Supermercado hasta 6 productos', DeliveryPricingRule.RequestKind.SUPERMERCADO, None, 1, 6, 1, 1, 4000, 30),
            ('Supermercado desde 7 productos', DeliveryPricingRule.RequestKind.SUPERMERCADO, None, 7, None, 1, 1, 5000, 31),
            ('Multipunto 2 puntos', DeliveryPricingRule.RequestKind.MULTIPUNTO, None, None, None, 2, 2, 7000, 40),
            ('Barragán antes del puente', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_barragan_antes, None, None, None, None, 10000, 50),
            ('Barragán después del puente', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_barragan_despues, None, None, None, None, 12000, 51),
            ('Condominios de Barragán', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_condominios_barragan, None, None, None, None, 14000, 52),
            ('La Camelia', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_camelia, None, None, None, None, 6000, 53),
            ('Club Casa y Pesca', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_club, None, None, None, None, 5000, 54),
            ('Delicias / Las Delicias', DeliveryPricingRule.RequestKind.RECOGER_ENTREGAR, zona_delicias, None, None, None, None, 5000, 55),
        ]

        for name, request_kind, zone, min_items, max_items, min_points, max_points, fee_amount, priority in rules:
            DeliveryPricingRule.objects.get_or_create(
                name=name,
                defaults={
                    'request_kind': request_kind,
                    'zone': zone,
                    'min_items': min_items,
                    'max_items': max_items,
                    'min_points': min_points,
                    'max_points': max_points,
                    'fee_amount': fee_amount,
                    'priority': priority,
                    'is_active': True,
                },
            )

    # ── Contactos ─────────────────────────────────────────────────────────────

    def _seed_contacts(self):
        from apps.contacts.models import Contact

        self.stdout.write('📞  Creando directorio de contactos...')

        contacts_data = [
            ('Policía Caicedonia',       '123',          'Línea de emergencia policía', Contact.ContactType.EMERGENCIA),
            ('Bomberos Caicedonia',      '119',          'Cuerpo de Bomberos',           Contact.ContactType.EMERGENCIA),
            ('Cruz Roja Caicedonia',     '3001234000',   'Urgencias y primeros auxilios',Contact.ContactType.EMERGENCIA),
            ('Hospital San Rafael',      '3209876543',   'Hospital municipal',           Contact.ContactType.EMERGENCIA),
            ('Alcaldía Caicedonia',      '2251234',      'Atención ciudadana',           Contact.ContactType.PROFESIONAL),
            ('Notaría Única',            '2254321',      'Trámites notariales',          Contact.ContactType.PROFESIONAL),
            ('EPM Caicedonia',           '3204445566',   'Empresa de servicios públicos',Contact.ContactType.COMERCIO),
            ('Bancolombia Caicedonia',   '3401234567',   'Sucursal bancaria',            Contact.ContactType.COMERCIO),
            ('Supermercado La 14',       '3151112233',   'Supermercado principal',       Contact.ContactType.COMERCIO),
            ('Taxímetro Central',        '3101234000',   'Servicio de taxis',            Contact.ContactType.OTRO),
        ]

        for name, phone, description, contact_type in contacts_data:
            Contact.objects.get_or_create(
                name=name,
                defaults={'phone': phone, 'description': description, 'contact_type': contact_type},
            )

    # ── Config sistema ────────────────────────────────────────────────────────

    def _seed_system_config(self):
        from apps.deliveries.models import SystemConfig

        self.stdout.write('⚙️  Creando configuración del sistema...')

        configs = [
            ('runners_commission_pct', '10',   'Porcentaje de comisión de Runners sobre ingresos de domiciliarios'),
            ('delivery_base_fee',      '3000',  'Tarifa base por domicilio (COP)'),
            ('service_runners_fee_pct','15',   'Porcentaje de comisión de Runners en servicios'),
            ('max_delivery_radius_km', '5',    'Radio máximo de cobertura de domicilios en km'),
            ('transfer_surcharge_threshold', '15000', 'Umbral desde el cual se cobra recargo por transferencia'),
            ('transfer_surcharge_amount', '2000', 'Valor de recargo por transferencia a favor de Runners'),
        ]

        for key, value, description in configs:
            SystemConfig.objects.get_or_create(key=key, defaults={'value': value, 'description': description})
