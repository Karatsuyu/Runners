from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.db.models import Count, Sum
from django.utils import timezone
from datetime import timedelta
from apps.users.permissions import IsAdmin
from apps.store.models import Order
from apps.services.models import ServiceRequest
from apps.deliveries.models import Deliverer, FinancialRecord


@api_view(['GET'])
@permission_classes([IsAdmin])
def dashboard_summary(request):
    """Resumen general para el dashboard del administrador."""
    from apps.users.models import User
    from apps.services.models import ServiceProvider

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
        'providers_pending_approval': ServiceProvider.objects.filter(approval_status='PENDIENTE').count(),
        'deliverers_available': Deliverer.objects.filter(status='DISPONIBLE', is_active=True).count(),
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
