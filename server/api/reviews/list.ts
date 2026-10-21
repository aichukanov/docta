import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { foldedLikeAny } from '~/server/common/search-collation';

interface ReviewListItem {
	id: number;
	label: string;
}

// Отзывов в базе тысячи (8.3k на 2026-10-21), и отдавать их все в селектор
// нельзя — поэтому поиск удалённый: без запроса приходит свежая выборка,
// с запросом — совпадения по всей таблице, а не по загруженному куску.
const RECENT_LIMIT = 50;
// Потолок выдачи поиска. У самой отзываемой клиники их 590 (Medical Vraneš,
// 2026-10-21), так что запрос по названию клиники должен умещаться целиком —
// иначе повторяется та же беда, из-за которой поиск и переделан.
const SEARCH_LIMIT = 1000;

const SEARCH_COLUMNS = ['u.name', 'c.name_sr', 'd.name_sr', 'ic.name_sr'];

const FROM_CLAUSE = `
	FROM reviews r
	LEFT JOIN auth_users u ON r.user_id = u.id
	LEFT JOIN clinics c ON r.clinic_id = c.id
	LEFT JOIN doctors d ON r.doctor_id = d.id
	LEFT JOIN insurance_companies ic ON r.insurance_company_id = ic.id
`;

const SELECT_CLAUSE = `
	SELECT
		r.id,
		r.rating,
		r.published_at,
		COALESCE(u.name, 'Аноним') as author_name,
		COALESCE(c.name_sr, '') as clinic_name,
		COALESCE(d.name_sr, '') as doctor_name,
		COALESCE(ic.name_sr, '') as insurance_company_name
`;

export default defineEventHandler(async (event): Promise<ReviewListItem[]> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event).catch(() => null);
		const query = String(body?.query || '').trim();

		const connection = await getConnection();

		let rows: any[];
		if (query) {
			const isNumeric = /^\d+$/.test(query);
			const pattern = `%${query}%`;
			const [result]: any = await connection.execute(
				`${SELECT_CLAUSE} ${FROM_CLAUSE}
				WHERE ${isNumeric ? 'r.id = ? OR' : ''} ${foldedLikeAny(SEARCH_COLUMNS)}
				ORDER BY r.published_at DESC
				LIMIT ${SEARCH_LIMIT}`,
				isNumeric
					? [Number(query), ...SEARCH_COLUMNS.map(() => pattern)]
					: SEARCH_COLUMNS.map(() => pattern),
			);
			rows = result;
		} else {
			const [result]: any = await connection.execute(
				`${SELECT_CLAUSE} ${FROM_CLAUSE}
				ORDER BY r.published_at DESC
				LIMIT ${RECENT_LIMIT}`,
			);
			rows = result;
		}

		await connection.end();

		return rows.map((r: any) => {
			const parts = [
				`#${r.id}`,
				r.rating ? `${r.rating}★` : '',
				r.author_name,
				r.clinic_name || r.doctor_name || r.insurance_company_name || '',
				r.published_at
					? new Date(r.published_at).toISOString().slice(0, 10)
					: '',
			].filter(Boolean);
			return { id: r.id, label: parts.join(' | ') };
		});
	} catch (error) {
		console.error('API Error - reviews list:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch reviews list',
		});
	}
});
