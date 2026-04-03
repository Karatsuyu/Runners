from django.urls import path

from . import views

urlpatterns = [
    path('threads/', views.ChatThreadListView.as_view(), name='chat_thread_list'),
    path('threads/open/', views.open_context_thread, name='chat_thread_open_context'),
    path('threads/<int:thread_pk>/messages/', views.ChatMessageListCreateView.as_view(), name='chat_message_list_create'),
]
