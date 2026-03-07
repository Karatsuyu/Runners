import api from './axiosConfig'

export const getContacts = (params) =>
  api.get('/contacts/', { params })

export const getContactDetail = (id) =>
  api.get(`/contacts/${id}/`)

export const createContact = (data) =>
  api.post('/contacts/', data)

export const updateContact = (id, data) =>
  api.patch(`/contacts/${id}/`, data)

export const deleteContact = (id) =>
  api.delete(`/contacts/${id}/`)
