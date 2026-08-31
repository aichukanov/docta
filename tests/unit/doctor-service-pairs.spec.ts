import { test, expect } from '@playwright/test';
import { buildClinicSpecialtyPairs } from '~/server/common/services';

// Листинг врачей грузит услуги одним запросом на всю страницу (20 врачей).
// Раньше в SQL уходили два независимых IN-списка — ВСЕ клиники страницы и ВСЕ
// специальности страницы, — и запрос возвращал их декартово произведение
// (замер: 21 клиника × 10 специальностей → до 1122 строк по семь колонок имён),
// после чего JS выбрасывал строки, не подошедшие ни одному врачу.
//
// Теперь фильтр перенесён в SQL списком пар «клиника + специальность»,
// собранных ПОКАЖДОМУ врачу. Тест сторожит то, ради чего это делалось:
// пары не должны склеиваться между врачами, и итог фильтрации обязан
// совпадать с прежним «взять всё и отфильтровать в JS».

type Doctor = { id: number; clinicIds: string; specialtyIds: string };

test.describe('buildClinicSpecialtyPairs', () => {
	test('не перемножает клиники одного врача со специальностями другого', () => {
		const doctors: Doctor[] = [
			{ id: 1, clinicIds: '10', specialtyIds: '100' },
			{ id: 2, clinicIds: '20', specialtyIds: '200' },
		];

		const pairs = buildClinicSpecialtyPairs(doctors);

		expect(pairs).toEqual([
			[10, 100],
			[20, 200],
		]);
		// (10,200) и (20,100) — те самые лишние комбинации старого запроса
		expect(pairs).not.toContainEqual([10, 200]);
		expect(pairs).not.toContainEqual([20, 100]);
	});

	test('перемножает клиники и специальности внутри одного врача', () => {
		const doctors: Doctor[] = [
			{ id: 1, clinicIds: '10,20', specialtyIds: '100,200' },
		];

		const pairs = buildClinicSpecialtyPairs(doctors);

		expect(pairs).toEqual([
			[10, 100],
			[10, 200],
			[20, 100],
			[20, 200],
		]);
	});

	test('дедуплицирует пары, общие для нескольких врачей', () => {
		const doctors: Doctor[] = [
			{ id: 1, clinicIds: '10', specialtyIds: '100' },
			{ id: 2, clinicIds: '10', specialtyIds: '100' },
		];

		const pairs = buildClinicSpecialtyPairs(doctors);

		expect(pairs).toEqual([[10, 100]]);
	});

	test('врач без клиник или без специальностей не даёт пар', () => {
		const doctors: Doctor[] = [
			{ id: 1, clinicIds: '', specialtyIds: '100' },
			{ id: 2, clinicIds: '10', specialtyIds: '' },
		];

		expect(buildClinicSpecialtyPairs(doctors)).toEqual([]);
	});

	test('итог фильтрации совпадает со старой схемой «всё и отфильтровать в JS»', () => {
		const doctors: Doctor[] = [
			{ id: 1, clinicIds: '10,20', specialtyIds: '100' },
			{ id: 2, clinicIds: '20', specialtyIds: '200,300' },
			{ id: 3, clinicIds: '30', specialtyIds: '100,300' },
		];
		// Каталог: услуга в клинике + специальности самой услуги
		const catalogue = [
			{ clinicId: 10, serviceId: 1, specialtyIds: [100] },
			{ clinicId: 10, serviceId: 2, specialtyIds: [200] },
			{ clinicId: 20, serviceId: 3, specialtyIds: [100, 300] },
			{ clinicId: 20, serviceId: 4, specialtyIds: [200] },
			{ clinicId: 30, serviceId: 5, specialtyIds: [300] },
			{ clinicId: 30, serviceId: 6, specialtyIds: [400] },
		];

		const parse = (value: string) =>
			value ? value.split(',').map(Number) : [];

		// Старая схема: два независимых IN-списка + фильтрация в JS
		const allClinics = new Set(doctors.flatMap((d) => parse(d.clinicIds)));
		const allSpecialties = new Set(
			doctors.flatMap((d) => parse(d.specialtyIds)),
		);
		const oldRows = catalogue
			.filter(
				(row) =>
					allClinics.has(row.clinicId) &&
					row.specialtyIds.some((id) => allSpecialties.has(id)),
			)
			.map((row) => ({
				...row,
				// GROUP_CONCAT отдаёт только специальности из IN-списка
				specialtyIds: row.specialtyIds.filter((id) => allSpecialties.has(id)),
			}));

		// Новая схема: фильтр парами в SQL
		const pairs = buildClinicSpecialtyPairs(doctors);
		const hasPair = (clinicId: number, specialtyId: number) =>
			pairs.some(([c, s]) => c === clinicId && s === specialtyId);
		const newRows = catalogue
			.filter((row) => row.specialtyIds.some((id) => hasPair(row.clinicId, id)))
			.map((row) => ({
				...row,
				specialtyIds: row.specialtyIds.filter((id) =>
					hasPair(row.clinicId, id),
				),
			}));

		// Строк по проводу меньше — ради этого всё и затевалось
		expect(newRows.length).toBeLessThan(oldRows.length);

		// ...а видимый результат обязан совпасть
		const byDoctor = (rows: typeof catalogue) =>
			doctors.map((doctor) => {
				const specialties = parse(doctor.specialtyIds);
				return parse(doctor.clinicIds).map((clinicId) =>
					rows
						.filter(
							(row) =>
								row.clinicId === clinicId &&
								row.specialtyIds.some((id) => specialties.includes(id)),
						)
						.map((row) => row.serviceId),
				);
			});

		expect(byDoctor(newRows)).toEqual(byDoctor(oldRows));
	});
});
