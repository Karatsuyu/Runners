from django.urls import path
from . import views

urlpatterns = [
    path('deliverers/', views.DelivererListView.as_view(), name='deliverer_list'),
    path('deliverers/create/', views.DelivererCreateView.as_view(), name='deliverer_create'),
    path('deliverers/me/', views.my_deliverer_profile, name='deliverer_profile_me'),
    path('admin/deliverers/', views.DelivererAdminListCreateView.as_view(), name='deliverer_admin_list'),
    path('admin/deliverers/<int:pk>/', views.DelivererAdminDetailView.as_view(), name='deliverer_admin_detail'),
    path('deliverers/<int:pk>/toggle-status/', views.toggle_deliverer_status, name='deliverer_toggle_status'),
    path('deliverers/status/', views.DelivererStatusView.as_view(), name='deliverer_status'),
    path('zones/', views.DeliveryZoneListCreateView.as_view(), name='delivery_zone_list_create'),
    path('zones/<int:pk>/', views.DeliveryZoneDetailView.as_view(), name='delivery_zone_detail'),
    path('pricing-rules/', views.DeliveryPricingRuleListCreateView.as_view(), name='delivery_pricing_rule_list_create'),
    path('pricing-rules/<int:pk>/', views.DeliveryPricingRuleDetailView.as_view(), name='delivery_pricing_rule_detail'),
    path('estimate/', views.estimate_delivery_fee, name='delivery_estimate'),
    path('requests/', views.DeliveryRequestListCreateView.as_view(), name='delivery_request_list_create'),
    path('requests/create/', views.DeliveryRequestListCreateView.as_view(), name='delivery_request_create'),
    path('requests/my-deliveries/', views.DeliveryRequestListCreateView.as_view(), name='my_deliveries'),
    path('requests/available/', views.AvailableDeliveryRequestsView.as_view(), name='available_requests'),
    path('requests/<int:pk>/approve/', views.DeliveryRequestApproveView.as_view(), name='delivery_request_approve'),
    path('requests/<int:pk>/assign/', views.assign_delivery, name='delivery_request_assign'),
    path('debug/auth-headers/', views.debug_auth_header, name='debug_auth_header'),
    path('requests/<int:pk>/chat/', views.DeliveryChatListCreateView.as_view(), name='delivery_request_chat'),
    path('requests/<int:pk>/complete/', views.complete_delivery, name='delivery_request_complete'),
    path('requests/<int:pk>/cancel/', views.cancel_delivery, name='delivery_request_cancel'),
    path('deliverers/<int:deliverer_pk>/records/', views.FinancialRecordListCreateView.as_view(), name='financial_records'),
    path('records/', views.FinancialRecordListCreateView.as_view(), name='my_financial_records'),
]
