/**
 * Очередь карточек для коллектора: кого снимать и кого переснимать.
 *
 * На выход — `data/google-places/review-targets.json` в том виде, какой ждёт
 * `E:\pet\google-map-reviews\automation\run-queue.mjs`.
 *
 * Два повода сходить на карточку:
 *   - **новая** — отзывов у нас ещё нет вовсе;
 *   - **обновление** — отзывы есть, но Google насчитывает больше, чем лежит
 *     у нас, либо съём старый.
 *
 * `userRatingCount` берётся из обхода Places и со временем устаревает, так
 * что это прикидка, а не точный счёт: сколько отзывов реально добавилось,
 * видно только на самой карточке.
 *
 * Usage:
 *   node scripts/reviews/build-review-targets.mjs                     # и новые, и обновления
 *   node scripts/reviews/build-review-targets.mjs --mode new          # только новые
 *   node scripts/reviews/build-review-targets.mjs --mode update       # только обновления
 *   node scripts/reviews/build-review-targets.mjs --min-reviews 10 --min-new 5 --older-than 180
 */

import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')
const PLACES_DIR = path.join(ROOT, 'data/google-places')
const OUT = path.join(PLACES_DIR, 'review-targets.json')

const argv = process.argv.slice(2)
const arg = (flag, fallback = null) => {
  const i = argv.indexOf(flag)
  return i >= 0 ? argv[i + 1] : fallback
}
const MODE = arg('--mode', 'both')
const MIN_REVIEWS = Number(arg('--min-reviews', 5))
const MIN_NEW = Number(arg('--min-new', 3))
const OLDER_THAN_DAYS = Number(arg('--older-than', 365))
const LIMIT = Number(arg('--limit', 1000))

const dayMs = 24 * 60 * 60 * 1000
const staleBefore = new Date(Date.now() - OLDER_THAN_DAYS * dayMs).toISOString().slice(0, 10)

const targets = []
for (const city of fs.readdirSync(PLACES_DIR)) {
  const dir = path.join(PLACES_DIR, city)
  if (!fs.statSync(dir).isDirectory()) continue

  for (const name of fs.readdirSync(dir)) {
    if (!name.endsWith('.json')) continue

    let place
    try {
      place = JSON.parse(fs.readFileSync(path.join(dir, name), 'utf8'))
    } catch {
      continue
    }
    if (!place.id) continue

    const onCard = place.userRatingCount ?? 0
    if (onCard < MIN_REVIEWS) continue

    // Places API отдаёт максимум пять отзывов на место, и они лежат в тех же
    // файлах. Снятые коллектором отличаются меткой `_reviewId` (и пустым
    // `publishTime`) — считать «уже собранными» надо только их, иначе место
    // с пятью отзывами из API выглядит собранным и в очередь не попадает.
    const all = place.reviews ?? []
    const stored = all.filter(r => r._reviewId).length
    const lastSeen = (place.lastCollectedAt ?? place.collectedAt ?? '').slice(0, 10)
    const gap = onCard - stored

    let reason = null
    if (stored === 0) reason = `новая${all.length ? `, в файле ${all.length} из API` : ''}`
    else if (gap >= MIN_NEW) reason = `на карточке больше на ${gap}`
    else if (lastSeen && lastSeen < staleBefore) reason = `съём от ${lastSeen}`

    if (!reason) continue
    if (MODE === 'new' && stored > 0) continue
    if (MODE === 'update' && stored === 0) continue

    targets.push({
      placeId: place.id,
      name: place.displayName?.text ?? path.basename(name, '.json'),
      slug: path.basename(name, '.json'),
      city,
      reviews: onCard, // реальное число на карточке — из него считается таймаут
      harvest: stored === 0 ? onCard : gap,
      stored,
      lastSeen: lastSeen || null,
      reason,
    })
  }
}

// Сперва то, где больше добыча; у новых это вся карточка, у обновлений — разница.
targets.sort((a, b) => b.harvest - a.harvest)
const items = targets.slice(0, LIMIT).map((t, i) => ({ rank: i + 1, ...t }))

fs.writeFileSync(
  OUT,
  `${JSON.stringify(
    {
      built_at: new Date().toISOString(),
      note: 'Построено scripts/reviews/build-review-targets.mjs — НЕ ПРАВИТЬ РУКАМИ.',
      criteria: { mode: MODE, minReviews: MIN_REVIEWS, minNew: MIN_NEW, olderThanDays: OLDER_THAN_DAYS },
      count: items.length,
      items,
    },
    null,
    2,
  )}\n`,
  'utf8',
)

const fresh = items.filter(i => i.stored === 0)
console.log(`Целей: ${items.length} — новых ${fresh.length}, на обновление ${items.length - fresh.length}`)
console.log(`Отзывов к съёму (прикидка): ${items.reduce((s, i) => s + i.harvest, 0)}`)
console.log(`→ ${OUT}`)
