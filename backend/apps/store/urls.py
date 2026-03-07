from django.urls import path
from . import views

urlpatterns = [
    # Categorías
    path('categories/', views.CategoryListView.as_view(), name='category_list'),
    path('categories/<int:pk>/', views.CategoryDetailView.as_view(), name='category_detail'),

    # Comercios
    path('commerces/', views.CommerceListView.as_view(), name='commerce_list'),
    path('commerces/<int:pk>/', views.CommerceDetailView.as_view(), name='commerce_detail'),

    # Productos (anidados por comercio)
    path('commerces/<int:commerce_pk>/products/', views.ProductListView.as_view(), name='product_list'),
    path('products/<int:pk>/', views.ProductDetailView.as_view(), name='product_detail'),

    # Pedidos
    path('orders/', views.OrderListView.as_view(), name='order_list'),
    path('orders/create/', views.OrderCreateView.as_view(), name='order_create'),
    path('orders/<int:pk>/', views.OrderDetailView.as_view(), name='order_detail'),
]
