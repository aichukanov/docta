/**
 * Compile Q&A from parsed Telegram channel data using Claude API.
 *
 * Groups similar questions, compiles generalized answers, suggests tags and entity links.
 *
 * Usage:
 *   node scripts/kb-compile-qa.mjs [data/kb/parsed/channel.json ...]
 *
 * If no args, processes all files in data/kb/parsed/
 *
 * Output:
 *   data/kb/qa/qa-001.json ... qa-NNN.json
 *   data/kb/articles/article-001.json ... (for large topics)
 */

import { readFileSync, writeFileSync, existsSync, mkdirSync, readdirSync } from 'node:fs'
import { resolve, dirname, basename } from 'node:path'
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

if (!ANTHROPIC_API_KEY) {
  console.error('Error: ANTHROPIC_API_KEY not set in .env or environment')
  process.exit(1)
}

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------

const args = process.argv.slice(2)
let inputPaths = args.filter(a => !a.startsWith('--'))

if (inputPaths.length === 0) {
  const parsedDir = resolve(ROOT, 'data/kb/parsed')
  if (existsSync(parsedDir)) {
    inputPaths = readdirSync(parsedDir)
      .filter(f => f.endsWith('.json'))
      .map(f => `data/kb/parsed/${f}`)
  }
}

if (inputPaths.length === 0) {
  console.error('No parsed files found. Run kb-parse-channel.mjs first.')
  process.exit(1)
}

// ---------------------------------------------------------------------------
// Load reference data (clinics, doctors, specialties)
// ---------------------------------------------------------------------------

const clinicListPath = resolve(ROOT, 'data/from-db/clinic-list.txt')
const clinicsDoctorsPath = resolve(ROOT, 'data/from-db/clinics-doctors.json')

let clinicList = ''
let clinicsDoctors = []

if (existsSync(clinicListPath)) {
  clinicList = readFileSync(clinicListPath, 'utf-8')
}
if (existsSync(clinicsDoctorsPath)) {
  clinicsDoctors = JSON.parse(readFileSync(clinicsDoctorsPath, 'utf-8'))
}

// Build compact reference for the prompt
const clinicRef = clinicList.trim()
const doctorRef = clinicsDoctors.flatMap(c =>
  (c.doctors || []).map(d => `  ${d.id}\t${d.name} (${c.name}) [${(d.specialties || []).join(', ')}]`)
).join('\n')

// ---------------------------------------------------------------------------
// Load all parsed data
// ---------------------------------------------------------------------------

const allThreads = []
const allStandalone = []
const sources = []

for (const p of inputPaths) {
  const abs = resolve(ROOT, p)
  const data = JSON.parse(readFileSync(abs, 'utf-8'))
  sources.push(data.source)

  for (const thread of data.threads) {
    if (thread.isQuestion) {
      allThreads.push({
        ...thread,
        channelId: data.source.providerId,
        channelName: data.source.name,
      })
    }
  }

  // Standalone questions (no replies but still questions)
  for (const msg of data.standalone) {
    if (msg.type === 'question') {
      allStandalone.push({
        ...msg,
        channelId: data.source.providerId,
        channelName: data.source.name,
      })
    }
  }
}

console.log(`Loaded ${allThreads.length} Q&A threads + ${allStandalone.length} standalone questions from ${sources.length} channel(s)`)

// ---------------------------------------------------------------------------
// Prepare threads for Claude
// ---------------------------------------------------------------------------

function formatThreadForPrompt(thread, idx) {
  const lines = [`--- Thread #${idx + 1} (root msg ${thread.rootMessageId}) ---`]
  for (const msg of thread.messages) {
    const role = msg.type === 'question' ? 'Q' : 'A'
    lines.push(`[${role}] ${msg.userName}: ${msg.text}`)
  }
  return lines.join('\n')
}

function formatStandaloneForPrompt(msg, idx) {
  return `--- Standalone Q #${idx + 1} (msg ${msg.id}) ---\n[Q] ${msg.userName}: ${msg.text}`
}

// ---------------------------------------------------------------------------
// Call Claude API
// ---------------------------------------------------------------------------

async function callClaude(prompt, maxTokens = 16000) {
  const resp = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-5-20250514',
      max_tokens: maxTokens,
      messages: [{ role: 'user', content: prompt }],
    }),
  })

  if (!resp.ok) {
    const err = await resp.text()
    throw new Error(`Anthropic API error ${resp.status}: ${err}`)
  }

  const body = await resp.json()
  return body.content[0].text
}

// ---------------------------------------------------------------------------
// Compile Q&A
// ---------------------------------------------------------------------------

const BATCH_SIZE = 30 // threads per API call

async function compileQA() {
  // Combine threads and standalone into one list
  const allItems = [
    ...allThreads.map((t, i) => ({ type: 'thread', data: t, formatted: formatThreadForPrompt(t, i) })),
    ...allStandalone.map((m, i) => ({ type: 'standalone', data: m, formatted: formatStandaloneForPrompt(m, i) })),
  ]

  if (allItems.length === 0) {
    console.log('No Q&A threads or standalone questions found.')
    return
  }

  // Process in batches
  const results = []

  for (let batchStart = 0; batchStart < allItems.length; batchStart += BATCH_SIZE) {
    const batch = allItems.slice(batchStart, batchStart + BATCH_SIZE)
    const batchNum = Math.floor(batchStart / BATCH_SIZE) + 1
    const totalBatches = Math.ceil(allItems.length / BATCH_SIZE)

    console.log(`\nProcessing batch ${batchNum}/${totalBatches} (${batch.length} items)...`)

    const threadsText = batch.map(item => item.formatted).join('\n\n')

    const prompt = `You are a medical content curator for docta.me — a medical directory for Montenegro.

Below are Q&A threads and standalone questions from a Telegram medical community channel.
Your task: group similar questions, compile generalized Q&A entries, and suggest metadata.

## Reference data

### Clinics in our database:
${clinicRef}

### Doctors in our database:
${doctorRef}

## Instructions

1. **Group similar questions** into one Q&A. For example, if 3 people asked "where to get blood tests in Budva" — merge into one Q&A.
2. For each group, write:
   - A clear, generalized **question** in Russian (the community language)
   - A comprehensive **answer** in Russian, compiled from the best answers in the threads. Include specific clinic names, prices, contacts if mentioned. Be factual — only use information from the threads.
3. **Tags**: suggest relevant tags from this taxonomy:
   - Specialties: stomatologija, ginekologija, dermatologija, kardiologija, endokrinologija, ortopedija, otorinolaringologija, nevrologija, urologija, oftalmologija, pediatrija, terapija, hirurgija, fizioterapija, psihijatrija
   - Cities: city:podgorica, city:budva, city:bar, city:tivat, city:kotor, city:herceg-novi, city:niksic, city:ulcinj, city:cetinje
   - Topics: topic:ceny, topic:analizy, topic:vyzov-na-dom, topic:strahovanje, topic:lechenie-zubov, topic:implantacija, topic:detskij-vrach, topic:beremennost, topic:uzi, topic:rentgen, topic:mrt, topic:ekg, topic:operacija, topic:reabilitacija, topic:apteka, topic:neotlozhnaja-pomosh
   - You may suggest NEW tags not in this list if needed (use same slug format)
4. **Entity links**: if specific clinics or doctors from our database are mentioned or clearly relevant, include them.
5. If a topic is **large/complex** (multiple sub-questions, detailed medical information, would benefit from a structured article) — mark as type "article" instead of "qa".
6. **Skip** messages that are just greetings, thanks, or off-topic.

## Threads

${threadsText}

## Output format

Return a JSON array. Each element:
\`\`\`json
{
  "type": "qa" or "article",
  "tags": ["tag1", "tag2"],
  "entities": [{"type": "clinic", "id": 5, "name": "..."}, {"type": "doctor", "id": 12, "name": "..."}],
  "sourceMessageIds": [107736, 107737, 107738],
  "question": "Обобщённый вопрос на русском?",
  "answer": "Обобщённый ответ на русском, с конкретикой из тредов...",
  "title": "Заголовок (только для type=article, иначе null)"
}
\`\`\`

IMPORTANT:
- Return ONLY valid JSON array, no markdown fences, no commentary
- sourceMessageIds must contain ALL message IDs from threads that were merged into this Q&A
- Every thread/standalone question must be assigned to exactly one Q&A (don't skip any)
- The question and answer should be in Russian
- Be factual: only include information that was actually mentioned in the threads`

    const response = await callClaude(prompt, 16000)

    // Parse JSON from response
    const jsonMatch = response.match(/\[[\s\S]*\]/)
    if (!jsonMatch) {
      console.error(`Failed to parse JSON from batch ${batchNum} response`)
      console.error('Response:', response.substring(0, 500))
      continue
    }

    let parsed
    try {
      parsed = JSON.parse(jsonMatch[0])
    } catch (e) {
      console.error(`JSON parse error in batch ${batchNum}:`, e.message)
      console.error('Matched JSON:', jsonMatch[0].substring(0, 500))
      continue
    }

    console.log(`  → Got ${parsed.length} Q&A entries`)

    // Enrich with source channel info
    for (const entry of parsed) {
      // Map sourceMessageIds to channel sources
      const msgIdSet = new Set(entry.sourceMessageIds || [])
      const channelSources = {}

      for (const item of batch) {
        if (item.type === 'thread') {
          const threadMsgIds = item.data.messages.map(m => m.id)
          const overlap = threadMsgIds.filter(id => msgIdSet.has(id))
          if (overlap.length > 0) {
            const chId = item.data.channelId
            if (!channelSources[chId]) channelSources[chId] = []
            channelSources[chId].push(...threadMsgIds)
          }
        } else {
          if (msgIdSet.has(item.data.id)) {
            const chId = item.data.channelId
            if (!channelSources[chId]) channelSources[chId] = []
            channelSources[chId].push(item.data.id)
          }
        }
      }

      entry.sourceMessages = Object.entries(channelSources).map(([channelId, messageIds]) => ({
        channelId,
        messageIds: [...new Set(messageIds)].sort((a, b) => a - b),
      }))

      results.push(entry)
    }
  }

  return results
}

// ---------------------------------------------------------------------------
// Save results
// ---------------------------------------------------------------------------

async function main() {
  const results = await compileQA()
  if (!results || results.length === 0) {
    console.log('No results to save.')
    return
  }

  const qaDir = resolve(ROOT, 'data/kb/qa')
  const articlesDir = resolve(ROOT, 'data/kb/articles')
  mkdirSync(qaDir, { recursive: true })
  mkdirSync(articlesDir, { recursive: true })

  let qaCount = 0
  let articleCount = 0

  for (const entry of results) {
    const isArticle = entry.type === 'article'
    const dir = isArticle ? articlesDir : qaDir
    const prefix = isArticle ? 'article' : 'qa'
    const num = isArticle ? ++articleCount : ++qaCount
    const id = `${prefix}-${String(num).padStart(3, '0')}`
    const filePath = resolve(dir, `${id}.json`)

    const output = {
      id,
      type: entry.type || 'qa',
      status: 'draft',
      tags: entry.tags || [],
      entities: entry.entities || [],
      sourceMessages: entry.sourceMessages || [],
      question: {
        text: entry.question,
        language: 'ru',
      },
      answer: {
        text: entry.answer,
        language: 'ru',
      },
    }

    if (isArticle && entry.title) {
      output.title = { text: entry.title, language: 'ru' }
      output.content = output.answer
      delete output.question
      delete output.answer
    }

    writeFileSync(filePath, JSON.stringify(output, null, 2), 'utf-8')
    console.log(`  Saved: ${filePath}`)
  }

  console.log(`\nDone! Created ${qaCount} Q&A + ${articleCount} articles`)
}

main().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
