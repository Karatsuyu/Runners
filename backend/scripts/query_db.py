import sqlite3
from pathlib import Path

db = Path(__file__).resolve().parents[1] / 'db.sqlite3'
print('DB path:', db)
conn = sqlite3.connect(str(db))
c = conn.cursor()

print('\n-- Usuarios que contienen "lau" en el email --')
for row in c.execute("SELECT id, email, first_name, last_name, role FROM runners_users WHERE email LIKE '%lau%' COLLATE NOCASE"):
    print(row)

print('\n-- Todos los usuarios (limit 20) --')
for row in c.execute("SELECT id, email, first_name, last_name, role FROM runners_users LIMIT 20"):
    print(row)

print('\n-- Proveedores (ServiceProvider) pendientes --')
for row in c.execute("SELECT id, user_id, approval_status, status, created_at FROM services_providers WHERE approval_status = 'PENDIENTE'"):
    print(row)

print('\n-- ServiceProvider rows (limit 50) --')
for row in c.execute("SELECT id, user_id, approval_status, status, created_at FROM services_providers LIMIT 50"):
    print(row)

conn.close()
