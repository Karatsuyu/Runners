from django.urls import path
from . import views

urlpatterns = [
    # Categorías
    path('categories/', views.CategoryListView.as_view(), name='category_list'),
    path('categories/<int:pk>/', views.CategoryDetailView.as_view(), name='category_detail'),

    # Comercios
    path('commerces/', views.CommerceListView.as_view(), name='commerce_list'),
    path('commerces/<int:pk>/', views.CommerceDetailView.as_view(), name='commerce_detail'),
    # Comercios - Admin (acceso total)
    path('admin/commerces/', views.CommerceAdminListView.as_view(), name='commerce_admin_list'),
    path('admin/commerces/<int:pk>/', views.CommerceAdminDetailView.as_view(), name='commerce_admin_detail'),


    # Productos (anidados por comercio)
    path('commerces/<int:commerce_pk>/products/', views.ProductListView.as_view(), name='product_list'),
    path('products/<int:pk>/', views.ProductDetailView.as_view(), name='product_detail'),
    # Menús / cartas: listar, subir y eliminar archivos (imagenes o PDF)
    path('commerces/<int:commerce_pk>/menus/', views.CommerceMenuFileListCreateView.as_view(), name='commerce_menu_list_create'),
    path('commerces/<int:commerce_pk>/menus/<int:pk>/', views.CommerceMenuFileDetailView.as_view(), name='commerce_menu_detail'),

    # Pedidos
    path('orders/', views.OrderListView.as_view(), name='order_list'),
    path('orders/create/', views.OrderCreateView.as_view(), name='order_create'),
    path('orders/<int:pk>/', views.OrderDetailView.as_view(), name='order_detail'),
]
