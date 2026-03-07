from django.urls import path
from . import views

urlpatterns = [
    path('deliverers/', views.DelivererListView.as_view(), name='deliverer_list'),
    path('deliverers/create/', views.DelivererCreateView.as_view(), name='deliverer_create'),
    path('deliverers/status/', views.DelivererStatusView.as_view(), name='deliverer_status'),
    path('deliverers/<int:deliverer_pk>/records/', views.FinancialRecordListCreateView.as_view(), name='financial_records'),
    path('records/', views.FinancialRecordListCreateView.as_view(), name='my_financial_records'),
]
