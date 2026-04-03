/**
 * Universal generator: Google Maps reviews JSON → SQL import script.
 *
 * Usage:
 *   # Full pipeline (with API key for translations):
 *   node scripts/generate-reviews-sql.mjs <config.json>
 *
 *   # Two-pass mode (without API key):
 *   node scripts/generate-reviews-sql.mjs <config.json> --extract
 *   # → creates <slug>-texts.json — give it to Claude for translation
 *   node scripts/generate-reviews-sql.mjs <config.json> --translations <translations.json>
 *   # → generates SQL with translations included
 *
 * See docs/import/REVIEWS_IMPORT.md for full docs.
 */

import { readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

// ---------------------------------------------------------------------------
// Load .env
// ---------------------------------------------------------------------------
const envPath = resolve(ROOT, '.env')
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
    const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/)
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, '')
  }
}

const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY || ''

// ---------------------------------------------------------------------------
// Parse CLI args
// ---------------------------------------------------------------------------

const args = process.argv.slice(2)
const configPath = args.find(a => !a.startsWith('--'))
const extractMode = args.includes('--extract')
const translationsArg = args.indexOf('--translations')
const translationsPath = translationsArg >= 0 ? args[translationsArg + 1] : null

if (!configPath) {
  console.error(`Usage:
  node scripts/generate-reviews-sql.mjs <config.json>
  node scripts/generate-reviews-sql.mjs <config.json> --extract
  node scripts/generate-reviews-sql.mjs <config.json> --translations <file.json>`)
  process.exit(1)
}

const config = JSON.parse(readFileSync(resolve(ROOT, configPath), 'utf-8'))

const INPUT = resolve(ROOT, config.jsonPath)
const OUTPUT = resolve(ROOT, config.outputPath)
const CLINIC_ID = config.clinicId
const CLINIC_NAME = config.clinicName || `Clinic ${CLINIC_ID}`
const DOCTORS = config.doctors || []
const CHILD_DENTIST_VAR = config.childDentistDoctorVar || null

const data = JSON.parse(readFileSync(INPUT, 'utf-8'))
const PLACE_ID = data.id
const reviews = data.reviews

if (!reviews || !reviews.length) { console.error('No reviews found in', INPUT); process.exit(1) }

// ---------------------------------------------------------------------------
// Relative date parsing ("3 недели назад", "пре 2 месеца", etc.)
// ---------------------------------------------------------------------------

const DATA_COLLECTED_DATE = config.dataCollectedDate || '2026-03-18'

function parseRelativeDate(desc, baseDate) {
  if (!desc) return null
  const base = new Date(baseDate + 'T12:00:00Z')
  const cleaned = desc.replace(/^Изменено\s+/i, '').replace(/^Измењено\s+/i, '').trim()

  // Russian: "3 недели назад", "2 месяца назад", "год назад", "5 дней назад"
  // Serbian: "пре 2 недеље", "пре 3 месеца", "пре годину дана"
  // English: "2 weeks ago", "3 months ago", "a year ago"
  let num, unit

  // Russian / Serbian patterns
  let m
  if ((m = cleaned.match(/(\d+)\s*(недел[яиьею]|недеље|nedelj[aeu]|week)/i))) {
    num = parseInt(m[1]); unit = 'weeks'
  } else if ((m = cleaned.match(/(\d+)\s*(месяц[аевой]?|месец[аи]?|mesec[aiu]?|month)/i))) {
    num = parseInt(m[1]); unit = 'months'
  } else if ((m = cleaned.match(/(\d+)\s*(год[ауе]?|лет|годин[аеу]?|year)/i))) {
    num = parseInt(m[1]); unit = 'years'
  } else if ((m = cleaned.match(/(\d+)\s*(дн[яейю]|дней|дан[аи]?|day)/i))) {
    num = parseInt(m[1]); unit = 'days'
  } else if (/год\s+назад|годину\s+дана|a\s+year\s+ago/i.test(cleaned)) {
    num = 1; unit = 'years'
  } else if (/месяц\s+назад|месец\s+дана|a\s+month\s+ago/i.test(cleaned)) {
    num = 1; unit = 'months'
  } else if (/недел[юя]\s+назад|недељ[уа]\s+дана|a\s+week\s+ago/i.test(cleaned)) {
    num = 1; unit = 'weeks'
  }

  if (!num || !unit) return null

  const result = new Date(base)
  if (unit === 'days') result.setUTCDate(result.getUTCDate() - num)
  else if (unit === 'weeks') result.setUTCDate(result.getUTCDate() - num * 7)
  else if (unit === 'months') result.setUTCMonth(result.getUTCMonth() - num)
  else if (unit === 'years') result.setUTCFullYear(result.getUTCFullYear() - num)

  return result.toISOString().replace('T12:00:00.000Z', 'T00:00:00Z')
}

// ---------------------------------------------------------------------------
// Serbian transliteration (Cyrillic → Latin)
// ---------------------------------------------------------------------------

const serbCyrToLat = {
  'Њ': 'Nj', 'њ': 'nj', 'Љ': 'Lj', 'љ': 'lj', 'Џ': 'Dž', 'џ': 'dž',
  'А': 'A', 'а': 'a', 'Б': 'B', 'б': 'b', 'В': 'V', 'в': 'v',
  'Г': 'G', 'г': 'g', 'Д': 'D', 'д': 'd', 'Ђ': 'Đ', 'ђ': 'đ',
  'Е': 'E', 'е': 'e', 'Ж': 'Ž', 'ж': 'ž', 'З': 'Z', 'з': 'z',
  'И': 'I', 'и': 'i', 'Ј': 'J', 'ј': 'j', 'К': 'K', 'к': 'k',
  'Л': 'L', 'л': 'l', 'М': 'M', 'м': 'm', 'Н': 'N', 'н': 'n',
  'О': 'O', 'о': 'o', 'П': 'P', 'п': 'p', 'Р': 'R', 'р': 'r',
  'С': 'S', 'с': 's', 'Т': 'T', 'т': 't', 'Ћ': 'Ć', 'ћ': 'ć',
  'У': 'U', 'у': 'u', 'Ф': 'F', 'ф': 'f', 'Х': 'H', 'х': 'h',
  'Ц': 'C', 'ц': 'c', 'Ч': 'Č', 'ч': 'č', 'Ш': 'Š', 'ш': 'š',
}

function serbianCyrillicToLatin(text) {
  if (!text) return null
  return text.split('').map(ch => serbCyrToLat[ch] || ch).join('')
}

// ---------------------------------------------------------------------------
// Translation via Anthropic API
// ---------------------------------------------------------------------------

const TARGET_LANGS = ['sr', 'sr_cyrl', 'en', 'ru', 'de', 'tr']
const LANG_NAMES = {
  sr: 'Serbian (Latin script, with diacritics č ć ž š đ)',
  sr_cyrl: 'Serbian (Cyrillic script)',
  en: 'English',
  ru: 'Russian',
  de: 'German',
  tr: 'Turkish',
}

async function translateBatch(texts, batchLabel) {
  if (!texts.length) return []

  const numbered = texts.map((t, i) => `[${i}] ${t}`).join('\n---\n')
  const langList = TARGET_LANGS.map(l => `${l}: ${LANG_NAMES[l]}`).join('\n')

  const prompt = `Translate each numbered review/reply text below into these languages:
${langList}

RULES:
- Keep the original tone and style (informal reviews, emojis OK)
- Serbian Latin (sr) must use proper Serbian Latin alphabet with diacritics: č, ć, ž, š, đ
- Serbian Cyrillic (sr_cyrl) must use Serbian Cyrillic alphabet
- If a text is empty, return empty strings for all languages
- Do NOT add any commentary or explanation

Return ONLY a JSON array where each element corresponds to a numbered input:
[{"sr":"...","sr_cyrl":"...","en":"...","ru":"...","de":"...","tr":"..."}, ...]

TEXTS:
${numbered}`

  const resp = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-haiku-4-5-20251001',
      max_tokens: 16000,
      messages: [{ role: 'user', content: prompt }],
    }),
  })

  if (!resp.ok) {
    const err = await resp.text()
    throw new Error(`Anthropic API error ${resp.status}: ${err}`)
  }

  const body = await resp.json()
  const content = body.content[0].text
  const jsonMatch = content.match(/\[[\s\S]*\]/)
  if (!jsonMatch) throw new Error(`Failed to parse translation response for ${batchLabel}`)

  const parsed = JSON.parse(jsonMatch[0])
  if (parsed.length !== texts.length) {
    throw new Error(`Translation count mismatch for ${batchLabel}: got ${parsed.length}, expected ${texts.length}`)
  }
  return parsed
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function escapeSQL(str) {
  if (str == null) return null
  return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'")
}

function extractReviewId(name) { return name.split('/').pop() }

function buildProviderReviewId(reviewId) { return `places/${PLACE_ID}/reviews/${reviewId}` }

function normalizeProfileUrl(uri) {
  if (!uri) return null
  try { return new URL(uri).origin + new URL(uri).pathname } catch { return uri }
}

function extractContributorId(uri) {
  const m = uri?.match(/\/maps\/contrib\/(\d+)/)
  return m ? m[1] : null
}

const nameTranslitMap = {
  'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo',
  'Ж': 'Zh', 'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M',
  'Н': 'N', 'О': 'O', 'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U',
  'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts', 'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Shch',
  'Ъ': '', 'Ы': 'Y', 'Ь': '', 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya',
  'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo',
  'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm',
  'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
  'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'shch',
  'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya',
  'і': 'i', 'ї': 'yi', 'є': 'ye', 'ґ': 'g',
  'І': 'I', 'Ї': 'Yi', 'Є': 'Ye', 'Ґ': 'G',
  'Ђ': 'Dj', 'ђ': 'dj', 'Ј': 'J', 'ј': 'j', 'Љ': 'Lj', 'љ': 'lj',
  'Њ': 'Nj', 'њ': 'nj', 'Ћ': 'C', 'ћ': 'c', 'Џ': 'Dz', 'џ': 'dz',
}

function makeVarName(displayName, contributorId) {
  let latin = ''
  for (const ch of displayName) latin += nameTranslitMap[ch] ?? ch
  let safe = latin.replace(/[^a-zA-Z0-9\s]/g, '').trim().replace(/\s+/g, '_').toLowerCase()
  if (!safe || safe.length < 2) safe = 'user_' + (contributorId || 'unknown')
  return safe
}

const doctorPatterns = DOCTORS.map(d => ({
  varName: d.varName,
  regexps: d.patterns.map(p => new RegExp(p, 'i')),
}))

function detectDoctor(text) {
  if (!text) return null
  const matched = new Set()
  for (const doc of doctorPatterns) {
    for (const rx of doc.regexps) { if (rx.test(text)) { matched.add(doc.varName); break } }
  }
  if (matched.size > 1) return null
  if (matched.size === 1) return `@doctor_${[...matched][0]}`
  if (CHILD_DENTIST_VAR && (/детск(?:ий|ого|ому|ая|ой)\s+(?:стоматолог|врач)/i.test(text) ||
      /ребенк/i.test(text) || /ребёнк/i.test(text))) return `@doctor_${CHILD_DENTIST_VAR}`
  return null
}

// ---------------------------------------------------------------------------
// Step 1: Merge reviews
// ---------------------------------------------------------------------------

const reviewMap = new Map()

for (const r of reviews) {
  const reviewId = extractReviewId(r.name)
  const isApi = r.name.startsWith('places/')
  const isHtml = r._source === 'html_markup'

  if (!reviewMap.has(reviewId)) reviewMap.set(reviewId, { reviewId, api: null, html: null })
  const entry = reviewMap.get(reviewId)
  if (isApi && !isHtml) entry.api = r
  else if (isHtml && isApi) { if (!entry.api) entry.api = r; else entry.html = r }
  else if (isHtml) entry.html = r
  else entry.api = r
}

const mergedReviews = []

for (const [reviewId, entry] of reviewMap) {
  const api = entry.api, html = entry.html, primary = api || html
  const rating = primary.rating
  if (rating == null) continue

  const publishTime = api?.publishTime || html?.publishTime
    || parseRelativeDate(api?.relativePublishTimeDescription || html?.relativePublishTimeDescription, DATA_COLLECTED_DATE)
    || null
  const authorApi = api?.authorAttribution, authorHtml = html?.authorAttribution
  const author = authorApi || authorHtml

  let originalText = '', originalLanguage = ''
  if (api?.originalText?.text) { originalText = api.originalText.text; originalLanguage = api.originalText.languageCode || '' }
  else if (html?.originalText?.text) { originalText = html.originalText.text; originalLanguage = html.originalText.languageCode || '' }
  if (!originalText && html?.text?.text) { originalText = html.text.text; originalLanguage = html.text.languageCode || '' }
  if (!originalLanguage) originalLanguage = 'ru'

  let textSrCyrl = null
  if (api?.text?.text && api.text.languageCode === 'sr' && api.text.text.trim()) textSrCyrl = api.text.text

  if (!publishTime && !originalText && !rating) continue

  mergedReviews.push({
    reviewId, providerReviewId: buildProviderReviewId(reviewId),
    rating, publishTime,
    displayName: author?.displayName || 'Unknown',
    photoUri: authorApi?.photoUri || authorHtml?.photoUri || null,
    profileUrl: normalizeProfileUrl(authorApi?.uri || authorHtml?.uri),
    contributorId: extractContributorId(author?.uri),
    originalText, originalLanguage, textSrCyrl,
    likesCount: html?.likesCount ?? api?.likesCount ?? 0,
    ownerReply: html?.ownerResponse?.text || api?._ownerReply || api?.ownerResponse?.text || null,
    ownerReplyLanguage: html?.ownerResponse?.languageCode || api?.ownerResponse?.languageCode || 'sr',
    ownerReplyPublishTime: parseRelativeDate(
      html?.ownerResponse?.relativePublishTimeDescription || api?.ownerResponse?.relativePublishTimeDescription,
      DATA_COLLECTED_DATE
    ) || null,
    doctorId: detectDoctor(originalText || ''),
    // Translations
    text_sr: null, text_sr_cyrl: null, text_en: null, text_ru: null, text_de: null, text_tr: null,
    replyTranslations: null,
  })
}

// ---------------------------------------------------------------------------
// Step 2: Handle translations
// ---------------------------------------------------------------------------

// Fill obvious fields (always, regardless of mode)
for (const r of mergedReviews) {
  if (r.originalLanguage === 'ru') r.text_ru = r.originalText
  if (r.originalLanguage === 'en') r.text_en = r.originalText
  if (r.originalLanguage === 'sr' || r.originalLanguage === 'bs' || r.originalLanguage === 'hr') r.text_sr = r.originalText
  if (r.originalLanguage === 'de') r.text_de = r.originalText
  if (r.originalLanguage === 'tr') r.text_tr = r.originalText
  if (r.textSrCyrl) {
    r.text_sr_cyrl = r.textSrCyrl
    r.text_sr = serbianCyrillicToLatin(r.textSrCyrl)
  }
}

// --- EXTRACT MODE ---
if (extractMode) {
  const slug = config.outputPath.replace(/.*\//, '').replace(/\.sql$/, '')
  const extractPath = resolve(ROOT, `data/review-translations/${slug}-texts.json`)

  const textsToTranslate = {
    _instructions: 'Translate each text into: sr (Serbian Latin with čćžšđ), sr_cyrl (Serbian Cyrillic), en (English), ru (Russian), de (German), tr (Turkish). Return same structure with translations filled in.',
    reviews: mergedReviews
      .filter(r => r.originalText?.trim())
      .map(r => ({
        id: r.reviewId,
        original_language: r.originalLanguage,
        text: r.originalText,
        translations: { sr: '', sr_cyrl: '', en: '', ru: '', de: '', tr: '' },
      })),
    replies: mergedReviews
      .filter(r => r.ownerReply?.trim())
      .map(r => ({
        review_id: r.reviewId,
        original_language: r.ownerReplyLanguage,
        text: r.ownerReply,
        translations: { sr: '', sr_cyrl: '', en: '', ru: '', de: '', tr: '' },
      })),
  }

  writeFileSync(extractPath, JSON.stringify(textsToTranslate, null, 2), 'utf-8')
  console.log(`✓ Extracted ${textsToTranslate.reviews.length} review texts + ${textsToTranslate.replies.length} reply texts`)
  console.log(`  → ${extractPath}`)
  console.log(`\nNext: translate this file (give to Claude), then run:`)
  console.log(`  node scripts/generate-reviews-sql.mjs ${configPath} --translations data/review-translations/${slug}-translations.json`)
  process.exit(0)
}

// --- LOAD EXTERNAL TRANSLATIONS ---
// Support: config.translationsDir (folder of per-review files), config.translations (embedded), --translations (separate file)
function loadTranslationsDir(dirPath) {
  const absDir = resolve(ROOT, dirPath)
  if (!existsSync(absDir)) return null
  const files = readdirSync(absDir).filter(f => f.endsWith('.json')).sort()
  if (!files.length) return null
  const reviews = [], replies = []
  for (const f of files) {
    const data = JSON.parse(readFileSync(resolve(absDir, f), 'utf-8'))
    if (data.type === 'reply') replies.push(data)
    else reviews.push(data)
  }
  console.log(`✓ Loaded ${reviews.length} review files + ${replies.length} reply files from ${dirPath}`)
  return { reviews, replies }
}

const tData = config.translationsDir
  ? loadTranslationsDir(config.translationsDir)
  : config.translations
    ? config.translations
    : translationsPath
      ? JSON.parse(readFileSync(resolve(ROOT, translationsPath), 'utf-8'))
      : null

if (tData) {

  const reviewTransMap = new Map()
  for (const rt of (tData.reviews || [])) reviewTransMap.set(rt.id, rt.translations)

  const replyTransMap = new Map()
  for (const rt of (tData.replies || [])) replyTransMap.set(rt.review_id, rt.translations)

  for (const r of mergedReviews) {
    const t = reviewTransMap.get(r.reviewId)
    if (t) {
      r.text_sr = r.text_sr || t.sr || null
      r.text_sr_cyrl = r.text_sr_cyrl || t.sr_cyrl || null
      r.text_en = r.text_en || t.en || null
      r.text_ru = r.text_ru || t.ru || null
      r.text_de = r.text_de || t.de || null
      r.text_tr = r.text_tr || t.tr || null
    }

    if (r.ownerReply) {
      const rt = replyTransMap.get(r.reviewId)
      if (rt) r.replyTranslations = rt
    }
  }

  console.log(`✓ Loaded translations: ${reviewTransMap.size} reviews, ${replyTransMap.size} replies`)
}

// Fill obvious reply language fields (same logic as reviews)
for (const r of mergedReviews) {
  if (!r.ownerReply) continue
  if (!r.replyTranslations) r.replyTranslations = {}
  const t = r.replyTranslations, lang = r.ownerReplyLanguage
  if (lang === 'ru' && !t.ru) t.ru = r.ownerReply
  if (lang === 'en' && !t.en) t.en = r.ownerReply
  if ((lang === 'sr' || lang === 'bs' || lang === 'hr') && !t.sr) t.sr = r.ownerReply
  if (lang === 'de' && !t.de) t.de = r.ownerReply
  if (lang === 'tr' && !t.tr) t.tr = r.ownerReply
}

// --- API TRANSLATIONS ---
if (!tData && ANTHROPIC_API_KEY) {
  const toTranslate = mergedReviews.filter(r => r.originalText?.trim())
  const BATCH_SIZE = 20

  for (let i = 0; i < toTranslate.length; i += BATCH_SIZE) {
    const batch = toTranslate.slice(i, i + BATCH_SIZE)
    const batchNum = Math.floor(i / BATCH_SIZE) + 1
    const totalBatches = Math.ceil(toTranslate.length / BATCH_SIZE)
    process.stdout.write(`  Translating reviews ${batchNum}/${totalBatches}...`)
    try {
      const translations = await translateBatch(batch.map(r => r.originalText), `reviews ${i}`)
      for (let j = 0; j < batch.length; j++) {
        const r = batch[j], t = translations[j]
        r.text_sr = r.text_sr || t.sr || serbianCyrillicToLatin(t.sr_cyrl) || null
        r.text_sr_cyrl = r.text_sr_cyrl || t.sr_cyrl || null
        r.text_en = r.text_en || t.en || null
        r.text_ru = r.text_ru || t.ru || null
        r.text_de = r.text_de || t.de || null
        r.text_tr = r.text_tr || t.tr || null
      }
      console.log(' ✓')
    } catch (err) { console.log(` ✗ ${err.message}`) }
  }

  const repliesWithText = mergedReviews.filter(r => r.ownerReply?.trim())
  for (let i = 0; i < repliesWithText.length; i += BATCH_SIZE) {
    const batch = repliesWithText.slice(i, i + BATCH_SIZE)
    const batchNum = Math.floor(i / BATCH_SIZE) + 1
    const totalBatches = Math.ceil(repliesWithText.length / BATCH_SIZE)
    process.stdout.write(`  Translating replies ${batchNum}/${totalBatches}...`)
    try {
      const translations = await translateBatch(batch.map(r => r.ownerReply), `replies ${i}`)
      for (let j = 0; j < batch.length; j++) batch[j].replyTranslations = translations[j]
      console.log(' ✓')
    } catch (err) { console.log(` ✗ ${err.message}`) }
  }
}

if (!translationsPath && !ANTHROPIC_API_KEY && !extractMode) {
  console.warn('⚠ No translations (no API key, no --translations file). Use --extract for two-pass mode.')
}

// ---------------------------------------------------------------------------
// Step 3: Users
// ---------------------------------------------------------------------------

const usersMap = new Map()
const userVarNames = new Map()
const usedVarNames = new Set()

for (const r of mergedReviews) {
  if (!r.profileUrl || usersMap.has(r.profileUrl)) continue
  usersMap.set(r.profileUrl, { displayName: r.displayName, photoUri: r.photoUri, profileUrl: r.profileUrl, contributorId: r.contributorId })
  let varName = makeVarName(r.displayName, r.contributorId), base = varName, idx = 2
  while (usedVarNames.has(varName)) varName = base + '_' + idx++
  usedVarNames.add(varName)
  userVarNames.set(r.profileUrl, varName)
}

// ---------------------------------------------------------------------------
// Step 4: Generate SQL
// ---------------------------------------------------------------------------

function sqlStr(val) { return val ? `'${escapeSQL(val)}'` : 'NULL' }

const lines = []
lines.push(`-- Insert Google Maps reviews for ${CLINIC_NAME}`)
lines.push(`-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < ${config.outputPath}`)
lines.push('')
lines.push('SET NAMES utf8mb4;')
lines.push('SET CHARACTER SET utf8mb4;')
lines.push('')

// PART 0
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('-- PART 0: Clinic and doctor IDs')
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('')
lines.push(`SET @clinic_id = ${CLINIC_ID};`)
for (const d of DOCTORS) lines.push(`SET @doctor_${d.varName} = ${d.id};`)
lines.push('')

// PART 1: Users
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('-- PART 1: Create phantom users + set user_id variables')
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('')

for (const u of usersMap.values()) {
  const varName = userVarNames.get(u.profileUrl)
  const profile = escapeSQL(u.profileUrl)
  lines.push(`INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)`)
  lines.push(`SELECT NULL, '${escapeSQL(u.displayName)}', ${u.photoUri ? `'${escapeSQL(u.photoUri)}'` : 'NULL'}, '${profile}', TRUE`)
  lines.push(`FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = '${profile}');`)
  lines.push(`SET @user_${varName} = (SELECT id FROM auth_users WHERE profile_url = '${profile}');`)
  lines.push('')
}

// PART 2: Reviews
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('-- PART 2: Insert reviews')
lines.push('-- ═══════════════════════════════════════════════════════════════')
lines.push('')

const reviewCols = 'user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at'

const reviewValues = mergedReviews.map(r => {
  const userVar = r.profileUrl ? `@user_${userVarNames.get(r.profileUrl)}` : 'NULL'
  const publishedAt = r.publishTime ? `'${r.publishTime.replace('T', ' ').replace(/\.\d+Z$/, '').replace('Z', '')}'` : 'NULL'

  return `(${userVar}, @clinic_id, ${r.doctorId || 'NULL'}, 'google_maps',
    ${sqlStr(r.providerReviewId)},
    ${r.rating}, ${sqlStr(r.originalLanguage)}, ${sqlStr(r.originalText)},
    ${sqlStr(r.text_sr)}, ${sqlStr(r.text_sr_cyrl)}, ${sqlStr(r.text_en)}, ${sqlStr(r.text_ru)}, ${sqlStr(r.text_de)}, ${sqlStr(r.text_tr)},
    ${r.likesCount || 0}, ${publishedAt})`
})

lines.push(`INSERT INTO reviews (${reviewCols}) VALUES`)
lines.push(reviewValues.join(',\n\n'))
lines.push(`ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);`)
lines.push('')

// PART 3: Replies
const repliedReviews = mergedReviews.filter(r => r.ownerReply)
if (repliedReviews.length > 0) {
  lines.push('-- ═══════════════════════════════════════════════════════════════')
  lines.push('-- PART 3: Insert review replies (owner responses)')
  lines.push('-- ═══════════════════════════════════════════════════════════════')
  lines.push('')

  for (const r of repliedReviews) {
    const t = r.replyTranslations || {}
    const pid = escapeSQL(r.providerReviewId)
    lines.push(`INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)`)
    lines.push(`VALUES (`)
    lines.push(`  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = '${pid}'),`)
    lines.push(`  'clinic', @clinic_id,`)
    lines.push(`  ${sqlStr(r.ownerReply)}, ${sqlStr(r.ownerReplyLanguage)},`)
    lines.push(`  ${sqlStr(t.sr)}, ${sqlStr(t.sr_cyrl)}, ${sqlStr(t.en)}, ${sqlStr(t.ru)}, ${sqlStr(t.de)}, ${sqlStr(t.tr)},`)
    const replyPublishedAt = r.ownerReplyPublishTime ? `'${r.ownerReplyPublishTime.replace('T', ' ').replace(/\.\d+Z$/, '').replace('Z', '')}'` : 'NULL'
    lines.push(`  'google_maps', ${replyPublishedAt})`)
    lines.push(`ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);`)
    lines.push('')
  }
}

writeFileSync(OUTPUT, lines.join('\n'), 'utf-8')

// Stats
const doctorStats = {}
for (const d of DOCTORS) doctorStats[d.varName] = 0
let clinicOnly = 0
for (const r of mergedReviews) {
  if (r.doctorId) { doctorStats[r.doctorId.replace('@doctor_', '')] = (doctorStats[r.doctorId.replace('@doctor_', '')] || 0) + 1 }
  else clinicOnly++
}

console.log(`✓ Generated: ${OUTPUT}`)
console.log(`  Reviews: ${mergedReviews.length} (deduplicated from ${reviews.length} entries)`)
console.log(`  Users: ${usersMap.size}`)
console.log(`  Replies: ${repliedReviews.length}`)
console.log(`  Translations: ${mergedReviews.some(r => r.text_en) ? 'yes' : 'no'}`)
for (const d of DOCTORS) console.log(`  Doctor ${d.varName} (id=${d.id}): ${doctorStats[d.varName]} reviews`)
console.log(`  Clinic only: ${clinicOnly} reviews`)
