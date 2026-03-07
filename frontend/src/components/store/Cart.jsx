import { useCart } from '../../context/CartContext'

export default function Cart({ onCheckout }) {
  const { items, total, updateQuantity, removeItem, clearCart } = useCart()

  if (items.length === 0) {
    return (
      <div style={{ padding: '1rem', textAlign: 'center', color: '#999' }}>
        🛒 Tu carrito está vacío
      </div>
    )
  }

  return (
    <div style={{
      border: '1px solid #e0e0e0', borderRadius: '8px',
      padding: '1rem', backgroundColor: 'white',
    }}>
      <h3>🛒 Carrito</h3>
      {items.map(item => (
        <div key={item.product.id} style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          padding: '0.5rem 0', borderBottom: '1px solid #f0f0f0',
        }}>
          <div>
            <strong>{item.product.name}</strong>
            <br />
            <small>${Number(item.product.price).toLocaleString('es-CO')} c/u</small>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <button onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
              style={{ padding: '0.2rem 0.5rem', cursor: 'pointer' }}>−</button>
            <span>{item.quantity}</span>
            <button onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
              style={{ padding: '0.2rem 0.5rem', cursor: 'pointer' }}>+</button>
            <button onClick={() => removeItem(item.product.id)}
              style={{ color: 'red', cursor: 'pointer', border: 'none', background: 'none' }}>✕</button>
          </div>
        </div>
      ))}
      <div style={{ marginTop: '1rem', fontWeight: 'bold', fontSize: '1.1rem' }}>
        Total: ${total.toLocaleString('es-CO')}
      </div>
      <div style={{ display: 'flex', gap: '0.5rem', marginTop: '0.5rem' }}>
        <button onClick={clearCart}
          style={{ flex: 1, padding: '0.5rem', cursor: 'pointer', backgroundColor: '#eee', border: '1px solid #ccc', borderRadius: '4px' }}>
          Vaciar
        </button>
        <button onClick={onCheckout}
          style={{ flex: 2, padding: '0.5rem', cursor: 'pointer', backgroundColor: '#2d6a4f', color: 'white', border: 'none', borderRadius: '4px' }}>
          Realizar Pedido
        </button>
      </div>
    </div>
  )
}
