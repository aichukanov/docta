import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { getLocalizedNameField } from '~/server/common/utils';

export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const body = await readBody(event);
	const locale = body?.locale || 'en';
	const nameField = getLocalizedNameField(locale) || 'name_en';

	const connection = await getConnection();
	// Порядок прежний, но выражен индексируемой колонкой sort_rank
	// (= COALESCE(sort_order, 2147483647), миграция 025). С прежним ведущим
	// членом-выражением индекс idx_ms_sort_order не применялся, и админский
	// список сортировал filesort'ом все 5237 строк на каждый запрос.
	const [rows] = await connection.execute(
		`SELECT ms.id, ms.name_en, ms.${nameField} AS localized_name
		FROM medical_services ms
		ORDER BY ms.sort_rank ASC, ms.rank_score DESC, ms.name_en ASC`,
	);
	await connection.end();

	const items: Array<{ id: number; name: string }> = (rows as any[]).map(
		(s) => ({
			id: s.id,
			name: s.localized_name || s.name_en || '',
		}),
	);

	return { items, totalCount: items.length };
});
