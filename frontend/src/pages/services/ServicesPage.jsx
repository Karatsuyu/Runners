import { useState, useEffect } from 'react'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import ServiceCard from '../../components/services/ServiceCard'
import ProviderCard from '../../components/services/ProviderCard'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import ErrorMessage from '../../components/common/ErrorMessage'
import { getServiceCategories, getProviders, createServiceRequest } from '../../api/servicesApi'

export default function ServicesPage() {
  const [categories, setCategories] = useState([])
  const [providers, setProviders] = useState([])
  const [selectedCategory, setSelectedCategory] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  useEffect(() => {
    getServiceCategories()
      .then(res => setCategories(res.data.results || res.data))
      .finally(() => setLoading(false))
  }, [])

  const handleSelectCategory = (catId) => {
    setSelectedCategory(catId)
    setLoading(true)
    getProviders({ category: catId })
      .then(res => setProviders(res.data.results || res.data))
      .finally(() => setLoading(false))
  }

  const handleRequest = async (provider) => {
    setError('')
    setSuccess('')
    const description = prompt('Describe brevemente el servicio que necesitas:')
    if (!description) return
    try {
      await createServiceRequest({
        provider: provider.id,
        category: provider.category,
        description,
      })
      setSuccess(`Solicitud enviada a ${provider.user_info?.first_name}. Runners será intermediaria del contacto.`)
    } catch (err) {
      setError(err.response?.data?.detail || 'Error al solicitar el servicio.')
    }
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        <h1>🔧 Servicios</h1>
        <p style={{ color: '#666', marginBottom: '1.5rem' }}>Encuentra prestadores de servicio en Caicedonia</p>

        <ErrorMessage message={error} />
        {success && <div style={{ padding: '0.75rem', backgroundColor: '#dcfce7', color: '#16a34a', borderRadius: '6px', marginBottom: '1rem' }}>✅ {success}</div>}

        {!selectedCategory ? (
          <>
            <h2>Categorías</h2>
            {loading ? <LoadingSpinner /> : (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', gap: '1rem' }}>
                {categories.map(cat => (
                  <ServiceCard key={cat.id} category={cat} onSelect={handleSelectCategory} />
                ))}
              </div>
            )}
          </>
        ) : (
          <>
            <button onClick={() => { setSelectedCategory(null); setProviders([]) }}
              style={{ marginBottom: '1rem', padding: '0.4rem 1rem', cursor: 'pointer', backgroundColor: '#eee', border: '1px solid #ccc', borderRadius: '4px' }}>
              ← Volver a categorías
            </button>
            <h2>Prestadores disponibles</h2>
            {loading ? <LoadingSpinner /> : (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '1rem' }}>
                {providers.length > 0 ? providers.map(p => (
                  <ProviderCard key={p.id} provider={p} onRequest={handleRequest} />
                )) : (
                  <p style={{ color: '#999' }}>Sin prestadores disponibles en este momento.</p>
                )}
              </div>
            )}
          </>
        )}
      </main>
      <Footer />
    </div>
  )
}
