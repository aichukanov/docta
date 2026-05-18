#!/usr/bin/env node
/**
 * Generate INSERT SQL for med_pharma_forms and med_substances with translations.
 *
 * Reads unique values from data/medicines.json, filters garbage,
 * generates translations using Claude API (haiku), outputs SQL migrations.
 *
 * Usage:
 *   node scripts/generate-med-translations.mjs                # both
 *   node scripts/generate-med-translations.mjs --forms        # pharma forms only
 *   node scripts/generate-med-translations.mjs --substances   # substances only
 *
 * Requires ANTHROPIC_API_KEY in .env
 */

import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');

// Load .env
const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
    const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, '');
  }
}

const API_KEY = process.env.ANTHROPIC_API_KEY;
if (!API_KEY) { console.error('ANTHROPIC_API_KEY not set in .env'); process.exit(1); }

const args = process.argv.slice(2);
const DO_FORMS      = !args.length || args.includes('--forms');
const DO_SUBSTANCES = !args.length || args.includes('--substances');

// ---------------------------------------------------------------------------
const medicines = JSON.parse(readFileSync(resolve(ROOT, 'data/medicines.json'), 'utf-8')).medicines;

function getUniqueForms() {
  const set = new Set();
  medicines.forEach(m => { const f = m.pharmaceutical_form?.trim(); if (f) set.add(f); });
  return [...set].filter(f => !/^\d/.test(f) && f.length >= 3).sort();
}

function getUniqueSubstances() {
  const set = new Set();
  medicines.forEach(m => {
    if (!m.inn) return;
    m.inn.split(',').forEach(s => { const t = s.trim().toLowerCase(); if (t) set.add(t); });
  });
  return [...set].filter(s => !/^\d+\)?$/.test(s) && s.length >= 3).sort();
}

// ---------------------------------------------------------------------------
const BATCH = 40;

async function callClaude(prompt) {
  const resp = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-api-key': API_KEY, 'anthropic-version': '2023-06-01' },
    body: JSON.stringify({ model: 'claude-haiku-4-5-20251001', max_tokens: 8000, messages: [{ role: 'user', content: prompt }] }),
  });
  if (!resp.ok) throw new Error(`API ${resp.status}: ${await resp.text()}`);
  const text = (await resp.json()).content[0].text;
  const match = text.match(/\[[\s\S]*\]/);
  if (!match) throw new Error(`No JSON array: ${text.substring(0, 300)}`);
  return JSON.parse(match[0]);
}

async function translateBatch(items, type) {
  const list = items.map((s, i) => `[${i}] ${s}`).join('\n');
  const isForm = type === 'form';

  const prompt = isForm
    ? `Translate pharmaceutical dosage forms from Montenegrin/Serbian Latin to 5 languages.
Return JSON array where each element has: "src" (original, exactly as given), "en", "sr", "sr_cyrl", "ru", "de", "tr".
Rules:
- en: standard pharmaceutical English (e.g. "Film tableta" → "Film-coated tablet")
- sr: Serbian Latin with diacritics (often same as src)
- sr_cyrl: Serbian Cyrillic (use Serbian ј,љ,њ,ћ,ђ NOT Russian й,ль,нь)
- ru: Russian pharmaceutical terminology
- de: German pharmaceutical terminology
- tr: Turkish pharmaceutical terminology
- Return ONLY JSON array

FORMS:\n${list}`
    : `Translate pharmaceutical active substance INN names from Montenegrin/Serbian to 5 languages.
Return JSON array where each element has: "src" (original, exactly as given), "en", "sr", "sr_cyrl", "ru", "de", "tr".
Rules:
- en: standard international INN in English (e.g. "paracetamol" → "paracetamol", "acetilsalicilna kiselina" → "acetylsalicylic acid")
- sr: Serbian Latin with diacritics
- sr_cyrl: Serbian Cyrillic (use Serbian forms, NOT Russian)
- ru: Russian pharmaceutical name
- de: German pharmaceutical name
- tr: Turkish pharmaceutical name
- Most INN names are internationally standardized and similar across languages
- Return ONLY JSON array

SUBSTANCES:\n${list}`;

  return callClaude(prompt);
}

// ---------------------------------------------------------------------------
function esc(s) {
  if (s == null) return 'NULL';
  return "'" + String(s).replace(/\\/g, '\\\\').replace(/'/g, "''") + "'";
}

function toSQL(table, results) {
  const lines = [
    `-- ${table} with translations`,
    `-- Generated: ${new Date().toISOString()}`,
    '', 'SET NAMES utf8mb4;', '',
  ];
  for (const r of results) {
    lines.push(`INSERT INTO ${table} (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)`);
    lines.push(`VALUES (${esc(r.src)}, ${esc(r.en)}, ${esc(r.sr)}, ${esc(r.sr_cyrl)}, ${esc(r.ru)}, ${esc(r.de)}, ${esc(r.tr)})`);
    lines.push(`ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);`);
    lines.push('');
  }
  return lines.join('\n');
}

// ---------------------------------------------------------------------------
async function process(items, type, label) {
  console.log(`\n${label}: ${items.length} items\n`);
  const all = [];
  let errors = 0;
  const total = Math.ceil(items.length / BATCH);

  for (let i = 0; i < items.length; i += BATCH) {
    const batch = items.slice(i, i + BATCH);
    const n = Math.floor(i / BATCH) + 1;
    process.stdout.write(`  batch ${n}/${total} (${batch.length})...`);

    try {
      const res = await translateBatch(batch, type);
      for (let j = 0; j < Math.min(batch.length, res.length); j++) res[j].src = batch[j];
      all.push(...res.slice(0, batch.length));
      console.log(' ✓');
    } catch (err) {
      console.log(` ✗ ${err.message.substring(0, 80)}`);
      errors++;
      batch.forEach(s => all.push({ src: s, en: null, sr: s, sr_cyrl: null, ru: null, de: null, tr: null }));
    }
    await new Promise(r => setTimeout(r, 500));
  }

  return { results: all, errors };
}

// ---------------------------------------------------------------------------
async function main() {
  console.log('Medicine translations generator');

  if (DO_FORMS) {
    const forms = getUniqueForms();
    const { results } = await process(forms, 'form', 'Pharma forms');
    const path = resolve(ROOT, 'server/sql/migrations/insert-med-pharma-forms.sql');
    writeFileSync(path, toSQL('med_pharma_forms', results), 'utf-8');
    console.log(`  → ${path}`);
  }

  if (DO_SUBSTANCES) {
    const subs = getUniqueSubstances();
    const { results } = await process(subs, 'substance', 'Substances');
    const path = resolve(ROOT, 'server/sql/migrations/insert-med-substances.sql');
    writeFileSync(path, toSQL('med_substances', results), 'utf-8');
    console.log(`  → ${path}`);
  }

  console.log('\nDone');
}

main().catch(err => { console.error('Fatal:', err.message); process.exit(1); });
