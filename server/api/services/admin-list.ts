import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { getLocalizedNameField } from '~/server/common/utils';

export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const body = await readBody(event);
	const locale = body?.locale || 'en';
	const nameField = getLocalizedNameField(locale) || 'name_en';

	const connection = await getConnection();
	const [rows] = await connection.execute(
		`SELECT ms.id, ms.name_en, ms.${nameField} AS localized_name
		FROM medical_services ms
		ORDER BY ms.sort_order IS NULL, ms.sort_order ASC, ms.rank_score DESC, ms.name_en ASC`,
	);
	await connection.end();

	const items = (rows as any[]).map((s) => ({
		id: s.id,
		name: s.localized_name || s.name_en || '',
	}));

	return { items, totalCount: items.length };
});
