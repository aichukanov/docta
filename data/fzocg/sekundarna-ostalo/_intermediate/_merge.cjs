// Merge SEKUNDARNA OSTALO batches + amendments → LATEST.json
const fs = require('fs');
const path = require('path');

const DIR = path.resolve(__dirname);
const BATCH_FILES = [
  'batch-1-base-pages-005-021.json',
  'batch-2-base-pages-022-039.json',
  'batch-3-base-pages-040-056.json',
  'batch-4-base-pages-057-072.json',
  'batch-5-base-pages-073-087.json',
  'batch-6-base-pages-088-101.json',
  'batch-7-base-pages-102-118.json',
  'batch-8-missing-sections.json',
];
const AMEND_FILE = 'batch-amendments-all.json';
const OUT_FILE = 'sekundarna-ostalo-LATEST.json';

function readJSON(name) {
  return JSON.parse(fs.readFileSync(path.join(DIR, name), 'utf8'));
}

// Determine pricing scheme of a base item based on which price fields are non-null.
function classifyScheme(item) {
  const op = item.price_operacija_eur;
  const an = item.price_anestezija_eur ?? item.price_opsta_anestezija_eur;
  const uk = item.price_ukupno_eur;
  if (op != null || an != null || uk != null) return 'operacija';
  const odj = item.price_odjeljenje_eur;
  const amb = item.price_ambulanta_eur;
  if (odj != null && amb != null) return 'dual';
  if (odj != null && amb == null) return 'single_odjeljenje';
  if (odj == null && amb != null) return 'single_ambulanta';
  return 'unknown';
}

// Normalize batch-5 field name price_opsta_anestezija_eur → price_anestezija_eur
function normalizeItem(item) {
  const out = { ...item };
  if ('price_opsta_anestezija_eur' in out) {
    out.price_anestezija_eur = out.price_opsta_anestezija_eur;
    delete out.price_opsta_anestezija_eur;
  }
  // Ensure canonical price fields exist (null if absent)
  const fields = [
    'price_odjeljenje_eur', 'price_ambulanta_eur',
    'price_operacija_eur', 'price_anestezija_eur', 'price_ukupno_eur',
  ];
  for (const f of fields) if (!(f in out)) out[f] = null;
  return out;
}

// === Load all base batches ===
const base = new Map(); // code → array of items (handle dupes)
const baseOrder = []; // preserve insertion order
const sectionCounts = {};
let totalLoaded = 0;
let dupeCodes = 0;

for (const fname of BATCH_FILES) {
  const j = readJSON(fname);
  for (const raw of j.items) {
    const item = normalizeItem(raw);
    item.price_scheme = classifyScheme(item);
    item.amended_from = null;
    item.added_in = null;
    item._source_batch = j.batch;
    totalLoaded++;

    const sec = item.section || '(none)';
    sectionCounts[sec] = (sectionCounts[sec] || 0) + 1;

    if (!base.has(item.code)) {
      base.set(item.code, [item]);
      baseOrder.push(item.code);
    } else {
      // duplicate code → keep both
      const arr = base.get(item.code);
      arr.push(item);
      dupeCodes++;
      const note = `VERIFY: duplicate code ${item.code} across base (instances: ${arr.length})`;
      item.note = item.note ? `${item.note} | ${note}` : note;
      arr[0].note = arr[0].note && arr[0].note.includes('VERIFY: duplicate code')
        ? arr[0].note : (arr[0].note ? `${arr[0].note} | ${note}` : note);
    }
  }
}

console.log(`Base items loaded: ${totalLoaded}, unique codes: ${base.size}, duplicate occurrences: ${dupeCodes}`);

// === Load + sort amendments ===
const amendData = readJSON(AMEND_FILE);
const amendments = [...amendData.amendments].sort((a, b) => a.effective_from.localeCompare(b.effective_from));

// Apply price from amendment item to base item
function applyPriceToBaseItem(baseItem, amItem, effective) {
  // Determine which fields the amendment provides
  const amOdj = amItem.price_odjeljenje_eur;
  const amAmb = amItem.price_ambulanta_eur;
  const amSingle = amItem.price_eur;
  const hasDual = amOdj !== undefined || amAmb !== undefined;
  const scheme = baseItem.price_scheme;

  if (hasDual) {
    if (amOdj !== undefined) baseItem.price_odjeljenje_eur = amOdj;
    if (amAmb !== undefined) baseItem.price_ambulanta_eur = amAmb;
    baseItem.price_scheme = classifyScheme(baseItem);
  } else if (amSingle !== undefined && amSingle !== null) {
    // Single price_eur — map based on base scheme
    if (scheme === 'operacija') {
      baseItem.price_ukupno_eur = amSingle;
      const n = `AMEND ${effective}: single price_eur applied to price_ukupno_eur (operacija scheme)`;
      baseItem.note = baseItem.note ? `${baseItem.note} | ${n}` : n;
    } else if (scheme === 'single_ambulanta') {
      baseItem.price_ambulanta_eur = amSingle;
    } else if (scheme === 'single_odjeljenje') {
      baseItem.price_odjeljenje_eur = amSingle;
    } else if (scheme === 'dual') {
      // Ambiguous — apply to both, flag
      baseItem.price_odjeljenje_eur = amSingle;
      baseItem.price_ambulanta_eur = amSingle;
      const n = `VERIFY AMEND ${effective}: single price_eur=${amSingle} applied to both odjeljenje & ambulanta`;
      baseItem.note = baseItem.note ? `${baseItem.note} | ${n}` : n;
    } else {
      // unknown — default to ambulanta
      baseItem.price_ambulanta_eur = amSingle;
      const n = `VERIFY AMEND ${effective}: scheme=unknown, single price applied to ambulanta`;
      baseItem.note = baseItem.note ? `${baseItem.note} | ${n}` : n;
    }
  }
  // Always recompute scheme after price changes
  baseItem.price_scheme = classifyScheme(baseItem);
  // else: amendment has no price (e.g. brisanje) — no-op
  baseItem.amended_from = effective;
}

const amendmentsApplied = [];
let stats = { izmjena_applied: 0, izmjena_missing_base: 0, dopuna_added: 0, dopuna_dup_existing: 0, brisanje_applied: 0, brisanje_missing: 0 };

for (const am of amendments) {
  let changed = 0;
  for (const amItem of am.items) {
    const code = amItem.code;
    const action = amItem.action;

    if (action === 'izmjena') {
      const arr = base.get(code);
      if (!arr || arr.length === 0) {
        // Missing — add as new with note
        const newItem = normalizeItem({
          code,
          name_sr_latin: amItem.name_sr_latin,
          section: amItem.section_ref || null,
          subsection: null,
        });
        newItem.price_scheme = 'unknown';
        newItem.amended_from = null;
        newItem.added_in = am.effective_from;
        newItem.note = `NEW_FROM_AMENDMENT_NO_BASE: izmjena ${am.broj} for code not present in base`;
        applyPriceToBaseItem(newItem, amItem, am.effective_from);
        newItem.amended_from = null; // it's brand-new from amendment
        base.set(code, [newItem]);
        baseOrder.push(code);
        stats.izmjena_missing_base++;
        changed++;
      } else {
        for (const baseItem of arr) {
          applyPriceToBaseItem(baseItem, amItem, am.effective_from);
          stats.izmjena_applied++;
          changed++;
        }
      }
    } else if (action === 'dopuna') {
      if (base.has(code)) {
        const arr = base.get(code);
        // Apply price update too, since it's effectively adding/setting; treat as izmjena fallback with note
        for (const baseItem of arr) {
          applyPriceToBaseItem(baseItem, amItem, am.effective_from);
          const n = `AMEND ${am.effective_from} dopuna: code already in base, treated as izmjena`;
          baseItem.note = baseItem.note ? `${baseItem.note} | ${n}` : n;
        }
        stats.dopuna_dup_existing++;
      } else {
        const newItem = normalizeItem({
          code,
          name_sr_latin: amItem.name_sr_latin,
          section: amItem.section_ref || null,
          subsection: null,
        });
        newItem.price_scheme = 'unknown';
        newItem.added_in = am.effective_from;
        newItem.amended_from = null;
        applyPriceToBaseItem(newItem, amItem, am.effective_from);
        // After applying price, recompute scheme
        newItem.price_scheme = classifyScheme(newItem);
        newItem.amended_from = null; // dopuna is initial price; not amended_from
        base.set(code, [newItem]);
        baseOrder.push(code);
        stats.dopuna_added++;
      }
      changed++;
    } else if (action === 'brisanje') {
      if (base.has(code)) {
        const arr = base.get(code);
        for (const baseItem of arr) {
          baseItem.deleted = true;
          baseItem.deleted_from = am.effective_from;
          baseItem.amended_from = am.effective_from;
        }
        stats.brisanje_applied++;
        changed++;
      } else {
        stats.brisanje_missing++;
      }
    } else {
      console.warn(`Unknown action: ${action} for code ${code}`);
    }
  }
  amendmentsApplied.push({
    effective_from: am.effective_from,
    broj: am.broj,
    items_changed: changed,
    signed_date: am.signed_date || null,
  });
}

// === Build final ===
const finalItems = [];
for (const code of baseOrder) {
  for (const item of base.get(code)) {
    // strip internal fields
    delete item._source_batch;
    // Re-classify scheme once at the end (catches any items whose scheme wasn't refreshed)
    item.price_scheme = classifyScheme(item);
    finalItems.push(item);
  }
}

// Recount sections + scheme distribution (after amendments)
const finalSectionCounts = {};
const schemeCounts = {};
let deletedCount = 0;
for (const it of finalItems) {
  if (it.deleted) deletedCount++;
  const sec = it.section || '(none)';
  finalSectionCounts[sec] = (finalSectionCounts[sec] || 0) + 1;
  schemeCounts[it.price_scheme] = (schemeCounts[it.price_scheme] || 0) + 1;
}

// Known extraction gaps from base PDF.
// Most gaps now filled by batch-8-missing-sections.json (manually re-extracted from PDF page images).
const knownGaps = [
  "FILLED by batch-8: Section 4 GENETIKA intro K05001-K05018 (p.21-bot).",
  "FILLED by batch-8: Section 8 OPŠTA INTERNA MEDICINA — E02001/E02002 (p.39-top).",
  "FILLED by batch-8: Section 9 PULMOLOGIJA/PNEUMOFTIZIOLOGIJA — E07001-E07004 + INTERVENCIJE X17001-X17007 + TERCIJARNA X18001-X18006 (p.39).",
  "FILLED by batch-8: Section 10 ENDOKRINOLOGIJA intro — E08001, E08003-E08006 (p.39-bot).",
  "FILLED by batch-8: Section 32 MAKSILOFACIJALNA HIRURGIJA — S08001/S08002 + INTERVENCIJE X28001-X28016 (p.56).",
  "FILLED by batch-8: Section 33 DJEČJA HIRURGIJA — S09001/S09002 (p.56-bot). No procedures visible in source PDF for this section.",
  "FILLED by batch-8: Section 34 GINEKOLOGIJA pregled C03001-C03004 (p.56-bot). Subsection X04xxx INTERVENCIJE already in batch-4.",
  "FIXED: J07007 'Ultrazvuk štitne i paraštitne žlijezde' (section 6 ULTRAZVUČNA) — was OCR-misread as J07014 in batch-2 (J07014 does not exist in source base PDF; sequence is non-linear). User confirmed via base PDF p.29 scan; code corrected to J07007 in batch-2.",
  "FIXED: Section 52 B01xxx codes — batch-7 had B01003 mis-OCR'd (should be B01001 per base PDF). Amendment 01-699 (2025-02-01) had codes for items 72-76 shifted by one row: B01001→B01005, B01002→B01001, B01005→B01006, B01002_kontrolni→B01002. User-verified via both base PDF and amendment scans; corrections applied to batch-7 and batch-amendments-all.json.",
  "AMENDMENT-INTRODUCED CODE (not a base gap): J07014 'Ultrazvuk pregled vrata' — added by 2022-07-01 amendment (01-5113) as a new code; not present in base PDF p.29 where sequence skips from J07013 to J07015. Treated as NEW_FROM_AMENDMENT_NO_BASE.",
];

const out = {
  source: "Cjenovnik FZOCG sekundarna i tercijarna zdravstvena zaštita — ostalo bolničko + specijalističko",
  base_pdf: "15846071842.-Cjenovnik-zdravstvenih-usluga-na-sekundarnom-i.pdf",
  base_signed: "2015-07-29",
  base_broj: "01-4596",
  level: "sekundarna i tercijarna zdravstvena zaštita — ostalo bolničko liječenje i specijalističko konsultativna i dijagnostička zdravstvena zaštita",
  amendments_applied: amendmentsApplied,
  extracted_date: "2026-05-13",
  items_total: finalItems.length,
  items_deleted: deletedCount,
  items_active: finalItems.length - deletedCount,
  sections: finalSectionCounts,
  price_schemes_note: {
    dual: "price_odjeljenje_eur + price_ambulanta_eur both present",
    single_ambulanta: "single CIJENA column in source PDF — value stored in price_ambulanta_eur (odjeljenje null)",
    single_odjeljenje: "single CIJENA column — value stored in price_odjeljenje_eur (ambulanta null)",
    operacija: "OPERACIJE sections use Operacija + Opšta anestezija = Ukupno → price_operacija_eur / price_anestezija_eur / price_ukupno_eur",
    unknown: "scheme not determinable",
  },
  merge_stats: {
    base_items_loaded: totalLoaded,
    base_unique_codes: baseOrder.length,
    base_duplicate_occurrences: dupeCodes,
    ...stats,
    price_scheme_distribution: schemeCounts,
  },
  extraction_gaps: knownGaps,
  items: finalItems,
};

fs.writeFileSync(path.join(DIR, OUT_FILE), JSON.stringify(out, null, 2));
console.log('\nWritten:', OUT_FILE);
console.log('items_total:', finalItems.length, '| deleted:', deletedCount, '| active:', finalItems.length - deletedCount);
console.log('amendments_applied:', amendmentsApplied.length);
console.log('stats:', JSON.stringify(stats, null, 2));
console.log('\nsections:');
for (const [k, v] of Object.entries(finalSectionCounts)) console.log(`  ${v.toString().padStart(4)}  ${k}`);
