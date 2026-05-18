#!/usr/bin/env node
/**
 * Rebuild substance translation batches:
 * - Remove entries not in substances-list.json
 * - Add missing entries (vaccines, herbal with correct parens)
 * - Re-sort and re-batch
 */

import { readFileSync, writeFileSync, readdirSync, existsSync, unlinkSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const DIR = resolve(ROOT, 'data/med-translations/substances');
const BATCH = 40;

const newSubs = new Set(JSON.parse(readFileSync(resolve(ROOT, 'data/substances-list.json'), 'utf8')));

// Collect valid existing translations
const all = [];
for (const f of readdirSync(DIR).filter(f => f.endsWith('.json')).sort()) {
  for (const s of JSON.parse(readFileSync(resolve(DIR, f), 'utf8'))) {
    if (newSubs.has(s.src)) {
      all.push(s);
      newSubs.delete(s.src);
    }
  }
}

// Add missing vaccine/herbal entries
const missing = [
  {src:"haemophilus influenzae tip b (konjugovana, adsorbovana)", en:"Haemophilus influenzae type b (conjugated, adsorbed)", sr:"Haemophilus influenzae tip b (konjugovana, adsorbovana)", sr_cyrl:"Haemophilus influenzae тип б (конјугована, адсорбована)", ru:"гемофильная палочка тип b (конъюгированная, адсорбированная)", de:"Haemophilus influenzae Typ b (konjugiert, adsorbiert)", tr:"Haemophilus influenzae tip b (konjuge, adsorbe)"},
  {src:"poliomijelitisa (inaktivisana) i haemophilus influenzae tip b (konjugovana, adsorbovana)", en:"poliomyelitis (inactivated) and Haemophilus influenzae type b (conjugated, adsorbed)", sr:"poliomijelitisa (inaktivisana) i Haemophilus influenzae tip b (konjugovana, adsorbovana)", sr_cyrl:"полиомијелитиса (инактивисана) и Haemophilus influenzae тип б (конјугована, адсорбована)", ru:"полиомиелита (инактивированная) и гемофильной палочки тип b (конъюгированная, адсорбированная)", de:"Poliomyelitis (inaktiviert) und Haemophilus influenzae Typ b (konjugiert, adsorbiert)", tr:"poliomiyelit (inaktive) ve Haemophilus influenzae tip b (konjuge, adsorbe)"},
  {src:"testerasta palma (serenoa repens (w. bartram) small, fructus)", en:"saw palmetto (Serenoa repens (W. Bartram) Small, fructus)", sr:"testerasta palma (Serenoa repens (W. Bartram) Small, fructus)", sr_cyrl:"тестераста палма (Serenoa repens (W. Bartram) Small, fructus)", ru:"пальма сабаль (Serenoa repens (W. Bartram) Small, плоды)", de:"Sägepalme (Serenoa repens (W. Bartram) Small, Fructus)", tr:"cüce palmiye (Serenoa repens (W. Bartram) Small, fructus)"},
  {src:"trovalentna vakcina protiv gripa (fragmentisani virus, inaktivisana)", en:"trivalent influenza vaccine (split virus, inactivated)", sr:"trovalentna vakcina protiv gripa (fragmentisani virus, inaktivisana)", sr_cyrl:"тровалентна вакцина против грипа (фрагментисани вирус, инактивисана)", ru:"трёхвалентная вакцина против гриппа (расщеплённый вирус, инактивированная)", de:"trivalenter Grippeimpfstoff (Spaltvirus, inaktiviert)", tr:"trivalan grip aşısı (parçalanmış virüs, inaktive)"},
  {src:"vakcina protiv covid-19 (ad26.cov2-s, rekombinantna)", en:"COVID-19 vaccine (Ad26.COV2-S, recombinant)", sr:"vakcina protiv COVID-19 (Ad26.COV2-S, rekombinantna)", sr_cyrl:"вакцина против COVID-19 (Ad26.COV2-S, рекомбинантна)", ru:"вакцина против COVID-19 (Ad26.COV2-S, рекомбинантная)", de:"COVID-19-Impfstoff (Ad26.COV2-S, rekombinant)", tr:"COVID-19 aşısı (Ad26.COV2-S, rekombinant)"},
  {src:"vakcina protiv covid-19 (chadox1-s, rekombinantna)", en:"COVID-19 vaccine (ChAdOx1-S, recombinant)", sr:"vakcina protiv COVID-19 (ChAdOx1-S, rekombinantna)", sr_cyrl:"вакцина против COVID-19 (ChAdOx1-S, рекомбинантна)", ru:"вакцина против COVID-19 (ChAdOx1-S, рекомбинантная)", de:"COVID-19-Impfstoff (ChAdOx1-S, rekombinant)", tr:"COVID-19 aşısı (ChAdOx1-S, rekombinant)"},
  {src:"vakcina protiv difterije tetanusa i poliomijelitisa (inaktivisana, adsorbovana)", en:"diphtheria, tetanus and poliomyelitis (inactivated, adsorbed) vaccine", sr:"vakcina protiv difterije tetanusa i poliomijelitisa (inaktivisana, adsorbovana)", sr_cyrl:"вакцина против дифтерије тетануса и полиомијелитиса (инактивисана, адсорбована)", ru:"вакцина против дифтерии, столбняка и полиомиелита (инактивированная, адсорбированная)", de:"Diphtherie-, Tetanus- und Poliomyelitis-Impfstoff (inaktiviert, adsorbiert)", tr:"difteri, tetanos ve poliomiyelit (inaktive, adsorbe) aşısı"},
  {src:"vakcina protiv gripa (inaktivisana, rascijepana virusna čestica)", en:"influenza vaccine (inactivated, split virion)", sr:"vakcina protiv gripa (inaktivisana, rascijepana virusna čestica)", sr_cyrl:"вакцина против грипа (инактивисана, расцијепана вирусна честица)", ru:"вакцина против гриппа (инактивированная, расщеплённый вирион)", de:"Grippeimpfstoff (inaktiviert, Spaltvirus)", tr:"grip aşısı (inaktive, parçalanmış virion)"},
  {src:"vakcina protiv gripa (površinski antigeni, inaktivisana)", en:"influenza vaccine (surface antigen, inactivated)", sr:"vakcina protiv gripa (površinski antigeni, inaktivisana)", sr_cyrl:"вакцина против грипа (површински антигени, инактивисана)", ru:"вакцина против гриппа (поверхностный антиген, инактивированная)", de:"Grippeimpfstoff (Oberflächenantigen, inaktiviert)", tr:"grip aşısı (yüzey antijeni, inaktive)"},
  {src:"vakcina protiv hepatitisa a (inaktivisana, adsorbovana)", en:"hepatitis A vaccine (inactivated, adsorbed)", sr:"vakcina protiv hepatitisa A (inaktivisana, adsorbovana)", sr_cyrl:"вакцина против хепатитиса А (инактивисана, адсорбована)", ru:"вакцина против гепатита A (инактивированная, адсорбированная)", de:"Hepatitis-A-Impfstoff (inaktiviert, adsorbiert)", tr:"hepatit A aşısı (inaktive, adsorbe)"},
  {src:"vakcina protiv humanog papilomavirusa (tipovi 6, 11, 16, 18)", en:"human papillomavirus vaccine (types 6, 11, 16, 18)", sr:"vakcina protiv humanog papilomavirusa (tipovi 6, 11, 16, 18)", sr_cyrl:"вакцина против хуманог папиломавируса (типови 6, 11, 16, 18)", ru:"вакцина против вируса папилломы человека (типы 6, 11, 16, 18)", de:"Humaner Papillomavirus-Impfstoff (Typen 6, 11, 16, 18)", tr:"insan papilloma virüsü aşısı (tip 6, 11, 16, 18)"},
  {src:"vakcina protiv humanog papilomavirusa 9-ovalentna (tipovi 6, 11, 16, 18, 31, 33, 45, 52, 58)", en:"human papillomavirus vaccine 9-valent (types 6, 11, 16, 18, 31, 33, 45, 52, 58)", sr:"vakcina protiv humanog papilomavirusa 9-ovalentna (tipovi 6, 11, 16, 18, 31, 33, 45, 52, 58)", sr_cyrl:"вакцина против хуманог папиломавируса 9-овалентна (типови 6, 11, 16, 18, 31, 33, 45, 52, 58)", ru:"вакцина против вируса папилломы человека 9-валентная (типы 6, 11, 16, 18, 31, 33, 45, 52, 58)", de:"9-valenter Humaner Papillomavirus-Impfstoff (Typen 6, 11, 16, 18, 31, 33, 45, 52, 58)", tr:"9-valanlı insan papilloma virüsü aşısı (tip 6, 11, 16, 18, 31, 33, 45, 52, 58)"},
  {src:"četvorovalentna vakcina protiv gripa (fragmentisani virus, inaktivisana)", en:"quadrivalent influenza vaccine (split virus, inactivated)", sr:"četvorovalentna vakcina protiv gripa (fragmentisani virus, inaktivisana)", sr_cyrl:"четворовалентна вакцина против грипа (фрагментисани вирус, инактивисана)", ru:"четырёхвалентная вакцина против гриппа (расщеплённый вирус, инактивированная)", de:"quadrivalenter Grippeimpfstoff (Spaltvirus, inaktiviert)", tr:"kuadrivalan grip aşısı (parçalanmış virüs, inaktive)"},
];

for (const m of missing) {
  if (newSubs.has(m.src)) {
    all.push(m);
    newSubs.delete(m.src);
  }
}

if (newSubs.size) {
  console.log('Still missing:', [...newSubs]);
}

// Sort and write batches
all.sort((a, b) => a.src.localeCompare(b.src));

const totalBatches = Math.ceil(all.length / BATCH);
for (let i = 0; i < all.length; i += BATCH) {
  const n = Math.floor(i / BATCH) + 1;
  const batch = all.slice(i, i + BATCH);
  const fname = `batch-${String(n).padStart(3, '0')}.json`;
  writeFileSync(resolve(DIR, fname), JSON.stringify(batch, null, 2), 'utf-8');
}

// Remove extra files
for (let n = totalBatches + 1; n <= 30; n++) {
  const fname = resolve(DIR, `batch-${String(n).padStart(3, '0')}.json`);
  if (existsSync(fname)) unlinkSync(fname);
}

console.log(`✓ ${all.length} substances in ${totalBatches} batches`);
