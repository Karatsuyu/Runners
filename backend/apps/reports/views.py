from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Count, Sum
from django.utils import timezone
from datetime import timedelta
from apps.users.permissions import IsAdmin
from apps.store.models import Order
from apps.services.models import ServiceRequest
from apps.deliveries.models import Deliverer, FinancialRecord


from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Count, Sum
from django.utils import timezone
from datetime import timedelta
from apps.users.permissions import IsAdmin
from apps.store.models import Order
from apps.services.models import ServiceRequest, ServiceProvider
from apps.deliveries.models import Deliverer, FinancialRecord, DeliveryRequest


@api_view(['GET'])
@permission_classes([IsAdmin])
def dashboard_summary(request):
    """Resumen general para el dashboard del administrador."""
    from apps.users.models import User

    total_users = User.objects.filter(is_active=True).count()
    clients = User.objects.filter(role='CLIENTE', is_active=True).count()
    providers = User.objects.filter(role='PRESTADOR', is_active=True).count()
    deliverers = User.objects.filter(role='DOMICILIARIO', is_active=True).count()

    total_orders = Order.objects.count()
    pending_orders = Order.objects.filter(status='PENDIENTE').count()
    delivered_orders = Order.objects.filter(status='ENTREGADO').count()
    total_revenue = float(Order.objects.aggregate(total=Sum('total'))['total'] or 0)

    total_deliveries = DeliveryRequest.objects.count()
    active_deliveries = DeliveryRequest.objects.filter(status='ACEPTADO').count()
    completed_deliveries = DeliveryRequest.objects.filter(status='ENTREGADO').count()
    cancelled_deliveries = DeliveryRequest.objects.filter(status='CANCELADO').count()
    deliverers_available = Deliverer.objects.filter(status='DISPONIBLE', is_active=True).count()
    deliverers_busy = Deliverer.objects.filter(status='OCUPADO', is_active=True).count()

    total_services = ServiceRequest.objects.count()
    registered_services = ServiceRequest.objects.filter(status='REGISTRADA').count()
    in_process_services = ServiceRequest.objects.filter(status='EN_PROCESO').count()
    completed_services = ServiceRequest.objects.filter(status='COMPLETADA').count()
    providers_pending_approval = ServiceProvider.objects.filter(approval_status='PENDIENTE').count()

    return Response({
        # Flat keys used by mobile dashboard cards.
        'total_users': total_users,
        'pending_providers': providers_pending_approval,
        'total_orders': total_orders,
        'active_deliveries': active_deliveries,
        'total_revenue': total_revenue,

        'users': {
            'total': total_users,
            'clients': clients,
            'providers': providers,
            'deliverers': deliverers,
        },
        'orders': {
            'total': total_orders,
            'pending': pending_orders,
            'delivered': delivered_orders,
        },
        'deliveries': {
            'total': total_deliveries,
            'active': active_deliveries,
            'completed': completed_deliveries,
            'cancelled': cancelled_deliveries,
            'deliverers_available': deliverers_available,
            'deliverers_busy': deliverers_busy,
        },
        'services': {
            'total': total_services,
            'registered': registered_services,
            'in_process': in_process_services,
            'completed': completed_services,
            'providers_pending_approval': providers_pending_approval,
        },
    })


@api_view(['GET'])
@permission_classes([IsAdmin])
def sales_report(request):
    """Reporte de ventas por período."""
    days = int(request.query_params.get('days', 30))
    since = timezone.now() - timedelta(days=days)

    orders = Order.objects.filter(created_at__gte=since)
    report = orders.values('commerce__name').annotate(
        order_count=Count('id'),
        total_sales=Sum('total')
    ).order_by('-total_sales')

    return Response({
        'period_days': days,
        'total_orders': orders.count(),
        'total_products_revenue': orders.aggregate(Sum('products_subtotal'))['products_subtotal__sum'] or 0,
        'total_delivery_revenue': orders.aggregate(Sum('delivery_total'))['delivery_total__sum'] or 0,
        'total_revenue': orders.aggregate(Sum('total'))['total__sum'] or 0,
        'by_commerce': list(report)
    })


@api_view(['GET'])
@permission_classes([IsAdmin])
def deliverers_report(request):
    """Reporte financiero de domiciliarios."""
    deliverers = Deliverer.objects.filter(is_active=True)
    data = []
    for d in deliverers:
        records = FinancialRecord.objects.filter(deliverer=d)
        incomes = records.filter(record_type='INGRESO').aggregate(Sum('amount'))['amount__sum'] or 0
        expenses = records.filter(record_type='EGRESO').aggregate(Sum('amount'))['amount__sum'] or 0
        commissions = records.filter(record_type='INGRESO').aggregate(Sum('runners_commission'))['runners_commission__sum'] or 0
        data.append({
            'deliverer': d.user.get_full_name(),
            'number': d.assigned_number,
            'incomes': float(incomes),
            'expenses': float(expenses),
            'balance': float(incomes - expenses),
            'runners_total_commission': float(commissions),
        })
    return Response(data)


@api_view(['GET'])
@permission_classes([IsAdmin])
def services_report(request):
    """Reporte de solicitudes de servicio por período."""
    days = int(request.query_params.get('days', 30))
    since = timezone.now() - timedelta(days=days)

    requests = ServiceRequest.objects.filter(created_at__gte=since)
    by_category = requests.values('category__name').annotate(
        total=Count('id'),
        completed=Count('id', filter=__import__('django.db.models', fromlist=['Q']).Q(status='COMPLETADA')),
    ).order_by('-total')

    return Response({
        'period_days': days,
        'total_requests': requests.count(),
        'by_status': {
            s: requests.filter(status=s).count()
            for s in ['REGISTRADA', 'ASIGNADA', 'EN_PROCESO', 'COMPLETADA', 'CANCELADA']
        },
        'by_category': list(by_category),
        'total_revenue': float(requests.aggregate(Sum('client_total'))['client_total__sum'] or 0),
        'total_provider_fees': float(requests.aggregate(Sum('provider_fee'))['provider_fee__sum'] or 0),
    })
