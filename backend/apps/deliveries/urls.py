from django.urls import path
from . import views

urlpatterns = [
    path('deliverers/', views.DelivererListView.as_view(), name='deliverer_list'),
    path('deliverers/create/', views.DelivererCreateView.as_view(), name='deliverer_create'),
    path('deliverers/status/', views.DelivererStatusView.as_view(), name='deliverer_status'),
    path('requests/', views.DeliveryRequestListCreateView.as_view(), name='delivery_request_list_create'),
    path('requests/<int:pk>/complete/', views.complete_delivery, name='delivery_request_complete'),
    path('requests/<int:pk>/cancel/', views.cancel_delivery, name='delivery_request_cancel'),
    path('deliverers/<int:deliverer_pk>/records/', views.FinancialRecordListCreateView.as_view(), name='financial_records'),
    path('records/', views.FinancialRecordListCreateView.as_view(), name='my_financial_records'),
]
