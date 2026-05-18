/**
 * Reads Google Places responses from data/google-places-hours/ and produces
 * SQL to populate clinic_working_hours.
 *
 * Logic:
 *   - 24/7: single period with open.day=0/hour=0/minute=0 and no close → all days '24/7'
 *   - Day with one or more periods → { type: 'regular', intervals: [...] }
 *   - Day with no periods → { type: 'closed' }
 *   - Overnight period (close.day !== open.day) → clipped at 23:59 of open day
 *     (наша схема не поддерживает start > end в одном дне; редкий случай)
 *
 * Output: server/sql/clinic_working_hours_from_google.sql
 *
 * Usage:
 *   node scripts/build-working-hours-sql.mjs
 */

import { existsSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const IN_DIR = resolve(ROOT, 'data/google-places-hours');
const OUT_FILE = resolve(ROOT, 'server/sql/clinic_working_hours_from_google.sql');

// Google Places day index: 0=Sunday, 1=Monday, ..., 6=Saturday
const DAY_NAMES = [
	'sunday',
	'monday',
	'tuesday',
	'wednesday',
	'thursday',
	'friday',
	'saturday',
];
const DAY_ORDER = [
	'monday',
	'tuesday',
	'wednesday',
	'thursday',
	'friday',
	'saturday',
	'sunday',
];

const pad = (n) => String(n).padStart(2, '0');
const hhmm = (p) => `${pad(p.hour ?? 0)}:${pad(p.minute ?? 0)}`;

function is24x7(periods) {
	return (
		periods.length === 1 &&
		!periods[0].close &&
		periods[0].open?.day === 0 &&
		(periods[0].open?.hour ?? 0) === 0 &&
		(periods[0].open?.minute ?? 0) === 0
	);
}

function buildDaySchedules(regularOpeningHours) {
	const empty = Object.fromEntries(
		DAY_ORDER.map((d) => [d, { type: 'not_specified' }]),
	);
	if (!regularOpeningHours?.periods?.length) return empty;

	const periods = regularOpeningHours.periods;

	if (is24x7(periods)) {
		return Object.fromEntries(DAY_ORDER.map((d) => [d, { type: '24/7' }]));
	}

	const byDay = {};
	for (const p of periods) {
		if (!p.open || !p.close) continue;
		const dayName = DAY_NAMES[p.open.day];
		if (!dayName) continue;

		const start = hhmm(p.open);
		const sameDay = p.close.day === p.open.day;
		const end = sameDay ? hhmm(p.close) : '23:59';
		if (start >= end) continue; // защита от мусора

		(byDay[dayName] ??= []).push({ start, end });
	}

	const result = {};
	for (const day of DAY_ORDER) {
		const intervals = (byDay[day] || []).sort((a, b) =>
			a.start.localeCompare(b.start),
		);
		result[day] = intervals.length
			? { type: 'regular', intervals }
			: { type: 'closed' };
	}
	return result;
}

function escape(jsonStr) {
	return jsonStr.replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------
if (!existsSync(IN_DIR)) {
	console.error(`Нет директории ${IN_DIR}. Сначала запусти fetch-clinic-working-hours.mjs`);
	process.exit(1);
}

const files = readdirSync(IN_DIR).filter((f) => f.endsWith('.json'));
console.log(`Найдено файлов: ${files.length}`);

const sqlLines = [
	'-- Сгенерировано scripts/build-working-hours-sql.mjs',
	'-- Источник: Google Places (New) regularOpeningHours',
	'',
];

let processed = 0;
let skippedNoHours = 0;

for (const file of files.sort()) {
	const data = JSON.parse(readFileSync(resolve(IN_DIR, file), 'utf-8'));
	const { clinicId, name, regularOpeningHours } = data;

	if (!regularOpeningHours?.periods?.length) {
		skippedNoHours++;
		sqlLines.push(`-- [skip] ${clinicId} ${name} — у Google нет часов`);
		continue;
	}

	const schedule = buildDaySchedules(regularOpeningHours);
	const cols = DAY_ORDER.map((d) => `'${escape(JSON.stringify(schedule[d]))}'`);

	sqlLines.push(`-- ${clinicId} ${name}`);
	sqlLines.push(
		`INSERT INTO clinic_working_hours (clinic_id, ${DAY_ORDER.join(', ')}, created_at, updated_at)`,
	);
	sqlLines.push(`VALUES (${clinicId}, ${cols.join(', ')}, NOW(), NOW())`);
	sqlLines.push(`ON DUPLICATE KEY UPDATE`);
	sqlLines.push(
		DAY_ORDER.map((d) => `  ${d} = VALUES(${d})`).join(',\n') +
			',\n  updated_at = NOW();',
	);
	sqlLines.push('');
	processed++;
}

writeFileSync(OUT_FILE, sqlLines.join('\n'), 'utf-8');

console.log(`\nГотово: ${processed} INSERT/UPDATE, ${skippedNoHours} пропущено без часов.`);
console.log(`Файл: ${OUT_FILE}`);
