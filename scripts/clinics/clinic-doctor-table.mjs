/**
 * Собирает JSON: клиники со списком врачей и их специальностей.
 * Результат сохраняется в data/from-db/clinics-doctors.json
 *
 * Usage:
 *   node scripts/clinic-doctor-table.mjs
 */

import { readFileSync, writeFileSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import mysql from 'mysql2/promise'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

// ---------------------------------------------------------------------------
// Load .env
// ---------------------------------------------------------------------------
const envPath = resolve(ROOT, '.env')
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
    const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/)
    if (m) process.env[m[1]] = m[2].trim()
  }
}

const connection = await mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: 'docta_me',
  port: 3306,
  charset: 'utf8mb4',
})

try {
  const [rows] = await connection.execute(`
    SELECT
      c.id   AS clinic_id,
      COALESCE(c.name_sr, c.name_ru, c.name_sr_cyrl) AS clinic_name,
      d.id   AS doctor_id,
      COALESCE(d.name_sr, d.name_ru, d.name_en)      AS doctor_name,
      GROUP_CONCAT(s.name ORDER BY s.name SEPARATOR ', ') AS specialties
    FROM clinics c
    LEFT JOIN doctor_clinics dc ON dc.clinic_id = c.id
    LEFT JOIN doctors d ON d.id = dc.doctor_id
    LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
    LEFT JOIN specialties s ON s.id = ds.specialty_id
    GROUP BY c.id, d.id
    ORDER BY c.id, d.id
  `)

  // Группируем по клиникам
  const clinicsMap = new Map()

  for (const row of rows) {
    if (!clinicsMap.has(row.clinic_id)) {
      clinicsMap.set(row.clinic_id, {
        id: row.clinic_id,
        name: row.clinic_name,
        doctors: [],
      })
    }

    if (row.doctor_id != null) {
      clinicsMap.get(row.clinic_id).doctors.push({
        id: row.doctor_id,
        name: row.doctor_name,
        specialties: row.specialties ? row.specialties.split(', ') : [],
      })
    }
  }

  const result = [...clinicsMap.values()]

  const outPath = resolve(ROOT, 'data/from-db/clinics-doctors.json')
  writeFileSync(outPath, JSON.stringify(result, null, 2), 'utf-8')

  console.log(`Done: ${result.length} clinics, ${rows.filter(r => r.doctor_id).length} doctor links`)
  console.log(`Saved to ${outPath}`)
} finally {
  await connection.end()
}
