/**
 * Merge translation batch files into a single translations JSON.
 *
 * Usage:
 *   node scripts/merge-translation-batches.mjs <texts-file> <batch-dir> <output-file>
 *
 * Example:
 *   node scripts/merge-translation-batches.mjs \
 *     data/review-translations/insert-reviews-just-dental-texts.json \
 *     data/review-translations \
 *     data/review-translations/insert-reviews-just-dental-translations.json
 */

import { readFileSync, writeFileSync, readdirSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

const [textsFile, batchDir, outputFile] = process.argv.slice(2)
if (!textsFile || !batchDir || !outputFile) {
  console.error('Usage: node scripts/merge-translation-batches.mjs <texts-file> <batch-dir> <output-file>')
  process.exit(1)
}

// Read original texts structure
const texts = JSON.parse(readFileSync(resolve(ROOT, textsFile), 'utf-8'))

// Read all batch files
const batchPath = resolve(ROOT, batchDir)
const batchFiles = readdirSync(batchPath).filter(f => f.startsWith('batch-') && f.endsWith('.json')).sort()

const reviewTransMap = new Map()
const replyTransMap = new Map()

for (const file of batchFiles) {
  const batch = JSON.parse(readFileSync(resolve(batchPath, file), 'utf-8'))
  for (const item of batch) {
    if (item.id) reviewTransMap.set(item.id, item.translations)
    if (item.review_id) replyTransMap.set(item.review_id, item.translations)
  }
  console.log(`  Read ${file}: ${batch.length} items`)
}

// Merge into texts structure
let reviewsFilled = 0, repliesFilled = 0

for (const r of texts.reviews) {
  const t = reviewTransMap.get(r.id)
  if (t) { r.translations = t; reviewsFilled++ }
}

for (const r of texts.replies) {
  const t = replyTransMap.get(r.review_id)
  if (t) { r.translations = t; repliesFilled++ }
}

// Remove _instructions field
delete texts._instructions

writeFileSync(resolve(ROOT, outputFile), JSON.stringify(texts, null, 2), 'utf-8')

console.log(`\n✓ Merged: ${outputFile}`)
console.log(`  Reviews: ${reviewsFilled}/${texts.reviews.length} translated`)
console.log(`  Replies: ${repliesFilled}/${texts.replies.length} translated`)
