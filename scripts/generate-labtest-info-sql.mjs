/**
 * Generate lab_test_info SQL from a tab-separated list of lab tests.
 *
 * Input format (labtest-list.txt, tab-separated, no header):
 *   Category\tID\tName
 *   Hematology\t1\tComplete Blood Count
 *   ...
 *
 * Usage:
 *   # Test with a single hardcoded test (CBC):
 *   node scripts/generate-labtest-info-sql.mjs --test
 *
 *   # Process a batch (first N tests from file):
 *   node scripts/generate-labtest-info-sql.mjs labtest-list.txt --limit 20
 *
 *   # Process a specific ID range:
 *   node scripts/generate-labtest-info-sql.mjs labtest-list.txt --ids 1,2,5,17
 *
 * Output: server/sql/insert-labtest-info.sql
 *
 * See docs/import/LABTEST_INFO_IMPORT.md for full docs.
 */

import { readFileSync, writeFileSync, existsSync } from 'node:fs'
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

// ---------------------------------------------------------------------------
// Parse CLI args
// ---------------------------------------------------------------------------
const args = process.argv.slice(2)
const testMode = args.includes('--test')
const inputFile = args.find(a => !a.startsWith('--'))
const limitArg = args.indexOf('--limit')
const limit = limitArg >= 0 ? parseInt(args[limitArg + 1]) : null
const idsArg = args.indexOf('--ids')
const filterIds = idsArg >= 0 ? new Set(args[idsArg + 1].split(',').map(Number)) : null

if (!testMode && !inputFile) {
  console.error(`Usage:
  node scripts/generate-labtest-info-sql.mjs --test
  node scripts/generate-labtest-info-sql.mjs labtest-list.txt [--limit N]
  node scripts/generate-labtest-info-sql.mjs labtest-list.txt --ids 1,2,5`)
  process.exit(1)
}

// ---------------------------------------------------------------------------
// Load tests
// ---------------------------------------------------------------------------

/** @typedef {{ id: number, name: string, category: string }} LabTestEntry */

/** @returns {LabTestEntry[]} */
function loadTestsFromFile(filePath) {
  const content = readFileSync(resolve(ROOT, filePath), 'utf-8')
  const tests = []
  for (const line of content.split('\n')) {
    // Skip SQL comment header and blank lines
    if (!line.trim() || line.startsWith('/') || line.startsWith('*') || line.startsWith('S')) continue
    const parts = line.split('\t')
    if (parts.length < 3) continue
    const [category, idStr, name] = parts
    const id = parseInt(idStr.trim())
    if (!id || !name?.trim()) continue
    tests.push({ id, name: name.trim(), category: category.trim() })
  }
  return tests
}

/** @type {LabTestEntry[]} */
let tests

if (testMode) {
  tests = [
    { id: 1, name: 'Complete Blood Count', category: 'Hematology' },
  ]
  console.log('Test mode: using Complete Blood Count (id=1)')
} else {
  const all = loadTestsFromFile(inputFile)
  if (filterIds) {
    tests = all.filter(t => filterIds.has(t.id))
  } else if (limit) {
    tests = all.slice(0, limit)
  } else {
    tests = all
  }
  console.log(`Loaded ${tests.length} tests from ${inputFile}`)
}

// ---------------------------------------------------------------------------
// Claude API call — generate structured info for a batch of tests
// ---------------------------------------------------------------------------

const BATCH_SIZE = 15

/**
 * @param {LabTestEntry[]} batch
 * @returns {Promise<object[]>}
 */
async function generateBatch(batch) {
  const testList = batch
    .map((t, i) => `[${i}] id=${t.id} | ${t.name} | category: ${t.category}`)
    .join('\n')

  const prompt = `You are a medical laboratory expert. For each lab test below, return structured metadata as a JSON array.

Each element must have exactly these fields:
- "sample_type": one of: "venous_blood", "capillary_blood", "urine", "stool", "swab", "saliva", "csf", "other"
- "fasting": one of: "required", "recommended", "not_required"
- "fasting_hours": integer (typical fasting hours) or null if fasting is not_required
- "turnaround_min": integer (minimum hours until results are typically ready)
- "turnaround_max": integer (maximum hours until results are typically ready)
- "parameters": array of strings listing key parameters/components measured (use standard abbreviations where applicable, max 12 items). Empty array [] if it's a single-value test with no sub-parameters.
- "summary": object with keys: "en", "ru", "sr", "sr_cyrl", "de", "tr" — each a 1–2 sentence plain-text description (no HTML). Focus on: what it measures, what it's used to detect/monitor. No filler phrases like "This test is...". Be direct and informative.

Rules:
- Serbian Latin (sr): use proper diacritics č ć ž š đ
- Serbian Cyrillic (sr_cyrl): use Cyrillic script
- turnaround times are typical clinical lab times (not STAT/express)
- Return ONLY a JSON array, no commentary

TESTS:
${testList}`

  const resp = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-haiku-4-5-20251001',
      max_tokens: 8000,
      messages: [{ role: 'user', content: prompt }],
    }),
  })

  if (!resp.ok) {
    const err = await resp.text()
    throw new Error(`Anthropic API error ${resp.status}: ${err}`)
  }

  const body = await resp.json()
  const content = body.content[0].text

  // Extract JSON array from response
  const jsonMatch = content.match(/\[[\s\S]*\]/)
  if (!jsonMatch) throw new Error(`Failed to parse API response:\n${content.slice(0, 500)}`)

  const parsed = JSON.parse(jsonMatch[0])
  if (parsed.length !== batch.length) {
    throw new Error(`Count mismatch: got ${parsed.length} results, expected ${batch.length}`)
  }
  return parsed
}

// ---------------------------------------------------------------------------
// Generate SQL
// ---------------------------------------------------------------------------

function escapeSQL(str) {
  if (str == null) return 'NULL'
  return "'" + String(str).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n') + "'"
}

function buildRow(testId, info) {
  const params = info.parameters?.length
    ? escapeSQL(JSON.stringify(info.parameters))
    : 'NULL'
  // sample_type_id resolved via subquery to avoid hardcoding IDs
  const sampleTypeId = `(SELECT id FROM lab_test_sample_types WHERE code = ${escapeSQL(info.sample_type)})`

  return `(${testId}, ${sampleTypeId}, ${escapeSQL(info.fasting)}, ` +
    `${info.fasting_hours ?? 'NULL'}, ${info.turnaround_min}, ${info.turnaround_max}, ` +
    `${params}, ` +
    `${escapeSQL(info.summary?.en)}, ${escapeSQL(info.summary?.ru)}, ` +
    `${escapeSQL(info.summary?.sr)}, ${escapeSQL(info.summary?.sr_cyrl)}, ` +
    `${escapeSQL(info.summary?.de)}, ${escapeSQL(info.summary?.tr)})`
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

const OUTPUT = resolve(ROOT, 'server/sql/insert-labtest-info.sql')
const cols = 'lab_test_id, sample_type_id, fasting, fasting_hours, turnaround_min, turnaround_max, ' +
  'parameters, summary_en, summary_ru, summary_sr, summary_sr_cyrl, summary_de, summary_tr'

const lines = []
lines.push('-- Lab test info: structured metadata for SEO content')
lines.push('-- Generated: ' + new Date().toISOString())
lines.push('-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-labtest-info.sql')
lines.push('')
lines.push('SET NAMES utf8mb4;')
lines.push('SET CHARACTER SET utf8mb4;')
lines.push('')

const allResults = []
let errors = 0

for (let i = 0; i < tests.length; i += BATCH_SIZE) {
  const batch = tests.slice(i, i + BATCH_SIZE)
  const batchNum = Math.floor(i / BATCH_SIZE) + 1
  const totalBatches = Math.ceil(tests.length / BATCH_SIZE)
  process.stdout.write(`  Generating batch ${batchNum}/${totalBatches} (${batch.length} tests)...`)

  try {
    const results = await generateBatch(batch)
    for (let j = 0; j < batch.length; j++) {
      allResults.push({ test: batch[j], info: results[j] })
    }
    console.log(' ✓')
  } catch (err) {
    console.log(` ✗ ${err.message}`)
    errors++
  }
}

if (allResults.length === 0) {
  console.error('No results generated. Exiting.')
  process.exit(1)
}

const values = allResults.map(({ test, info }) => {
  lines.push(`-- ${test.id}: ${test.name} (${test.category})`)
  return buildRow(test.id, info)
})

lines.push(`INSERT INTO lab_test_info (${cols}) VALUES`)
lines.push(values.join(',\n\n'))
lines.push(`ON DUPLICATE KEY UPDATE`)
lines.push(`  sample_type    = VALUES(sample_type),`)
lines.push(`  fasting        = VALUES(fasting),`)
lines.push(`  fasting_hours  = VALUES(fasting_hours),`)
lines.push(`  turnaround_min = VALUES(turnaround_min),`)
lines.push(`  turnaround_max = VALUES(turnaround_max),`)
lines.push(`  parameters     = VALUES(parameters),`)
lines.push(`  summary_en     = VALUES(summary_en),`)
lines.push(`  summary_ru     = VALUES(summary_ru),`)
lines.push(`  summary_sr     = VALUES(summary_sr),`)
lines.push(`  summary_sr_cyrl = VALUES(summary_sr_cyrl),`)
lines.push(`  summary_de     = VALUES(summary_de),`)
lines.push(`  summary_tr     = VALUES(summary_tr);`)

writeFileSync(OUTPUT, lines.join('\n'), 'utf-8')

console.log('')
console.log(`✓ Generated: ${OUTPUT}`)
console.log(`  Tests processed: ${allResults.length}`)
if (errors > 0) console.log(`  Batches failed: ${errors}`)
console.log('')
console.log(`Apply to DB:`)
console.log(`  mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-labtest-info.sql`)

// ---------------------------------------------------------------------------
// Test mode: print preview of the generated data
// ---------------------------------------------------------------------------
if (testMode && allResults.length > 0) {
  const { test, info } = allResults[0]
  console.log('')
  console.log('─── Preview ────────────────────────────────────────────────')
  console.log(`Test: ${test.name} (id=${test.id}, ${test.category})`)
  console.log(`  sample_type:    ${info.sample_type}`)
  console.log(`  fasting:        ${info.fasting}${info.fasting_hours ? ` (${info.fasting_hours}h)` : ''}`)
  console.log(`  turnaround:     ${info.turnaround_min}–${info.turnaround_max} hours`)
  console.log(`  parameters:     ${(info.parameters || []).join(', ') || '—'}`)
  console.log(`  summary_en:     ${info.summary?.en}`)
  console.log(`  summary_ru:     ${info.summary?.ru}`)
  console.log(`  summary_sr:     ${info.summary?.sr}`)
}
