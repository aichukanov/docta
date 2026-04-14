import { readdir, readFile } from 'fs/promises'
import { join, basename } from 'path'

const PLACES_DIR = 'data/google-places'
const CLINIC_LIST = 'data/from-db/clinic-list.txt'

// Read already-added clinics
const clinicListRaw = await readFile(CLINIC_LIST, 'utf-8')
const addedClinics = clinicListRaw
  .split('\n')
  .map(line => line.replace(/^\d+[\s\t]+/, '').trim())
  .filter(Boolean)
  .map(name => name.toLowerCase())

// Collect all clinics from google-places
const cities = (await readdir(PLACES_DIR, { withFileTypes: true }))
  .filter(d => d.isDirectory())

const clinics = []

for (const cityDir of cities) {
  const cityPath = join(PLACES_DIR, cityDir.name)
  const files = (await readdir(cityPath)).filter(f => f.endsWith('.json'))

  for (const file of files) {
    try {
      const data = JSON.parse(await readFile(join(cityPath, file), 'utf-8'))
      if (data.userRatingCount != null) {
        clinics.push({
          name: data.displayName?.text || basename(file, '.json'),
          city: cityDir.name,
          count: data.userRatingCount,
          rating: data.rating || 0,
        })
      }
    } catch {}
  }
}

// Normalize for fuzzy matching: remove diacritics, punctuation, city suffixes
function normalize(s) {
  return s
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '') // remove diacritics
    .toLowerCase()
    .replace(/[""„"«»'"]/g, '')
    .replace(/[–—\-]/g, ' ')
    .replace(/\s*\([^)]*\)\s*/g, ' ')  // remove (City) suffixes
    .replace(/[^a-z0-9\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

// Extract core name (first meaningful words) for partial matching
function coreWords(s) {
  return normalize(s).split(' ').filter(w => w.length > 1)
}

function isAdded(clinic) {
  const n = normalize(clinic.name)
  const nWords = coreWords(clinic.name)

  return addedClinics.some(added => {
    const a = normalize(added)
    // Direct inclusion
    if (a.includes(n) || n.includes(a)) return true
    // Word-based: if all words from the shorter name appear in the longer one
    const aWords = coreWords(added)
    const shorter = aWords.length <= nWords.length ? aWords : nWords
    const longer = aWords.length <= nWords.length ? nWords : aWords
    const longerStr = longer.join(' ')
    const matchCount = shorter.filter(w => longerStr.includes(w)).length
    const matchRatio = matchCount / shorter.length
    // For single long words (like "Milmedika"), exact inclusion is enough
    if (shorter.length === 1 && shorter[0].length >= 5 && matchRatio === 1) return true
    return matchRatio >= 0.8 && shorter.length >= 2
  })
}

// Split into two groups
const notAdded = clinics.filter(c => !isAdded(c))
const added = clinics.filter(c => isAdded(c))

// Sort both by userRatingCount descending
notAdded.sort((a, b) => b.count - a.count)
added.sort((a, b) => b.count - a.count)

// Print
function formatCity(slug) {
  return slug.replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
}

function printList(list) {
  for (const c of list) {
    const rating = c.rating ? ` ⭐${c.rating}` : ''
    console.log(`  ${String(c.count).padStart(5)}  ${c.name} (${formatCity(c.city)})${rating}`)
  }
}

console.log(`\n=== НЕ ДОБАВЛЕНЫ (${notAdded.length}) ===\n`)
printList(notAdded)

console.log(`\n=== УЖЕ ДОБАВЛЕНЫ (${added.length}) ===\n`)
printList(added)

console.log(`\nВсего: ${clinics.length} клиник`)
