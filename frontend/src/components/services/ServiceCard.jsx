export default function ServiceCard({ category, onSelect }) {
  return (
    <div
      onClick={() => onSelect(category.id)}
      style={{
        border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1.5rem',
        backgroundColor: 'white', cursor: 'pointer', textAlign: 'center',
        boxShadow: '0 2px 4px rgba(0,0,0,0.1)', transition: 'transform 0.2s',
      }}
      onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'}
      onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}
    >
      <h3>{category.name}</h3>
      <p style={{ color: '#666', fontSize: '0.9rem' }}>{category.description}</p>
    </div>
  )
}
