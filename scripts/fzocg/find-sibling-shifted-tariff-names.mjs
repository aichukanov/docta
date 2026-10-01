#!/usr/bin/env node
/**
 * Второй детектор сдвинутых имён тарифов — сдвиг к соседу по серии.
 *
 * find-shifted-tariff-names.mjs сравнивает имена по триграммам и не видит
 * сдвига там, где соседние позиции отличаются одним словом: «Longeta od
 * ramena do šake» против «Longeta podlaktice i šake», «Ekscizija manjih
 * lezija» против «malignih», биопсия «pleure» против «pluća». Здесь
 * сравниваются множества слов отремонтированного OCR и имени в БД: у каждого
 * должно быть своё содержательное слово, которого нет у другого (варианты
 * одного слова — склонение, ije/je, dj/đ — не в счёт). Кто прав, решает
 * название услуги: оно должно разделять слово OCR, а не слово БД.
 *
 * Выход — data/fzocg/_sibling-shifts.json, его читает plan-tariff-name-fixes.mjs.
 * Запускать из корня репозитория.
 *
 * Usage: node scripts/fzocg/find-sibling-shifted-tariff-names.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';
import { createRepairer } from './ocr-name-repair.mjs';
loadEnv(process.cwd());
const fold = (s) => (s || '').toLowerCase().normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/g, 'd');
const words = (s) => new Set((fold(s).match(/[a-z0-9]+/g) || []));
const FOLDERS = { 'fzocg-sekundarna': 'sekundarna-ostalo', 'fzocg-pzz': 'primarna-zdravstvena-zastita' };
const db = await mysql.createConnection(dbConfigFromEnv());
const [t] = await db.query("SELECT t.id, t.tariff_source src, t.code, t.name_sr_latin n, s.slug, s.name_sr sn FROM medical_service_tariffs t LEFT JOIN medical_services s ON s.id = t.medical_service_id");
const clean = [...(await db.query('SELECT name_sr FROM medical_services UNION ALL SELECT name_sr FROM lab_tests'))[0].map((r) => r.name_sr)];
await db.end();
const finals = {}, ocr = {};
for (const [src, f] of Object.entries(FOLDERS)) {
  finals[src] = JSON.parse(readFileSync(`data/fzocg/${f}/${f}-FINAL.json`, 'utf-8')).items;
  for (const it of finals[src]) if (it.name && !String(it._sources?.name || '').startsWith('paddle')) clean.push(it.name);
  ocr[src] = new Map();
  for (const file of readdirSync(`data/fzocg/${f}/paddleocr`).filter((x) => x.endsWith('.items.json'))) {
    const j = JSON.parse(readFileSync(`data/fzocg/${f}/paddleocr/${file}`, 'utf-8'));
    for (const it of Array.isArray(j) ? j : j.items || []) if (it.code && it.name && !ocr[src].has(it.code)) ocr[src].set(it.code, it.name);
  }
}
const repair = createRepairer(clean);
const dict = new Set(clean.flatMap((n) => [...words(n)]));
const STOP = new Set(['i', 'u', 'sa', 'na', 'za', 'od', 'do', 'ili', 'bez', 'po', 'kod', 'iz', 's', 'uz', 'op', 'the']);
const hits = [];
for (const r of t) {
  if (!ocr[r.src]) continue;
  const raw = ocr[r.src].get(r.code); if (!raw) continue;
  const rep = repair(raw); if (rep.unresolved.length) continue;
  const a = words(rep.name), b = words(r.n);
  const onlyOcr = [...a].filter((w) => !b.has(w) && dict.has(w) && w.length > 2 && !STOP.has(w));
  const onlyDb = [...b].filter((w) => !a.has(w) && dict.has(w) && w.length > 2 && !STOP.has(w));
  // Варианты одного слова (склонение, ije/je, dj/đ) — не различие: общая основа ≥4 или ≤2 правки
  const lev = (x, y) => { const d = Array.from({ length: x.length + 1 }, (_, i) => [i]); for (let j = 1; j <= y.length; j++) d[0][j] = j;
    for (let i = 1; i <= x.length; i++) for (let j = 1; j <= y.length; j++) d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + (x[i - 1] === y[j - 1] ? 0 : 1)); return d[x.length][y.length]; };
  const same = (x, y) => { let k = 0; while (k < x.length && x[k] === y[k]) k++; return k >= 4 || lev(x, y) <= 2; };
  const o = onlyOcr.filter((w) => !onlyDb.some((v) => same(w, v)));
  const q = onlyDb.filter((v) => !onlyOcr.some((w) => same(w, v)));
  if (!o.length || !q.length || o.length + q.length > 8) continue;
  // Решает название услуги: оно должно быть ближе к OCR, чем к БД
  if (r.sn) { const sOcr = [...words(r.sn)].filter((w) => o.includes(w)).length; const sDb = [...words(r.sn)].filter((w) => q.includes(w)).length;
    const lemma = (arr) => [...words(r.sn)].filter((w) => arr.some((x) => same(x, w))).length;
    if (lemma(o) <= lemma(q)) continue; }
  hits.push({ src: r.src, code: r.code, tariff_id: r.id, slug: r.slug, db: r.n, ocr: rep.name, onlyOcr: o, onlyDb: q, svc: r.sn });
}
writeFileSync('data/fzocg/_sibling-shifts.json', JSON.stringify(hits, null, 1));
console.log('подозрений на сдвиг к соседу по серии:', hits.length, '| привязанных:', hits.filter((h) => h.slug).length);
for (const h of hits.slice(0, 60)) {
	console.log(h.src.replace('fzocg-', ''), h.code, '|', (h.slug || '-').slice(0, 38), '| OCR+', h.onlyOcr.join(','), '| DB+', h.onlyDb.join(','));
	console.log('     DB :', h.db.slice(0, 100));
	console.log('     OCR:', h.ocr.slice(0, 100));
}
