import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import logo from '../../assets/r2.jpg'

export default function Navbar() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await logout()
    navigate('/login')
  }

  return (
    <nav style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.6rem 1rem', backgroundColor: 'transparent', color: '#FFFDFD' }}>
      <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '0.6rem', color: '#FFFDFD', textDecoration: 'none' }}>
        <img src={logo} alt="Runners" style={{ height: 44, width: 44, objectFit: 'cover', borderRadius: '50%' }} />
      </Link>

      <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
        {user ? (
          <>
            <Link to="/store" style={{ color: '#FFFDFD', textDecoration: 'none' }}>Tienda</Link>
            <Link to="/services" style={{ color: '#FFFDFD', textDecoration: 'none' }}>Servicios</Link>
            <Link to="/deliveries" style={{ color: '#FFFDFD', textDecoration: 'none' }}>Domicilios</Link>
            <Link to="/contacts" style={{ color: '#FFFDFD', textDecoration: 'none' }}>Contactos</Link>
            {user.role === 'ADMIN' && (
              <Link to="/admin" style={{ color: '#ffd700', textDecoration: 'none' }}>Admin</Link>
            )}
            {user.role === 'DOMICILIARIO' && (
              <Link to="/deliveries/dashboard" style={{ color: '#00ff88', textDecoration: 'none' }}>Mi Panel</Link>
            )}
            <span style={{ color: '#ccc' }}>|</span>
            <span style={{ color: '#aaa', fontSize: '0.9rem' }}>{user.first_name} ({user.role})</span>
            <button onClick={handleLogout} style={{ padding: '0.4rem 0.8rem', backgroundColor: '#f80000', color: '#FFFDFD', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
              Salir
            </button>
          </>
        ) : (
          <>
            <Link to="/login" style={{ color: '#FFFDFD', textDecoration: 'none' }}>Iniciar Sesión</Link>
            <Link to="/register" style={{ color: '#003818', background: '#FFFDFD', padding: '0.25rem 0.6rem', borderRadius: 4, textDecoration: 'none' }}>Registrarse</Link>
          </>
        )}
      </div>
    </nav>
  )
}
