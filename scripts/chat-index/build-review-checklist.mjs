// Flags foreign-brand entries whose `strength` field looks non-clean, so a human can
// verify the source data. Writes data/med-foreign-brands/_review-checklist.md.
// Run: node scripts/medicines/build-review-checklist.mjs  (path: scripts/chat-index/)

import { readFileSync, writeFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

const DIR = join('data', 'med-foreign-brands');
// тот же экстрактор доз, что в pages/medicines/[medicineSlug]/index.vue
const DOSE_RE =
	/\d+(?:[.,]\d+)?(?:\s*[/–-]\s*\d+(?:[.,]\d+)?)*\s*(?:mg|mcg|µg|ml|g|l|%|мг|мкг|мл|г|л)(?:\s*\/\s*\d*(?:[.,]\d+)?\s*(?:mg|mcg|µg|ml|g|l|мг|мкг|мл|г|л))?/gi;
const extract = (s) => {
	const d = (s || '').match(DOSE_RE);
	return d ? [...new Set(d.map((x) => x.replace(/\s+/g, ' ').trim()))].join(', ') : '';
};
const isCombo = (b) =>
	/\+|комбинац|combination|kombi|\bи\b/i.test(`${b.strength || ''} ${b.note || ''}`);

const subs = [];
for (const f of readdirSync(DIR).filter((f) => /^batch-\d+\.json$/.test(f)).sort()) {
	subs.push(...JSON.parse(readFileSync(join(DIR, f), 'utf8')));
}

const lines = ['# Чеклист ручной проверки зарубежных брендов', '',
	'Флаги: **combo** — strength/note содержит состав (вероятно комбинированный препарат под',
	'моно-веществом — проверить, уместен ли); **no-dose** — в strength нет дозы (доза скрыта в',
	'выводе, показывается только вещество); **form-mixed** — доза есть, но с формо-словами',
	'(вывод авто-чистится экстрактором — сверить «→»).', '',
	'Только флагнутые записи. Чистые не показаны.', ''];

let counts = { combo: 0, nodose: 0, formmixed: 0, subs: 0 };
for (const s of subs) {
	const rows = [];
	for (const mk of ['RU', 'DE', 'PL', 'US']) {
		for (const b of (s.markets?.[mk] || [])) {
			const raw = b.strength || '';
			const extracted = extract(raw);
			const combo = isCombo(b);
			const noDose = raw.trim() && !extracted;
			const formMixed = extracted && /[a-zа-яäöü]{4,}/i.test(raw.replace(DOSE_RE, ''));
			if (!combo && !noDose && !formMixed) continue;
			const flags = [combo && 'combo', noDose && 'no-dose', formMixed && 'form-mixed']
				.filter(Boolean).join(', ');
			if (combo) counts.combo++;
			if (noDose) counts.nodose++;
			if (formMixed) counts.formmixed++;
			rows.push(`  - ${mk} **${b.brand}** [${flags}] — strength: "${raw}"` +
				(extracted ? ` → покажем: "${extracted}"` : ' → доза не покажется') +
				(b.note ? ` · note: "${b.note}"` : ''));
		}
	}
	if (rows.length) {
		counts.subs++;
		lines.push(`### ${s.inn_en} (${s.inn_ru})`, ...rows, '');
	}
}

lines.splice(6, 0, `Сводка: веществ с флагами **${counts.subs}**, combo **${counts.combo}**, ` +
	`no-dose **${counts.nodose}**, form-mixed **${counts.formmixed}**.`, '');
writeFileSync(join(DIR, '_review-checklist.md'), lines.join('\n') + '\n', 'utf8');
console.log(`substances flagged: ${counts.subs}, combo: ${counts.combo}, no-dose: ${counts.nodose}, form-mixed: ${counts.formmixed}`);
