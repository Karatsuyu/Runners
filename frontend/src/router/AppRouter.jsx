import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from '../context/AuthContext'
import { CartProvider } from '../context/CartContext'

// Pages
import Home from '../pages/Home'
import Login from '../pages/Login'
import Register from '../pages/Register'
import StorePage from '../pages/store/StorePage'
import ComercioDetail from '../pages/store/ComercioDetail'
import OrderHistory from '../pages/store/OrderHistory'
import ServicesPage from '../pages/services/ServicesPage'
import DeliveriesPage from '../pages/deliveries/DeliveriesPage'
import DeliveryDashboard from '../pages/deliveries/DeliveryDashboard'
import ContactsPage from '../pages/contacts/ContactsPage'
import AdminDashboard from '../pages/admin/AdminDashboard'

function ProtectedRoute({ children, roles }) {
  const { user, loading } = useAuth()
  if (loading) return <div>Cargando...</div>
  if (!user) return <Navigate to="/login" replace />
  if (roles && !roles.includes(user.role)) return <Navigate to="/" replace />
  return children
}

export default function AppRouter() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <CartProvider>
          <Routes>
            {/* Públicas */}
            <Route path="/" element={<Home />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />

            {/* Tienda */}
            <Route path="/store" element={<ProtectedRoute><StorePage /></ProtectedRoute>} />
            <Route path="/store/:id" element={<ProtectedRoute><ComercioDetail /></ProtectedRoute>} />
            <Route path="/orders" element={<ProtectedRoute><OrderHistory /></ProtectedRoute>} />

            {/* Servicios */}
            <Route path="/services" element={<ProtectedRoute><ServicesPage /></ProtectedRoute>} />

            {/* Domicilios */}
            <Route path="/deliveries" element={<ProtectedRoute><DeliveriesPage /></ProtectedRoute>} />
            <Route path="/deliveries/dashboard" element={
              <ProtectedRoute roles={['DOMICILIARIO', 'ADMIN']}>
                <DeliveryDashboard />
              </ProtectedRoute>
            } />

            {/* Contactos */}
            <Route path="/contacts" element={<ProtectedRoute><ContactsPage /></ProtectedRoute>} />

            {/* Admin */}
            <Route path="/admin" element={
              <ProtectedRoute roles={['ADMIN']}>
                <AdminDashboard />
              </ProtectedRoute>
            } />

            {/* 404 */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </CartProvider>
      </AuthProvider>
    </BrowserRouter>
  )
}
