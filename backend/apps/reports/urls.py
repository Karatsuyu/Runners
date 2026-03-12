from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/', views.dashboard_summary, name='dashboard_summary'),
    path('sales/', views.sales_report, name='sales_report'),
    path('deliverers/', views.deliverers_report, name='deliverers_report'),
    path('services/', views.services_report, name='services_report'),
]
