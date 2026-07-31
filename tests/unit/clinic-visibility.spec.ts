import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { clinicIsPublicSql } from '../../server/common/clinic-visibility';

// Публичная видимость клиники — два условия: опубликована владельцем И не
// скрыта админом. Условие раскидано по 14 файлам (листинги, карточки услуг,
// анализов и лекарств, отзывы, sitemap), и цена забытого места — скрытая
// клиника остаётся в поиске или в sitemap, то есть в индексе.
// Поэтому предикат собирается только clinicIsPublicSql(), а тест ловит
// возврат сырого литерала.

const HERE = dirname(fileURLToPath(import.meta.url));
const SERVER_DIR = resolve(HERE, '../../server');
const HELPER = resolve(SERVER_DIR, 'common/clinic-visibility.ts');

function tsFiles(dir: string): string[] {
	return readdirSync(dir).flatMap((entry) => {
		const path = join(dir, entry);
		if (statSync(path).isDirectory()) return tsFiles(path);
		return path.endsWith('.ts') ? [path] : [];
	});
}

test('предикат публичности включает оба условия', () => {
	expect(clinicIsPublicSql('c')).toBe(
		"(c.status = 'published' AND c.hidden = 0)",
	);
	expect(clinicIsPublicSql()).toBe(clinicIsPublicSql('c'));
});

test('в server/ нет сырого фильтра по status = published', () => {
	const offenders: string[] = [];

	for (const path of tsFiles(SERVER_DIR)) {
		if (resolve(path) === HELPER) continue;
		const src = readFileSync(path, 'utf8');
		src.split(/\r?\n/).forEach((line, index) => {
			if (/status\s*=\s*'published'/.test(line)) {
				offenders.push(`${relative(SERVER_DIR, path)}:${index + 1}`);
			}
		});
	}

	expect(
		offenders,
		'Используйте clinicIsPublicSql() — иначе скрытая админом клиника ' +
			'останется в этой выборке',
	).toEqual([]);
});
