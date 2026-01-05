export const getClinicMarkerId = (clinicId: number) => {
	return `clinic-marker-${clinicId}`;
};

/**
 * Получает локализованное имя для сущности (клиника, врач и т.д.)
 * @param entity - объект с полями name, name_ru, name_sr_cyrl
 * @param locale - текущая локаль (sr, sr-cyrl, ru, en и т.д.)
 * @returns локализованное имя или базовое имя как fallback
 */
export function getLocalizedName<
	T extends { name: string; name_ru?: string; name_sr_cyrl?: string },
>(entity: T | null | undefined, locale: string): string {
	if (!entity) {
		return '';
	}

	// Преобразуем 'sr-cyrl' в 'sr_cyrl' для доступа к полю
	const fieldName = `name_${locale.replace('-', '_')}` as keyof T;

	return (entity[fieldName] as string) || entity.name;
}
