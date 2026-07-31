import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	doctorIsPublicSql,
	isDoctorHiddenByAdmin,
	isDoctorPublic,
} from '../../server/common/doctor-visibility';

// Публичная видимость врача — три условия: не черновик, не скрыт сам и не скрыт
// админом. Условие раскидано по ~10 файлам (листинги, карточки клиник и услуг,
// отзывы, sitemap), и цена забытого места — скрытый врач остаётся в поиске или
// в sitemap, то есть в индексе. Поэтому предикат собирается только
// doctorIsPublicSql(), а тест ловит возврат сырого литерала.

const HERE = dirname(fileURLToPath(import.meta.url));
const SERVER_DIR = resolve(HERE, '../../server');
// Оба хелпера — законные хозяева литералов: у клиник свой флаг `hidden`
// с тем же текстом (server/common/clinic-visibility.ts).
const HELPERS = [
	resolve(SERVER_DIR, 'common/doctor-visibility.ts'),
	resolve(SERVER_DIR, 'common/clinic-visibility.ts'),
];

function tsFiles(dir: string): string[] {
	return readdirSync(dir).flatMap((entry) => {
		const path = join(dir, entry);
		if (statSync(path).isDirectory()) return tsFiles(path);
		return path.endsWith('.ts') ? [path] : [];
	});
}

test('предикат публичности включает все три флага', () => {
	expect(doctorIsPublicSql('d')).toBe(
		'(d.hidden = 0 AND d.hidden_by_admin = 0 AND d.is_draft = 0)',
	);
	expect(doctorIsPublicSql()).toBe(doctorIsPublicSql('d'));
});

test('скрытие админом отличается от самоскрытия и черновика', () => {
	expect(isDoctorPublic({ hidden: 0, hidden_by_admin: 0, is_draft: 0 })).toBe(
		true,
	);
	// 410 только для админского скрытия — остальное 404
	expect(isDoctorHiddenByAdmin({ hidden: 1, is_draft: 1 })).toBe(false);
	expect(isDoctorHiddenByAdmin({ hidden_by_admin: 1 })).toBe(true);
	expect(isDoctorPublic({ hidden: 1 })).toBe(false);
	expect(isDoctorPublic({ hidden_by_admin: 1 })).toBe(false);
	expect(isDoctorPublic({ is_draft: 1 })).toBe(false);
});

test('в server/ нет сырого фильтра по hidden/is_draft врача', () => {
	const offenders: string[] = [];
	// literal-сравнения флагов; `hidden = ?` в UPDATE и `hidden_by_admin`
	// (другое имя колонки) сюда не попадают
	const rawFilter = /(?:^|[^_\w])(hidden|is_draft)\s*=\s*(0|1|FALSE|TRUE)\b/i;

	for (const path of tsFiles(SERVER_DIR)) {
		if (HELPERS.includes(resolve(path))) continue;
		const src = readFileSync(path, 'utf8');
		src.split(/\r?\n/).forEach((line, index) => {
			if (rawFilter.test(line)) {
				offenders.push(`${relative(SERVER_DIR, path)}:${index + 1}`);
			}
		});
	}

	expect(
		offenders,
		'Используйте doctorIsPublicSql() — иначе скрытый админом врач ' +
			'останется в этой выборке',
	).toEqual([]);
});
