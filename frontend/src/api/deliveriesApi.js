import api from './axiosConfig'

export const getDeliverers = () =>
  api.get('/deliveries/deliverers/')

export const createDeliverer = (data) =>
  api.post('/deliveries/deliverers/create/', data)

export const updateDelivererStatus = (status) =>
  api.patch('/deliveries/deliverers/status/', { status })

export const getFinancialRecords = () =>
  api.get('/deliveries/records/')

export const createFinancialRecord = (data) =>
  api.post('/deliveries/records/', data)

export const getDelivererRecords = (delivererId) =>
  api.get(`/deliveries/deliverers/${delivererId}/records/`)
