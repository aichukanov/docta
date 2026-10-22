import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { getConnection } from '~/server/common/db-mysql';
import { parseCautionTypes } from '~/server/common/clinic-reputation';
import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

// Слаги публичных клиник — по ним статьи решают, оставлять ли ссылку.
// В статьях ссылки на клиники захардкожены слагами (это часть текста, а не
// выборка), и после скрытия клиники ссылка вела бы на 410. Отдельный лёгкий
// эндпоинт вместо /api/clinics/list: нужен только список слагов, а не сотня
// клиник с расписаниями в payload SEO-страницы.
// caution — слаг → типы активных подтверждённых жалоб: ClinicRouteLink
// дорисовывает к ссылке бейдж «Осторожно» (prd/clinic-reputation/).
export default defineEventHandler(
	async (): Promise<{
		slugs: string[];
		caution: Record<string, ClinicComplaintType[]>;
	}> => {
		const connection = await getConnection();
		try {
			const [rows] = await connection.execute<any[]>(
				`SELECT
					c.slug,
					(
						SELECT GROUP_CONCAT(cc.complaint_type ORDER BY cc.complaint_type)
						FROM clinic_complaints cc
						WHERE cc.clinic_id = c.id AND cc.is_active = 1 AND cc.status = 'confirmed'
					) as cautionTypes
				FROM clinics c WHERE ${clinicIsPublicSql('c')} ORDER BY c.slug`,
			);
			const caution: Record<string, ClinicComplaintType[]> = {};
			for (const row of rows) {
				const types = parseCautionTypes(row.cautionTypes);
				if (types.length > 0) {
					caution[row.slug as string] = types;
				}
			}
			return {
				slugs: rows.map((row) => row.slug as string),
				caution,
			};
		} catch (error) {
			console.error('API Error - clinics/public-slugs:', error);
			// Пустой список означал бы «все ссылки битые» — безопаснее считать,
			// что клиники на месте, чем молча снять все ссылки в статьях.
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch public clinic slugs',
			});
		} finally {
			await connection.end();
		}
	},
);
