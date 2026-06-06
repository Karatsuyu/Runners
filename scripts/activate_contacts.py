import sqlite3

con = sqlite3.connect('backend/db.sqlite3')
cur = con.cursor()
cur.execute("UPDATE contacts SET is_active=1 WHERE owner_id IS NOT NULL AND is_active=0")
con.commit()
print('rows updated:', cur.rowcount)
con.close()
