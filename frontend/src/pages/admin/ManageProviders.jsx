import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'

export default function ManageProviders() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
        <h1>🔧 Gestionar Prestadores</h1>
        <p>Módulo de aprobación de prestadores — próximamente.</p>
      </main>
      <Footer />
    </div>
  )
}
