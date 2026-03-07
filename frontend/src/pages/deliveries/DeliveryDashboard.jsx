import { useState, useEffect } from 'react'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import ErrorMessage from '../../components/common/ErrorMessage'
import { getFinancialRecords, createFinancialRecord, updateDelivererStatus } from '../../api/deliveriesApi'

export default function DeliveryDashboard() {
  const [records, setRecords] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [form, setForm] = useState({ record_type: 'INGRESO', amount: '', description: '' })

  const loadRecords = () => {
    getFinancialRecords()
      .then(res => setRecords(res.data.results || res.data))
      .finally(() => setLoading(false))
  }

  useEffect(() => { loadRecords() }, [])

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    try {
      await createFinancialRecord({ ...form, amount: parseFloat(form.amount) })
      setForm({ record_type: 'INGRESO', amount: '', description: '' })
      loadRecords()
    } catch (err) {
      setError(err.response?.data?.detail || 'Error al registrar.')
    }
  }

  const handleStatusChange = async (status) => {
    try {
      await updateDelivererStatus(status)
      alert(`Estado actualizado a: ${status}`)
    } catch (err) {
      setError('Error al cambiar estado.')
    }
  }

  const incomes = records.filter(r => r.record_type === 'INGRESO').reduce((s, r) => s + parseFloat(r.amount), 0)
  const expenses = records.filter(r => r.record_type === 'EGRESO').reduce((s, r) => s + parseFloat(r.amount), 0)
  const commissions = records.filter(r => r.record_type === 'INGRESO').reduce((s, r) => s + parseFloat(r.runners_commission || 0), 0)

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1000px', margin: '0 auto', width: '100%' }}>
        <h1>📊 Panel de Domiciliario</h1>

        <ErrorMessage message={error} />

        {/* Estado */}
        <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
          <button onClick={() => handleStatusChange('DISPONIBLE')} style={{ padding: '0.5rem 1rem', backgroundColor: '#dcfce7', border: '1px solid #16a34a', borderRadius: '4px', cursor: 'pointer' }}>🟢 Disponible</button>
          <button onClick={() => handleStatusChange('OCUPADO')} style={{ padding: '0.5rem 1rem', backgroundColor: '#fef3c7', border: '1px solid #d97706', borderRadius: '4px', cursor: 'pointer' }}>🟡 Ocupado</button>
          <button onClick={() => handleStatusChange('INACTIVO')} style={{ padding: '0.5rem 1rem', backgroundColor: '#f3f4f6', border: '1px solid #6b7280', borderRadius: '4px', cursor: 'pointer' }}>⚫ Inactivo</button>
        </div>

        {/* Resumen */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '1rem', marginBottom: '2rem' }}>
          <div style={{ padding: '1rem', backgroundColor: '#dcfce7', borderRadius: '8px', textAlign: 'center' }}>
            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#16a34a' }}>${incomes.toLocaleString('es-CO')}</p>
            <p style={{ color: '#666' }}>Ingresos</p>
          </div>
          <div style={{ padding: '1rem', backgroundColor: '#fee2e2', borderRadius: '8px', textAlign: 'center' }}>
            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#dc2626' }}>${expenses.toLocaleString('es-CO')}</p>
            <p style={{ color: '#666' }}>Egresos</p>
          </div>
          <div style={{ padding: '1rem', backgroundColor: '#dbeafe', borderRadius: '8px', textAlign: 'center' }}>
            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#2563eb' }}>${(incomes - expenses).toLocaleString('es-CO')}</p>
            <p style={{ color: '#666' }}>Balance</p>
          </div>
          <div style={{ padding: '1rem', backgroundColor: '#fef3c7', borderRadius: '8px', textAlign: 'center' }}>
            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#d97706' }}>${commissions.toLocaleString('es-CO')}</p>
            <p style={{ color: '#666' }}>Comisión Runners</p>
          </div>
        </div>

        {/* Formulario */}
        <div style={{ backgroundColor: 'white', border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1.5rem', marginBottom: '2rem' }}>
          <h3>Registrar movimiento</h3>
          <form onSubmit={handleSubmit} style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
            <select value={form.record_type} onChange={e => setForm({ ...form, record_type: e.target.value })}
              style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px' }}>
              <option value="INGRESO">Ingreso</option>
              <option value="EGRESO">Egreso</option>
            </select>
            <input type="number" placeholder="Valor" value={form.amount} onChange={e => setForm({ ...form, amount: e.target.value })} required min="1"
              style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', flex: 1 }} />
            <input type="text" placeholder="Descripción" value={form.description} onChange={e => setForm({ ...form, description: e.target.value })} required
              style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', flex: 2 }} />
            <button type="submit" style={{ padding: '0.5rem 1.5rem', backgroundColor: '#1a1a2e', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
              Registrar
            </button>
          </form>
        </div>

        {/* Historial */}
        <h3>Historial de movimientos</h3>
        {loading ? <LoadingSpinner /> : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
            {records.map(r => (
              <div key={r.id} style={{
                display: 'flex', justifyContent: 'space-between', padding: '0.75rem',
                backgroundColor: r.record_type === 'INGRESO' ? '#f0fdf4' : '#fef2f2',
                borderRadius: '6px', border: '1px solid #e0e0e0',
              }}>
                <div>
                  <strong>{r.record_type}</strong> — {r.description}
                  {r.runners_commission > 0 && <small style={{ color: '#d97706' }}> (comisión: ${r.runners_commission})</small>}
                </div>
                <span style={{ fontWeight: 'bold', color: r.record_type === 'INGRESO' ? '#16a34a' : '#dc2626' }}>
                  {r.record_type === 'INGRESO' ? '+' : '-'}${Number(r.amount).toLocaleString('es-CO')}
                </span>
              </div>
            ))}
          </div>
        )}
      </main>
      <Footer />
    </div>
  )
}
