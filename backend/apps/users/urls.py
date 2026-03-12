from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenBlacklistView
from . import views

urlpatterns = [
    # Autenticación
    path('register/', views.RegisterView.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', TokenBlacklistView.as_view(), name='token_blacklist'),

    # Perfil
    path('profile/', views.UserProfileView.as_view(), name='user_profile'),

    # Admin
    path('users/', views.UserListView.as_view(), name='user_list'),
    path('users/<int:pk>/', views.UserDetailAdminView.as_view(), name='user_detail'),
    path('users/<int:pk>/toggle-status/', views.toggle_user_status, name='user_toggle_status'),
]
