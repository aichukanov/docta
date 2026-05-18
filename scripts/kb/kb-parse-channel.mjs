/**
 * Parse Telegram channel export → structured JSON with threads, users, messages.
 *
 * Usage:
 *   node scripts/kb-parse-channel.mjs data/chat-exports/test-export/result.json
 *
 * Output:
 *   data/kb/parsed/<channel-slug>.json
 */

import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------

const args = process.argv.slice(2)
const inputPath = args.find(a => !a.startsWith('--'))

if (!inputPath) {
  console.error('Usage: node scripts/kb-parse-channel.mjs <result.json>')
  process.exit(1)
}

const absInput = resolve(ROOT, inputPath)
if (!existsSync(absInput)) {
  console.error(`File not found: ${absInput}`)
  process.exit(1)
}

// ---------------------------------------------------------------------------
// Load export
// ---------------------------------------------------------------------------

const raw = JSON.parse(readFileSync(absInput, 'utf-8'))
const channelName = raw.name || 'unknown'
const channelId = String(raw.id || '0')
const channelType = raw.type || 'unknown'

console.log(`Channel: ${channelName} (${channelType}, id=${channelId})`)
console.log(`Total messages in export: ${raw.messages.length}`)

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Flatten Telegram's mixed text (string | array of string/object) → plain string */
function flattenText(text) {
  if (typeof text === 'string') return text
  if (!Array.isArray(text)) return ''
  return text.map(part => {
    if (typeof part === 'string') return part
    if (part && typeof part === 'object') return part.text || ''
    return ''
  }).join('')
}

/** Extract entities from text_entities array */
function extractEntities(textEntities) {
  const hashtags = []
  const mentions = []
  const links = []

  if (!Array.isArray(textEntities)) return { hashtags, mentions, links }

  for (const e of textEntities) {
    switch (e.type) {
      case 'hashtag':
        hashtags.push(e.text)
        break
      case 'mention':
        mentions.push(e.text)
        break
      case 'link':
        links.push(e.text)
        break
      case 'text_link':
        if (e.href) links.push(e.href)
        break
    }
  }

  return { hashtags, mentions, links }
}

/** Extract telegram user ID from from_id like "user1431915921" */
function extractTelegramUserId(fromId) {
  if (!fromId) return null
  const m = fromId.match(/^user(\d+)$/)
  return m ? m[1] : null
}

/** Check if message is from channel (admin/ad) */
function isChannelMessage(msg) {
  return msg.from_id && msg.from_id.startsWith('channel')
}

/** Slugify channel name for filename */
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
    .substring(0, 80)
}

// ---------------------------------------------------------------------------
// Step 1: Filter & parse messages
// ---------------------------------------------------------------------------

const allMessages = raw.messages.filter(msg => msg.type === 'message')

let skippedChannel = 0
let skippedEmpty = 0
let skippedService = 0

/** @type {Map<number, object>} */
const messagesById = new Map()

/** @type {Map<string, { name: string, messageCount: number }>} */
const users = new Map()

for (const msg of allMessages) {
  // Skip non-message types
  if (msg.type !== 'message') {
    skippedService++
    continue
  }

  // Skip channel/admin messages (ads)
  if (isChannelMessage(msg)) {
    skippedChannel++
    continue
  }

  const text = flattenText(msg.text)

  // Skip empty messages (media-only without text)
  if (!text.trim()) {
    skippedEmpty++
    continue
  }

  const telegramUserId = extractTelegramUserId(msg.from_id)
  if (!telegramUserId) {
    skippedEmpty++
    continue
  }

  const { hashtags, mentions, links } = extractEntities(msg.text_entities)

  const parsed = {
    id: msg.id,
    telegramUserId,
    userName: msg.from || 'Unknown',
    text,
    date: msg.date,
    replyTo: msg.reply_to_message_id || null,
    hashtags,
    mentions,
    links,
    hasMedia: !!(msg.photo || msg.file || msg.media_type),
    mediaType: msg.media_type || (msg.photo ? 'photo' : null),
    edited: msg.edited || null,
    forwarded: msg.forwarded_from || null,
  }

  messagesById.set(msg.id, parsed)

  // Track users
  const existing = users.get(telegramUserId)
  if (existing) {
    existing.messageCount++
    // Use the latest name (in case user changed display name)
    if (msg.from) existing.name = msg.from
  } else {
    users.set(telegramUserId, { name: msg.from || 'Unknown', messageCount: 1 })
  }
}

console.log(`\nFiltered: ${messagesById.size} user messages`)
console.log(`Skipped: ${skippedChannel} channel/admin, ${skippedEmpty} empty/no-user, ${skippedService} service`)
console.log(`Unique users: ${users.size}`)

// ---------------------------------------------------------------------------
// Step 2: Classify messages (question / answer / recommendation / other)
// ---------------------------------------------------------------------------

/** Check if message looks like a review/recommendation */
const REVIEW_PATTERNS = [
  /отзыв/i,
  /рекоменду[юе]/i,
  /советую/i,
  /хоро[шщ]ий\s+(?:врач|доктор|специалист|клиник)/i,
  /отличн\S*\s+(?:врач|доктор|специалист|клиник)/i,
  /замечательн\S*\s+(?:врач|доктор|специалист)/i,
  /однозначно\s+рекоменду/i,
  /всем\s+рекоменду/i,
]

function isReviewMessage(text) {
  return REVIEW_PATTERNS.some(p => p.test(text))
}

// First pass: identify questions, recommendations, answers
for (const [, msg] of messagesById) {
  const isReview = isReviewMessage(msg.text)
  const isQuestion = msg.text.includes('?') && !msg.replyTo
  const isReplyToKnown = msg.replyTo && messagesById.has(msg.replyTo)

  if (isReview) {
    msg.type = 'recommendation'
  } else if (isQuestion) {
    msg.type = 'question'
  } else if (isReplyToKnown) {
    msg.type = 'answer' // will refine below
  } else if (msg.replyTo && !messagesById.has(msg.replyTo)) {
    // Reply to a message we don't have (filtered out / older export)
    msg.type = 'other'
  } else {
    msg.type = 'other'
  }
}

// Second pass: answers are replies to questions (direct or transitive)
// Build a set of question IDs, then mark replies to questions as answers
const questionIds = new Set()
for (const [id, msg] of messagesById) {
  if (msg.type === 'question') questionIds.add(id)
}

// Expand: if a message replies to a question or to another answer-to-question, it's an answer
let changed = true
while (changed) {
  changed = false
  for (const [id, msg] of messagesById) {
    if (msg.type === 'answer' && !questionIds.has(id)) {
      // Check if this answer's parent is a question or answer-in-question-thread
      if (msg.replyTo && questionIds.has(msg.replyTo)) {
        questionIds.add(id) // part of a question thread
      }
    }
  }
  // Also mark replies to non-questions that contain "?" as questions
  // (replies that are themselves questions — sub-questions in threads)
  for (const [id, msg] of messagesById) {
    if (msg.type !== 'question' && msg.text.includes('?') && msg.replyTo && messagesById.has(msg.replyTo)) {
      // This is a follow-up question within a thread — keep as answer in the thread context
    }
  }
  break // one pass is enough for our depth
}

// Stats
const stats = { question: 0, answer: 0, recommendation: 0, other: 0 }
for (const [, msg] of messagesById) {
  stats[msg.type] = (stats[msg.type] || 0) + 1
}
console.log(`\nClassification: ${stats.question} questions, ${stats.answer} answers, ${stats.recommendation} recommendations, ${stats.other} other`)

// ---------------------------------------------------------------------------
// Step 3: Build threads
// ---------------------------------------------------------------------------

// A thread starts from a root message (no replyTo, or replyTo not in our set)
// and includes all transitive replies

/** @type {Map<number, number>} message id → root id */
const msgToRoot = new Map()

function findRoot(msgId) {
  if (msgToRoot.has(msgId)) return msgToRoot.get(msgId)
  const msg = messagesById.get(msgId)
  if (!msg) return null
  if (!msg.replyTo || !messagesById.has(msg.replyTo)) {
    msgToRoot.set(msgId, msgId)
    return msgId
  }
  const root = findRoot(msg.replyTo)
  msgToRoot.set(msgId, root)
  return root
}

// Compute root for every message
for (const [id] of messagesById) {
  findRoot(id)
}

// Group by root
/** @type {Map<number, number[]>} root id → [message ids in chronological order] */
const threadGroups = new Map()
for (const [id] of messagesById) {
  const root = msgToRoot.get(id)
  if (!root) continue
  if (!threadGroups.has(root)) threadGroups.set(root, [])
  threadGroups.get(root).push(id)
}

// Sort messages within each thread by date
for (const [, ids] of threadGroups) {
  ids.sort((a, b) => {
    const ma = messagesById.get(a)
    const mb = messagesById.get(b)
    return new Date(ma.date) - new Date(mb.date)
  })
}

// Separate: threads with >1 message vs standalone
const threads = []
const standalone = []

for (const [rootId, ids] of threadGroups) {
  const messages = ids.map(id => {
    const msg = messagesById.get(id)
    return {
      id: msg.id,
      telegramUserId: msg.telegramUserId,
      userName: msg.userName,
      type: msg.type,
      text: msg.text,
      date: msg.date,
      replyTo: msg.replyTo,
      hashtags: msg.hashtags.length ? msg.hashtags : undefined,
      mentions: msg.mentions.length ? msg.mentions : undefined,
      links: msg.links.length ? msg.links : undefined,
      hasMedia: msg.hasMedia || undefined,
      mediaType: msg.mediaType || undefined,
      forwarded: msg.forwarded || undefined,
    }
  })

  if (ids.length > 1) {
    // Check if root is a question
    const rootMsg = messagesById.get(rootId)
    threads.push({
      rootMessageId: rootId,
      isQuestion: rootMsg.type === 'question',
      messageCount: ids.length,
      messages,
    })
  } else {
    standalone.push(messages[0])
  }
}

// Sort threads: questions first, then by date
threads.sort((a, b) => {
  if (a.isQuestion !== b.isQuestion) return a.isQuestion ? -1 : 1
  return new Date(a.messages[0].date) - new Date(b.messages[0].date)
})

// Sort standalone by date
standalone.sort((a, b) => new Date(a.date) - new Date(b.date))

const questionThreads = threads.filter(t => t.isQuestion)
const otherThreads = threads.filter(t => !t.isQuestion)

console.log(`\nThreads: ${threads.length} total (${questionThreads.length} Q&A, ${otherThreads.length} discussion)`)
console.log(`Standalone messages: ${standalone.length}`)

// ---------------------------------------------------------------------------
// Step 3b: Extract reviews (recommendations about doctors/clinics)
// ---------------------------------------------------------------------------

const reviews = []

// Collect all recommendation-type messages
for (const [, msg] of messagesById) {
  if (msg.type === 'recommendation') {
    reviews.push({
      id: msg.id,
      telegramUserId: msg.telegramUserId,
      userName: msg.userName,
      text: msg.text,
      date: msg.date,
      replyTo: msg.replyTo,
      hashtags: msg.hashtags.length ? msg.hashtags : undefined,
      mentions: msg.mentions.length ? msg.mentions : undefined,
      links: msg.links.length ? msg.links : undefined,
    })
  }
}

reviews.sort((a, b) => new Date(a.date) - new Date(b.date))
console.log(`Reviews (recommendations): ${reviews.length}`)

// ---------------------------------------------------------------------------
// Step 4: Build output
// ---------------------------------------------------------------------------

const usersObj = {}
for (const [telegramId, data] of users) {
  usersObj[telegramId] = data
}

const output = {
  source: {
    provider: 'telegram',
    providerId: channelId,
    name: channelName,
    type: channelType,
    exportDate: new Date().toISOString().split('T')[0],
    totalMessagesInExport: raw.messages.length,
    parsedMessages: messagesById.size,
  },
  stats: {
    totalParsed: messagesById.size,
    questions: stats.question,
    answers: stats.answer,
    recommendations: stats.recommendation,
    other: stats.other,
    uniqueUsers: users.size,
    threads: threads.length,
    questionThreads: questionThreads.length,
    standalone: standalone.length,
    reviews: reviews.length,
  },
  users: usersObj,
  threads,
  standalone,
  reviews,
}

// ---------------------------------------------------------------------------
// Step 5: Write output
// ---------------------------------------------------------------------------

const outputDir = resolve(ROOT, 'data/kb/parsed')
if (!existsSync(outputDir)) mkdirSync(outputDir, { recursive: true })

const slug = slugify(channelName)
const outputPath = resolve(outputDir, `${slug}.json`)

writeFileSync(outputPath, JSON.stringify(output, null, 2), 'utf-8')

console.log(`\nOutput: ${outputPath}`)
console.log('Done!')
