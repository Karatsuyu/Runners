export default function ProviderCard({ provider, onRequest }) {
  return (
    <div style={{
      border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1rem',
      backgroundColor: 'white', boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
    }}>
      <h3>🔧 {provider.user_info?.first_name} {provider.user_info?.last_name}</h3>
      <p style={{ color: '#666' }}><strong>Categoría:</strong> {provider.category_name}</p>
      <p style={{ color: '#666', fontSize: '0.9rem' }}>{provider.description}</p>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: '0.5rem' }}>
        <span style={{
          padding: '0.2rem 0.6rem', borderRadius: '12px', fontSize: '0.8rem',
          backgroundColor: provider.status === 'DISPONIBLE' ? '#dcfce7' : '#fee2e2',
          color: provider.status === 'DISPONIBLE' ? '#16a34a' : '#dc2626',
        }}>
          {provider.status}
        </span>
        {provider.status === 'DISPONIBLE' && (
          <button
            onClick={() => onRequest(provider)}
            style={{
              padding: '0.4rem 1rem', backgroundColor: '#1a1a2e', color: 'white',
              border: 'none', borderRadius: '4px', cursor: 'pointer',
            }}
          >
            Solicitar Servicio
          </button>
        )}
      </div>
    </div>
  )
}
