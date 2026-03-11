import { useState, useEffect, useRef } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import ErrorMessage from '../components/common/ErrorMessage'
import './Login.css'
import fondo from '../assets/fondo.png'
import logoImg from '../assets/r2.jpg'
import ayudaImg from '../assets/ayuda.png'
import mostrarImg from '../assets/mostrar.png'
import ocultarImg from '../assets/ocultar.png'
import correoIcon from '../assets/correo.png'
import contraseniaIcon from '../assets/contraseña.png'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()
  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      const user = await login(email, password)
      if (user.role === 'ADMIN') navigate('/admin')
      else navigate('/')
    } catch (err) {
      setError(err.response?.data?.detail || 'Correo o contraseña incorrectos.')
    } finally {
      setLoading(false)
    }
  }


  const [showPassword, setShowPassword] = useState(false)
  const [remember, setRemember] = useState(true)

  useEffect(() => {
    const prev = {
      backgroundImage: document.body.style.backgroundImage,
      backgroundSize: document.body.style.backgroundSize,
      backgroundPosition: document.body.style.backgroundPosition,
      backgroundRepeat: document.body.style.backgroundRepeat,
      backgroundAttachment: document.body.style.backgroundAttachment,
      backgroundColor: document.body.style.backgroundColor,
      overflow: document.body.style.overflow
    }
    document.body.style.backgroundImage = `url(${fondo})`
    document.body.style.backgroundSize = 'cover'
    document.body.style.backgroundPosition = 'center center'
    document.body.style.backgroundRepeat = 'no-repeat'
    document.body.style.backgroundAttachment = 'fixed'
    document.body.style.backgroundColor = 'transparent'
    document.body.style.overflow = 'hidden'
    return () => {
      document.body.style.backgroundImage = prev.backgroundImage
      document.body.style.backgroundSize = prev.backgroundSize
      document.body.style.backgroundPosition = prev.backgroundPosition
      document.body.style.backgroundRepeat = prev.backgroundRepeat
      document.body.style.backgroundAttachment = prev.backgroundAttachment
      document.body.style.backgroundColor = prev.backgroundColor
      document.body.style.overflow = prev.overflow
    }
  }, [])
  const [helpOpen, setHelpOpen] = useState(false)
  const helpRef = useRef(null)

  // Close help popup when clicking outside
  useEffect(() => {
    function handleClick(e) {
      if (helpRef.current && !helpRef.current.contains(e.target)) {
        setHelpOpen(false)
      }
    }
    document.addEventListener('mousedown', handleClick)
    return () => document.removeEventListener('mousedown', handleClick)
  }, [])

  return (
    <div className="login-page" style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>

      <div className="top-bar">
        <Link to="/" className="topbar-left">
          <img src={logoImg} alt="Runners" className="topbar-logo" />
        </Link>
        <div ref={helpRef} style={{position:'relative'}}>
          <button className="help-btn" aria-label="Ayuda" onClick={() => setHelpOpen(s => !s)}>
            <img src={ayudaImg} alt="Ayuda" />
          </button>
          {helpOpen && (
            <div className="help-popup open">
              <h4>¿Necesitas ayuda?</h4>
              <hr />
              <p>Escribe tu usuario o correo y contraseña registrados.</p>
              <p style={{marginTop:8}}>Si olvidaste tus datos, usa la opción de "¿Olvidaste tu contraseña?"</p>
            </div>
          )}
        </div>
      </div>

      <div className="login-card">
        <img src={logoImg} alt="Runners" className="logo-top" />
        <h2 className="login-title">Inicia sesión</h2>
        <ErrorMessage message={error} />

        <form className="login-form" onSubmit={handleSubmit}>
          <div className="field">
            <label>Usuario o Correo<span className="required">*</span></label>
            <div className="input-group with-left-icon">
              <img src={correoIcon} alt="correo" className="input-icon" />
              <input type="email" value={email} onChange={e => setEmail(e.target.value)} required />
            </div>
          </div>

          <div className="field">
            <label>Contraseña<span className="required">*</span></label>
            <div className="input-group with-left-icon">
              <img src={contraseniaIcon} alt="contraseña" className="input-icon" />
              <input type={showPassword ? 'text' : 'password'} value={password} onChange={e => setPassword(e.target.value)} required />
              <button type="button" className="toggle-pass" onClick={() => setShowPassword(s => !s)} aria-label="Mostrar/ocultar contraseña">
                <img src={showPassword ? ocultarImg : mostrarImg} alt="toggle" />
              </button>
            </div>
          </div>

          <button className="btn-primary" type="submit" disabled={loading}>
            {loading ? 'Ingresando...' : 'Acceder'}
          </button>

          <div className="remember-row">
            <label className="remember"><input type="checkbox" checked={remember} onChange={e => setRemember(e.target.checked)} /> Recordarme</label>
            <Link to="/forgot" className="forgot">¿Olvidaste tu contraseña?</Link>
          </div>
        </form>

        <div className="links-row">
          <Link to="/register" className="left-link">Registrarse</Link>
          <Link to="/guest" className="right-link">Continuar como invitado</Link>
        </div>
      </div>
    </div>
  )
}
