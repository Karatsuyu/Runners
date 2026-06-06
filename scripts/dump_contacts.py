import sqlite3, json
con = sqlite3.connect('backend/db.sqlite3')
cur = con.execute('SELECT id,name,phone,owner_id,is_active,approval_status,category_id,contact_type,created_at FROM contacts ORDER BY created_at DESC')
rows = cur.fetchall()
keys = ['id','name','phone','owner_id','is_active','approval_status','category_id','contact_type','created_at']
print(json.dumps([dict(zip(keys, r)) for r in rows], default=str, ensure_ascii=False, indent=2))
