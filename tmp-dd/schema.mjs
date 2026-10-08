import mysql from 'mysql2/promise';
import { readFileSync } from 'node:fs';
for (const line of readFileSync('e:/pet/docta.me/nuxt/.env','utf-8').split('\n')) { const m=line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/); if(m) process.env[m[1]]=m[2].trim(); }
const c = await mysql.createConnection({host:process.env.DB_HOST,user:process.env.DB_USER,password:process.env.DB_PASSWORD,database:process.env.DB_NAME,port:+process.env.DB_PORT});
for (const t of ['clinics','doctors','doctor_clinics','cities']) { const [r]=await c.query('SHOW COLUMNS FROM '+t); console.log(t, r.map(x=>x.Field).join(', ')); }
await c.end();
