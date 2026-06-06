import sqlite3
from pathlib import Path
from datetime import datetime

_db = Path(__file__).resolve().parents[1] / 'db.sqlite3'
print('DB:', _db)
conn = sqlite3.connect(str(_db))
c = conn.cursor()

# Ensure user exists
for row in c.execute("SELECT id, email, role FROM runners_users WHERE id = 1"):
    print('User:', row)

# Insert provider record (if not exists)
exists = False
for row in c.execute("SELECT id, user_id FROM services_providers WHERE user_id = 1"):
    print('Existing provider row:', row)
    exists = True

if not exists:
    now = datetime.now().isoformat(sep=' ', timespec='microseconds')
    c.execute(
        "INSERT INTO services_providers (user_id, category_id, description, photo, resume, terms_accepted, status, approval_status, rejection_reason, approved_by, approved_at, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (1, None, 'Solicitud de prueba recreada', None, None, 0, 'INACTIVO', 'PENDIENTE', None, None, None, now, now)
    )
    conn.commit()
    print('Inserted new provider for user_id=1')
else:
    print('Provider already exists; not inserting')

print('\nProviders now:')
for row in c.execute("SELECT id, user_id, approval_status, status, created_at FROM services_providers"):
    print(row)

conn.close()
