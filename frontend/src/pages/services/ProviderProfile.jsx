import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'

export default function ProviderProfile() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '800px', margin: '0 auto' }}>
        <h1>Perfil del Prestador</h1>
        <p style={{ color: '#666' }}>Página del perfil del prestador — próximamente.</p>
      </main>
      <Footer />
    </div>
  )
}
