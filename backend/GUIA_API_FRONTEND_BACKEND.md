# Guia API Frontend-Backend Runners

## Objetivo
Esta guia resume los endpoints nuevos y ajustados para que frontend consuma:
- Domicilios generales y domicilios ligados a tienda.
- Asociacion/correccion de negocio en domicilios.
- Tarifas por zona y tipo.
- Registro financiero (rojo/azul/negro).
- Chat por REST + WebSocket.
- Reportes modulares.

## Base URL y autenticacion
- Base API: `/api/v1`
- Autenticacion: `Authorization: Bearer <access_token_jwt>`
- Todos los endpoints aqui listados requieren usuario autenticado.

Ejemplo header:
```http
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOi...
Content-Type: application/json
```

## Catalogo de tiendas (con tipo y carta PDF)

### Listar comercios
`GET /api/v1/store/commerces/?category=<id>&business_type=<TIPO>`

Tipos soportados en `business_type`:
- `RESTAURANTE`
- `TIENDA`
- `FARMACIA`
- `SUPERMERCADO`
- `OTRO`

### Crear/actualizar comercio (admin)
`POST /api/v1/store/commerces/`

Campos relevantes:
- `name`
- `category`
- `business_type`
- `description`
- `phone`
- `address`
- `image`
- `menu_pdf`

Nota: para `image` y `menu_pdf` enviar `multipart/form-data`.

## Domicilios

### 1) Crear domicilio general
`POST /api/v1/deliveries/requests/`

Body ejemplo:
```json
{
  "description": "Comprar 2 medicamentos y llevarlos al cliente",
  "source_type": "GENERAL",
  "request_kind": "COMPRA_SENCILLA",
  "zone": 1,
  "points_count": 1,
  "items_count": 2,
  "is_transfer_payment": true,
  "product_amount": 18000,
  "pickup_address": "Cra 5 # 10-20",
  "delivery_address": "Cll 12 # 8-30"
}
```

### 2) Crear domicilio desde tienda
`POST /api/v1/deliveries/requests/`

Body ejemplo:
```json
{
  "description": "Pedido desde carta PDF del negocio",
  "source_type": "STORE",
  "request_kind": "RECOGER_ENTREGAR",
  "commerce": 7,
  "zone": 1,
  "points_count": 1,
  "items_count": 1,
  "is_transfer_payment": false,
  "product_amount": 0,
  "pickup_address": "Negocio: Cra 6 # 7-15",
  "delivery_address": "Cliente: Cll 9 # 4-18"
}
```

Reglas de negocio aplicadas al crear domicilio:
- Asigna automaticamente un domiciliario disponible.
- Calcula tarifa segun reglas activas (`zone + request_kind + items_count + points_count`).
- Si `is_transfer_payment = true` y `product_amount > threshold`, aplica recargo de transferencia.
- El recargo de transferencia se registra como valor a favor de Runners.

### 3) Listar domicilios
`GET /api/v1/deliveries/requests/`

Filtro disponible para admin:
- `source_type=GENERAL|STORE`

### 4) Asociar/corregir negocio en domicilio (admin)
`POST /api/v1/deliveries/requests/<delivery_id>/associate-commerce/`

Body ejemplo:
```json
{
  "commerce_id": 9,
  "notes": "Correccion por error de digitacion"
}
```

Para desasociar negocio (volver a general):
```json
{
  "commerce_id": null,
  "notes": "Se corrige: era domicilio general"
}
```

### 5) Ver historial de asociaciones de negocio
`GET /api/v1/deliveries/requests/<delivery_id>/commerce-history/`

### 6) Completar o cancelar domicilio
- Completar: `POST /api/v1/deliveries/requests/<delivery_id>/complete/`
- Cancelar: `POST /api/v1/deliveries/requests/<delivery_id>/cancel/`

## Zonas y reglas de tarifa (admin)

### Zonas
- Listar/crear: `GET|POST /api/v1/deliveries/zones/`
- Detalle/editar/eliminar: `GET|PUT|PATCH|DELETE /api/v1/deliveries/zones/<id>/`

### Reglas de precio
- Listar/crear: `GET|POST /api/v1/deliveries/pricing-rules/`
- Detalle/editar/eliminar: `GET|PUT|PATCH|DELETE /api/v1/deliveries/pricing-rules/<id>/`

`request_kind` soportado:
- `RECOGER_ENTREGAR`
- `COMPRA_SENCILLA`
- `SUPERMERCADO`
- `MULTIPUNTO`

Campos de regla:
- `zone` (opcional, si no se envia aplica general)
- `min_items`, `max_items` (opcionales)
- `min_points`, `max_points` (opcionales)
- `fee_amount`
- `priority` (menor numero = mayor prioridad)

## Registros financieros (rojo/azul/negro)

### Listar
- Admin global: `GET /api/v1/deliveries/records/`
- Admin por domiciliario: `GET /api/v1/deliveries/deliverers/<deliverer_id>/records/`
- Domiciliario (sus propios registros): `GET /api/v1/deliveries/records/`

### Crear registro
- Admin por domiciliario: `POST /api/v1/deliveries/deliverers/<deliverer_id>/records/`
- Domiciliario propio: `POST /api/v1/deliveries/records/`

Body ejemplo:
```json
{
  "record_type": "EGRESO",
  "classification": "ROJO",
  "reason": "PRODUCTO",
  "amount": 20000,
  "description": "Producto pagado por el domiciliario desde su base",
  "affects_balance": true,
  "related_delivery": 15
}
```

Catalogos contables:
- `record_type`: `INGRESO`, `EGRESO`
- `classification`:
  - `NEGRO`: transaccion normal
  - `ROJO`: deuda hacia el domiciliario
  - `AZUL`: saldo extra en caja del domiciliario
- `reason`:
  - `PRODUCTO`
  - `DOMICILIO`
  - `RECARGO_TRANSFERENCIA`
  - `CONSIGNACION_BASE`
  - `COBRO_DEUDA_CLIENTE`
  - `AJUSTE_MANUAL`

Aclaracion del recargo por transferencia:
- Se toma como valor de Runners.
- Configuracion en `SystemConfig`:
  - `transfer_surcharge_threshold`
  - `transfer_surcharge_amount`

## Chat interno

## REST

### Abrir/obtener hilo por contexto
`POST /api/v1/chat/threads/open/`

Para domicilio:
```json
{
  "delivery_request_id": 15
}
```

Para servicio:
```json
{
  "service_request_id": 8
}
```

### Listar hilos del usuario
`GET /api/v1/chat/threads/`

### Listar o enviar mensajes
`GET|POST /api/v1/chat/threads/<thread_id>/messages/`

Body para enviar mensaje por REST:
```json
{
  "message": "Voy en camino con tu pedido"
}
```

## WebSocket

URL:
`/ws/chat/threads/<thread_id>/?token=<access_token_jwt>`

Evento de envio desde cliente:
```json
{
  "message": "Necesito confirmar la direccion"
}
```

Evento broadcast recibido:
```json
{
  "id": 101,
  "thread_id": 22,
  "sender_id": 4,
  "sender_name": "Carlos Perez",
  "message": "Necesito confirmar la direccion",
  "created_at": "2026-04-03T21:20:11.123456+00:00"
}
```

## Reportes modulares (admin)

- Dashboard: `GET /api/v1/reports/dashboard/`
- Domicilios: `GET /api/v1/reports/deliveries/?days=30`
- Finanzas: `GET /api/v1/reports/finance/?days=30`
- Domiciliarios: `GET /api/v1/reports/deliverers/`
- Servicios: `GET /api/v1/reports/services/?days=30`
- Contactos: `GET /api/v1/reports/contacts/`
- Ventas tienda: `GET /api/v1/reports/sales/?days=30`

## Flujo recomendado para frontend

1. Cliente lista tiendas y abre detalle para ver `menu_pdf`.
2. Cliente crea domicilio (`STORE` o `GENERAL`).
3. Front abre hilo de chat con `threads/open/` y luego conecta WebSocket.
4. Admin puede corregir negocio con `associate-commerce/` y conservar historial.
5. Admin monitorea operacion en reportes por modulo.

## Notas de compatibilidad
- Se mantuvo el flujo previo de productos/pedidos en tienda para no romper frontend actual.
- Ya esta listo el soporte nuevo de carta PDF y tipo de negocio para evolucionar la UI.
