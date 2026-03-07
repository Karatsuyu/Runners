export default function CategoryFilter({ categories, selected, onSelect }) {
  return (
    <div style={{ display: 'flex', gap: '0.5rem', flexWrap: 'wrap', marginBottom: '1rem' }}>
      <button
        onClick={() => onSelect(null)}
        style={{
          padding: '0.4rem 1rem', borderRadius: '20px', cursor: 'pointer',
          border: '1px solid #ccc',
          backgroundColor: !selected ? '#1a1a2e' : 'white',
          color: !selected ? 'white' : '#333',
        }}
      >
        Todas
      </button>
      {categories.map(cat => (
        <button
          key={cat.id}
          onClick={() => onSelect(cat.id)}
          style={{
            padding: '0.4rem 1rem', borderRadius: '20px', cursor: 'pointer',
            border: '1px solid #ccc',
            backgroundColor: selected === cat.id ? '#1a1a2e' : 'white',
            color: selected === cat.id ? 'white' : '#333',
          }}
        >
          {cat.icon} {cat.name}
        </button>
      ))}
    </div>
  )
}
