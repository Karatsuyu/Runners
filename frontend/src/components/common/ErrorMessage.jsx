export default function ErrorMessage({ message }) {
  if (!message) return null

  return (
    <div style={{
      padding: '0.75rem 1rem',
      backgroundColor: '#fee2e2',
      color: '#dc2626',
      borderRadius: '6px',
      border: '1px solid #fca5a5',
      marginBottom: '1rem',
    }}>
      ⚠️ {message}
    </div>
  )
}
