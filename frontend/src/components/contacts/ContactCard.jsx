export default function ContactCard({ contact }) {
  return (
    <div style={{
      border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1rem',
      backgroundColor: 'white', boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h3 style={{ margin: '0 0 0.25rem' }}>{contact.name}</h3>
          <p style={{ color: '#666', fontSize: '0.9rem' }}>{contact.description}</p>
        </div>
        <span style={{
          padding: '0.2rem 0.6rem', borderRadius: '12px', fontSize: '0.75rem',
          backgroundColor: contact.contact_type === 'EMERGENCIA' ? '#fee2e2' : '#dbeafe',
          color: contact.contact_type === 'EMERGENCIA' ? '#dc2626' : '#2563eb',
        }}>
          {contact.contact_type}
        </span>
      </div>
      <div style={{ marginTop: '0.5rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <a href={`tel:${contact.phone}`} style={{
          color: '#2d6a4f', fontWeight: 'bold', fontSize: '1.1rem', textDecoration: 'none',
        }}>
          📞 {contact.phone}
        </a>
        <span style={{
          padding: '0.2rem 0.6rem', borderRadius: '12px', fontSize: '0.75rem',
          backgroundColor: contact.availability === 'EN_SERVICIO' ? '#dcfce7' : '#f3f4f6',
          color: contact.availability === 'EN_SERVICIO' ? '#16a34a' : '#6b7280',
        }}>
          {contact.availability === 'EN_SERVICIO' ? '🟢 En Servicio' : '⚫ Fuera de Servicio'}
        </span>
      </div>
    </div>
  )
}
