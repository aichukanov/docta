import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
for (const line of readFileSync('.env','utf-8').split('\n')) { const m=line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/); if(m) process.env[m[1]]=m[2].trim(); }
const c = await mysql.createConnection({host:process.env.DB_HOST,user:process.env.DB_USER,password:process.env.DB_PASSWORD,database:process.env.DB_NAME,port:+process.env.DB_PORT});
const [clinics]=await c.query(`SELECT c.id,c.slug,c.name_sr,c.town_sr,ci.name city,c.address_sr,c.phone,c.website,c.hidden,c.status FROM clinics c LEFT JOIN cities ci ON ci.id=c.city_id`);
const [doctors]=await c.query(`SELECT d.id,d.slug,d.name_sr,d.hidden,d.hidden_by_admin,d.is_draft, GROUP_CONCAT(DISTINCT cl.slug) clinics FROM doctors d LEFT JOIN doctor_clinics dc ON dc.doctor_id=d.id LEFT JOIN clinics cl ON cl.id=dc.clinic_id GROUP BY d.id`);
writeFileSync('C:/Users/AICHUK~1/AppData/Local/Temp/claude/e--pet-docta-me-nuxt/94666b83-839c-4ab9-8452-6b84bf354026/scratchpad/ours.json', JSON.stringify({clinics,doctors},null,1));
console.log(clinics.length, doctors.length);
await c.end();
