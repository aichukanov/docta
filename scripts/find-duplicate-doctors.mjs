/**
 * Ищет потенциальные дубликаты врачей в БД и выводит их блоками для ручной проверки.
 *
 * Что ловим:
 *   - Потерянная диакритика:  «Laković» vs «Lakovic»
 *   - Перевёрнутое имя:       «Ime Prezime» vs «Prezime Ime»
 *   - Двойная фамилия / лишний/недостающий токен:
 *                             «Ana Marković» vs «Ana Marković-Tatar»
 *                             «Ana Marković» vs «Dr Ana Marković»
 *
 * Результат выводится в stdout.
 *
 * Usage:
 *   node scripts/find-duplicate-doctors.mjs
 */

import { readFileSync, existsSync } from 'node:fs'
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

// ---------------------------------------------------------------------------
// Нормализация: lowercase, диакритика → ASCII, отбрасываем не-буквы, токены.
// đ обрабатываем явно — он не разлагается NFD.
// ---------------------------------------------------------------------------
function normalize(str) {
  if (!str) return ''
  return str
    .toLowerCase()
    .replace(/đ/g, 'dj')
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9\s]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

// Профессиональные префиксы и звания, не несущие смысла для сравнения имён.
const NOISE_TOKENS = new Set([
  'dr', 'prof', 'mr', 'ms', 'mrs',
  'doc', 'docent', 'docenta',
  'spec', 'specijalista',
  'prim', 'primarijus',
  'akademik',
])

function tokens(str) {
  const n = normalize(str)
  if (!n) return []
  return n.split(' ').filter((t) => t && !NOISE_TOKENS.has(t))
}

// ---------------------------------------------------------------------------
// Подключение к БД
// ---------------------------------------------------------------------------
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
      d.id,
      d.name_sr,
      d.name_sr_cyrl,
      d.name_ru,
      d.name_en,
      GROUP_CONCAT(DISTINCT s.name ORDER BY s.name SEPARATOR ', ') AS specialties
    FROM doctors d
    LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
    LEFT JOIN specialties s ON s.id = ds.specialty_id
    GROUP BY d.id
    ORDER BY d.id
  `)

  // Готовим компактное представление для каждого врача
  const doctors = rows
    .map((r) => {
      const primary = r.name_sr || r.name_ru || r.name_en || ''
      const tks = tokens(primary)
      return {
        id: r.id,
        name: primary,
        cyrl: r.name_sr_cyrl || '',
        nameRu: r.name_ru || '',
        nameEn: r.name_en || '',
        tokens: tks,
        sortedKey: [...tks].sort().join(' '),
        tokenSet: new Set(tks),
        specialties: r.specialties || '—',
      }
    })
    .filter((d) => d.tokens.length > 0)

  console.log(`Loaded ${doctors.length} doctors with non-empty names`)

  // ---------------------------------------------------------------------------
  // 1) Точные дубли: одинаковый набор токенов в любом порядке
  //    (ловит диакритику и перевёрнутые имена)
  // ---------------------------------------------------------------------------
  const exactClusters = new Map()
  for (const d of doctors) {
    if (!exactClusters.has(d.sortedKey)) exactClusters.set(d.sortedKey, [])
    exactClusters.get(d.sortedKey).push(d)
  }
  const exactGroups = [...exactClusters.values()].filter((g) => g.length > 1)
  const exactPairKey = (a, b) => (a.id < b.id ? `${a.id}-${b.id}` : `${b.id}-${a.id}`)
  const exactPairs = new Set()
  for (const g of exactGroups) {
    for (let i = 0; i < g.length; i++) {
      for (let j = i + 1; j < g.length; j++) {
        exactPairs.add(exactPairKey(g[i], g[j]))
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 2) Подмножество: токены одного — строгое подмножество токенов другого
  //    (ловит двойные фамилии, недостающие/лишние токены).
  //    Требуем ≥2 общих токена, чтобы не цеплять однофамильцев по фамилии.
  // ---------------------------------------------------------------------------
  const edges = new Map() // id -> Set<id>
  const addEdge = (a, b) => {
    if (!edges.has(a)) edges.set(a, new Set())
    if (!edges.has(b)) edges.set(b, new Set())
    edges.get(a).add(b)
    edges.get(b).add(a)
  }

  for (let i = 0; i < doctors.length; i++) {
    for (let j = i + 1; j < doctors.length; j++) {
      const a = doctors[i]
      const b = doctors[j]
      // Пропускаем пары, уже найденные точным матчем
      if (exactPairs.has(exactPairKey(a, b))) continue

      const small = a.tokens.length <= b.tokens.length ? a : b
      const big = small === a ? b : a
      if (small.tokens.length < 2) continue
      if (small.tokens.length === big.tokens.length) continue // одинаковый размер обработан в (1)

      let isSubset = true
      for (const tok of small.tokenSet) {
        if (!big.tokenSet.has(tok)) {
          isSubset = false
          break
        }
      }
      if (isSubset) addEdge(a.id, b.id)
    }
  }

  // Компоненты связности по edges
  const byId = new Map(doctors.map((d) => [d.id, d]))
  const visited = new Set()
  const subsetGroups = []
  for (const id of edges.keys()) {
    if (visited.has(id)) continue
    const stack = [id]
    const comp = []
    while (stack.length) {
      const cur = stack.pop()
      if (visited.has(cur)) continue
      visited.add(cur)
      comp.push(byId.get(cur))
      for (const nb of edges.get(cur) || []) {
        if (!visited.has(nb)) stack.push(nb)
      }
    }
    if (comp.length > 1) subsetGroups.push(comp)
  }

  // ---------------------------------------------------------------------------
  // Отчёт → stdout
  // ---------------------------------------------------------------------------
  const print = (s = '') => console.log(s)

  print(`# Doctor duplicates report — ${new Date().toISOString()}`)
  print(`# Total doctors scanned: ${doctors.length}`)
  print()
  print('=================================================================')
  print(' SECTION 1. Точные дубли (одинаковые токены, любой порядок)')
  print('   — потеря диакритики, перевёрнутое имя')
  print(`   Groups: ${exactGroups.length}`)
  print('=================================================================')
  print()

  exactGroups.sort((a, b) => a[0].sortedKey.localeCompare(b[0].sortedKey))
  for (const g of exactGroups) {
    print(`--- key: "${g[0].sortedKey}"`)
    for (const d of g) {
      print(`  [${String(d.id).padStart(5)}]  ${d.name}   |   ${d.specialties}`)
      if (d.nameRu) print(`              ru: ${d.nameRu}`)
    }
    print()
  }

  print('=================================================================')
  print(' SECTION 2. Подмножество токенов (один ⊂ другому)')
  print('   — двойная фамилия, недостающий/лишний токен')
  print(`   Groups: ${subsetGroups.length}`)
  print('=================================================================')
  print()

  subsetGroups.sort((a, b) => {
    const ka = [...a].sort((x, y) => x.tokens.length - y.tokens.length)[0].sortedKey
    const kb = [...b].sort((x, y) => x.tokens.length - y.tokens.length)[0].sortedKey
    return ka.localeCompare(kb)
  })
  for (const g of subsetGroups) {
    const sorted = [...g].sort((a, b) => a.tokens.length - b.tokens.length)
    print('---')
    for (const d of sorted) {
      print(`  [${String(d.id).padStart(5)}]  ${d.name}   |   ${d.specialties}`)
      if (d.nameRu) print(`              ru: ${d.nameRu}`)
    }
    print()
  }

  print(`# Done. Exact groups: ${exactGroups.length}, subset groups: ${subsetGroups.length}`)
} finally {
  await connection.end()
}
