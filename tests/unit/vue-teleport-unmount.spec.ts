import { test, expect } from '@playwright/test';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);

// Баг Vue: если Teleport снимают до того, как выполнилось его ОТЛОЖЕННОЕ
// монтирование, `TeleportImpl.remove` всё равно идёт по детям — а они не
// смонтированы, `vnode.component === null`. Наружу это вылезало как
// `TypeError: Cannot destructure property 'bum' of 'E' as it is null`:
// исключение обрывало размонтирование старой страницы, роутер не доводил
// переход, и человек оставался на листинге с уже изменившимся URL.
//
// Монтирование откладывается, когда у родительского Suspense есть
// pending-ветка, — то есть ровно во время перехода между страницами Nuxt.
// Ловилось на листингах с картой: `clinic-services-map.vue` создаёт
// Teleport на маркер для каждой клиники, и если Leaflet догрузился с CDN
// уже после клика по карточке, все эти Teleport'ы рождались внутри окна
// перехода. Локально на прод-сборке воспроизводилось 6 из 6.
//
// Исправлено в Vue 3.5.40 двумя условиями в `TeleportImpl.remove`:
//   if (!pendingMount && (disabled || target) && shapeFlag & 16)
// Тест сторожит откат версии — код приложения от этого бага не защищает.

const MIN_VUE = [3, 5, 40] as const;

function parse(version: string): number[] {
	return version.split('-')[0].split('.').map(Number);
}

function gte(actual: number[], min: readonly number[]): boolean {
	for (let i = 0; i < min.length; i++) {
		const a = actual[i] ?? 0;
		if (a > min[i]) return true;
		if (a < min[i]) return false;
	}
	return true;
}

test('vue не ниже 3.5.40 — иначе переход в карточку иногда зависает', () => {
	const version = require('vue/package.json').version as string;
	expect(
		gte(parse(version), MIN_VUE),
		`vue ${version}: нужен минимум ${MIN_VUE.join('.')}`,
	).toBe(true);
});

test('в @vue/runtime-core есть оба guard-условия', () => {
	// Версия — не гарантия: пакет мог приехать из override или resolutions.
	// Проверяем сам код, который падал.
	const path =
		require.resolve('@vue/runtime-core/dist/runtime-core.esm-bundler.js');
	const source = require('node:fs').readFileSync(path, 'utf8') as string;

	expect(
		source.includes('!pendingMount && (disabled || target) && shapeFlag & 16'),
		'в TeleportImpl.remove нет guard-условий из Vue 3.5.40',
	).toBe(true);
});
