import { useState, useEffect } from 'react'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import DeliveryCard from '../../components/deliveries/DeliveryCard'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import { getDeliverers } from '../../api/deliveriesApi'

export default function DeliveriesPage() {
  const [deliverers, setDeliverers] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    getDeliverers()
      .then(res => setDeliverers(res.data.results || res.data))
      .finally(() => setLoading(false))
  }, [])

  const handleRequest = (deliverer) => {
    alert(`Solicitando domiciliario #${deliverer.assigned_number} - ${deliverer.user_name}. Runners coordinará el servicio.`)
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        <h1>🏍️ Domicilios</h1>
        <p style={{ color: '#666', marginBottom: '1.5rem' }}>Solicita un domiciliario disponible en Caicedonia</p>

        {loading ? <LoadingSpinner /> : (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1.5rem' }}>
            {deliverers.length > 0 ? deliverers.map(d => (
              <DeliveryCard key={d.id} deliverer={d} onRequest={handleRequest} />
            )) : (
              <p style={{ color: '#999', textAlign: 'center', gridColumn: '1 / -1' }}>Sin domiciliarios disponibles.</p>
            )}
          </div>
        )}
      </main>
      <Footer />
    </div>
  )
}
