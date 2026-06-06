import sqlite3
from pathlib import Path

_db = Path(__file__).resolve().parents[1] / 'db.sqlite3'
print('DB:', _db)
conn = sqlite3.connect(str(_db))
c = conn.cursor()

# show before
print('\nBefore deletion:')
for row in c.execute("SELECT id, user_id, approval_status, status FROM services_providers WHERE user_id = 1"):
    print(row)

# delete
c.execute("DELETE FROM services_providers WHERE user_id = 1")
conn.commit()

print('\nAfter deletion:')
for row in c.execute("SELECT id, user_id, approval_status, status FROM services_providers WHERE user_id = 1"):
    print(row)

# confirm user role
print('\nUser row:')
for row in c.execute("SELECT id, email, role FROM runners_users WHERE id = 1"):
    print(row)

conn.close()
