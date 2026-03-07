import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import CategoryFilter from '../../components/store/CategoryFilter'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import { getCategories, getCommerces } from '../../api/storeApi'

export default function StorePage() {
  const [categories, setCategories] = useState([])
  const [commerces, setCommerces] = useState([])
  const [selectedCategory, setSelectedCategory] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([getCategories(), getCommerces()])
      .then(([catRes, comRes]) => {
        setCategories(catRes.data.results || catRes.data)
        setCommerces(comRes.data.results || comRes.data)
      })
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    setLoading(true)
    getCommerces(selectedCategory ? { category: selectedCategory } : {})
      .then(res => setCommerces(res.data.results || res.data))
      .finally(() => setLoading(false))
  }, [selectedCategory])

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        <h1>🛒 Tienda</h1>
        <p style={{ color: '#666', marginBottom: '1.5rem' }}>Explora restaurantes y almacenes de Caicedonia</p>

        <CategoryFilter categories={categories} selected={selectedCategory} onSelect={setSelectedCategory} />

        {loading ? <LoadingSpinner /> : (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1.5rem' }}>
            {commerces.length > 0 ? commerces.map(commerce => (
              <Link key={commerce.id} to={`/store/${commerce.id}`} style={{ textDecoration: 'none', color: 'inherit' }}>
                <div style={{
                  border: '1px solid #e0e0e0', borderRadius: '8px', padding: '1rem',
                  backgroundColor: 'white', boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
                  transition: 'transform 0.2s',
                }}>
                  {commerce.image && (
                    <img src={commerce.image} alt={commerce.name} style={{ width: '100%', height: '150px', objectFit: 'cover', borderRadius: '6px' }} />
                  )}
                  <h3 style={{ margin: '0.5rem 0 0.25rem' }}>{commerce.name}</h3>
                  <p style={{ color: '#888', fontSize: '0.85rem' }}>{commerce.category_name}</p>
                  <p style={{ color: '#666', fontSize: '0.9rem' }}>{commerce.description}</p>
                  <p style={{ color: '#2d6a4f', fontWeight: 'bold' }}>{commerce.products_count} productos</p>
                </div>
              </Link>
            )) : (
              <p style={{ color: '#999', gridColumn: '1 / -1', textAlign: 'center' }}>No hay comercios disponibles.</p>
            )}
          </div>
        )}
      </main>
      <Footer />
    </div>
  )
}
