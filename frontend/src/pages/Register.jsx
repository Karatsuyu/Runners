import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import ErrorMessage from '../components/common/ErrorMessage'

export default function Register() {
  const [form, setForm] = useState({
    email: '', first_name: '', last_name: '', phone: '', password: '', password2: ''
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { register } = useAuth()
  const navigate = useNavigate()

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')

    if (form.password !== form.password2) {
      setError('Las contraseñas no coinciden.')
      return
    }

    setLoading(true)
    try {
      await register(form)
      navigate('/')
    } catch (err) {
      const data = err.response?.data
      if (data) {
        const messages = Object.values(data).flat().join(' ')
        setError(messages)
      } else {
        setError('Error al registrarse. Intenta de nuevo.')
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', backgroundColor: '#f5f5f5' }}>
      <div style={{ width: '450px', padding: '2rem', backgroundColor: 'white', borderRadius: '12px', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
        <h2 style={{ textAlign: 'center', marginBottom: '1.5rem' }}>🏃 Registrarse</h2>

        <ErrorMessage message={error} />

        <form onSubmit={handleSubmit}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem', marginBottom: '0.75rem' }}>
            <div>
              <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Nombre</label>
              <input type="text" name="first_name" value={form.first_name} onChange={handleChange} required
                style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
            </div>
            <div>
              <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Apellido</label>
              <input type="text" name="last_name" value={form.last_name} onChange={handleChange} required
                style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
            </div>
          </div>
          <div style={{ marginBottom: '0.75rem' }}>
            <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Correo electrónico</label>
            <input type="email" name="email" value={form.email} onChange={handleChange} required
              style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
          </div>
          <div style={{ marginBottom: '0.75rem' }}>
            <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Teléfono</label>
            <input type="text" name="phone" value={form.phone} onChange={handleChange}
              style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem', marginBottom: '1rem' }}>
            <div>
              <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Contraseña</label>
              <input type="password" name="password" value={form.password} onChange={handleChange} required
                style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
            </div>
            <div>
              <label style={{ display: 'block', marginBottom: '0.3rem', fontWeight: 'bold' }}>Confirmar</label>
              <input type="password" name="password2" value={form.password2} onChange={handleChange} required
                style={{ width: '100%', padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', boxSizing: 'border-box' }} />
            </div>
          </div>
          <button type="submit" disabled={loading}
            style={{ width: '100%', padding: '0.7rem', backgroundColor: '#2d6a4f', color: 'white', border: 'none', borderRadius: '6px', cursor: 'pointer', fontSize: '1rem' }}>
            {loading ? 'Registrando...' : 'Registrarse'}
          </button>
        </form>

        <p style={{ textAlign: 'center', marginTop: '1rem', color: '#666' }}>
          ¿Ya tienes cuenta? <Link to="/login" style={{ color: '#1a1a2e' }}>Iniciar Sesión</Link>
        </p>
      </div>
    </div>
  )
}
