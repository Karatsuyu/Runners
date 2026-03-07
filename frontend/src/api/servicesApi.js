import api from './axiosConfig'

export const getServiceCategories = () =>
  api.get('/services/categories/')

export const getProviders = (params) =>
  api.get('/services/providers/', { params })

export const registerAsProvider = (formData) =>
  api.post('/services/providers/register/', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })

export const updateProviderStatus = (status) =>
  api.patch('/services/providers/status/', { status })

export const approveProvider = (id, data) =>
  api.post(`/services/providers/${id}/approve/`, data)

export const createServiceRequest = (data) =>
  api.post('/services/requests/create/', data)

export const getServiceRequests = () =>
  api.get('/services/requests/')
