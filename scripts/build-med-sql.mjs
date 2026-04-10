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

function loadSingleJson(path) {
  return JSON.parse(readFileSync(resolve(ROOT, path), 'utf-8'));
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

// --- Countries ---
const countries = loadSingleJson('data/med-translations/countries.json');
const countriesSql = generateSQL('countries', countries, 'Countries with translations (55 entries, 6 languages)');
const countriesPath = resolve(ROOT, 'server/sql/migrations/insert-med-countries.sql');
writeFileSync(countriesPath, countriesSql, 'utf-8');
console.log(`✓ ${countriesPath} (${countries.length} countries)`);

// --- Dispensing modes ---
const modes = loadSingleJson('data/med-translations/dispensing-modes.json');
const modesSql = generateSQL('med_dispensing_modes', modes, 'Dispensing modes with translations (9 modes, 6 languages)');
const modesPath = resolve(ROOT, 'server/sql/migrations/insert-med-dispensing-modes.sql');
writeFileSync(modesPath, modesSql, 'utf-8');
console.log(`✓ ${modesPath} (${modes.length} modes)`);

// --- ATC groups ---
const atcGroups = loadSingleJson('data/med-translations/atc-groups.json');
const atcLines = [
  '-- ATC therapeutic groups with translations (14 groups, 6 languages)',
  `-- Generated: ${new Date().toISOString()}`,
  '-- Source: data/med-translations/atc-groups.json',
  '',
  'SET NAMES utf8mb4;',
  '',
];
for (const r of atcGroups) {
  atcLines.push(`INSERT INTO \`med_atc_groups\` (code, name, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)`);
  atcLines.push(`VALUES (${esc(r.src)}, ${esc(r.en)}, ${esc(r.en)}, ${esc(r.sr)}, ${esc(r.sr_cyrl)}, ${esc(r.ru)}, ${esc(r.de)}, ${esc(r.tr)})`);
  atcLines.push(`ON DUPLICATE KEY UPDATE name=VALUES(name), name_en=VALUES(name_en), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_tr=VALUES(name_tr);`);
  atcLines.push('');
}
const atcPath = resolve(ROOT, 'server/sql/migrations/insert-med-atc-groups.sql');
writeFileSync(atcPath, atcLines.join('\n'), 'utf-8');
console.log(`✓ ${atcPath} (${atcGroups.length} groups)`);

// --- Auth holders & Manufacturers (from medicines.json, no translations) ---
const medicines = JSON.parse(readFileSync(resolve(ROOT, 'data/medicines.json'), 'utf-8')).medicines;

// Auth holders
const holders = [...new Set(medicines.map(x => x.authorization_holder).filter(Boolean))].sort();
const holdersLines = [
  '-- Authorization holders (46 legal entities in Montenegro)',
  `-- Generated: ${new Date().toISOString()}`,
  '', 'SET NAMES utf8mb4;', '',
];
for (const h of holders) {
  holdersLines.push(`INSERT INTO \`med_auth_holders\` (name) VALUES (${esc(h)}) ON DUPLICATE KEY UPDATE name=VALUES(name);`);
}
const holdersPath = resolve(ROOT, 'server/sql/migrations/insert-med-auth-holders.sql');
writeFileSync(holdersPath, holdersLines.join('\n'), 'utf-8');
console.log(`✓ ${holdersPath} (${holders.length} holders)`);

// Manufacturers (name + full_address + country_id via subquery)
const mfgMap = new Map();
medicines.forEach(x => {
  if (!x.manufacturer) return;
  if (!mfgMap.has(x.manufacturer)) {
    mfgMap.set(x.manufacturer, { name: x.manufacturer, full_address: x.detail_manufacturer || null, country: x.country || null });
  }
});
const mfgs = [...mfgMap.values()].sort((a, b) => a.name.localeCompare(b.name));
const mfgLines = [
  `-- Manufacturers (${mfgs.length} companies)`,
  `-- Generated: ${new Date().toISOString()}`,
  '', 'SET NAMES utf8mb4;', '',
];
for (const m of mfgs) {
  const countryRef = m.country
    ? `(SELECT id FROM \`countries\` WHERE name = ${esc(m.country)} LIMIT 1)`
    : 'NULL';
  mfgLines.push(`INSERT INTO \`med_manufacturers\` (name, full_address, country_id) VALUES (${esc(m.name)}, ${esc(m.full_address)}, ${countryRef}) ON DUPLICATE KEY UPDATE full_address=VALUES(full_address), country_id=VALUES(country_id);`);
}
const mfgPath = resolve(ROOT, 'server/sql/migrations/insert-med-manufacturers.sql');
writeFileSync(mfgPath, mfgLines.join('\n'), 'utf-8');
console.log(`✓ ${mfgPath} (${mfgs.length} manufacturers)`);

// --- Medicines + medicine_substances ---
const medLines = [
  `-- Medicines (${medicines.length} entries) + substance links`,
  `-- Generated: ${new Date().toISOString()}`,
  '', 'SET NAMES utf8mb4;', '',
];
const subLinkLines = [];

// Paren-aware INN split (same logic as normalize script)
function splitINN(inn) {
  if (/vakcin|pneumokokna|imunoglobulin|albumin|koagulacioni faktor|proteini plazme|fibrinogen|trombin/i.test(inn)) return [inn.trim()];
  const parts = []; let cur = '', depth = 0;
  for (const ch of inn) {
    if (ch === '(') depth++;
    else if (ch === ')') depth = Math.max(0, depth - 1);
    if (ch === ',' && depth === 0) { if (cur.trim()) parts.push(cur.trim()); cur = ''; }
    else cur += ch;
  }
  if (cur.trim()) parts.push(cur.trim());
  return parts;
}

for (const m of medicines) {
  const pharmaRef = m.pharmaceutical_form
    ? `(SELECT id FROM med_pharma_forms WHERE name = ${esc(m.pharmaceutical_form)} LIMIT 1)`
    : 'NULL';
  const mfgRef = m.manufacturer
    ? `(SELECT id FROM med_manufacturers WHERE name = ${esc(m.manufacturer)} LIMIT 1)`
    : 'NULL';
  const holderRef = m.authorization_holder
    ? `(SELECT id FROM med_auth_holders WHERE name = ${esc(m.authorization_holder)} LIMIT 1)`
    : 'NULL';
  const dispRef = m.dispensing_mode
    ? `(SELECT id FROM med_dispensing_modes WHERE name = ${esc(m.dispensing_mode)} LIMIT 1)`
    : 'NULL';
  const atcGroupRef = m.atc_code
    ? `(SELECT id FROM med_atc_groups WHERE code = ${esc(m.atc_code[0])} LIMIT 1)`
    : 'NULL';
  const isActive = m.license_status ? 0 : 1;
  const authDate = m.authorization_date ? esc(m.authorization_date) : 'NULL';

  medLines.push(`INSERT INTO med_medicines (cinmed_id, name, pharmaceutical_form_id, strength, packaging, detail_packaging, manufacturer_id, authorization_holder_id, authorization_number, authorization_date, dispensing_mode_id, atc_code, atc_group_id, is_active, detail_url)`);
  medLines.push(`VALUES (${m.cinmed_id}, ${esc(m.name)}, ${pharmaRef}, ${esc(m.strength)}, ${esc(m.packaging)}, ${esc(m.detail_packaging)}, ${mfgRef}, ${holderRef}, ${esc(m.authorization_number)}, ${authDate}, ${dispRef}, ${esc(m.atc_code)}, ${atcGroupRef}, ${isActive}, ${esc(m.detail_url)})`);
  medLines.push(`ON DUPLICATE KEY UPDATE name=VALUES(name), pharmaceutical_form_id=VALUES(pharmaceutical_form_id), strength=VALUES(strength), packaging=VALUES(packaging), detail_packaging=VALUES(detail_packaging), manufacturer_id=VALUES(manufacturer_id), authorization_holder_id=VALUES(authorization_holder_id), authorization_number=VALUES(authorization_number), authorization_date=VALUES(authorization_date), dispensing_mode_id=VALUES(dispensing_mode_id), atc_code=VALUES(atc_code), atc_group_id=VALUES(atc_group_id), is_active=VALUES(is_active), detail_url=VALUES(detail_url);`);
  medLines.push('');

  // Substance links
  if (m.inn) {
    const parts = splitINN(m.inn);
    for (const part of parts) {
      const sub = part.trim().toLowerCase();
      if (!sub || sub.length < 3 || /^\d+\)?$/.test(sub)) continue;
      subLinkLines.push(`INSERT IGNORE INTO med_medicine_substances (medicine_id, substance_id) SELECT m.id, s.id FROM med_medicines m JOIN med_substances s ON s.name = ${esc(sub)} WHERE m.cinmed_id = ${m.cinmed_id};`);
    }
  }
}

const medPath = resolve(ROOT, 'server/sql/migrations/insert-med-medicines.sql');
writeFileSync(medPath, medLines.join('\n'), 'utf-8');
console.log(`✓ ${medPath} (${medicines.length} medicines)`);

const subLinkPath = resolve(ROOT, 'server/sql/migrations/insert-med-medicine-substances.sql');
const subLinkFull = [
  `-- Medicine ↔ Substance links`,
  `-- Generated: ${new Date().toISOString()}`,
  '', 'SET NAMES utf8mb4;', '',
  ...subLinkLines,
].join('\n');
writeFileSync(subLinkPath, subLinkFull, 'utf-8');
console.log(`✓ ${subLinkPath} (${subLinkLines.length} links)`);

