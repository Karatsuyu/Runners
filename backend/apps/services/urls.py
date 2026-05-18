from django.urls import path
from . import views

urlpatterns = [
    path('categories/', views.ServiceCategoryListView.as_view(), name='service_category_list'),
    path('providers/', views.ServiceProviderListView.as_view(), name='provider_list'),
    path('providers/register/', views.RegisterAsProviderView.as_view(), name='provider_register'),
    path('providers/status/', views.ProviderStatusView.as_view(), name='provider_status'),
    path('providers/<int:pk>/approve/', views.approve_provider, name='provider_approve'),
    path('requests/', views.ServiceRequestListView.as_view(), name='service_request_list'),
    path('requests/create/', views.ServiceRequestCreateView.as_view(), name='service_request_create'),
]
