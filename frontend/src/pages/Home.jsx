import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import Navbar from '../components/common/Navbar'
import Footer from '../components/common/Footer'

export default function Home() {
  const { user } = useAuth()

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto' }}>
        <div style={{ textAlign: 'center', padding: '3rem 0' }}>
          <h1 style={{ fontSize: '3rem', marginBottom: '0.5rem' }}>🏃 Runners</h1>
          <p style={{ fontSize: '1.3rem', color: '#666', marginBottom: '2rem' }}>
            Plataforma de Intermediación de Servicios y Domicilios
          </p>
          <p style={{ color: '#888', maxWidth: '600px', margin: '0 auto 2rem' }}>
            Conectamos a la comunidad de Caicedonia con tiendas, restaurantes,
            prestadores de servicios y domiciliarios. Todo en un solo lugar.
          </p>

          {!user ? (
            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
              <Link to="/register" style={{
                padding: '0.75rem 2rem', backgroundColor: '#2d6a4f', color: 'white',
                textDecoration: 'none', borderRadius: '6px', fontSize: '1.1rem',
              }}>
                Registrarse
              </Link>
              <Link to="/login" style={{
                padding: '0.75rem 2rem', backgroundColor: '#1a1a2e', color: 'white',
                textDecoration: 'none', borderRadius: '6px', fontSize: '1.1rem',
              }}>
                Iniciar Sesión
              </Link>
            </div>
          ) : (
            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
              <Link to="/store" style={cardStyle}>🛒 Tienda</Link>
              <Link to="/services" style={cardStyle}>🔧 Servicios</Link>
              <Link to="/deliveries" style={cardStyle}>🏍️ Domicilios</Link>
              <Link to="/contacts" style={cardStyle}>📞 Contactos</Link>
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  )
}

const cardStyle = {
  padding: '2rem 3rem', backgroundColor: 'white', color: '#333',
  textDecoration: 'none', borderRadius: '12px', fontSize: '1.2rem',
  boxShadow: '0 4px 6px rgba(0,0,0,0.1)', border: '1px solid #e0e0e0',
  transition: 'transform 0.2s',
}
