#!/usr/bin/env node
/**
 * Normalize medicines.json: clean up country names, INN splitting, etc.
 * Run after scraping to fix inconsistencies from cinmed.me source.
 *
 * Usage: node scripts/normalize-medicines-json.mjs
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const JSON_PATH = resolve(ROOT, 'data/medicines.json');

// ---------------------------------------------------------------------------
// Country normalization
// ---------------------------------------------------------------------------

const COUNTRY_MAP = {
  'BiH':                                      'Bosna i Hercegovina',
  'Italija.':                                 'Italija',
  'Njemačka.':                                'Njemačka',
  'Srbija.':                                  'Srbija',
  'KG Njemačka':                              'Njemačka',
  'Sanofi-Aventis Deutschland GmbH Njemačka': 'Njemačka',
  'HEMOMONT d.o.o. Crna Gora':               'Crna Gora',
  'Vršac':                                    'Srbija',
  'Zdravlje A.D. Leskovac':                   'Srbija',
  'Madjarska':                                'Mađarska',
  'Svedska':                                  'Švedska',
  'UK':                                       'Velika Britanija',
  'Češka Republika':                          'Češka',
  'Makedonija':                               'Severna Makedonija',
  'Republika Severna Makedonija':             'Severna Makedonija',
  'Republika Sjeverna Makedonija':            'Severna Makedonija',
};

// ---------------------------------------------------------------------------
// INN normalization: split by commas but respect parentheses
// ---------------------------------------------------------------------------

/**
 * Split INN string into individual substances.
 *
 * Vaccines have descriptive INN ("vakcina protiv difterije, tetanusa...")
 * that should NOT be split — they're stored as a single entry.
 *
 * Normal medicines: "paracetamol, kofein" → ["paracetamol", "kofein"]
 */
function splitINN(inn) {
  // Vaccines & biologics: INN is a description, not a list of substances — keep whole
  if (/vakcin|pneumokokna/i.test(inn)) return [inn.trim()];
  // Blood products: "albumin, humani", "imunoglobulin, normalni humani, ..."
  if (/imunoglobulin|albumin|koagulacioni faktor|proteini plazme|fibrinogen|trombin/i.test(inn)) return [inn.trim()];
  // Unknown substance
  if (/^nepoznat$/i.test(inn.trim())) return [inn.trim()];

  const parts = [];
  let current = '';
  let depth = 0;

  for (const ch of inn) {
    if (ch === '(') depth++;
    else if (ch === ')') depth = Math.max(0, depth - 1);

    if (ch === ',' && depth === 0) {
      const trimmed = current.trim();
      if (trimmed) parts.push(trimmed);
      current = '';
    } else {
      current += ch;
    }
  }

  const trimmed = current.trim();
  if (trimmed) parts.push(trimmed);

  return parts;
}

/**
 * Normalize a single INN part: trim, lowercase, filter garbage fragments.
 */
const GARBAGE_SUBSTANCES = new Set([
  'adsorbovana', 'adsorbovana)', 'inaktivisana', 'inaktivisana)',
  'rekombinantna', 'rekombinantna)', 'kombinovana', 'konjugovana',
  'atenuirana', 'pentavalentna', 'polisaharidna',
  'fructus)', 'rascijepana virusna čestica)',
]);

function normalizeINNPart(s) {
  s = s.trim().toLowerCase();
  if (/^\d+\)?$/.test(s)) return null;
  if (s.length < 3) return null;
  if (GARBAGE_SUBSTANCES.has(s)) return null;
  return s;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Manufacturer normalization: pick canonical name for each group of dupes
// ---------------------------------------------------------------------------

// Explicit manufacturer renames (canonical form)
const MFG_MAP = {
  'HEMOMONT d.o.o.': 'Hemomont d.o.o.',
  'HEMOFARM A.D.': 'Hemofarm a.d.',
  'Hemofarm A.D.': 'Hemofarm a.d.',
  'Hemofarm AD': 'Hemofarm a.d.',
  'HEMOFARM AD': 'Hemofarm a.d.',
  'Hemofarm AD Vršac': 'Hemofarm a.d. Vršac',
  'HEMOFARM A.D. Vršac': 'Hemofarm a.d. Vršac',
  'HEMOFARM AD Vršac': 'Hemofarm a.d. Vršac',
  'GALENIKA A.D.': 'Galenika a.d.',
  'Galenika AD': 'Galenika a.d.',
  'GALENIKA a.d.Beograd': 'Galenika a.d. Beograd',
  'GALENIKA a.d. Beograd': 'Galenika a.d. Beograd',
  'Galenika A.D. Beograd': 'Galenika a.d. Beograd',
  'SALUTAS PHARMA GMBH': 'Salutas Pharma GmbH',
  'ZDRAVLJE A.D.': 'Zdravlje a.d.',
  'CENEXI': 'Cenexi',
  'PHARMATHEN SA': 'Pharmathen S.A.',
  'DELPHARM REIMS': 'Delpharm Reims',
  'Medochemie LTD': 'Medochemie Ltd.',
  'KeVaRo GROUP EOOD': 'Kevaro Group EOOD',
  'AstraZeneca A.B.': 'AstraZeneca AB',
  'Bosnalijek d.d': 'Bosnalijek d.d.',
  'Novo mesto': 'Novo Mesto',
  'PharmaSwiss d.o.o.': 'Pharmaswiss d.o.o.',
  'Merck Sharp & Dohme BV': 'Merck Sharp & Dohme B.V.',
  'F.Hoffmann La Roche AG': 'F. Hoffmann-La Roche AG',
  'F.Hoffmann-La Roche AG': 'F. Hoffmann-La Roche AG',
  'F.Hoffmann - La Roche AG': 'F. Hoffmann-La Roche AG',
  'Bionika Pharmaceuticals D.O.O.': 'Bionika Pharmaceuticals d.o.o.',
  'Sanofi Aventis Deutschland GmBH': 'Sanofi-Aventis Deutschland GmbH',
  'Sanofi-Aventis Deutschland GmBH': 'Sanofi-Aventis Deutschland GmbH',
  'Sanofi Aventis Deutschland GmbH': 'Sanofi-Aventis Deutschland GmbH',
  'AbbVie Deutschland GmbH & Co.KG': 'AbbVie Deutschland GmbH & Co. KG',
  'Boehringer Ingelheim Pharma GmbH & Co.KG': 'Boehringer Ingelheim Pharma GmbH & Co. KG',
  'Bayer Weimar GmbH&Co.KG': 'Bayer Weimar GmbH & Co. KG',
  'Dragenopharm Apotheker Puschl GmbH & Co KG': 'Dragenopharm Apotheker Puschl GmbH & Co. KG',
  'B.Braun Melsungen AG': 'B. Braun Melsungen AG',
  'Jadran-Galenski Laboratorij d.d.': 'Jadran - Galenski Laboratorij d.d.',
  'S.C.Sindan-Pharma S.r.l.': 'S. C. Sindan-Pharma S.r.l.',
  'Teva Operations Poland Sp.z.o.o.': 'Teva Operations Poland Sp. z o.o.',
  'Ebewe Pharma Ges.m.b.H. Nfg.KG': 'Ebewe Pharma Ges.m.b.H.Nfg.KG',
  'L. Molteni & C. DEI. F.LLI ALITTI SOCIETA DI ESERCIZIO S.p.A.': 'L. Molteni & C. DEI F.LLI ALITTI SOCIETA DI ESERCIZIO S.p.A.',
  'Vianex S.A. Plant C': 'Vianex S.A. - Plant C',
  'Chephasaar Chemisch-Pharmazeutische Fabrik GmbH': 'Chephasaar Chemisch-pharmazeutische Fabrik GmbH',
  'spol. s.r.o.': 'spol. s r.o.',
  'Abbvie S.r.L': 'AbbVie S.r.l.',
  'Abbvie S.r.l.': 'AbbVie S.r.l.',
  'Genepharm S.A.': 'Genepharm S.A.',
  'GlaxoSmithKline Biologicals S.A': 'GlaxoSmithKline Biologicals S.A.',
  'GlaxoSmithKline Manufacturing S.p.A': 'GlaxoSmithKline Manufacturing S.p.A.',
  'Kedrion S.p.A': 'Kedrion S.p.A.',
  'Janssen Biologics B.V.': 'Janssen Biologics B.V.',
  'Janssen Biologics B.V': 'Janssen Biologics B.V.',
  'Biogen Netherlands B.V': 'Biogen Netherlands B.V.',
  'Gedeon Richter Plc': 'Gedeon Richter Plc.',
  'Ferring International Center SA': 'Ferring International Center S.A.',
  'Rafarm SA': 'Rafarm S.A.',
  'Actavis Ltd': 'Actavis Ltd.',
  'Remedica Ltd': 'Remedica Ltd.',
  'A. Menarini Manufacturing Logistics and Services s.r.l.': 'A. Menarini Manufacturing Logistics and Services S.r.l.',
  'Grindeks\u201D': 'Grindeks',
  'spoljnju trgovinu i zastupanje': null,  // garbage fragment, will be fixed from detail_manufacturer
  'SL': 'S.L.',
  'PHARMATHEN S.A.': 'Pharmathen S.A.',
  'Bayer Weimar GmbH & Co KG': 'Bayer Weimar GmbH & Co. KG',
  'L.Molteni & C. DEI F.LLI ALITTI SOCIETA DI ESERCIZIO S.p.A.': 'L. Molteni & C. DEI F.LLI ALITTI SOCIETA DI ESERCIZIO S.p.A.',
  'Alkaloid AD Skoplje': 'Alkaloid AD Skopje',
  'Astellas Ireland Co.Ltd.': 'Astellas Ireland Co. Limited',
  'Astellas Ireland Co.Limited': 'Astellas Ireland Co. Limited',
  'Remedica Limited': 'Remedica Ltd.',
  'Takeda Ireland Limited': 'Takeda Ireland Ltd.',
  'Novartis Pharmaceuticals UK Limited': 'Novartis Pharmaceuticals UK Ltd.',
  'Reckitt Benckiser Healthcare International Limited': 'Reckitt Benckiser Healthcare International Ltd.',
  'GlaxoSmithKline Dungarvan Limited': 'GlaxoSmithKline Dungarvan Ltd.',
  'B.Braun Melsungen AG': 'B. Braun Melsungen AG',
};

function normalizeManufacturer(name) {
  if (!name) return name;
  let n = name.trim();
  // Explicit renames first (exact match). null = garbage, signal to use detail_manufacturer
  if (n in MFG_MAP) return MFG_MAP[n];
  // Case-insensitive: UPPERCASE → canonical
  const upper = Object.keys(MFG_MAP).find(k => k.toLowerCase() === n.toLowerCase());
  if (upper) return MFG_MAP[upper];
  // Strip stray smart quotes and normalize suffixes
  n = n.replace(/[\u201C\u201D\u201E\u201F\u2018\u2019]/g, '')
       .replace(/\bGmBH\b/g, 'GmbH')
       .replace(/\bA\.B\.\b/g, 'AB')
       .replace(/\bS\.P\.A\./g, 'S.p.A.');
  return n;
}

const data = JSON.parse(readFileSync(JSON_PATH, 'utf-8'));
let countryFixes = 0;
let innFixes = 0;
let mfgFixes = 0;

for (const med of data.medicines) {
  // Fix countries
  if (med.country && COUNTRY_MAP[med.country]) {
    med.country = COUNTRY_MAP[med.country];
    countryFixes++;
  }

  // Fix garbage manufacturer — extract real name from detail_manufacturer
  if (med.manufacturer && /^\d|^[0-9]/.test(med.manufacturer) && med.detail_manufacturer) {
    // "1x0.5ml Merck Sharp..." or "500ml" or "84529 Tittmoning" — take first company from detail
    const firstCompany = med.detail_manufacturer.split(';')[0].split(',')[0].trim();
    if (firstCompany.length > 3) { med.manufacturer = firstCompany; mfgFixes++; }
  }
  if (med.manufacturer && med.detail_manufacturer) {
    // Detect fragments that are not real company names (suffixes, cities, etc.)
    const frag = /^(GmbH|Inc\.?|Ltd\.?|S\.A\.?|S\.L\.?|S\.A\.U\.?|S\.L\.U\.?|d\.|d\.d\.?|d\.o\.o\.?|k\.s\.?|spol\.?|spol\. s r\.o\.|Sp\.|Beograd|Vršac|Skopje|Skoplje|Novo Mesto)$/i;
    if (med.manufacturer.length <= 15 && frag.test(med.manufacturer)) {
      const firstCompany = med.detail_manufacturer.split(';')[0].split(',')[0].trim();
      if (firstCompany.length > 3) { med.manufacturer = firstCompany; mfgFixes++; }
    }
  }

  // Fix manufacturer name normalization
  if (med.manufacturer) {
    const fixed = normalizeManufacturer(med.manufacturer);
    if (fixed === null && med.detail_manufacturer) {
      // Garbage — take from detail
      med.manufacturer = med.detail_manufacturer.split(';')[0].split(',')[0].trim();
      mfgFixes++;
    } else if (fixed && fixed !== med.manufacturer) {
      med.manufacturer = fixed;
      mfgFixes++;
    }
  }

  // Fix slipped detail_manufacturer addresses (two addresses glued without separator)
  if (med.detail_manufacturer) {
    med.detail_manufacturer = med.detail_manufacturer.replace(
      /(Irska|Holandija|Hrvatska|Slovenija|Srbija|Njemačka|Francuska|Italija|Austrija|Belgija|Španija|Švajcarska|Švedska|Danska|Finska|Norveška|Grčka|Turska|Mađarska|Rumunija|Bugarska|Češka|Slovačka|Poljska|Velika Britanija|Crna Gora|Koreja|Kipar|Letonija|Litvanija|Island|Portugalija|Ruska Federacija|SAD|Kanada|Izrael|Malta|Severna Makedonija|Bosna i Hercegovina)([A-Z])/g,
      '$1; $2'
    );
  }

  // Normalize INN: re-split with paren-aware logic, store as cleaned string
  if (med.inn) {
    const parts = splitINN(med.inn);
    const cleaned = parts.map(normalizeINNPart).filter(Boolean);
    const newInn = cleaned.join(', ');
    if (newInn !== med.inn) {
      med.inn = newInn;
      innFixes++;
    }
  }
}

data.scraped_at = new Date().toISOString();
writeFileSync(JSON_PATH, JSON.stringify(data, null, 2), 'utf-8');

// Regenerate substances list
const subs = new Set();
data.medicines.forEach(m => {
  if (!m.inn) return;
  splitINN(m.inn).forEach(s => {
    const n = normalizeINNPart(s);
    if (n) subs.add(n);
  });
});
const subsList = [...subs].sort();
writeFileSync(resolve(ROOT, 'data/substances-list.json'), JSON.stringify(subsList, null, 2), 'utf-8');

const countries = [...new Set(data.medicines.map(m => m.country).filter(Boolean))].sort();
console.log(`✓ Fixed ${countryFixes} country values (${countries.length} unique)`);
console.log(`✓ Fixed ${mfgFixes} manufacturer values`);
console.log(`✓ Fixed ${innFixes} INN values`);
console.log(`✓ ${subsList.length} unique substances (was 932)`);

// Show any remaining orphan parens
const orphans = subsList.filter(s => {
  const o = (s.match(/\(/g)||[]).length;
  const c = (s.match(/\)/g)||[]).length;
  return o !== c;
});
if (orphans.length) {
  console.log(`\n⚠ ${orphans.length} substances with mismatched parens:`);
  orphans.forEach(s => console.log(`  ${s}`));
} else {
  console.log(`✓ No orphan parentheses`);
}
