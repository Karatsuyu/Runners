import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import ErrorMessage from "../components/common/ErrorMessage";
import fondo from "../assets/fondo.png";
import logoImg from "../assets/r2.jpg";
import "./Register.css";

export default function Register() {

  const [form, setForm] = useState({
    email: "",
    first_name: "",
    last_name: "",
    phone: "",
    password: "",
    password2: "",
  });

  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const { register } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (form.password !== form.password2) {
      setError("Las contraseñas no coinciden");
      return;
    }

    setLoading(true);

    try {
      await register(form);
      navigate("/");
    } catch (err) {
      const data = err.response?.data;

      if (data) {
        const messages = Object.values(data).flat().join(" ");
        setError(messages);
      } else {
        setError("Error al registrarse.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page">

      {/* Barra superior */}
      <div className="top-bar">

        <img src={logoImg} alt="logo" className="top-logo"/>

        <div className="help-icon">?</div>

      </div>

      {/* Fondo */}
      <div
        className="register-container"
        style={{ backgroundImage: `url(${fondo})` }}
      >

        <div className="register-card">

          <div className="logo-container">
            <img src={logoImg} alt="logo" />
          </div>

          <h2>Registrarse</h2>

          <ErrorMessage message={error} />

          <form onSubmit={handleSubmit}>

            <div className="row">

              <div className="field">
                <label>Nombre<span className="required">*</span></label>
                <input
                  type="text"
                  name="first_name"
                  value={form.first_name}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="field">
                <label>Apellidos<span className="required">*</span></label>
                <input
                  type="text"
                  name="last_name"
                  value={form.last_name}
                  onChange={handleChange}
                  required
                />
              </div>

            </div>

            <div className="field">
              <label>Correo electrónico<span className="required">*</span></label>
              <input
                type="email"
                name="email"
                value={form.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="field">
              <label>Teléfono<span className="required">*</span></label>
              <input
                type="text"
                name="phone"
                value={form.phone}
                onChange={handleChange}
              />
            </div>

            <div className="row">

              <div className="field">
                <label>Contraseña<span className="required">*</span></label>
                <input
                  type="password"
                  name="password"
                  value={form.password}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="field">
                <label>Confirmar contraseña<span className="required">*</span></label>
                <input
                  type="password"
                  name="password2"
                  value={form.password2}
                  onChange={handleChange}
                  required
                />
              </div>

            </div>

            <button className="btn-register">
              {loading ? "Registrando..." : "Registrarse"}
            </button>

          </form>

          <p className="login-text">
            ¿Ya tienes cuenta? <Link to="/login">Iniciar Sesión</Link>
          </p>

        </div>

      </div>
    </div>
  );
}