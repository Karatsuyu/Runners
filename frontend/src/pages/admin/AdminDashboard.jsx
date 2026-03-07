import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import api from '../../api/axiosConfig'

export default function AdminDashboard() {
  const [summary, setSummary] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    api.get('/reports/dashboard/')
      .then(res => setSummary(res.data))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        <h1>👑 Panel de Administración</h1>

        {loading ? <LoadingSpinner /> : summary && (
          <>
            {/* Tarjetas resumen */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))', gap: '1rem', marginBottom: '2rem' }}>
              <SummaryCard title="Usuarios activos" value={summary.users.total} color="#2563eb" />
              <SummaryCard title="Clientes" value={summary.users.clients} color="#16a34a" />
              <SummaryCard title="Prestadores" value={summary.users.providers} color="#d97706" />
              <SummaryCard title="Domiciliarios" value={summary.users.deliverers} color="#7c3aed" />
              <SummaryCard title="Pedidos totales" value={summary.orders.total} color="#1a1a2e" />
              <SummaryCard title="Pedidos pendientes" value={summary.orders.pending} color="#dc2626" />
              <SummaryCard title="Pedidos entregados" value={summary.orders.delivered} color="#16a34a" />
              <SummaryCard title="Prestadores pendientes" value={summary.providers_pending_approval} color="#ea580c" />
              <SummaryCard title="Domiciliarios disponibles" value={summary.deliverers_available} color="#0891b2" />
            </div>

            {/* Accesos rápidos */}
            <h2>Gestión</h2>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', gap: '1rem' }}>
              <AdminLink to="/admin" label="👥 Gestionar Usuarios" desc="Ver, activar o suspender usuarios" />
              <AdminLink to="/store" label="🛒 Gestionar Tienda" desc="Comercios, productos y pedidos" />
              <AdminLink to="/services" label="🔧 Gestionar Servicios" desc="Aprobar prestadores, categorías" />
              <AdminLink to="/deliveries" label="🏍️ Gestionar Domicilios" desc="Domiciliarios y registros financieros" />
              <AdminLink to="/contacts" label="📞 Gestionar Contactos" desc="Directorio de emergencia y profesionales" />
              <AdminLink to="/orders" label="📋 Historial de Ventas" desc="Pedidos realizados por la plataforma" />
            </div>
          </>
        )}
      </main>
      <Footer />
    </div>
  )
}

function SummaryCard({ title, value, color }) {
  return (
    <div style={{
      padding: '1.25rem', backgroundColor: 'white', borderRadius: '8px',
      border: '1px solid #e0e0e0', boxShadow: '0 2px 4px rgba(0,0,0,0.05)',
      borderLeft: `4px solid ${color}`,
    }}>
      <p style={{ fontSize: '2rem', fontWeight: 'bold', color, margin: 0 }}>{value}</p>
      <p style={{ color: '#666', margin: '0.25rem 0 0', fontSize: '0.85rem' }}>{title}</p>
    </div>
  )
}

function AdminLink({ to, label, desc }) {
  return (
    <Link to={to} style={{
      textDecoration: 'none', color: 'inherit',
      padding: '1.25rem', backgroundColor: 'white', borderRadius: '8px',
      border: '1px solid #e0e0e0', boxShadow: '0 2px 4px rgba(0,0,0,0.05)',
      display: 'block',
    }}>
      <h3 style={{ margin: '0 0 0.25rem' }}>{label}</h3>
      <p style={{ color: '#666', margin: 0, fontSize: '0.85rem' }}>{desc}</p>
    </Link>
  )
}
