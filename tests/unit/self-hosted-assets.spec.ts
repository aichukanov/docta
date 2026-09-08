import { test, expect } from '@playwright/test';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Сторонние хосты на критическом пути возвращались тихо: то стили карты с
// unpkg (динамический <link> в <head> блокирует рендер, пока не приедет), то
// заглушка аватара с ui-avatars (она же LCP на детальной врача). Тест
// сторожит, что и библиотека карт, и заглушка остались своими.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

const read = (relativePath: string) =>
	readFileSync(resolve(ROOT, relativePath), 'utf-8');

test.describe('Leaflet раздаётся со своего домена', () => {
	test('composable не ходит на внешние CDN', () => {
		const source = read('composables/use-leaflet.ts');
		const code = source
			.split('\n')
			.filter((line) => !line.trim().startsWith('*'))
			.join('\n');

		expect(code).not.toContain('unpkg.com');
		expect(code).not.toContain('cdnjs');
		expect(code).not.toContain('jsdelivr');
	});

	test('файлы библиотеки лежат в public/', () => {
		for (const file of [
			'public/leaflet/leaflet-1.9.4/leaflet.js',
			'public/leaflet/leaflet-1.9.4/leaflet.css',
			// Leaflet ищет иконки маркеров по url() из своей таблицы стилей
			'public/leaflet/leaflet-1.9.4/images/marker-icon.png',
			'public/leaflet/leaflet.markercluster-1.5.3/leaflet.markercluster.js',
			'public/leaflet/leaflet.markercluster-1.5.3/MarkerCluster.css',
			'public/leaflet/leaflet.markercluster-1.5.3/MarkerCluster.Default.css',
		]) {
			expect(existsSync(resolve(ROOT, file)), file).toBe(true);
		}
	});

	test('пути в composable совпадают с папками в public/', () => {
		const source = read('composables/use-leaflet.ts');
		const bases = [...source.matchAll(/'(\/leaflet\/[^']+)'/g)].map(
			(match) => match[1],
		);

		expect(bases.length).toBeGreaterThan(0);
		for (const base of bases) {
			expect(existsSync(resolve(ROOT, `public${base}`)), base).toBe(true);
		}
	});

	test('стили подключаются, не блокируя рендер', () => {
		// media="print" на время загрузки выводит <link> из render-blocking
		expect(read('composables/use-leaflet.ts')).toContain(
			"link.media = 'print'",
		);
	});
});

test('заглушка аватара рисуется локально, без ui-avatars', () => {
	expect(read('components/doctor/avatar.vue')).not.toContain('ui-avatars.com');
});
