import { useState, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import ProductCard from '../../components/store/ProductCard'
import Cart from '../../components/store/Cart'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import ErrorMessage from '../../components/common/ErrorMessage'
import { useCart } from '../../context/CartContext'
import { getCommerceDetail, createOrder } from '../../api/storeApi'

export default function ComercioDetail() {
  const { id } = useParams()
  const [commerce, setCommerce] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const { addItem, items, clearCart, commerceId } = useCart()

  useEffect(() => {
    getCommerceDetail(id)
      .then(res => setCommerce(res.data))
      .catch(() => setError('Error al cargar el comercio.'))
      .finally(() => setLoading(false))
  }, [id])

  const handleAddToCart = (product) => {
    addItem(product, parseInt(id))
  }

  const handleCheckout = async () => {
    if (items.length === 0) return
    setError('')
    setSuccess('')
    try {
      const orderData = {
        commerce_id: parseInt(id),
        items: items.map(item => ({ product: item.product.id, quantity: item.quantity })),
        notes: '',
      }
      await createOrder(orderData)
      setSuccess('¡Pedido realizado exitosamente!')
      clearCart()
    } catch (err) {
      setError(err.response?.data?.detail || 'Error al crear el pedido.')
    }
  }

  if (loading) return <><Navbar /><LoadingSpinner /></>

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        {commerce && (
          <>
            <h1>{commerce.name}</h1>
            <p style={{ color: '#888' }}>{commerce.category_name} | 📞 {commerce.phone}</p>
            <p style={{ color: '#666' }}>{commerce.description}</p>

            <ErrorMessage message={error} />
            {success && <div style={{ padding: '0.75rem', backgroundColor: '#dcfce7', color: '#16a34a', borderRadius: '6px', marginBottom: '1rem' }}>✅ {success}</div>}

            <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '2rem', marginTop: '1.5rem' }}>
              <div>
                <h2>Productos</h2>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))', gap: '1rem' }}>
                  {commerce.products?.filter(p => p.is_available).map(product => (
                    <ProductCard key={product.id} product={product} onAddToCart={handleAddToCart} />
                  ))}
                </div>
              </div>
              <div>
                <Cart onCheckout={handleCheckout} />
              </div>
            </div>
          </>
        )}
      </main>
      <Footer />
    </div>
  )
}
