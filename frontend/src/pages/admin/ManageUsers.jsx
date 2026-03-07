import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'

export default function ManageUsers() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
        <h1>👥 Gestionar Usuarios</h1>
        <p>Módulo de gestión de usuarios — próximamente.</p>
      </main>
      <Footer />
    </div>
  )
}
