import { useParams } from 'react-router-dom'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'

export default function ServiceDetail() {
  const { id } = useParams()

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '800px', margin: '0 auto' }}>
        <h1>Detalle del Servicio #{id}</h1>
        <p style={{ color: '#666' }}>Página de detalle del servicio — próximamente.</p>
      </main>
      <Footer />
    </div>
  )
}
