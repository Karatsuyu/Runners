from django.urls import path
from . import views

urlpatterns = [
    path('', views.ContactListView.as_view(), name='contact_list'),
    path('<int:pk>/', views.ContactDetailView.as_view(), name='contact_detail'),
    path('<int:pk>/review/', views.review_contact, name='contact_review'),
]
