// Consolidates normalized per-FORM foreign brand batches into an idempotent SQL insert
// for the product model (med_foreign_products + med_foreign_product_substances).
//
// A foreign product = (market_code, brand_name, pharma_form_id) with a SET of substances
// and one normalized dose. Inputs:
//   - batch-norm-*.json   : per-form MONO entries {market, brand, substances:[src], form:<key>, strength, note}
//   - batch-combo-*.json  : combination products {market, brand, substances:[src...], form:<free-text>, strength, note}
//   - batch-combo-enrich.json : {src, markets:{MK:[{brand, also:[src...]}]}} — adds co-ingredients to a brand
//
// Form is normalized to med_pharma_forms.id (localized names + icon category reused across the app).
// Mono `form` is a vocab KEY (FORM_KEY_TO_ID); combo `form` is free text → classifyFormText → key.
//
// Emits server/sql/migrations/insert-med-foreign-products.sql. Run:
//   node scripts/medicines/build-foreign-products-sql.mjs

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..', '..');
const BRANDS_DIR = join(ROOT, 'data', 'med-foreign-brands');
const TRANS_DIR = join(ROOT, 'data', 'med-translations', 'substances');
const CURATED = join(BRANDS_DIR, '_curated-substances.json');
const OUT_SQL = join(ROOT, 'server', 'sql', 'migrations', 'insert-med-foreign-products.sql');

const MARKETS = ['RU', 'UA', 'TR', 'DE', 'PL', 'US'];

const norm = (s) => (s || '').toString().trim().toLowerCase().replace(/\s+/g, ' ');
const sqlStr = (s) => (s === null || s === undefined || s === '')
  ? 'NULL'
  : `'${s.toString().replace(/'/g, "''")}'`;
const brandKey = (s) => norm(s).replace(/[®™]/g, '').replace(/\s+/g, ' ').trim();

// dose text: drop (OTC)/(Rx)/prescription parentheticals, collapse spaces
const cleanStrength = (s) => {
  if (!s) return null;
  let x = s.toString()
    .replace(/\((?:[^)]*\b(?:otc|rx|prescription|бrecept|рецепт|reçete)\b[^)]*)\)/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .replace(/[;,]\s*$/, '');
  return x || null;
};

// vocab key -> med_pharma_forms.id (chosen representatives, verified against the table)
const FORM_KEY_TO_ID = {
  tablet: 125, film_tablet: 6, effervescent_tablet: 147, chewable_tablet: 129,
  dispersible_tablet: 2, capsule: 24, soft_capsule: 27, syrup: 109,
  oral_suspension: 49, oral_solution: 55, oral_drops: 51, oral_powder_sachet: 82,
  granules_oral: 14, effervescent_granules: 148, lozenge: 41, chewing_gum: 39,
  gel: 10, cream: 36, ointment: 42, suppository: 117, nasal_spray: 112,
  nasal_drops: 18, eye_drops: 19, ear_drops: 21, throat_spray: 114, skin_spray: 111,
  injection: 94, injection_powder: 85, transdermal_patch: 131, vaginal_tablet: 135,
  vaginal_capsule: 133, vaginal_cream: 136,
  // Ингаляционные формы: без них астма и ХОБЛ падали в other и теряли форму,
  // а вместе с ней и сопоставление с карточкой. Категория у всех — 'spray'
  // (enums/pharma-form.ts), так что formMatch работает.
  inhaler_powder: 73,          // Prašak za inhalaciju (DPI, турбухалер и т.п.)
  inhaler_capsule: 75,         // Prašak za inhalaciju, tvrda kapsula
  inhaler_aerosol: 93,         // Rastvor za inhalaciju pod pritiskom (MDI)
  inhaler_aerosol_suspension: 118, // Suspenzija za inhalaciju pod pritiskom
  nebuliser: 105,              // Rastvor za raspršivanje
  nebuliser_suspension: 124,   // Suspenzija za raspršivanje
  // Формы, которых не хватало: без них продукт оставался без формы и в блоке
  // выглядел пустой строкой с одним брендом (Салофальк-клизма, Мирена, Бетадин-раствор)
  skin_solution: 103,          // Rastvor za kožu (наружный раствор)
  skin_foam: 59,               // Pjena za kožu
  skin_powder: 80,             // Prašak za kožu (присыпка)
  rectal_suspension: 108,      // Rektalna suspenzija (клизма)
  rectal_ointment: 107,        // Rektalna mast
  sublingual_tablet: 115,      // Sublingvalna tableta
  intrauterine_system: 17,     // Intrauterini dostavni sistem (ВМС)
  other: null,
};

// free-text form (any market language) -> vocab key (for combo batches)
const FORM_TEXT_RULES = [
  // Ингаляции проверяем ПЕРВЫМИ: «Prašak za inhalaciju» иначе уедет в порошок,
  // а «Suspenzija za inhalaciju» — в оральную суспензию
  [/inhalat|inhaler|ингалят|inhalac|inhalasyon|dosieraerosol/, 'inhaler_aerosol'],
  [/dpi|turbuhaler|diskus|breezhaler|genuair|ellipta|handihaler/, 'inhaler_powder'],
  [/nebul|небулай|raspršiv|verneb/, 'nebuliser'],
  [/klizm|klysm|enema|wlewk|lavman|клизм/, 'rectal_suspension'],
  [/iud|intrauter|внутриматочн|spirala/, 'intrauterine_system'],
  [/sublingual|подъязыч|dil altı/, 'sublingual_tablet'],
  [/pjena|foam|пена|schaum/, 'skin_foam'],
  // «наружный раствор» проверяем ПОСЛЕ спреев и капель, но ДО общего «раствора»
  [/topical solution|раствор наружн|наружный раствор|rastvor za kožu|lösung zur anwendung auf der haut/, 'skin_solution'],
  [/saszet|sachet|kesic|пакет|şase|köpük/, 'oral_powder_sachet'],
  [/powder|порош|prašak|pulver|\btoz\b/, 'oral_powder_sachet'],
  [/granul|гранул/, 'granules_oral'],
  [/effervescent|шипуч|musując|efervesan|šumeć/, 'effervescent_tablet'],
  [/syrup|сироп|syrop|şurup|saft|sirup/, 'syrup'],
  [/suspens|суспенз|zawiesin|suspansiyon/, 'oral_suspension'],
  [/lozenge|pastil|пастил|леденц|таблетки для рассасыв|throat/, 'lozenge'],
  [/kaps|капсул|kapsuł|kapsül/, 'capsule'],
  [/tablet|табле|таблет|tabletk|tablett|draje|dragee|draż|kaplet/, 'tablet'],
  [/gel|гель|żel/, 'gel'],
  [/cream|крем|krem|creme/, 'cream'],
  [/ointment|мазь|maść|salbe|merhem|pomad/, 'ointment'],
  [/suppos|свеч|czopk|fitil|zäpfchen/, 'suppository'],
  [/nasal|назал|nos\b|burun/, 'nasal_spray'],
  [/inject|инъекц|ампул|ampul|iğne|enjeksiyon/, 'injection'],
  // Последним — «просто раствор». Все осмысленные варианты (капли, спрей,
  // ингаляция, инъекция, полоскание, ректальный, для приёма внутрь) уже
  // разобраны выше, поэтому остаток — это наружные антисептики (Бетадин,
  // Октенисепт, Браунол). Без этого правила они оставались без формы и
  // показывались строкой из одного названия бренда.
  [/lotion|лосьон|losion/, 'skin_solution'],
  [/puder|присыпк|powder for skin|prašak za kožu/, 'skin_powder'],
  [/раствор|розчин|roztwór|roztw|lösung|losung|solution|çözelti|rastvor/, 'skin_solution'],
];
const classifyFormText = (text) => {
  const t = norm(text);
  if (!t) return 'other';
  for (const [re, key] of FORM_TEXT_RULES) if (re.test(t)) return key;
  return 'other';
};

// ---- substance name set (validate srcs) ----
const srcSet = new Set();
for (const f of readdirSync(TRANS_DIR).filter((f) => f.endsWith('.json'))) {
  for (const r of JSON.parse(readFileSync(join(TRANS_DIR, f), 'utf8'))) {
    if (r.src) srcSet.add(norm(r.src));
  }
}
const curated = existsSync(CURATED) ? JSON.parse(readFileSync(CURATED, 'utf8')) : [];
for (const c of curated) srcSet.add(norm(c.name));

// ---- load batches ----
const readBatches = (re) =>
  readdirSync(BRANDS_DIR).filter((f) => re.test(f)).sort()
    .flatMap((f) => JSON.parse(readFileSync(join(BRANDS_DIR, f), 'utf8')));
const normEntries = readBatches(/^batch-norm-\d+\.json$/);
const comboEntries = readBatches(/^batch-combo-[a-z]{2}\.json$/);
const enrichEntries = existsSync(join(BRANDS_DIR, 'batch-combo-enrich.json'))
  ? JSON.parse(readFileSync(join(BRANDS_DIR, 'batch-combo-enrich.json'), 'utf8'))
  : [];

// ---- merge into products keyed by (market, brand, form) ----
const products = new Map();
let order = 0;
const unresolved = new Set();
const addProduct = (market, brand, formId, subs, strength, note) => {
  if (!MARKETS.includes(market)) return;
  const bk = brandKey(brand);
  if (!bk) return;
  const key = `${market}|${bk}|${formId ?? 'x'}`;
  let p = products.get(key);
  if (!p) {
    p = { market, brand: brand.replace(/\s+/g, ' ').trim(), formId: formId ?? null, subs: new Set(), strength: null, note: null, order: order++ };
    products.set(key, p);
  }
  for (const s of subs) {
    if (srcSet.has(norm(s))) p.subs.add(s);
    else unresolved.add(s);
  }
  const st = cleanStrength(strength);
  if (!p.strength && st) p.strength = st;
  if (!p.note && note) p.note = note.toString().slice(0, 500);
  return p;
};

// mono per-form entries
for (const e of normEntries) {
  if (!e.brand || !e.market || !Array.isArray(e.substances)) continue;
  // Ключ словаря; если это `other` или незнакомый ключ, пробуем вытащить форму
  // из примечания: агенты писали её словами («Rx; клизма», «OTC; topical
  // solution»), и без этого продукт оставался без формы — в блоке он выглядел
  // пустой строкой с одним названием бренда рядом с той же маркой в норм. форме
  const keyed = e.form in FORM_KEY_TO_ID ? FORM_KEY_TO_ID[e.form] : null;
  const formId =
    keyed != null ? keyed : (FORM_KEY_TO_ID[classifyFormText(e.note || '')] ?? null);
  addProduct(e.market, e.brand, formId, e.substances, e.strength, e.note);
}
// combination products (free-text form)
for (const e of comboEntries) {
  if (!e.brand || !e.market || !Array.isArray(e.substances)) continue;
  const formId = FORM_KEY_TO_ID[classifyFormText(e.form)];
  addProduct(e.market, e.brand, formId, e.substances, e.strength, e.note);
}
// enrich: add co-ingredients (also) + anchor src to every form of a (market, brand)
for (const e of enrichEntries) {
  if (!e.markets) continue;
  for (const market of MARKETS) {
    for (const b of e.markets[market] || []) {
      const bk = brandKey(b.brand);
      const extra = [e.src, ...(b.also || [])].filter((s) => srcSet.has(norm(s)));
      for (const p of products.values()) {
        if (p.market === market && brandKey(p.brand) === bk) {
          for (const s of extra) p.subs.add(s);
        }
      }
    }
  }
}

// ---- build SQL ----
const lines = [];
lines.push('-- Foreign cross-country PRODUCTS, normalized per form (market, brand, pharma_form).');
lines.push('-- Generated by scripts/medicines/build-foreign-products-sql.mjs — ПОЛНАЯ ПЕРЕСБОРКА');
lines.push('-- (DELETE + INSERT в транзакции): upsert не дедуплицировал NULL-формы, см. скрипт.');
lines.push('-- Prereq: 017-med-foreign-products-forms.sql (tables) + medicines/med_pharma_forms loaded.');
lines.push('-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/insert-med-foreign-products.sql');
lines.push('');
lines.push('SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;');
lines.push('');

if (curated.length) {
  lines.push('-- Curated co-ingredient substances (idempotent).');
  for (const c of curated) {
    lines.push(`INSERT INTO med_substances (name, name_en, name_ru, name_de, name_sr, name_sr_cyrl, name_tr)`);
    lines.push(`  VALUES (${sqlStr(c.name)}, ${sqlStr(c.name_en)}, ${sqlStr(c.name_ru)}, ${sqlStr(c.name_de)}, ${sqlStr(c.name_sr)}, ${sqlStr(c.name_sr_cyrl)}, ${sqlStr(c.name_tr)})`);
    lines.push(`  ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_ru=VALUES(name_ru), name_de=VALUES(name_de), name_sr=VALUES(name_sr), name_sr_cyrl=VALUES(name_sr_cyrl), name_tr=VALUES(name_tr);`);
  }
  lines.push('');
}

// Полная пересборка, а не upsert. Причина: UNIQUE (market_code, brand_name,
// pharma_form_id) НЕ дедуплицирует строки с NULL-формой — в MySQL NULL != NULL,
// поэтому каждый повторный прогон файла добавлял ещё одну копию продукта без
// распознанной формы, а связка веществ (WHERE ... IS NULL) цеплялась ко ВСЕМ
// копиям. На проде это дало «Salofalk» 11 раз в одном блоке.
//
// Заодно чинится вторая дыра: upsert не умел удалять продукты, выпавшие из
// батчей, — они оставались в базе навсегда.
lines.push('START TRANSACTION;');
lines.push('DELETE FROM med_foreign_product_substances;');
lines.push('DELETE FROM med_foreign_products;');
lines.push('');
lines.push('-- Products (per market/brand/form) + substance links.');
const ordered = [...products.values()].filter((p) => p.subs.size > 0).sort((a, b) => a.order - b.order);
let linkCount = 0;
const perMarket = Object.fromEntries(MARKETS.map((m) => [m, 0]));
const formWhere = (formId) => formId == null ? 'p.pharma_form_id IS NULL' : `p.pharma_form_id = ${formId}`;
for (const p of ordered) {
  perMarket[p.market]++;
  lines.push(`INSERT INTO med_foreign_products (market_code, brand_name, pharma_form_id, strength, note, sort_order)`);
  lines.push(`  VALUES (${sqlStr(p.market)}, ${sqlStr(p.brand)}, ${p.formId == null ? 'NULL' : p.formId}, ${sqlStr(p.strength)}, ${sqlStr(p.note)}, ${p.order})`);
  lines.push(`  ON DUPLICATE KEY UPDATE strength=VALUES(strength), note=VALUES(note), sort_order=VALUES(sort_order);`);
  for (const s of p.subs) {
    linkCount++;
    lines.push(`INSERT INTO med_foreign_product_substances (product_id, substance_id)`);
    lines.push(`  SELECT p.id, s.id FROM med_foreign_products p JOIN med_substances s ON s.name = ${sqlStr(s)}`);
    lines.push(`  WHERE p.market_code = ${sqlStr(p.market)} AND p.brand_name = ${sqlStr(p.brand)} AND ${formWhere(p.formId)}`);
    lines.push(`  ON DUPLICATE KEY UPDATE product_id = product_id;`);
  }
}

lines.push('');
lines.push('COMMIT;');
lines.push('');
lines.push('-- VERIFICATION: числа должны совпасть с отчётом скрипта');
lines.push('SELECT COUNT(*) AS products FROM med_foreign_products;');
lines.push('SELECT COUNT(*) AS substance_links FROM med_foreign_product_substances;');
lines.push(
  "SELECT COUNT(*) AS duplicate_brand_form FROM (SELECT market_code, brand_name, IFNULL(pharma_form_id, 0) f FROM med_foreign_products GROUP BY market_code, brand_name, f HAVING COUNT(*) > 1) q;",
);

writeFileSync(OUT_SQL, lines.join('\n') + '\n', 'utf8');

// ---- report ----
console.log(JSON.stringify({
  normEntries: normEntries.length,
  comboEntries: comboEntries.length,
  products: ordered.length,
  multiSubstance: ordered.filter((p) => p.subs.size > 1).length,
  substanceLinks: linkCount,
  perMarket,
  nullForm: ordered.filter((p) => p.formId == null).length,
  unresolvedSubstances: [...unresolved],
}, null, 2));
