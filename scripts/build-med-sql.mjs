#!/usr/bin/env node
/**
 * Build SQL migration files from JSON translation data.
 * Reads data/med-translations/pharma-forms/*.json and substances/*.json,
 * outputs SQL INSERT statements.
 *
 * Usage: node scripts/build-med-sql.mjs
 */

import { readFileSync, writeFileSync, readdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');

function esc(s) {
  if (s == null) return 'NULL';
  return "'" + String(s).replace(/\\/g, '\\\\').replace(/'/g, "''") + "'";
}

function loadAllBatches(dir) {
  const fullDir = resolve(ROOT, dir);
  const files = readdirSync(fullDir).filter(f => f.endsWith('.json')).sort();
  const all = [];
  for (const f of files) {
    const items = JSON.parse(readFileSync(resolve(fullDir, f), 'utf-8'));
    all.push(...items);
  }
  return all;
}

function generateSQL(table, items, header) {
  const lines = [
    `-- ${header}`,
    `-- Generated: ${new Date().toISOString()}`,
    `-- Source: data/med-translations/`,
    '',
    'SET NAMES utf8mb4;',
    '',
  ];

  for (const r of items) {
    lines.push(`INSERT INTO \`${table}\` (name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)`);
    lines.push(`VALUES (${esc(r.src)}, ${esc(r.en)}, ${esc(r.sr)}, ${esc(r.sr_cyrl)}, ${esc(r.ru)}, ${esc(r.de)}, ${esc(r.tr)})`);
    lines.push(`ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);`);
    lines.push('');
  }

  return lines.join('\n');
}

// --- Pharma forms ---
const forms = loadAllBatches('data/med-translations/pharma-forms');
const formsSql = generateSQL('med_pharma_forms', forms, 'Pharmaceutical forms with translations (148 forms, 6 languages)');
const formsPath = resolve(ROOT, 'server/sql/migrations/insert-med-pharma-forms.sql');
writeFileSync(formsPath, formsSql, 'utf-8');
console.log(`✓ ${formsPath} (${forms.length} forms)`);

// --- Substances ---
const subs = loadAllBatches('data/med-translations/substances');
const subsSql = generateSQL('med_substances', subs, 'Active substances (INN) with translations (932 substances, 6 languages)');
const subsPath = resolve(ROOT, 'server/sql/migrations/insert-med-substances.sql');
writeFileSync(subsPath, subsSql, 'utf-8');
console.log(`✓ ${subsPath} (${subs.length} substances)`);
