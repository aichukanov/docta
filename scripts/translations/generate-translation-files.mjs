#!/usr/bin/env node
/**
 * Создаёт скелеты файлов переводов из извлечённых данных отзывов.
 *
 * Что делает:
 * - Для bs/hr/sr/cnr оригиналов: копирует текст в sr (латиница уже подходит)
 * - Для sr-кириллица оригиналов: копирует в sr_cyrl
 * - Для en/tr/ru/de оригиналов: копирует в соответствующее поле
 * - Остальные языковые поля оставляет пустыми для ручного перевода
 * - sr_cyrl НЕ генерируется автоматически (наивная транслитерация ненадёжна)
 *
 * Usage:
 *   node scripts/generate-translation-files.mjs <raw-json> <output-dir>
 *
 * raw-json — массив объектов:
 *   { idx, id, lang, text, hasReply, replyLang, replyText }
 *
 * Для извлечения raw-json из Google Places JSON:
 *   node -e "
 *     const d = require('./<google-places-file>.json');
 *     const r = d.reviews.filter(r => r.originalText?.text?.trim()).map((r, i) => ({
 *       idx: i+1,
 *       id: r._reviewId || r.name.split('/reviews/')[1],
 *       lang: r.originalText.languageCode || 'sr',
 *       text: r.originalText.text,
 *       hasReply: !!(r.ownerResponse?.text?.trim()),
 *       replyLang: r.ownerResponse?.languageCode || 'sr',
 *       replyText: r.ownerResponse?.text || ''
 *     }));
 *     require('fs').writeFileSync('<output>.json', JSON.stringify(r, null, 2));
 *   "
 */
import { readFileSync, writeFileSync, mkdirSync } from 'fs';
import { join } from 'path';

const BCS_LANGS = new Set(['bs', 'hr', 'sr', 'cnr', 'me']);

function isCyrillic(text) {
  const cyr = (text.match(/[а-яёА-ЯЁЂђЈјЉљЊњЋћЏџ]/g) || []).length;
  const lat = (text.match(/[a-zA-Z]/g) || []).length;
  return cyr > lat;
}

function buildTranslations(lang, text) {
  const t = {};
  if (BCS_LANGS.has(lang)) {
    if (isCyrillic(text)) {
      t.sr_cyrl = text;
      // sr (латиница) — нужен ручной перевод или транслитерация
    } else {
      t.sr = text;
      // sr_cyrl — нужен ручной перевод (наивная транслитерация ненадёжна)
    }
  } else if (['en', 'tr', 'ru', 'de'].includes(lang)) {
    t[lang] = text;
  }
  // fr, pl, sl и др. — нужен полный перевод на все 6 языков
  for (const k of ['sr', 'sr_cyrl', 'en', 'ru', 'de', 'tr']) {
    if (!t[k]) t[k] = '';
  }
  return t;
}

// ---

const rawFile = process.argv[2];
const outputDir = process.argv[3];

if (!rawFile || !outputDir) {
  console.error('Usage: node scripts/generate-translation-files.mjs <raw-json> <output-dir>');
  process.exit(1);
}

mkdirSync(outputDir, { recursive: true });
const raw = JSON.parse(readFileSync(rawFile, 'utf8'));

let reviewCount = 0;
let replyCount = 0;

for (const item of raw) {
  const num = String(item.idx).padStart(3, '0');

  // --- REVIEW ---
  const reviewData = {
    id: item.id,
    original_language: item.lang,
    text: item.text,
    translations: buildTranslations(item.lang, item.text)
  };
  writeFileSync(join(outputDir, `review-${num}.json`), JSON.stringify(reviewData, null, 2) + '\n');
  reviewCount++;

  // --- REPLY ---
  if (item.hasReply && item.replyText) {
    const rLang = item.replyLang || 'sr';
    const replyData = {
      type: 'reply',
      id: item.id,
      original_language: rLang,
      text: item.replyText,
      translations: buildTranslations(rLang, item.replyText)
    };
    writeFileSync(join(outputDir, `reply-${num}.json`), JSON.stringify(replyData, null, 2) + '\n');
    replyCount++;
  }
}

console.log(`✓ Generated ${reviewCount} review files + ${replyCount} reply files in ${outputDir}`);
