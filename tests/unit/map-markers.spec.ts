import { test, expect } from '@playwright/test';
import {
	getClinicMarkerHtml,
	groupServicesByClinicId,
} from '../../components/map/markers';

// Боковая карта листингов раскладывает услуги по клиникам и рисует маркеры
// статичным HTML (иначе кластеризация ломает Teleport-цели). Тест сторожит обе
// половины: раскладку (её раньше делал filter+split на каждую пару «клиника ×
// услуга») и то, что в иконку не утекает мусор.

type Service = { id: number; clinicIds?: string };

const service = (id: number, clinicIds?: string): Service => ({
	id,
	clinicIds,
});

test.describe('groupServicesByClinicId', () => {
	test('раскладывает услугу по всем её клиникам', () => {
		const a = service(1, '10,20,30');
		const b = service(2, '20');

		const byClinic = groupServicesByClinicId([a, b]);

		expect([...byClinic.keys()].sort((x, y) => x - y)).toEqual([10, 20, 30]);
		expect(byClinic.get(10)).toEqual([a]);
		expect(byClinic.get(20)).toEqual([a, b]);
		expect(byClinic.get(30)).toEqual([a]);
	});

	test('сохраняет порядок услуг внутри клиники', () => {
		const first = service(1, '7');
		const second = service(2, '7');
		const third = service(3, '7');

		expect(groupServicesByClinicId([first, second, third]).get(7)).toEqual([
			first,
			second,
			third,
		]);
	});

	test('пропускает элементы без клиник и мусорные id', () => {
		const withClinics = service(1, '5');

		const byClinic = groupServicesByClinicId([
			service(2),
			service(3, ''),
			service(4, ',,'),
			withClinics,
		]);

		expect(byClinic.size).toBe(1);
		expect(byClinic.get(5)).toEqual([withClinics]);
	});

	test('клиника без услуг в списке не попадает в раскладку', () => {
		// На ней боковая карта больше не ставит маркер (PRD prd/maps, итерация 1)
		expect(groupServicesByClinicId([service(1, '10')]).has(99)).toBe(false);
	});
});

test.describe('getClinicMarkerHtml', () => {
	test('в режиме услуг показывает их число', () => {
		expect(getClinicMarkerHtml(3)).toContain('>3<');
		expect(getClinicMarkerHtml(3)).toContain('clinic-service-marker');
	});

	test('в режиме клиник показывает иконку вместо числа', () => {
		const html = getClinicMarkerHtml(0, true);

		expect(html).toContain('<svg');
		expect(html).not.toContain('>0<');
	});

	test('не выводит дробное или отрицательное число', () => {
		expect(getClinicMarkerHtml(2.7)).toContain('>2<');
		expect(getClinicMarkerHtml(-5)).toContain('>0<');
	});
});
