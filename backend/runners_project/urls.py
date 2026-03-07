from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include([
        path('auth/', include('apps.users.urls')),
        path('store/', include('apps.store.urls')),
        path('services/', include('apps.services.urls')),
        path('deliveries/', include('apps.deliveries.urls')),
        path('contacts/', include('apps.contacts.urls')),
        path('reports/', include('apps.reports.urls')),
    ])),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
