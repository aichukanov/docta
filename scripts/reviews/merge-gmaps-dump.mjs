/**
 * Выгрузка коллектора → файл клиники в `data/google-places/<город>/<slug>.json`.
 *
 * Отзывы снимаются расширением/коллектором (`E:\pet\google-map-reviews`), и
 * выгрузка приходит папкой `<hexId>/<hexId>.json`. `place_id` в ней нет: место
 * сличается по `cid` — это вторая половина hex-пары, она же лежит в
 * `googleMapsUri` наших файлов.
 *
 * Карточку можно снимать повторно: скрипт **дописывает** новые отзывы к уже
 * лежащим, а не перезаписывает файл. Отзыв узнаётся по его id, так что
 * повторный съём ничего не задваивает.
 *
 * Каждому отзыву проставляется `_collectedAt` — дата съёма, в который он
 * появился у нас. Она нужна дважды:
 *   - по ней отбираются новые: в миграцию и на перевод идёт только то, чего
 *     раньше не было (`generate-reviews-sql.mjs --since`);
 *   - из неё восстанавливается дата отзыва. В выгрузке `publishTime` всегда
 *     `null`, дата живёт только в строке «год назад», и считать её надо от
 *     того съёма, в котором строка прочитана. Если взять общий
 *     `dataCollectedDate`, дозалитые отзывы получат даты, сдвинутые на
 *     промежуток между съёмами.
 *
 * Старым отзывам, у которых отметки ещё нет, она проставляется из `collectedAt`
 * файла — то есть из даты того съёма, когда их и сняли.
 *
 * Usage:
 *   node scripts/reviews/merge-gmaps-dump.mjs [--from <dir>] [--dry-run]
 */

import fs from 'node:fs'
import os from 'node:os'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..')
const PLACES_DIR = path.join(ROOT, 'data/google-places')

const argv = process.argv.slice(2)
const arg = (flag, fallback = null) => {
  const i = argv.indexOf(flag)
  return i >= 0 ? argv[i + 1] : fallback
}
const FROM = arg('--from', path.join(os.homedir(), 'Downloads', 'gmaps-reviews'))
const DRY_RUN = argv.includes('--dry-run')

if (!fs.existsSync(FROM)) {
  console.error(`Нет папки с выгрузками: ${FROM}`)
  process.exit(2)
}

// ---------------------------------------------------------------------------
// Указатель: cid → файл клиники
// ---------------------------------------------------------------------------

/** Файлы клиник лежат по городам; `all-<город>.json` в корне — сводки, не они. */
function clinicFiles() {
  const out = []
  for (const city of fs.readdirSync(PLACES_DIR)) {
    const dir = path.join(PLACES_DIR, city)
    if (!fs.statSync(dir).isDirectory()) continue
    for (const name of fs.readdirSync(dir)) {
      if (name.endsWith('.json')) out.push(path.join(dir, name))
    }
  }
  return out
}

/**
 * Дата съёма старых отзывов берётся из конфига клиники, а не из `collectedAt`
 * файла: отзывы вносились руками из расширения, и `collectedAt` — это дата
 * обхода Places API, она с днём съёма не совпадает. У 30 клиник из 116 они
 * расходятся, в одном случае на месяц. Именно от конфиговой даты посчитаны
 * даты отзывов, которые уже лежат в базе, — значит её и надо сохранить.
 */
const CONFIGS_DIR = path.join(ROOT, 'data/review-import-configs')
const collectedByJsonPath = new Map()
const configJsonPaths = new Set()
if (fs.existsSync(CONFIGS_DIR)) {
  for (const name of fs.readdirSync(CONFIGS_DIR)) {
    if (!name.endsWith('.json')) continue
    try {
      const config = JSON.parse(fs.readFileSync(path.join(CONFIGS_DIR, name), 'utf8'))
      if (config.jsonPath) configJsonPaths.add(path.resolve(ROOT, config.jsonPath))
      if (config.jsonPath && config.dataCollectedDate) {
        collectedByJsonPath.set(path.resolve(ROOT, config.jsonPath), config.dataCollectedDate.slice(0, 10))
      }
    } catch {}
  }
}

// Часть файлов клиник — не карточки Places, а выгрузки расширения как есть;
// cid у них надёжно есть только в `placeIds.hexId`. У одного места бывает и
// несколько файлов (двойники по папкам городов, выгрузка рядом с карточкой
// Places) — дописывать надо в тот, на который смотрит конфиг отзывов: из
// него генерируется SQL. До 2026-10-30 запись шла в случайный.
const byCid = new Map()
for (const file of clinicFiles()) {
  let place, text
  try {
    text = fs.readFileSync(file, 'utf8')
    place = JSON.parse(text)
  } catch {
    continue
  }
  const cid = /cid=(\d+)/.exec(place.googleMapsUri ?? '')?.[1] ?? cidFromHexId(place.placeIds?.hexId ?? '')
  if (!cid) continue
  if (byCid.has(cid) && !configJsonPaths.has(file)) continue
  // Отступ и перевод строки — как в файле: выгрузки расширения лежат с табами,
  // и переписанный двумя пробелами файл дал бы diff на тысячи строк.
  const indent = /^\{\r?\n([ \t]+)/.exec(text)?.[1] ?? '  '
  const eol = text.includes('\r\n') ? '\r\n' : '\n'
  byCid.set(cid, { file, place, indent, eol })
}

/** Вторая половина hex-пары — cid карточки, в десятичном виде. */
function cidFromHexId(hexId) {
  const low = String(hexId).split(':')[1]
  if (!low) return null
  try {
    return BigInt(low).toString()
  } catch {
    return null
  }
}

const reviewKey = (review) =>
  review._reviewId ?? (review.name ?? '').split('/reviews/')[1] ?? review.name ?? null

const contributorId = (review) =>
  /\/maps\/contrib\/(\d+)/.exec(review.authorAttribution?.uri ?? '')?.[1] ?? null

// ---------------------------------------------------------------------------
// Слияние
// ---------------------------------------------------------------------------

const today = new Date().toISOString().slice(0, 10)
const updated = []
const foreign = []
const broken = []

for (const name of fs.readdirSync(FROM)) {
  const dir = path.join(FROM, name)
  if (!fs.statSync(dir).isDirectory()) continue

  const jsonName = fs.readdirSync(dir).find((f) => f.endsWith('.json'))
  if (!jsonName) {
    broken.push({ folder: name, why: 'нет <folder>.json' })
    continue
  }

  let dump
  try {
    dump = JSON.parse(fs.readFileSync(path.join(dir, jsonName), 'utf8'))
  } catch (error) {
    broken.push({ folder: name, why: `не парсится: ${error.message}` })
    continue
  }

  const cid = cidFromHexId(dump.placeIds?.hexId ?? '')
  const target = cid ? byCid.get(cid) : null
  if (!target) {
    foreign.push({ folder: name, placeName: dump.placeName, reviews: dump.reviews?.length ?? 0 })
    continue
  }

  const { file, place } = target
  const collectedAt = (dump.collectedAt ?? '').slice(0, 10) || today
  const existing = place.reviews ?? []

  // База для старых отзывов: день их съёма по конфигу, иначе дата файла.
  const baseCollectedAt =
    collectedByJsonPath.get(file) ?? (place.collectedAt ?? '').slice(0, 10) ?? collectedAt
  for (const review of existing) {
    if (!review._collectedAt) review._collectedAt = baseCollectedAt
  }

  // `_excludedReviewIds` — отзывы, убранные из файла руками (дубль того же текста
  // на другой карточке клиники и т.п.): выгрузка приносит их при каждом съёме.
  const known = new Set([...existing.map(reviewKey), ...(place._excludedReviewIds ?? [])].filter(Boolean))

  // Пять отзывов из Places API лежат в файле без `_reviewId`. Та же запись в
  // выгрузке узнаётся по id (2026-10-29 так совпали все 411), а на случай
  // расхождения — по автору. Из выгрузки API-отзыв добирает то, чего API не
  // отдаёт: ответ владельца и лайки; свой id и точный `publishTime` сохраняет.
  const apiTwins = new Map()
  for (const review of existing) {
    if (review._reviewId) continue
    apiTwins.set(reviewKey(review), review)
    const author = contributorId(review)
    if (author) apiTwins.set(`author:${author}`, review)
  }

  let enriched = 0
  const fresh = []
  for (const review of dump.reviews ?? []) {
    const key = reviewKey(review)
    if (!key) continue

    const twin = apiTwins.get(key) ?? apiTwins.get(`author:${contributorId(review)}`)
    if (twin && twin.rating === review.rating) {
      if (!twin._enrichedFromDump) {
        twin._enrichedFromDump = collectedAt
        // «месяц назад» в ответе прочитано в этом съёме, а не в съёме самого отзыва.
        if (review.ownerResponse && !twin.ownerResponse) {
          twin.ownerResponse = { ...review.ownerResponse, _collectedAt: collectedAt }
        }
        if (review._likesCount != null && twin._likesCount == null) twin._likesCount = review._likesCount
        enriched++
      }
      continue
    }
    if (known.has(key)) continue
    known.add(key)
    fresh.push({ ...review, _collectedAt: collectedAt })
  }

  // Оценка и счётчик на карточке меняются и без новых отзывов.
  const ratingBefore = place.rating
  const countBefore = place.userRatingCount

  place.reviews = [...existing, ...fresh]
  if (dump.googleRating != null) place.rating = dump.googleRating
  if (dump.googleReviewCount != null) place.userRatingCount = dump.googleReviewCount
  place.lastCollectedAt = collectedAt

  updated.push({
    file: path.relative(ROOT, file),
    slug: path.basename(file, '.json'),
    placeName: place.displayName?.text ?? dump.placeName,
    was: existing.length,
    added: fresh.length,
    enriched,
    total: place.reviews.length,
    rating: ratingBefore !== place.rating ? `${ratingBefore} → ${place.rating}` : null,
    count: countBefore !== place.userRatingCount ? `${countBefore} → ${place.userRatingCount}` : null,
  })

  if (!DRY_RUN) {
    const json = JSON.stringify(place, null, target.indent).replace(/\n/g, target.eol)
    fs.writeFileSync(file, `${json}${target.eol}`, 'utf8')
  }
}

// ---------------------------------------------------------------------------
// Отчёт
// ---------------------------------------------------------------------------

console.log(`Наши клиники: ${updated.length}`)
for (const item of updated) {
  const marks = [
    item.added > 0 ? `+${item.added} новых` : 'новых нет',
    item.enriched > 0 && `${item.enriched} из API узнаны`,
    item.rating && `оценка ${item.rating}`,
    item.count && `на карточке ${item.count}`,
  ].filter(Boolean)
  console.log(`  ${item.slug.padEnd(42)} было ${String(item.was).padStart(4)} → ${String(item.total).padStart(4)}  ${marks.join(', ')}`)
}

const added = updated.reduce((sum, i) => sum + i.added, 0)
console.log(`\nНовых отзывов: ${added}${added ? ` (дата съёма ${today})` : ''}`)

if (foreign.length) {
  console.log(`\nНе наши карточки — пропущены: ${foreign.length}`)
  for (const item of foreign) {
    console.log(`  ${(item.placeName ?? item.folder).slice(0, 48).padEnd(48)} ${String(item.reviews).padStart(4)} отз.`)
  }
}

if (broken.length) {
  console.log(`\nНе прочитались: ${broken.length}`)
  for (const item of broken) console.log(`  ${item.folder}: ${item.why}`)
}

if (DRY_RUN) console.log('\n--dry-run: ничего не записано.')
