/**
 * Generate SQL from compiled & translated Q&A and article files.
 *
 * Reads:
 *   data/kb/parsed/*.json   — messages & users (for phantom user creation + message import)
 *   data/kb/qa/*.json        — compiled Q&A with translations
 *   data/kb/articles/*.json  — compiled articles with translations
 *
 * Output:
 *   server/sql/insert-kb.sql
 *
 * Usage:
 *   node scripts/kb-generate-sql.mjs
 */

import { readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function escapeSQL(str) {
  if (str == null) return 'NULL'
  return "'" + String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n') + "'"
}

function slugify(str) {
  return str
    .toLowerCase()
    .replace(/[а-яё]/g, c => {
      const map = {
        'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo',
        'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'j', 'к': 'k', 'л': 'l', 'м': 'm',
        'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
        'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh', 'щ': 'sch',
        'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'
      }
      return map[c] || c
    })
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .substring(0, 200)
}

// ---------------------------------------------------------------------------
// Load data
// ---------------------------------------------------------------------------

function collectJsonFiles(dir) {
  if (!existsSync(dir)) return []
  return readdirSync(dir)
    .filter(f => f.endsWith('.json'))
    .sort()
    .map(f => JSON.parse(readFileSync(resolve(dir, f), 'utf-8')))
}

const parsedFiles = collectJsonFiles(resolve(ROOT, 'data/kb/parsed'))
const qaFiles = collectJsonFiles(resolve(ROOT, 'data/kb/qa'))
const articleFiles = collectJsonFiles(resolve(ROOT, 'data/kb/articles'))

console.log(`Loaded: ${parsedFiles.length} parsed channels, ${qaFiles.length} Q&A, ${articleFiles.length} articles`)

if (parsedFiles.length === 0) {
  console.error('No parsed files found. Run kb-parse-channel.mjs first.')
  process.exit(1)
}

// ---------------------------------------------------------------------------
// Build SQL
// ---------------------------------------------------------------------------

const lines = []

lines.push('-- Knowledge Base data import')
lines.push('-- Generated: ' + new Date().toISOString())
lines.push('-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-kb.sql')
lines.push('')
lines.push('SET NAMES utf8mb4;')
lines.push('SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;')
lines.push('')

// ======================== PART 1: Sources ========================

lines.push('-- =====================================================')
lines.push('-- PART 1: Sources (channels)')
lines.push('-- =====================================================')
lines.push('')

for (const parsed of parsedFiles) {
  const s = parsed.source
  lines.push(`INSERT INTO kb_sources (provider, provider_source_id, name, metadata)`)
  lines.push(`VALUES (${escapeSQL(s.provider)}, ${escapeSQL(s.providerId)}, ${escapeSQL(s.name)}, ${escapeSQL(JSON.stringify({ type: s.type }))})`)
  lines.push(`ON DUPLICATE KEY UPDATE name = VALUES(name), metadata = VALUES(metadata);`)
  lines.push('')
}

// ======================== PART 2: Phantom Users ========================

lines.push('-- =====================================================')
lines.push('-- PART 2: Phantom users from Telegram')
lines.push('-- =====================================================')
lines.push('')

// Collect all unique users across all parsed files
const allUsers = new Map() // telegramId → { name }
for (const parsed of parsedFiles) {
  for (const [telegramId, userData] of Object.entries(parsed.users)) {
    if (!allUsers.has(telegramId)) {
      allUsers.set(telegramId, userData)
    }
  }
}

for (const [telegramId, userData] of allUsers) {
  const name = userData.name || 'Unknown'
  const varName = `@tg_user_${telegramId}`

  lines.push(`-- User: ${name} (telegram:${telegramId})`)
  lines.push(`SET ${varName} = (`)
  lines.push(`  SELECT au.id FROM auth_users au`)
  lines.push(`  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id`)
  lines.push(`  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '${telegramId}'`)
  lines.push(`  LIMIT 1`)
  lines.push(`);`)
  lines.push(``)
  lines.push(`INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)`)
  lines.push(`SELECT ${escapeSQL(name)}, TRUE, 'telegram', NOW()`)
  lines.push(`FROM DUAL WHERE ${varName} IS NULL;`)
  lines.push(`SET ${varName} = COALESCE(${varName}, LAST_INSERT_ID());`)
  lines.push(``)
  lines.push(`INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)`)
  lines.push(`VALUES (${varName}, 'telegram', '${telegramId}', NOW());`)
  lines.push(``)
  lines.push(`INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)`)
  lines.push(`SELECT id, ${telegramId}, ${escapeSQL(name)}, NOW()`)
  lines.push(`FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '${telegramId}';`)
  lines.push(``)
}

// ======================== PART 3: Messages ========================

lines.push('-- =====================================================')
lines.push('-- PART 3: Messages')
lines.push('-- =====================================================')
lines.push('')

// First pass: insert all messages without reply_to_id (to avoid FK issues)
for (const parsed of parsedFiles) {
  const sourceId = `(SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '${parsed.source.providerId}')`

  // Collect all messages from threads + standalone
  const allMsgs = []
  for (const thread of parsed.threads) {
    allMsgs.push(...thread.messages)
  }
  allMsgs.push(...parsed.standalone)

  // Sort by id for consistent ordering
  allMsgs.sort((a, b) => a.id - b.id)

  lines.push(`-- Channel: ${parsed.source.name} (${allMsgs.length} messages)`)
  lines.push('')

  for (const msg of allMsgs) {
    const userVar = `@tg_user_${msg.telegramUserId}`

    lines.push(`INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)`)
    lines.push(`VALUES (${sourceId}, ${userVar}, '${msg.id}', ${escapeSQL(msg.type)}, ${escapeSQL(msg.text)}, 'ru', ${escapeSQL(msg.date)}, ${msg.hasMedia ? 1 : 0}, ${escapeSQL(msg.mediaType || null)})`)
    lines.push(`ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);`)
    lines.push('')
  }

  // Second pass: set reply_to_id
  lines.push('-- Set reply_to_id references')
  for (const msg of allMsgs) {
    if (msg.replyTo) {
      lines.push(`UPDATE kb_messages SET reply_to_id = (`)
      lines.push(`  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = ${sourceId} AND provider_message_id = '${msg.replyTo}') AS t`)
      lines.push(`) WHERE source_id = ${sourceId} AND provider_message_id = '${msg.id}' AND reply_to_id IS NULL;`)
    }
  }
  lines.push('')
}

// ======================== PART 4: Tags ========================

lines.push('-- =====================================================')
lines.push('-- PART 4: Tags')
lines.push('-- =====================================================')
lines.push('')

// Collect all unique tags from Q&A and articles
const allTags = new Set()
for (const qa of [...qaFiles, ...articleFiles]) {
  for (const tag of (qa.tags || [])) {
    allTags.add(tag)
  }
}

// Determine parent tags (tags with ":" prefix like "city:budva" → parent is "city")
const parentTags = new Set()
for (const tag of allTags) {
  const colon = tag.indexOf(':')
  if (colon > 0) {
    parentTags.add(tag.substring(0, colon))
  }
}

// Insert parent tags first
for (const parent of parentTags) {
  if (!allTags.has(parent)) {
    lines.push(`INSERT IGNORE INTO kb_tags (slug) VALUES (${escapeSQL(parent)});`)
  }
}

// Insert all tags
for (const tag of allTags) {
  const colon = tag.indexOf(':')
  if (colon > 0) {
    const parent = tag.substring(0, colon)
    lines.push(`INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES (${escapeSQL(tag)}, (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = ${escapeSQL(parent)}) AS t));`)
  } else {
    lines.push(`INSERT IGNORE INTO kb_tags (slug) VALUES (${escapeSQL(tag)});`)
  }
}
lines.push('')

// ======================== PART 5: Q&A Threads ========================

lines.push('-- =====================================================')
lines.push('-- PART 5: Q&A Threads')
lines.push('-- =====================================================')
lines.push('')

for (const qa of qaFiles) {
  if (!qa.question || !qa.answer) continue

  const tr = qa.question.translations || {}
  const ar = qa.answer.translations || {}
  const qSlug = slugify(qa.question.text).substring(0, 250)

  lines.push(`-- ${qa.id}: ${qa.question.text.substring(0, 80)}...`)

  // Use question text as title
  lines.push(`INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)`)
  lines.push(`VALUES (${escapeSQL(qSlug)}, 'draft',`)
  lines.push(`  ${escapeSQL(tr.sr || null)}, ${escapeSQL(tr.sr_cyrl || null)}, ${escapeSQL(tr.en || null)}, ${escapeSQL(tr.ru || qa.question.text)}, ${escapeSQL(tr.de || null)}, ${escapeSQL(tr.tr || null)},`)
  lines.push(`  ${escapeSQL(ar.sr || null)}, ${escapeSQL(ar.sr_cyrl || null)}, ${escapeSQL(ar.en || null)}, ${escapeSQL(ar.ru || qa.answer.text)}, ${escapeSQL(ar.de || null)}, ${escapeSQL(ar.tr || null)}`)
  lines.push(`)`)
  lines.push(`ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);`)
  lines.push('')

  // Thread tags
  for (const tag of (qa.tags || [])) {
    lines.push(`INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)`)
    lines.push(`SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = ${escapeSQL(qSlug)} AND tg.slug = ${escapeSQL(tag)};`)
  }

  // Entity links
  for (const entity of (qa.entities || [])) {
    if (entity.type && entity.id) {
      lines.push(`INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)`)
      lines.push(`SELECT 'thread', t.id, ${escapeSQL(entity.type)}, ${entity.id} FROM kb_threads t WHERE t.slug = ${escapeSQL(qSlug)};`)
    }
  }

  // Thread sources (link to original messages)
  for (const src of (qa.sourceMessages || [])) {
    for (const msgId of (src.messageIds || [])) {
      lines.push(`INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)`)
      lines.push(`SELECT t.id, m.id FROM kb_threads t, kb_messages m`)
      lines.push(`WHERE t.slug = ${escapeSQL(qSlug)}`)
      lines.push(`AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = ${escapeSQL(src.channelId)})`)
      lines.push(`AND m.provider_message_id = '${msgId}';`)
    }
  }

  lines.push('')
}

// ======================== PART 6: Articles ========================

lines.push('-- =====================================================')
lines.push('-- PART 6: Articles')
lines.push('-- =====================================================')
lines.push('')

for (const article of articleFiles) {
  if (!article.title || !article.content) continue

  const tr = article.title.translations || {}
  const cr = article.content.translations || {}
  const aSlug = article.slug || slugify(article.title.text).substring(0, 250)

  lines.push(`-- ${article.id}: ${article.title.text.substring(0, 80)}...`)

  lines.push(`INSERT INTO kb_articles (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, content_sr, content_sr_cyrl, content_en, content_ru, content_de, content_tr)`)
  lines.push(`VALUES (${escapeSQL(aSlug)}, 'draft',`)
  lines.push(`  ${escapeSQL(tr.sr || null)}, ${escapeSQL(tr.sr_cyrl || null)}, ${escapeSQL(tr.en || null)}, ${escapeSQL(tr.ru || article.title.text)}, ${escapeSQL(tr.de || null)}, ${escapeSQL(tr.tr || null)},`)
  lines.push(`  ${escapeSQL(cr.sr || null)}, ${escapeSQL(cr.sr_cyrl || null)}, ${escapeSQL(cr.en || null)}, ${escapeSQL(cr.ru || article.content.text)}, ${escapeSQL(cr.de || null)}, ${escapeSQL(cr.tr || null)}`)
  lines.push(`)`)
  lines.push(`ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), content_ru = VALUES(content_ru);`)
  lines.push('')

  // Article tags
  for (const tag of (article.tags || [])) {
    lines.push(`INSERT IGNORE INTO kb_article_tags (article_id, tag_id)`)
    lines.push(`SELECT a.id, tg.id FROM kb_articles a, kb_tags tg WHERE a.slug = ${escapeSQL(aSlug)} AND tg.slug = ${escapeSQL(tag)};`)
  }

  // Entity links
  for (const entity of (article.entities || [])) {
    if (entity.type && entity.id) {
      lines.push(`INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)`)
      lines.push(`SELECT 'article', a.id, ${escapeSQL(entity.type)}, ${entity.id} FROM kb_articles a WHERE a.slug = ${escapeSQL(aSlug)};`)
    }
  }

  // Article sources
  for (const src of (article.sourceMessages || [])) {
    for (const msgId of (src.messageIds || [])) {
      lines.push(`INSERT IGNORE INTO kb_article_sources (article_id, message_id)`)
      lines.push(`SELECT a.id, m.id FROM kb_articles a, kb_messages m`)
      lines.push(`WHERE a.slug = ${escapeSQL(aSlug)}`)
      lines.push(`AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = ${escapeSQL(src.channelId)})`)
      lines.push(`AND m.provider_message_id = '${msgId}';`)
    }
  }

  lines.push('')
}

// ======================== PART 7: Validation ========================

lines.push('-- =====================================================')
lines.push('-- PART 7: Validation')
lines.push('-- =====================================================')
lines.push('')
lines.push('SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;')
lines.push('')
lines.push('SELECT "kb_sources" AS `table`, COUNT(*) AS cnt FROM kb_sources')
lines.push('UNION ALL SELECT "kb_messages", COUNT(*) FROM kb_messages')
lines.push('UNION ALL SELECT "kb_tags", COUNT(*) FROM kb_tags')
lines.push('UNION ALL SELECT "kb_threads", COUNT(*) FROM kb_threads')
lines.push('UNION ALL SELECT "kb_articles", COUNT(*) FROM kb_articles')
lines.push('UNION ALL SELECT "kb_entity_links", COUNT(*) FROM kb_entity_links;')

// ---------------------------------------------------------------------------
// Write output
// ---------------------------------------------------------------------------

const outputPath = resolve(ROOT, 'server/sql/insert-kb.sql')
writeFileSync(outputPath, lines.join('\n') + '\n', 'utf-8')

console.log(`\nOutput: ${outputPath}`)
console.log(`SQL lines: ${lines.length}`)
console.log(`Users: ${allUsers.size}, Tags: ${allTags.size}, Q&A: ${qaFiles.length}, Articles: ${articleFiles.length}`)
console.log('\nTo run:')
console.log(`mysql -u root -p --default-character-set=utf8mb4 docta_me < ${outputPath.replace(/\\/g, '/')}`)
