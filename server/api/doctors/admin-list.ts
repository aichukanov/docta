import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';

/**
 * Лёгкий список врачей для админских селекторов.
 * Возвращает только {id, name, localName} — без подзапросов в reviews/junction-таблицы.
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const body = await readBody(event);
	const locale = body?.locale || 'en';

	const connection = await getConnection();
	const [rows] = await connection.execute(
		`SELECT d.id, d.name_sr, d.name_sr_cyrl, d.name_ru, d.name_en
		FROM doctors d
		ORDER BY d.name_sr ASC`,
	);
	await connection.end();

	const doctors = (rows as any[]).map((d: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(d, locale);
		return { id: d.id, name, localName };
	});

	return { doctors, totalCount: doctors.length };
});
