// Общие помощники для API лекарств (DRY): локализация имён, плейсхолдеры,
// управление соединением, маппинг повторяющихся групп полей.
import { getConnection } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';

export type Conn = Awaited<ReturnType<typeof getConnection>>;

// Поле локализованного имени с безопасным фолбэком на en.
export const nameFieldFor = (locale?: string): string =>
	getLocalizedNameField(locale || 'en') || 'name_en';

// SQL-выражение локализованного имени: локаль → en → исходное (пустые как NULL).
export const localizedNameSql = (alias: string, nameField: string): string =>
	`COALESCE(NULLIF(${alias}.${nameField}, ''), NULLIF(${alias}.name_en, ''), ${alias}.name)`;

// Строка из n плейсхолдеров «?, ?, …» для IN (...).
export const placeholders = (n: number): string =>
	Array.from({ length: n }, () => '?').join(',');

// Соединение из пула с гарантированным release() (даже при исключении).
export async function withConnection<T>(
	fn: (conn: Conn) => Promise<T>,
): Promise<T> {
	const conn = await getConnection();
	try {
		return await fn(conn);
	} finally {
		await conn.end();
	}
}

// Нормализация структурных полей упаковки (одинаково в списке/деталях/аналогах).
export const mapPack = (row: any) => ({
	pack_total: row.pack_total,
	pack_unit: row.pack_unit,
	pack_container_count: row.pack_container_count,
	pack_per_container: row.pack_per_container,
	pack_volume: row.pack_volume != null ? Number(row.pack_volume) : null,
	pack_volume_unit: row.pack_volume_unit,
	pack_parse_status: row.pack_parse_status,
});

// Значение локализованной пары «base / baseEn» (pharmaForm, country, atcGroup).
export const localizedField = (row: any, base: string): string | null =>
	row[base] || row[`${base}En`] || null;
