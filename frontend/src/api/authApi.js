import api from './axiosConfig'

export const login = (email, password) =>
  api.post('/auth/login/', { email, password })

export const register = (userData) =>
  api.post('/auth/register/', userData)

export const getProfile = () =>
  api.get('/auth/profile/')

export const updateProfile = (data) =>
  api.patch('/auth/profile/', data)

export const refreshToken = (refresh) =>
  api.post('/auth/token/refresh/', { refresh })

export const logout = (refresh) =>
  api.post('/auth/logout/', { refresh })
