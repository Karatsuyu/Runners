export default function ProductCard({ product, onAddToCart }) {
  return (
    <div style={{
      border: '1px solid #e0e0e0',
      borderRadius: '8px',
      padding: '1rem',
      backgroundColor: 'white',
      boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
    }}>
      {product.image && (
        <img src={product.image} alt={product.name} style={{ width: '100%', height: '150px', objectFit: 'cover', borderRadius: '6px' }} />
      )}
      <h3 style={{ margin: '0.5rem 0 0.25rem' }}>{product.name}</h3>
      <p style={{ color: '#666', fontSize: '0.9rem' }}>{product.description}</p>
      <p style={{ fontWeight: 'bold', color: '#2d6a4f', fontSize: '1.2rem' }}>
        ${Number(product.price).toLocaleString('es-CO')}
      </p>
      {product.is_available ? (
        <button
          onClick={() => onAddToCart(product)}
          style={{
            width: '100%', padding: '0.5rem', backgroundColor: '#2d6a4f',
            color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer',
          }}
        >
          Agregar al carrito
        </button>
      ) : (
        <span style={{ color: '#999' }}>No disponible</span>
      )}
    </div>
  )
}
