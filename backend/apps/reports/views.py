from datetime import timedelta

from django.db.models import Count, Q, Sum
from django.utils import timezone
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from apps.contacts.models import Contact
from apps.deliveries.models import Deliverer, DeliveryRequest, FinancialRecord
from apps.services.models import ServiceProvider, ServiceRequest
from apps.store.models import Order
from apps.users.permissions import IsAdmin


@api_view(['GET'])
@permission_classes([IsAdmin])
def dashboard_summary(request):
    """Resumen general para el dashboard del administrador."""
    from apps.users.models import User

    return Response({
        'users': {
            'total': User.objects.filter(is_active=True).count(),
            'clients': User.objects.filter(role='CLIENTE', is_active=True).count(),
            'providers': User.objects.filter(role='PRESTADOR', is_active=True).count(),
            'deliverers': User.objects.filter(role='DOMICILIARIO', is_active=True).count(),
        },
        'orders': {
            'total': Order.objects.count(),
            'pending': Order.objects.filter(status='PENDIENTE').count(),
            'delivered': Order.objects.filter(status='ENTREGADO').count(),
        },
        'deliveries': {
            'total': DeliveryRequest.objects.count(),
            'active': DeliveryRequest.objects.filter(status='ACEPTADO').count(),
            'completed': DeliveryRequest.objects.filter(status='ENTREGADO').count(),
            'cancelled': DeliveryRequest.objects.filter(status='CANCELADO').count(),
            'deliverers_available': Deliverer.objects.filter(status='DISPONIBLE', is_active=True).count(),
            'deliverers_busy': Deliverer.objects.filter(status='OCUPADO', is_active=True).count(),
        },
        'services': {
            'total': ServiceRequest.objects.count(),
            'registered': ServiceRequest.objects.filter(status='REGISTRADA').count(),
            'in_process': ServiceRequest.objects.filter(status='EN_PROCESO').count(),
            'completed': ServiceRequest.objects.filter(status='COMPLETADA').count(),
            'providers_pending_approval': ServiceProvider.objects.filter(approval_status='PENDIENTE').count(),
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
        'total_revenue': orders.aggregate(Sum('total'))['total__sum'] or 0,
        'by_commerce': list(report)
    })


@api_view(['GET'])
@permission_classes([IsAdmin])
def deliveries_report(request):
    """Reporte de domicilios por estado/tipo/zona."""
    days = int(request.query_params.get('days', 30))
    since = timezone.now() - timedelta(days=days)

    deliveries = DeliveryRequest.objects.filter(created_at__gte=since)

    by_source = deliveries.values('source_type').annotate(total=Count('id')).order_by('-total')
    by_kind = deliveries.values('request_kind').annotate(total=Count('id')).order_by('-total')
    by_zone = deliveries.values('zone__name').annotate(total=Count('id')).order_by('-total')

    return Response({
        'period_days': days,
        'total': deliveries.count(),
        'status': {
            'solicitado': deliveries.filter(status='SOLICITADO').count(),
            'aceptado': deliveries.filter(status='ACEPTADO').count(),
            'en_camino': deliveries.filter(status='EN_CAMINO').count(),
            'entregado': deliveries.filter(status='ENTREGADO').count(),
            'cancelado': deliveries.filter(status='CANCELADO').count(),
        },
        'total_delivery_fees': float(deliveries.aggregate(Sum('delivery_fee'))['delivery_fee__sum'] or 0),
        'total_transfer_surcharge': float(deliveries.aggregate(Sum('transfer_surcharge'))['transfer_surcharge__sum'] or 0),
        'by_source': list(by_source),
        'by_kind': list(by_kind),
        'by_zone': list(by_zone),
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
def finance_report(request):
    """Reporte financiero consolidado: ingresos, egresos, rojo, azul, negro y recargos de transferencia."""
    days = int(request.query_params.get('days', 30))
    since = timezone.now() - timedelta(days=days)

    records = FinancialRecord.objects.filter(created_at__gte=since)

    by_classification = records.values('classification').annotate(total=Sum('amount'), count=Count('id')).order_by('classification')
    by_reason = records.values('reason').annotate(total=Sum('amount'), count=Count('id')).order_by('-total')

    income_total = records.filter(record_type='INGRESO').aggregate(total=Sum('amount'))['total'] or 0
    expense_total = records.filter(record_type='EGRESO').aggregate(total=Sum('amount'))['total'] or 0
    extra_blue_total = records.filter(classification='AZUL').aggregate(total=Sum('amount'))['total'] or 0
    debt_red_total = records.filter(classification='ROJO').aggregate(total=Sum('amount'))['total'] or 0
    regular_black_total = records.filter(classification='NEGRO').aggregate(total=Sum('amount'))['total'] or 0
    transfer_surcharge_for_runners = records.filter(reason='RECARGO_TRANSFERENCIA').aggregate(total=Sum('runners_commission'))['total'] or 0

    return Response({
        'period_days': days,
        'total_records': records.count(),
        'income_total': float(income_total),
        'expense_total': float(expense_total),
        'net_total': float(income_total - expense_total),
        'red_total': float(debt_red_total),
        'blue_total': float(extra_blue_total),
        'black_total': float(regular_black_total),
        'transfer_surcharge_for_runners': float(transfer_surcharge_for_runners),
        'by_classification': list(by_classification),
        'by_reason': list(by_reason),
    })


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


@api_view(['GET'])
@permission_classes([IsAdmin])
def contacts_report(request):
    """Reporte de contactos por tipo y actividad."""
    contacts = Contact.objects.all()
    by_type = contacts.values('contact_type').annotate(total=Count('id')).order_by('-total')

    return Response({
        'total_contacts': contacts.count(),
        'active_contacts': contacts.filter(is_active=True).count(),
        'inactive_contacts': contacts.filter(is_active=False).count(),
        'by_type': list(by_type),
    })
