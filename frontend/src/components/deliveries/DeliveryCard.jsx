export default function DeliveryCard({ deliverer, onRequest }) {
  return (
    <div style={{
      border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1rem',
      backgroundColor: 'white', boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
    }}>
      <h3>🏍️ Domiciliario #{deliverer.assigned_number}</h3>
      <p><strong>{deliverer.user_name}</strong></p>
      <p style={{ color: '#666' }}>📞 {deliverer.phone || 'Sin teléfono'}</p>
      <p style={{ color: '#666' }}>Tipo: {deliverer.work_type}</p>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '0.5rem' }}>
        <span style={{
          padding: '0.2rem 0.6rem', borderRadius: '12px', fontSize: '0.8rem',
          backgroundColor: deliverer.status === 'DISPONIBLE' ? '#dcfce7' : '#fee2e2',
          color: deliverer.status === 'DISPONIBLE' ? '#16a34a' : '#dc2626',
        }}>
          {deliverer.status}
        </span>
        {deliverer.status === 'DISPONIBLE' && (
          <button
            onClick={() => onRequest(deliverer)}
            style={{
              padding: '0.4rem 1rem', backgroundColor: '#1a1a2e', color: 'white',
              border: 'none', borderRadius: '4px', cursor: 'pointer',
            }}
          >
            Solicitar
          </button>
        )}
      </div>
    </div>
  )
}
