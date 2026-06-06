import sqlite3
from pathlib import Path

_db = Path(__file__).resolve().parents[1] / 'db.sqlite3'
print('DB:', _db)
conn = sqlite3.connect(str(_db))
c = conn.cursor()

# Find user_ids that have provider rows not approved
rows = list(c.execute("SELECT DISTINCT user_id FROM services_providers WHERE approval_status != 'APROBADO'"))
if not rows:
    print('No non-approved providers found.')
else:
    changed = 0
    for (user_id,) in rows:
        # Set user role to CLIENTE
        c.execute("UPDATE runners_users SET role = 'CLIENTE' WHERE id = ?", (user_id,))
        if c.rowcount:
            changed += 1
            print(f'Set user {user_id} role -> CLIENTE')
    conn.commit()
    print(f'Updated roles for {changed} users.')

conn.close()
