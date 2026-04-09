#!/usr/bin/env node
/**
 * Generate substance translations JSON from the substances list.
 * No API needed — uses transliteration rules and INN suffix mappings.
 *
 * INN names are internationally standardized; most translations are:
 * - en: replace Serbian suffixes with English INN equivalents
 * - sr: same as source (Montenegrin ≈ Serbian Latin)
 * - sr_cyrl: transliterate to Serbian Cyrillic
 * - ru: transliterate to Russian pharmaceutical Cyrillic
 * - de: same as en for most INN (German uses international INN)
 * - tr: same as en for most INN (Turkish uses international INN)
 *
 * Output: data/med-translations/substances/batch-NNN.json (40 per file)
 *
 * Usage: node scripts/generate-substance-translations.mjs
 */

import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const OUT_DIR = resolve(ROOT, 'data/med-translations/substances');
const BATCH_SIZE = 40;

if (!existsSync(OUT_DIR)) mkdirSync(OUT_DIR, { recursive: true });

// ---------------------------------------------------------------------------
// Serbian Latin → Serbian Cyrillic mapping
// ---------------------------------------------------------------------------

const SR_CYRL_MAP = {
  'lj': 'љ', 'Lj': 'Љ', 'LJ': 'Љ',
  'nj': 'њ', 'Nj': 'Њ', 'NJ': 'Њ',
  'dž': 'џ', 'Dž': 'Џ', 'DŽ': 'Џ',
  'a': 'а', 'b': 'б', 'c': 'ц', 'č': 'ч', 'ć': 'ћ',
  'd': 'д', 'đ': 'ђ', 'e': 'е', 'f': 'ф', 'g': 'г',
  'h': 'х', 'i': 'и', 'j': 'ј', 'k': 'к', 'l': 'л',
  'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п', 'r': 'р',
  's': 'с', 'š': 'ш', 't': 'т', 'u': 'у', 'v': 'в',
  'z': 'з', 'ž': 'ж',
  'A': 'А', 'B': 'Б', 'C': 'Ц', 'Č': 'Ч', 'Ć': 'Ћ',
  'D': 'Д', 'Đ': 'Ђ', 'E': 'Е', 'F': 'Ф', 'G': 'Г',
  'H': 'Х', 'I': 'И', 'J': 'Ј', 'K': 'К', 'L': 'Л',
  'M': 'М', 'N': 'Н', 'O': 'О', 'P': 'П', 'R': 'Р',
  'S': 'С', 'Š': 'Ш', 'T': 'Т', 'U': 'У', 'V': 'В',
  'Z': 'З', 'Ž': 'Ж',
};

function toSrCyrl(text) {
  let result = '';
  let i = 0;
  while (i < text.length) {
    // Try digraphs first (lj, nj, dž)
    if (i + 1 < text.length) {
      const di = text.substring(i, i + 2);
      if (SR_CYRL_MAP[di]) {
        result += SR_CYRL_MAP[di];
        i += 2;
        continue;
      }
    }
    const ch = text[i];
    result += SR_CYRL_MAP[ch] || ch;
    i++;
  }
  return result;
}

// ---------------------------------------------------------------------------
// Serbian Latin → Russian Cyrillic mapping (pharmaceutical)
// Different from Serbian Cyrillic! (й not ј, ль not љ, etc.)
// ---------------------------------------------------------------------------

const RU_MAP = {
  'lj': 'ль', 'Lj': 'Ль', 'LJ': 'ЛЬ',
  'nj': 'нь', 'Nj': 'Нь', 'NJ': 'НЬ',
  'dž': 'дж', 'Dž': 'Дж', 'DŽ': 'ДЖ',
  'a': 'а', 'b': 'б', 'c': 'ц', 'č': 'ч', 'ć': 'ч',
  'd': 'д', 'đ': 'дж', 'e': 'е', 'f': 'ф', 'g': 'г',
  'h': 'х', 'i': 'и', 'j': 'й', 'k': 'к', 'l': 'л',
  'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п', 'r': 'р',
  's': 'с', 'š': 'ш', 't': 'т', 'u': 'у', 'v': 'в',
  'z': 'з', 'ž': 'ж',
  'A': 'А', 'B': 'Б', 'C': 'Ц', 'Č': 'Ч', 'Ć': 'Ч',
  'D': 'Д', 'Đ': 'Дж', 'E': 'Е', 'F': 'Ф', 'G': 'Г',
  'H': 'Х', 'I': 'И', 'J': 'Й', 'K': 'К', 'L': 'Л',
  'M': 'М', 'N': 'Н', 'O': 'О', 'P': 'П', 'R': 'Р',
  'S': 'С', 'Š': 'Ш', 'T': 'Т', 'U': 'У', 'V': 'В',
  'Z': 'З', 'Ž': 'Ж',
};

function toRu(text) {
  let result = '';
  let i = 0;
  while (i < text.length) {
    if (i + 1 < text.length) {
      const di = text.substring(i, i + 2);
      if (RU_MAP[di]) {
        result += RU_MAP[di];
        i += 2;
        continue;
      }
    }
    const ch = text[i];
    result += RU_MAP[ch] || ch;
    i++;
  }
  return result;
}

// ---------------------------------------------------------------------------
// Serbian INN → English INN suffix mappings
// ---------------------------------------------------------------------------

const SUFFIX_MAP_EN = [
  // Order matters — longer suffixes first
  ['acetilsalicilna kiselina', 'acetylsalicylic acid'],
  ['alendronska kiselina', 'alendronic acid'],
  ['aminokapronska kiselina', 'aminocaproic acid'],
  ['askorbinska kiselina', 'ascorbic acid'],
  ['folna kiselina', 'folic acid'],
  ['fumarna kiselina', 'fumaric acid'],
  ['gadoterinska kiselina', 'gadoteric acid'],
  ['hlorovodonična kiselina', 'hydrochloric acid'],
  ['ibandronska kiselina', 'ibandronic acid'],
  ['lizinasetilsalicilna kiselina', 'lysine acetylsalicylate'],
  ['mefenaminska kiselina', 'mefenamic acid'],
  ['mikofenolna kiselina', 'mycophenolic acid'],
  ['obetihol kiselina', 'obeticholic acid'],
  ['pipemidna kiselina', 'pipemidic acid'],
  ['risedronska kiselina', 'risedronic acid'],
  ['traneksaminska kiselina', 'tranexamic acid'],
  ['ursodeoksiholna kiselina', 'ursodeoxycholic acid'],
  ['valproinska kiselina', 'valproic acid'],
  ['zoledronska kiselina', 'zoledronic acid'],
  ['kiselina', 'acid'],
];

const WORD_MAP_EN = {
  // Common pharmaceutical words
  'gvožđe': 'iron', 'kalcijum': 'calcium', 'kalijum': 'potassium',
  'natrijum': 'sodium', 'magnezijum': 'magnesium', 'aluminijum': 'aluminium',
  'cink': 'zinc', 'bakar': 'copper', 'hlor': 'chlorine',
  'hidroksid': 'hydroxide', 'hlorid': 'chloride', 'sulfat': 'sulfate',
  'karbonat': 'carbonate', 'acetat': 'acetate', 'fosfat': 'phosphate',
  'oksid': 'oxide', 'bromid': 'bromide', 'nitrat': 'nitrate',
  'glicerofosfat': 'glycerophosphate', 'askorbat': 'ascorbate',
  'kompleks': 'complex', 'gel': 'gel', 'polimaltozni': 'polymaltose',
  'bezodni': 'anhydrous', 'monohidrat': 'monohydrate', 'dihidrat': 'dihydrate',
  'trihidrat': 'trihydrate', 'tetrahidrat': 'tetrahydrate',
  'prekršteno': 'cross-linked', 'prečišćeno': 'purified',
  'sojino': 'soy', 'ulje': 'oil', 'voda': 'water',
  'za': 'for', 'injekciju': 'injection', 'i': 'and',
  'sa': 'with', 'bez': 'without', 'ili': 'or',
  'humani': 'human', 'rekombinantni': 'recombinant',
  'iii': 'III', 'ii': 'II',
};

// INN name suffix conversions (Serbian → English)
const INN_SUFFIX_RULES = [
  [/cilna$/i, 'cylic'],        // acetilsalicilna → acetylsalicylic
  [/cikl/i, 'cycl'],
  [/ks/g, 'x'],                // amoksicilin → amoxicillin
  [/cetin$/i, 'cetine'],
  [/mab$/i, 'mab'],            // biologics keep suffix
  [/nib$/i, 'nib'],            // kinase inhibitors
  [/lib$/i, 'lib'],
  [/zumab$/i, 'zumab'],
  [/ximab$/i, 'ximab'],
];

function toEnglishINN(src) {
  // Check exact suffix mappings first
  for (const [srSuffix, enSuffix] of SUFFIX_MAP_EN) {
    if (src.toLowerCase() === srSuffix) return enSuffix;
    if (src.toLowerCase().endsWith(' ' + srSuffix)) {
      return src.substring(0, src.length - srSuffix.length) + enSuffix;
    }
  }

  // Word-by-word replacement for compound names
  let result = src;
  for (const [sr, en] of Object.entries(WORD_MAP_EN)) {
    const re = new RegExp('\\b' + sr.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\b', 'gi');
    result = result.replace(re, en);
  }

  // Common character substitutions for INN
  result = result
    .replace(/đ/g, 'dj')
    .replace(/Đ/g, 'Dj')
    .replace(/š/g, 'sh')
    .replace(/Š/g, 'Sh')
    .replace(/č/g, 'ch')
    .replace(/Č/g, 'Ch')
    .replace(/ć/g, 'c')
    .replace(/Ć/g, 'C')
    .replace(/ž/g, 'zh')
    .replace(/Ž/g, 'Zh');

  return result;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

const substances = JSON.parse(readFileSync(resolve(ROOT, 'data/substances-list.json'), 'utf-8'))
  .filter(s => !/^\d+\)?$/.test(s) && s.length >= 3);

console.log(`Generating translations for ${substances.length} substances...\n`);

let batchNum = 0;
let totalWritten = 0;

for (let i = 0; i < substances.length; i += BATCH_SIZE) {
  batchNum++;
  const batch = substances.slice(i, i + BATCH_SIZE);
  const fileName = `batch-${String(batchNum).padStart(3, '0')}.json`;

  const translations = batch.map(src => ({
    src,
    en: toEnglishINN(src),
    sr: src,
    sr_cyrl: toSrCyrl(src),
    ru: toRu(src),
    de: toEnglishINN(src), // German pharma uses international INN
    tr: toEnglishINN(src), // Turkish pharma uses international INN
  }));

  const outPath = resolve(OUT_DIR, fileName);
  writeFileSync(outPath, JSON.stringify(translations, null, 2), 'utf-8');
  totalWritten += batch.length;
  console.log(`  ${fileName}: ${batch.length} items`);
}

console.log(`\n✓ Written ${totalWritten} substances in ${batchNum} batches to ${OUT_DIR}`);

// Quick quality check
const sample = ['paracetamol', 'acetilsalicilna kiselina', 'ibuprofen', 'amoksicilin', 'gvožđe (iii) hidroksid polimaltozni kompleks'];
console.log('\nSample translations:');
for (const s of sample) {
  const found = substances.includes(s);
  if (!found) continue;
  console.log(`  ${s}`);
  console.log(`    en:      ${toEnglishINN(s)}`);
  console.log(`    sr_cyrl: ${toSrCyrl(s)}`);
  console.log(`    ru:      ${toRu(s)}`);
}
