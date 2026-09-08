import { test, expect } from '@playwright/test';
import { buildRemovedMedicationsAction } from '../../server/common/redirect/removed-medications';

// Раздел `/medications` снят с сайта (см. removed-medications.ts). Адреса были
// в индексе, поэтому исход у каждого свой, и перепутать их дорого:
// 301 карточки на реестр — ложь про тождество сущностей, а 404 вместо 410 —
// «soft 404» на странице, удалённой намеренно.
//
// Риск несимметричный ещё и в другую сторону: соседний `/medicines` живой и
// названия отличаются одной буквой, поэтому первым делом фиксируем, что на
// чужих путях функция МОЛЧИТ.

const path = (p: string) => p.split('/').slice(1);

test.describe('чужие пути не трогаем', () => {
	test('реестр /medicines остаётся сам собой', () => {
		expect(buildRemovedMedicationsAction(path('/medicines'), {})).toBeNull();
		expect(
			buildRemovedMedicationsAction(path('/medicines/aspirin'), {}),
		).toBeNull();
	});

	test('другие подстраницы клиники', () => {
		for (const sub of ['services', 'labtests', 'doctors', 'reviews']) {
			expect(
				buildRemovedMedicationsAction(path(`/clinics/some-clinic/${sub}`), {}),
			).toBeNull();
		}
	});

	test('сама клиника и прочие разделы', () => {
		expect(
			buildRemovedMedicationsAction(path('/clinics/some-clinic'), {}),
		).toBeNull();
		expect(buildRemovedMedicationsAction(path('/articles'), {})).toBeNull();
		expect(buildRemovedMedicationsAction([], {})).toBeNull();
	});
});

test.describe('листинг — 301 на реестр', () => {
	test('преемник интента «лекарства в Черногории»', () => {
		expect(buildRemovedMedicationsAction(path('/medications'), {})).toEqual({
			type: 'redirect',
			status: 301,
			url: '/medicines',
		});
	});

	test('локаль не теряется: русская версия уходит на русскую', () => {
		expect(
			buildRemovedMedicationsAction(path('/medications'), { lang: 'ru' }),
		).toEqual({ type: 'redirect', status: 301, url: '/medicines?lang=ru' });
	});

	test('дефолтная локаль в URL не дописывается', () => {
		expect(
			buildRemovedMedicationsAction(path('/medications'), { lang: 'sr' }),
		).toEqual({ type: 'redirect', status: 301, url: '/medicines' });
	});
});

test.describe('карточки — 410, а не редирект', () => {
	test('слаг', () => {
		expect(
			buildRemovedMedicationsAction(path('/medications/paracetamol'), {}),
		).toEqual({ type: 'gone' });
	});

	test('числовой ID: у снятого раздела канонического адреса нет', () => {
		expect(buildRemovedMedicationsAction(path('/medications/17'), {})).toEqual({
			type: 'gone',
		});
	});

	test('тёзка из реестра на реестр НЕ уводится', () => {
		// Совпадение имени — не совпадение сущности: у нас была ампула, в
		// реестре потребительская упаковка. Тёзок было 5 из 33.
		expect(
			buildRemovedMedicationsAction(path('/medications/aspirin'), {}),
		).toEqual({ type: 'gone' });
	});
});

test.describe('подстраница клиники — 301 на клинику', () => {
	test('клиника-то осталась, исчез только её раздел', () => {
		expect(
			buildRemovedMedicationsAction(
				path('/clinics/some-clinic/medications'),
				{},
			),
		).toEqual({
			type: 'redirect',
			status: 301,
			url: '/clinics/some-clinic',
		});
	});

	test('хвост пути отбрасывается вместе с разделом', () => {
		expect(
			buildRemovedMedicationsAction(
				path('/clinics/some-clinic/medications/whatever'),
				{},
			),
		).toEqual({
			type: 'redirect',
			status: 301,
			url: '/clinics/some-clinic',
		});
	});

	test('локаль переносится', () => {
		expect(
			buildRemovedMedicationsAction(path('/clinics/some-clinic/medications'), {
				lang: 'de',
			}),
		).toEqual({
			type: 'redirect',
			status: 301,
			url: '/clinics/some-clinic?lang=de',
		});
	});
});
