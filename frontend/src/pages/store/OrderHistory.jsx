import { useState, useEffect } from 'react'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import { getOrders } from '../../api/storeApi'

export default function OrderHistory() {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    getOrders()
      .then(res => setOrders(res.data.results || res.data))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1000px', margin: '0 auto', width: '100%' }}>
        <h1>📋 Historial de Pedidos</h1>

        {loading ? <LoadingSpinner /> : orders.length === 0 ? (
          <p style={{ color: '#999', textAlign: 'center' }}>No tienes pedidos aún.</p>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {orders.map(order => (
              <div key={order.id} style={{
                border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1rem',
                backgroundColor: 'white', boxShadow: '0 2px 4px rgba(0,0,0,0.05)',
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <h3 style={{ margin: 0 }}>Pedido #{order.id}</h3>
                  <span style={{
                    padding: '0.2rem 0.6rem', borderRadius: '12px', fontSize: '0.8rem',
                    backgroundColor: order.status === 'ENTREGADO' ? '#dcfce7' : order.status === 'CANCELADO' ? '#fee2e2' : '#fef3c7',
                    color: order.status === 'ENTREGADO' ? '#16a34a' : order.status === 'CANCELADO' ? '#dc2626' : '#d97706',
                  }}>
                    {order.status}
                  </span>
                </div>
                <p style={{ color: '#666', margin: '0.25rem 0' }}>🏪 {order.commerce_name}</p>
                <p style={{ color: '#888', fontSize: '0.85rem' }}>
                  {new Date(order.created_at).toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' })}
                </p>
                {order.items?.map(item => (
                  <div key={item.id} style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.9rem', color: '#555' }}>
                    <span>{item.product_name} x{item.quantity}</span>
                    <span>${Number(item.subtotal).toLocaleString('es-CO')}</span>
                  </div>
                ))}
                <div style={{ marginTop: '0.5rem', fontWeight: 'bold', textAlign: 'right' }}>
                  Total: ${Number(order.total).toLocaleString('es-CO')}
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
      <Footer />
    </div>
  )
}
