import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'

export default function Navbar() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await logout()
    navigate('/login')
  }

  return (
    <nav style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '1rem 2rem', backgroundColor: '#1a1a2e', color: 'white' }}>
      <Link to="/" style={{ color: 'white', textDecoration: 'none', fontSize: '1.5rem', fontWeight: 'bold' }}>
        🏃 Runners
      </Link>

      <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
        {user ? (
          <>
            <Link to="/store" style={{ color: 'white', textDecoration: 'none' }}>Tienda</Link>
            <Link to="/services" style={{ color: 'white', textDecoration: 'none' }}>Servicios</Link>
            <Link to="/deliveries" style={{ color: 'white', textDecoration: 'none' }}>Domicilios</Link>
            <Link to="/contacts" style={{ color: 'white', textDecoration: 'none' }}>Contactos</Link>
            {user.role === 'ADMIN' && (
              <Link to="/admin" style={{ color: '#ffd700', textDecoration: 'none' }}>Admin</Link>
            )}
            {user.role === 'DOMICILIARIO' && (
              <Link to="/deliveries/dashboard" style={{ color: '#00ff88', textDecoration: 'none' }}>Mi Panel</Link>
            )}
            <span style={{ color: '#ccc' }}>|</span>
            <span style={{ color: '#aaa', fontSize: '0.9rem' }}>{user.first_name} ({user.role})</span>
            <button onClick={handleLogout} style={{ padding: '0.4rem 0.8rem', backgroundColor: '#e74c3c', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
              Salir
            </button>
          </>
        ) : (
          <>
            <Link to="/login" style={{ color: 'white', textDecoration: 'none' }}>Iniciar Sesión</Link>
            <Link to="/register" style={{ color: '#00ff88', textDecoration: 'none' }}>Registrarse</Link>
          </>
        )}
      </div>
    </nav>
  )
}
