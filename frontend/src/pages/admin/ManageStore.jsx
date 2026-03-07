import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'

export default function ManageStore() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
        <h1>🛒 Gestionar Tienda</h1>
        <p>Módulo de gestión de comercios y productos — próximamente.</p>
      </main>
      <Footer />
    </div>
  )
}
