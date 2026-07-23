// Cross-reference: messages naming a drug AND signalling unavailability / "bring from abroad".
// Reads index.jsonl produced by build-index.mjs. Prints compact hits + a product frequency
// tally, and writes the hits to data/chat-exports/_analysis/unavailable-meds.jsonl.
//
// Run: node scripts/chat-index/find-unavailable-meds.mjs

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const BASE = join('data', 'chat-exports');
const DIRS = ['t.me-MonteLiveFamily_2026-07-17', 't.me-medicina_montenegro-2026-03-20'];

const UNAVAIL = [
  'нет в аптек', 'не найти', 'не найд', 'не прода', 'не купить', 'не достать',
  'нельзя купить', 'из белград', 'из серби', 'привез', 'привоз', 'заказыва', 'передач',
  'нет аналог', 'чем заменить', 'не зарегистр', 'тут нет', 'здесь нет', 'нет в чг',
  'нет в черногор', 'везут из', 'не выпускают', 'нет такого', 'по рецепту только',
];
const PRODUCTS = {
  'энтеросгель': ['энтеросгел'], 'регидрон': ['регидрон'], 'зиртек/цетиризин': ['зиртек', 'цетиризин'],
  'но-шпа': ['но-шпа', 'ношпа'], 'смекта': ['смект'], 'нурофен': ['нурофен'],
  'мирамистин': ['мирамистин'], 'валидол': ['валидол'], 'зелёнка': ['зелёнк', 'зеленк'],
  'супрастин': ['супрастин'], 'эргоферон': ['эргоферон'], 'полисорб': ['полисорб'],
  'фенистил': ['фенистил'], 'виферон': ['виферон'], 'мезим/креон': ['мезим', 'креон'],
  'активированный уголь': ['активированный уголь', 'активиров'], 'перекись': ['перекис'],
  'йод': ['йод '], 'нурофен детский': ['нурофен дет'], 'парацетамол детский': ['парацетамол дет'],
  'анальгин/метамизол': ['анальгин', 'метамизол'], 'аспирин': ['аспирин'],
  'антибиотик без рецепта': ['антибиотик'],
};

const hits = [];
const tally = {};
for (const dir of DIRS) {
  const lines = readFileSync(join(BASE, dir, 'index.jsonl'), 'utf8').split('\n').filter(Boolean);
  for (const ln of lines) {
    const r = JSON.parse(ln);
    const low = r.text.toLowerCase();
    if (!UNAVAIL.some((u) => low.includes(u))) continue;
    const named = Object.entries(PRODUCTS).filter(([, terms]) => terms.some((t) => low.includes(t))).map(([n]) => n);
    if (!named.length) continue;
    hits.push({ chat: dir.includes('Family') ? 'family' : 'medicina', ...r, products: named });
    for (const n of named) tally[n] = (tally[n] || 0) + 1;
  }
}

mkdirSync(join(BASE, '_analysis'), { recursive: true });
writeFileSync(join(BASE, '_analysis', 'unavailable-meds.jsonl'), hits.map((h) => JSON.stringify(h)).join('\n') + '\n', 'utf8');

console.log('=== product mentions in unavailability context ===');
console.log(Object.entries(tally).sort((a, b) => b[1] - a[1]).map(([n, c]) => `${c}\t${n}`).join('\n'));
console.log('\n=== hits (' + hits.length + ') ===');
for (const h of hits) {
  console.log(`[${h.chat} #${h.id} ${h.date.slice(0, 10)}] {${h.products.join(', ')}}\n  ${h.text.slice(0, 260)}`);
}
