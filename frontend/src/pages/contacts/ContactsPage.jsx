import { useState, useEffect } from 'react'
import Navbar from '../../components/common/Navbar'
import Footer from '../../components/common/Footer'
import ContactCard from '../../components/contacts/ContactCard'
import LoadingSpinner from '../../components/common/LoadingSpinner'
import { getContacts } from '../../api/contactsApi'

export default function ContactsPage() {
  const [contacts, setContacts] = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [filterType, setFilterType] = useState('')
  const [filterAvailability, setFilterAvailability] = useState('')

  useEffect(() => {
    const params = {}
    if (search) params.search = search
    if (filterType) params.type = filterType
    if (filterAvailability) params.availability = filterAvailability

    setLoading(true)
    getContacts(params)
      .then(res => setContacts(res.data.results || res.data))
      .finally(() => setLoading(false))
  }, [search, filterType, filterAvailability])

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar />
      <main style={{ flex: 1, padding: '2rem', maxWidth: '1200px', margin: '0 auto', width: '100%' }}>
        <h1>📞 Contactos</h1>
        <p style={{ color: '#666', marginBottom: '1.5rem' }}>Directorio de contactos de emergencia y profesionales</p>

        {/* Filtros */}
        <div style={{ display: 'flex', gap: '0.75rem', marginBottom: '1.5rem', flexWrap: 'wrap' }}>
          <input
            type="text" placeholder="🔍 Buscar por nombre o teléfono..."
            value={search} onChange={e => setSearch(e.target.value)}
            style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px', flex: 2, minWidth: '200px' }}
          />
          <select value={filterType} onChange={e => setFilterType(e.target.value)}
            style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px' }}>
            <option value="">Todos los tipos</option>
            <option value="EMERGENCIA">Emergencia</option>
            <option value="PROFESIONAL">Profesional</option>
            <option value="COMERCIO">Comercio</option>
            <option value="OTRO">Otro</option>
          </select>
          <select value={filterAvailability} onChange={e => setFilterAvailability(e.target.value)}
            style={{ padding: '0.5rem', border: '1px solid #ccc', borderRadius: '4px' }}>
            <option value="">Todas las disponibilidades</option>
            <option value="EN_SERVICIO">En Servicio</option>
            <option value="FUERA_DE_SERVICIO">Fuera de Servicio</option>
          </select>
        </div>

        {loading ? <LoadingSpinner /> : (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: '1rem' }}>
            {contacts.length > 0 ? contacts.map(contact => (
              <ContactCard key={contact.id} contact={contact} />
            )) : (
              <p style={{ color: '#999', textAlign: 'center', gridColumn: '1 / -1' }}>Sin resultados para tu búsqueda.</p>
            )}
          </div>
        )}
      </main>
      <Footer />
    </div>
  )
}
