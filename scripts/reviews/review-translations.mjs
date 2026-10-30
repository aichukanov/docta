/**
 * Недостающие переводы отзывов Google и ответов владельцев — пачками.
 *
 * Источник — база, а не файлы клиник: переводить надо то, чего не хватает в
 * `reviews` / `review_replies`, сколько бы конфигов и съёмов за этим ни стояло.
 * Отзыв адресуется по `provider_review_id`, ответ — по нему же (ответ один на
 * отзыв: `uq_review_responder`), поэтому SQL годится и для локальной базы, и
 * для прода, где id строк другие.
 *
 *   extract  — пачки по --size текстов в <dir>/todo/batch-NNN.json; в каждом
 *              элементе только те языки, которых нет (`need`)
 *   status   — сколько пачек переведено
 *   sql      — <dir>/done/*.json → <out>.sql (COALESCE: переведённое не трогает)
 *
 * Перевод пачки — файл <dir>/done/batch-NNN.json того же имени:
 *   { "<key>": { "en": "...", "ru": "...", ... }, ... }
 * Свой файл на пачку — параллельные исполнители не перетирают друг друга.
 *
 * Usage:
 *   node scripts/reviews/review-translations.mjs extract --dir <dir> [--size 20]
 *   node scripts/reviews/review-translations.mjs status --dir <dir>
 *   node scripts/reviews/review-translations.mjs sql --dir <dir> --out <file.sql>
 */

import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import mysql from 'mysql2/promise'

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')

for (const line of fs.readFileSync(path.join(ROOT, '.env'), 'utf8').split(/\r?\n/)) {
  const m = /^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/.exec(line)
  if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, '')
}

const [command, ...argv] = process.argv.slice(2)
const arg = (flag, fallback = null) => {
  const i = argv.indexOf(flag)
  return i >= 0 ? argv[i + 1] : fallback
}
const DIR = path.resolve(ROOT, arg('--dir', 'data/review-translations/batches'))
const LANGS = ['sr', 'sr_cyrl', 'en', 'ru', 'de', 'tr']

const isCyrillic = (text) => /[Ѐ-ӿ]/.test(text)

/** Языки, которых у строки нет. Оригинал на целевом языке переводить незачем. */
function missing(row) {
  return LANGS.filter((lang) => !row[`text_${lang}`]?.trim())
}

async function extract() {
  const size = Number(arg('--size', 20))
  const db = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    charset: 'utf8mb4',
  })
  const cols = LANGS.map((l) => `x.text_${l}`).join(', ')
  const missingWhere = LANGS.map((l) => `x.text_${l} IS NULL OR TRIM(x.text_${l}) = ''`).join(' OR ')
  const [reviews] = await db.query(
    `SELECT 'review' AS kind, x.provider_review_id AS pid, x.original_language AS lang, x.original_text AS text, ${cols}
     FROM reviews x
     WHERE x.provider = 'google_maps' AND x.status != 'rejected'
       AND CHAR_LENGTH(TRIM(x.original_text)) > 0 AND (${missingWhere})
     ORDER BY x.clinic_id, x.id`,
  )
  const [replies] = await db.query(
    `SELECT 'reply' AS kind, r.provider_review_id AS pid, x.original_language AS lang, x.original_text AS text, ${cols}
     FROM review_replies x JOIN reviews r ON r.id = x.review_id
     WHERE x.provider = 'google_maps' AND r.provider = 'google_maps' AND r.status != 'rejected'
       AND CHAR_LENGTH(TRIM(x.original_text)) > 0 AND (${missingWhere})
     ORDER BY r.clinic_id, r.id`,
  )
  await db.end()

  const items = [...reviews, ...replies].map((row) => ({
    key: `${row.kind === 'reply' ? 'p' : 'r'}:${row.pid}`,
    kind: row.kind,
    lang: row.lang,
    // Сербский оригинал кириллицей — повод заполнить sr_cyrl им самим, а sr
    // перевести; латиницей — наоборот. Это решает исполнитель по тексту.
    script: isCyrillic(row.text) ? 'cyrl' : 'latn',
    text: row.text,
    need: missing(row),
  }))

  fs.rmSync(path.join(DIR, 'todo'), { recursive: true, force: true })
  fs.mkdirSync(path.join(DIR, 'todo'), { recursive: true })
  fs.mkdirSync(path.join(DIR, 'done'), { recursive: true })
  let n = 0
  for (let i = 0; i < items.length; i += size) {
    n++
    const name = `batch-${String(n).padStart(3, '0')}.json`
    fs.writeFileSync(path.join(DIR, 'todo', name), `${JSON.stringify(items.slice(i, i + size), null, 2)}\n`)
  }
  const chars = items.reduce((s, i) => s + i.text.length, 0)
  console.log(`отзывов ${reviews.length}, ответов ${replies.length}, знаков ${chars}, пачек ${n} по ${size}`)
}

function status() {
  const todo = fs.readdirSync(path.join(DIR, 'todo')).filter((f) => f.endsWith('.json'))
  const done = new Set(fs.readdirSync(path.join(DIR, 'done')).filter((f) => f.endsWith('.json')))
  const left = todo.filter((f) => !done.has(f))
  console.log(`пачек ${todo.length}, переведено ${todo.length - left.length}, осталось ${left.length}`)
  if (left.length) console.log(`первые оставшиеся: ${left.slice(0, 10).join(' ')}`)
}

function sql() {
  const out = path.resolve(ROOT, arg('--out'))
  const esc = (s) => s.replace(/\\/g, '\\\\').replace(/'/g, "\\'")
  const lines = [
    '-- Переводы отзывов Google и ответов владельцев (scripts/reviews/review-translations.mjs).',
    '-- COALESCE: уже переведённое не перезаписывается; повторное применение безопасно.',
    '',
    'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;',
    '',
  ]
  const problems = []
  let count = 0
  for (const name of fs.readdirSync(path.join(DIR, 'done')).sort()) {
    if (!name.endsWith('.json')) continue
    const todo = JSON.parse(fs.readFileSync(path.join(DIR, 'todo', name), 'utf8'))
    const done = JSON.parse(fs.readFileSync(path.join(DIR, 'done', name), 'utf8'))
    for (const item of todo) {
      const tr = done[item.key]
      if (!tr) { problems.push(`${name}: нет ${item.key}`); continue }
      const sets = item.need
        .filter((lang) => {
          const ok = typeof tr[lang] === 'string' && tr[lang].trim()
          if (!ok) problems.push(`${name}: ${item.key} без ${lang}`)
          return ok
        })
        .map((lang) => `text_${lang} = COALESCE(text_${lang}, '${esc(tr[lang].trim())}')`)
      if (!sets.length) continue
      const pid = esc(item.key.slice(2))
      lines.push(
        item.kind === 'reply'
          ? `UPDATE review_replies SET ${sets.join(', ')} WHERE provider = 'google_maps' AND review_id = (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = '${pid}');`
          : `UPDATE reviews SET ${sets.join(', ')} WHERE provider = 'google_maps' AND provider_review_id = '${pid}';`,
      )
      count++
    }
  }
  fs.writeFileSync(out, `${lines.join('\n')}\n`)
  console.log(`строк: ${count} → ${path.relative(ROOT, out)}`)
  if (problems.length) {
    console.log(`замечаний ${problems.length}:`)
    for (const p of problems.slice(0, 30)) console.log(`  ${p}`)
  }
}

if (command === 'extract') await extract()
else if (command === 'status') status()
else if (command === 'sql') sql()
else {
  console.error('команда: extract | status | sql')
  process.exit(2)
}
