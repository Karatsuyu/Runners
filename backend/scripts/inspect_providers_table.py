import sqlite3
from pathlib import Path

_db = Path(__file__).resolve().parents[1] / 'db.sqlite3'
print('DB:', _db)
conn = sqlite3.connect(str(_db))
c = conn.cursor()

print('PRAGMA table_info(services_providers)')
for row in c.execute("PRAGMA table_info('services_providers')"):
    print(row)

print('\nSample rows:')
for row in c.execute("SELECT * FROM services_providers LIMIT 5"):
    print(row)

conn.close()
