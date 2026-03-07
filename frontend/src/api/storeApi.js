import api from './axiosConfig'

export const getCategories = () =>
  api.get('/store/categories/')

export const getCommerces = (params) =>
  api.get('/store/commerces/', { params })

export const getCommerceDetail = (id) =>
  api.get(`/store/commerces/${id}/`)

export const getProducts = (commerceId) =>
  api.get(`/store/commerces/${commerceId}/products/`)

export const createOrder = (orderData) =>
  api.post('/store/orders/create/', orderData)

export const getOrders = (params) =>
  api.get('/store/orders/', { params })

export const getOrderDetail = (id) =>
  api.get(`/store/orders/${id}/`)
