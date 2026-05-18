/**
 * Translate compiled Q&A and articles to 6 languages using Claude API.
 *
 * Reads data/kb/qa/*.json and data/kb/articles/*.json,
 * adds translations directly into the same files.
 *
 * Usage:
 *   node scripts/kb-translate.mjs
 *   node scripts/kb-translate.mjs --force   # re-translate even if translations exist
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
if (!ANTHROPIC_API_KEY) {
  console.error('Error: ANTHROPIC_API_KEY not set in .env or environment')
  process.exit(1)
}

const FORCE = process.argv.includes('--force')
const LANGS = ['sr', 'sr_cyrl', 'en', 'ru', 'de', 'tr']

// ---------------------------------------------------------------------------
// Collect files to translate
// ---------------------------------------------------------------------------

function collectFiles(dir) {
  if (!existsSync(dir)) return []
  return readdirSync(dir)
    .filter(f => f.endsWith('.json'))
    .map(f => resolve(dir, f))
}

const qaFiles = collectFiles(resolve(ROOT, 'data/kb/qa'))
const articleFiles = collectFiles(resolve(ROOT, 'data/kb/articles'))
const allFiles = [...qaFiles, ...articleFiles]

if (allFiles.length === 0) {
  console.error('No Q&A or article files found. Run kb-compile-qa.mjs first.')
  process.exit(1)
}

console.log(`Found ${qaFiles.length} Q&A + ${articleFiles.length} article files`)

// ---------------------------------------------------------------------------
// Claude API helper
// ---------------------------------------------------------------------------

async function callClaude(prompt, maxTokens = 8000) {
  const resp = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-haiku-4-5-20251001',
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
// Translation
// ---------------------------------------------------------------------------

/**
 * Translate a batch of texts to 6 languages.
 * @param {Array<{id: string, text: string, language: string}>} items
 * @returns {Promise<Array<{sr, sr_cyrl, en, ru, de, tr}>>}
 */
async function translateBatch(items) {
  const numbered = items.map((item, i) =>
    `${i + 1}. [${item.language}] ${item.text}`
  ).join('\n\n')

  const prompt = `You are a professional medical translator for docta.me — a medical directory for Montenegro.

Translate each numbered text below into 6 languages: Serbian Latin (sr), Serbian Cyrillic (sr_cyrl), English (en), Russian (ru), German (de), Turkish (tr).

Rules:
- If the source language matches a target language, copy the original exactly
- If source is "sr" and text is Cyrillic, use it for sr_cyrl and transliterate for sr
- Preserve tone, style, emojis, formatting
- Do NOT translate clinic names, doctor names, brand names
- Medical terms should be professionally translated
- Keep the same paragraph structure
- Do NOT add any commentary

Return ONLY a JSON array where each element corresponds to a numbered input:
[{"sr":"...","sr_cyrl":"...","en":"...","ru":"...","de":"...","tr":"..."}, ...]

TEXTS:
${numbered}`

  const response = await callClaude(prompt, 12000)
  const jsonMatch = response.match(/\[[\s\S]*\]/)
  if (!jsonMatch) throw new Error('Failed to parse translation response')

  const parsed = JSON.parse(jsonMatch[0])
  if (parsed.length !== items.length) {
    throw new Error(`Translation count mismatch: got ${parsed.length}, expected ${items.length}`)
  }
  return parsed
}

// ---------------------------------------------------------------------------
// Process files
// ---------------------------------------------------------------------------

async function main() {
  let translated = 0
  let skipped = 0

  for (const filePath of allFiles) {
    const data = JSON.parse(readFileSync(filePath, 'utf-8'))
    const fileId = data.id

    // Collect texts that need translation
    const textsToTranslate = []
    const textKeys = [] // track where to put translations back

    if (data.type === 'article') {
      // Article: title + content
      if (data.title) {
        const hasTranslation = data.title.translations && Object.keys(data.title.translations).length === LANGS.length
        if (!hasTranslation || FORCE) {
          textsToTranslate.push({ id: `${fileId}-title`, text: data.title.text, language: data.title.language })
          textKeys.push('title')
        }
      }
      if (data.content) {
        const hasTranslation = data.content.translations && Object.keys(data.content.translations).length === LANGS.length
        if (!hasTranslation || FORCE) {
          textsToTranslate.push({ id: `${fileId}-content`, text: data.content.text, language: data.content.language })
          textKeys.push('content')
        }
      }
    } else {
      // Q&A: question + answer
      if (data.question) {
        const hasTranslation = data.question.translations && Object.keys(data.question.translations).length === LANGS.length
        if (!hasTranslation || FORCE) {
          textsToTranslate.push({ id: `${fileId}-question`, text: data.question.text, language: data.question.language })
          textKeys.push('question')
        }
      }
      if (data.answer) {
        const hasTranslation = data.answer.translations && Object.keys(data.answer.translations).length === LANGS.length
        if (!hasTranslation || FORCE) {
          textsToTranslate.push({ id: `${fileId}-answer`, text: data.answer.text, language: data.answer.language })
          textKeys.push('answer')
        }
      }
    }

    if (textsToTranslate.length === 0) {
      skipped++
      continue
    }

    console.log(`Translating ${fileId} (${textsToTranslate.length} texts)...`)

    try {
      const translations = await translateBatch(textsToTranslate)

      // Write translations back into the data
      for (let i = 0; i < textKeys.length; i++) {
        const key = textKeys[i]
        data[key].translations = translations[i]
      }

      writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf-8')
      translated++
      console.log(`  ✓ ${fileId}`)
    } catch (err) {
      console.error(`  ✗ ${fileId}: ${err.message}`)
    }

    // Small delay between API calls to avoid rate limiting
    if (translated % 5 === 0) {
      await new Promise(r => setTimeout(r, 1000))
    }
  }

  console.log(`\nDone! Translated: ${translated}, Skipped (already done): ${skipped}`)
}

main().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
