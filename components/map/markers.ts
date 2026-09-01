// Хелперы карт: разбор clinicIds и статичный HTML иконок маркеров.
//
// HTML статичный, а не Vue-компонент через Teleport, потому что при
// кластеризации leaflet.markercluster пересоздаёт DOM маркеров при сборке и
// разборке кластеров — цели Teleport внутри них пропадают
// (см. AddMarkerOptions.html в composables/use-leaflet.ts).

// Повторяет components/icon/clinic.vue (там Vue-компонент, здесь нужна строка)
export const CLINIC_ICON_SVG = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 256 256" fill="none" aria-hidden="true">
	<line x1="32" y1="216" x2="248" y2="216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<path d="M48,216V48a8,8,0,0,1,8-8h96a8,8,0,0,1,8,8V216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<path d="M160,120h64a8,8,0,0,1,8,8v88" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<line x1="104" y1="72" x2="104" y2="120" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<line x1="80" y1="96" x2="128" y2="96" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<polyline points="128 216 128 160 80 160 80 216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
</svg>`;

/**
 * Иконка маркера боковой карты: в режиме клиник — символ клиники,
 * в режиме услуг — число услуг этой клиники из текущего списка.
 * Стили — `.clinic-service-marker` в clinic-services-map.vue (не scoped:
 * маркер живёт вне Vue-дерева).
 */
export const getClinicMarkerHtml = (
	serviceCount: number,
	showIcon = false,
): string =>
	showIcon
		? `<div class="clinic-service-marker">${CLINIC_ICON_SVG}</div>`
		: // serviceCount — число, экранировать нечего
			`<div class="clinic-service-marker">${Math.max(0, Math.trunc(serviceCount))}</div>`;

/**
 * Раскладывает элементы списка по клиникам, разбирая `clinicIds` ОДИН раз на
 * элемент. Наивный `services.filter(s => s.clinicIds.split(',')…)` внутри цикла
 * по клиникам давал 126 × 20 ≈ 2500 разборов строки на каждый пересчёт.
 * Порядок элементов внутри клиники сохраняется — как у прежнего filter.
 */
export const groupServicesByClinicId = <T extends { clinicIds?: string }>(
	services: T[],
): Map<number, T[]> => {
	const byClinicId = new Map<number, T[]>();

	for (const service of services) {
		if (!service.clinicIds) continue;

		for (const rawId of service.clinicIds.split(',')) {
			const clinicId = Number(rawId);
			if (!clinicId) continue;

			const clinicServices = byClinicId.get(clinicId);
			if (clinicServices) {
				clinicServices.push(service);
			} else {
				byClinicId.set(clinicId, [service]);
			}
		}
	}

	return byClinicId;
};
