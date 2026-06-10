import { CONTAINER_UNITS } from '~/i18n/packaging';

export interface PackagingFields {
	pack_total?: number | null;
	pack_unit?: string | null;
	pack_container?: string | null;
	pack_container_count?: number | null;
	pack_per_container?: number | null;
	pack_volume?: number | null;
	pack_volume_unit?: string | null;
	pack_parse_status?: string | null;
}

type TFn = (key: string) => string;

// Аккуратное число: «0.5» вместо «0.50», запятая как десятичный разделитель.
function fmtVolume(v: number): string {
	return String(v).replace(/\.0+$/, '').replace('.', ',');
}

/**
 * Собирает локализованную подпись упаковки из структурных полей.
 * @param withBreakdown — добавлять «(2 × 10)» (для детальной страницы).
 * Возвращает '' для неразобранных (manual) записей — сырой текст не показываем.
 */
export function buildPackagingLabel(
	med: PackagingFields,
	t: TFn,
	withBreakdown = false,
): string {
	if (med.pack_parse_status !== 'ok' || med.pack_total == null) return '';

	const total = med.pack_total;
	const unit = med.pack_unit;
	const volLabel =
		med.pack_volume != null && med.pack_volume_unit
			? `${fmtVolume(med.pack_volume)} ${t(`pack_vol_${med.pack_volume_unit}`)}`
			: '';

	// Контейнер с объёмом: «флакон 100 мл», «3 × шприц 0,5 мл».
	if (unit && CONTAINER_UNITS.has(unit) && volLabel) {
		const name = t(`pack_unit_${unit}`);
		return total > 1 ? `${total} × ${name} ${volLabel}` : `${name} ${volLabel}`;
	}

	// Контейнер без объёма: «1 флакон».
	if (unit && CONTAINER_UNITS.has(unit)) {
		return `${total} ${t(`pack_unit_${unit}`)}`;
	}

	// Только объём, без единицы (например, раствор): «100 мл».
	if (!unit && volLabel) return volLabel;

	if (!unit) return '';

	// Счётные единицы: «20 таблеток» + опциональная разбивка «(2 × 10)».
	let label = `${total} ${t(`pack_unit_${unit}`)}`;
	if (
		withBreakdown &&
		med.pack_container_count != null &&
		med.pack_per_container != null
	) {
		label += ` (${med.pack_container_count} × ${med.pack_per_container})`;
	}
	return label;
}
