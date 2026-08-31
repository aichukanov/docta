import { fetchClinicItemsSummary } from '~/server/common/clinic-items-summary';
import { GONE_PAYLOAD, type GonePayload } from '~/common/gone';
import { getCurrentUser } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { isClinicAdmin } from '~/server/common/clinic-admins';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import { fetchClinicCoupons } from '~/server/common/clinic-coupons';
import type { ClinicItemsSummary, ClinicStatus } from '~/interfaces/clinic';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';
import { isValidLocale, validateBody } from '~/common/validation';

export interface ClinicItemsSummaryResponse {
	id: number;
	slug: string;
	name: string;
	localName: string;
	itemsSummary: ClinicItemsSummary;
	// Купон нужен подстраницам с ценами — у крупных клиник основной список
	// услуг живёт здесь, а не на главной странице клиники
	coupon?: ClinicCoupon;
	// Непубличная клиника: подстраница доезжает только до владельца и админа
	// и рисует ту же плашку, что и главная страница клиники
	status?: ClinicStatus;
	hidden?: boolean;
	hiddenReason?: string;
	isOwner?: boolean;
}

export default defineEventHandler(
	async (event): Promise<ClinicItemsSummaryResponse | GonePayload | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/items-summary')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}
			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid clinic slug');
				return null;
			}

			const locale = isValidLocale(body.locale) ? body.locale : 'en';
			const connection = await getConnection();
			// Статус, hidden и владельца читаем, а не фильтруем в SQL: подстранице
			// нужно отличить «нет такой клиники» (404) от «скрыта админом» (410),
			// а владельцу и админу — показать содержимое с плашкой.
			const [rows] = await connection.execute(
				`SELECT id, slug, status, hidden, hidden_reason,
					name_sr, name_sr_cyrl, name_ru
				FROM clinics WHERE slug = ? LIMIT 1`,
				[body.slug],
			);

			const clinic = (rows as any[])[0];
			const currentUser = await getCurrentUser(event);
			// Проверку прав делаем до end(): администраторы клиники живут в
			// отдельной таблице, а не в колонке clinics
			const isOwner = await isClinicAdmin(
				connection,
				clinic?.id,
				currentUser?.id,
			);
			await connection.end();

			const canSeeNonPublic = isOwner || !!currentUser?.is_admin;

			// Права те же, что на главной странице клиники (clinics/details.ts).
			// Статус ответа ставит страница, а не эндпоинт: любой не-2xx ответ
			// здесь useFetch считает ошибкой и обнуляет data — маркер до
			// страницы не доехал бы, и подстраница отдала бы 404 вместо 410.
			if (clinic?.hidden && !canSeeNonPublic) {
				return GONE_PAYLOAD;
			}
			if (!clinic || (clinic.status !== 'published' && !canSeeNonPublic)) {
				setResponseStatus(event, 404, 'Clinic not found');
				return null;
			}

			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				clinic,
				locale,
			);
			const itemsSummary = await fetchClinicItemsSummary(clinic.id, locale);
			const coupon = (await fetchClinicCoupons(clinic.id)).get(clinic.id);

			return {
				id: clinic.id,
				slug: clinic.slug,
				name,
				localName,
				itemsSummary,
				coupon,
				status: clinic.status as ClinicStatus,
				hidden: Boolean(clinic.hidden),
				hiddenReason: clinic.hidden_reason || '',
				isOwner,
			};
		} catch (error) {
			console.error('API Error - clinic items-summary:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch clinic items summary',
			});
		}
	},
);
