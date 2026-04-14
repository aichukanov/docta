#!/usr/bin/env node
/**
 * Merges translations from a JSON file into existing translation files.
 *
 * Usage: node scripts/merge-translations.mjs <dir> <translations-json>
 *
 * translations-json format:
 * {
 *   "review-001": { "en": "...", "ru": "...", "de": "...", "tr": "..." },
 *   "reply-001": { "en": "...", "ru": "...", "de": "...", "tr": "..." },
 *   ...
 * }
 */
import { readFileSync, writeFileSync, existsSync } from 'fs';
import { join } from 'path';

const dir = process.argv[2];
const transFile = process.argv[3];

if (!dir || !transFile) {
  console.error('Usage: node scripts/merge-translations.mjs <dir> <translations-json>');
  process.exit(1);
}

const translations = JSON.parse(readFileSync(transFile, 'utf8'));
let updated = 0;

for (const [key, trans] of Object.entries(translations)) {
  const filepath = join(dir, `${key}.json`);
  if (!existsSync(filepath)) {
    console.error(`✗ File not found: ${filepath}`);
    continue;
  }

  const data = JSON.parse(readFileSync(filepath, 'utf8'));
  let changed = false;

  for (const [lang, text] of Object.entries(trans)) {
    if (text && (!data.translations[lang] || data.translations[lang] === '')) {
      data.translations[lang] = text;
      changed = true;
    }
  }

  if (changed) {
    writeFileSync(filepath, JSON.stringify(data, null, 2) + '\n');
    updated++;
  }
}

console.log(`✓ Updated ${updated} files from ${Object.keys(translations).length} entries`);
