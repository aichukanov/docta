/**
 * Универсальная функция для группировки элементов по категориям
 * 
 * @param items - Массив элементов для группировки
 * @param getCategoryIds - Функция для получения ID категорий из элемента
 * @returns Объект с сгруппированными категориями и элементами без категории
 */
export function useItemsByCategory<T>(
	items: Ref<T[]>,
	getCategoryIds: (item: T) => number[] | undefined,
) {
	return computed(() => {
		const itemsList = items.value;

		// Собираем все уникальные категории
		const categoriesMap = new Map<number, T[]>();
		const itemsWithoutCategory: T[] = [];

		itemsList.forEach((item) => {
			const categoryIds = getCategoryIds(item);

			if (categoryIds && categoryIds.length > 0) {
				// Добавляем элемент во все его категории
				categoryIds.forEach((categoryId) => {
					if (!categoriesMap.has(categoryId)) {
						categoriesMap.set(categoryId, []);
					}
					categoriesMap.get(categoryId)!.push(item);
				});
			} else {
				itemsWithoutCategory.push(item);
			}
		});

		// Преобразуем Map в массив объектов с сортировкой по ID категории
		const categories = Array.from(categoriesMap.entries())
			.map(([categoryId, items]) => ({
				categoryId,
				items,
			}))
			.sort((a, b) => a.categoryId - b.categoryId);

		return {
			categories,
			itemsWithoutCategory,
		};
	});
}
