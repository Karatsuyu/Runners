from channels.routing import URLRouter

from apps.chat.routing import websocket_urlpatterns

application = URLRouter(websocket_urlpatterns)
