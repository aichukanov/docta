/**
 * Generate SQL for importing reviews from Telegram channel exports.
 *
 * Reads review translation files from data/review-translations/<slug>/
 * and generates SQL for the `reviews` table with provider='telegram'.
 *
 * Usage:
 *   node scripts/generate-telegram-reviews-sql.mjs data/review-import-configs/telegram-medicina-cg.json
 */

import { readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------

const args = process.argv.slice(2)
const configPath = args.find(a => !a.startsWith('--'))

if (!configPath) {
  console.error('Usage: node scripts/generate-telegram-reviews-sql.mjs <config.json>')
  process.exit(1)
}

const config = JSON.parse(readFileSync(resolve(ROOT, configPath), 'utf-8'))
const TRANSLATIONS_DIR = resolve(ROOT, config.translationsDir)
const OUTPUT = resolve(ROOT, config.outputPath)
const CHANNEL_ID = config.channelId
const CHANNEL_NAME = config.channelName || 'Telegram Channel'

// ---------------------------------------------------------------------------
// Load review translations
// ---------------------------------------------------------------------------

if (!existsSync(TRANSLATIONS_DIR)) {
  console.error(`Translations dir not found: ${TRANSLATIONS_DIR}`)
  process.exit(1)
}

const reviewFiles = readdirSync(TRANSLATIONS_DIR)
  .filter(f => f.startsWith('review-') && f.endsWith('.json'))
  .sort()

if (reviewFiles.length === 0) {
  console.error('No review files found in', TRANSLATIONS_DIR)
  process.exit(1)
}

const reviews = reviewFiles.map(f =>
  JSON.parse(readFileSync(resolve(TRANSLATIONS_DIR, f), 'utf-8'))
)

console.log(`Loaded ${reviews.length} reviews from ${TRANSLATIONS_DIR}`)

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function escapeSQL(str) {
  if (str == null) return 'NULL'
  return "'" + String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n') + "'"
}

// ---------------------------------------------------------------------------
// Generate SQL
// ---------------------------------------------------------------------------

const lines = []

lines.push(`-- Telegram reviews import: ${CHANNEL_NAME}`)
lines.push(`-- Generated: ${new Date().toISOString()}`)
lines.push(`-- Source: ${configPath}`)
lines.push(`-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < ${config.outputPath}`)
lines.push('')
lines.push('SET NAMES utf8mb4;')
lines.push('')

// ======================== PART 1: Phantom Users ========================

lines.push('-- =====================================================')
lines.push('-- PART 1: Phantom users')
lines.push('-- =====================================================')
lines.push('')

// Collect unique users
const usersMap = new Map()
for (const r of reviews) {
  if (r.telegramUserId && !usersMap.has(r.telegramUserId)) {
    usersMap.set(r.telegramUserId, r.userName || 'Unknown')
  }
}

for (const [telegramId, name] of usersMap) {
  const varName = `@tg_user_${telegramId}`

  lines.push(`-- User: ${name} (telegram:${telegramId})`)
  lines.push(`SET ${varName} = (`)
  lines.push(`  SELECT au.id FROM auth_users au`)
  lines.push(`  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id`)
  lines.push(`  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '${telegramId}'`)
  lines.push(`  LIMIT 1`)
  lines.push(`);`)
  lines.push('')
  lines.push(`INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)`)
  lines.push(`SELECT ${escapeSQL(name)}, TRUE, 'telegram', NOW()`)
  lines.push(`FROM DUAL WHERE ${varName} IS NULL;`)
  lines.push(`SET ${varName} = COALESCE(${varName}, LAST_INSERT_ID());`)
  lines.push('')
  lines.push(`INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)`)
  lines.push(`VALUES (${varName}, 'telegram', '${telegramId}', NOW());`)
  lines.push('')
  lines.push(`INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)`)
  lines.push(`SELECT id, ${telegramId}, ${escapeSQL(name)}, NOW()`)
  lines.push(`FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '${telegramId}';`)
  lines.push('')
}

// ======================== PART 2: Reviews ========================

lines.push('-- =====================================================')
lines.push('-- PART 2: Reviews')
lines.push('-- =====================================================')
lines.push('')

for (const r of reviews) {
  if (r._note) {
    lines.push(`-- NOTE: ${r._note}`)
  }

  // Skip reviews without doctor/clinic link and without explicit link
  const clinicId = r.clinicId || null
  const doctorId = r.doctorId || null

  if (!clinicId && !doctorId) {
    lines.push(`-- SKIPPED: review ${r.id} (${r.userName}) — no clinic_id or doctor_id mapped`)
    lines.push(`-- Text: ${(r.text || '').substring(0, 100)}...`)
    lines.push('')
    continue
  }

  const userVar = `@tg_user_${r.telegramUserId}`
  const providerReviewId = `tg_${CHANNEL_ID}_${r.providerMessageId}`
  const t = r.translations || {}

  lines.push(`-- Review by ${r.userName} (${r.date})`)
  lines.push(`INSERT INTO reviews (`)
  lines.push(`  user_id, clinic_id, doctor_id,`)
  lines.push(`  provider, provider_review_id,`)
  lines.push(`  rating, original_language, original_text,`)
  lines.push(`  text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr,`)
  lines.push(`  published_at`)
  lines.push(`) VALUES (`)
  lines.push(`  ${userVar}, ${clinicId || 'NULL'}, ${doctorId || 'NULL'},`)
  lines.push(`  'telegram', ${escapeSQL(providerReviewId)},`)
  lines.push(`  ${r.rating || 'NULL'}, ${escapeSQL(r.original_language || 'ru')}, ${escapeSQL(r.text)},`)
  lines.push(`  ${escapeSQL(t.sr || null)}, ${escapeSQL(t.sr_cyrl || null)}, ${escapeSQL(t.en || null)}, ${escapeSQL(t.ru || null)}, ${escapeSQL(t.de || null)}, ${escapeSQL(t.tr || null)},`)
  lines.push(`  ${escapeSQL(r.date)}`)
  lines.push(`)`)
  lines.push(`ON DUPLICATE KEY UPDATE`)
  lines.push(`  original_text = VALUES(original_text),`)
  lines.push(`  text_sr = VALUES(text_sr), text_sr_cyrl = VALUES(text_sr_cyrl),`)
  lines.push(`  text_en = VALUES(text_en), text_ru = VALUES(text_ru),`)
  lines.push(`  text_de = VALUES(text_de), text_tr = VALUES(text_tr);`)
  lines.push('')
}

// ======================== PART 3: Validation ========================

lines.push('-- =====================================================')
lines.push('-- PART 3: Validation')
lines.push('-- =====================================================')
lines.push('')
lines.push(`SELECT 'telegram_reviews' AS source, COUNT(*) AS cnt FROM reviews WHERE provider = 'telegram';`)

// ---------------------------------------------------------------------------
// Write output
// ---------------------------------------------------------------------------

writeFileSync(OUTPUT, lines.join('\n') + '\n', 'utf-8')

const linked = reviews.filter(r => r.clinicId || r.doctorId).length
const skipped = reviews.filter(r => !r.clinicId && !r.doctorId).length

console.log(`\nOutput: ${OUTPUT}`)
console.log(`Reviews: ${reviews.length} total, ${linked} linked (with clinic/doctor), ${skipped} skipped (no mapping)`)
console.log(`Users: ${usersMap.size}`)
console.log('\nTo run:')
console.log(`mysql -u root -p --default-character-set=utf8mb4 docta_me < ${OUTPUT.replace(/\\/g, '/')}`)
