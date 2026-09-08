import { test, expect } from '@playwright/test';
import { reuseOrder } from '~/composables/use-clinic-ranking';

// Локация приезжает асинхронно и всегда после первого рендера, поэтому
// пересортировка карточек по расстоянию — это сдвиг макета уже показанного
// списка (CLS). Порядок фиксируется на первом рендере набора, и переставляется
// только новый набор — другая страница списка, другой фильтр, переход.
// reuseOrder — та половина механизма, которая решает, применим ли ранее
// показанный порядок.

const clinic = (id: number) => ({ id, name: `clinic-${id}` });

test.describe('reuseOrder', () => {
	test('возвращает ранее показанный порядок для того же набора', () => {
		const clinics = [clinic(1), clinic(2), clinic(3)];

		expect(reuseOrder(clinics, [3, 1, 2])?.map((c) => c.id)).toEqual([3, 1, 2]);
	});

	test('первый рендер (порядка ещё нет) ранжируется заново', () => {
		expect(reuseOrder([clinic(1), clinic(2)], null)).toBeNull();
	});

	test('новый состав ранжируется заново, а не подгоняется под старый', () => {
		// Другая страница списка: id частично совпадают
		expect(reuseOrder([clinic(1), clinic(9)], [1, 2])).toBeNull();
		// Клиника исчезла из набора
		expect(reuseOrder([clinic(1)], [1, 2])).toBeNull();
		// Клиника добавилась
		expect(reuseOrder([clinic(1), clinic(2), clinic(3)], [1, 2])).toBeNull();
	});

	test('отдаёт актуальные объекты, а не сохранённые ранее', () => {
		// Стор мог подгрузить клиники заново: порядок берём старый, данные — новые
		const fresh = [clinic(1), clinic(2)];
		const result = reuseOrder(fresh, [2, 1]);

		expect(result?.[0]).toBe(fresh[1]);
		expect(result?.[1]).toBe(fresh[0]);
	});
});
