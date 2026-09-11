import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import {
	parseClinicPricesData,
	getClinicRankOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
	buildReferenceInfo,
} from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { getDoctorsForServiceByClinic } from '~/server/common/services';
import { fetchServiceTariffs } from '~/server/common/tariffs';
import { isValidLocale, validateBody } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/services/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid medical service slug');
				return null;
			}

			const locale = isValidLocale(body.locale) ? body.locale : 'en';

			// Порядок клиник: композитный скор без локации (rank_score + бонус
			// за цену); вклад расстояния добавит клиент (use-clinic-ranking.ts)
			const rankOrder = getClinicRankOrderBySQL('c_rank', 'cms', {
				hasPriceMin: true,
				hasOutdatedFlag: true,
			});
			const medicalServiceQuery = `
			SELECT DISTINCT
				ms.id,
				ms.slug,
				ms.name_en,
				ms.name_sr,
				ms.name_sr_cyrl,
				ms.name_ru,
				ms.name_de,
				ms.name_tr,
				(
					SELECT GROUP_CONCAT(cms.clinic_id ORDER BY ${rankOrder})
					FROM clinic_medical_services cms
					JOIN clinics c_rank ON c_rank.id = cms.clinic_id AND ${clinicIsPublicSql('c_rank')}
					WHERE cms.medical_service_id = ms.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(cms.clinic_id, ':', IFNULL(cms.price, ''), ':', IFNULL(cms.price_min, ''), ':', IFNULL(cms.price_max, ''), ':', COALESCE(cms.code, ''), ':', cms.is_price_outdated)
						ORDER BY ${rankOrder}
					)
					FROM clinic_medical_services cms
					JOIN clinics c_rank ON c_rank.id = cms.clinic_id AND ${clinicIsPublicSql('c_rank')}
					WHERE cms.medical_service_id = ms.id
				) as clinicPricesData,
				(
					SELECT GROUP_CONCAT(medical_service_category_id ORDER BY medical_service_category_id)
					FROM medical_service_categories_relations
					WHERE medical_service_id = ms.id
				) as categoryIds
			FROM medical_services ms
			WHERE ms.slug = ?
			GROUP BY ms.id, ms.slug, ms.name_en, ms.name_sr, ms.name_sr_cyrl, ms.name_ru, ms.name_de, ms.name_tr;
		`;

			const connection = await getConnection();
			const [medicalServiceRows] = await connection.execute(
				medicalServiceQuery,
				[body.slug],
			);

			const row = (medicalServiceRows as any[])[0];
			if (!row) {
				await connection.end();
				return null;
			}

			const tariffs = await fetchServiceTariffs(connection, row.id);

			const [referenceInfoRows] = await connection.execute(
				`SELECT * FROM medical_service_reference_info WHERE medical_service_id = ?`,
				[row.id],
			);

			// Врачи по клиникам для блока «Врачи» в карточке клиники (см. PRD
			// service-page-doctor-links). Только для услуг, не для анализов.
			const clinicIdList: number[] = row.clinicIds
				? row.clinicIds.split(',').map(Number)
				: [];
			const clinicDoctors = await getDoctorsForServiceByClinic(
				connection,
				row.id,
				clinicIdList,
				locale,
			);

			await connection.end();

			// Обрабатываем локализованные имена
			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				row,
				locale,
			);
			// Удаляем избыточные поля локализации
			const {
				name_en,
				name_sr,
				name_sr_cyrl,
				name_ru,
				name_de,
				name_tr,
				...rest
			} = row;

			return {
				...rest,
				id: row.id,
				name,
				localName,
				clinicIds: row.clinicIds,
				clinicPrices: parseClinicPricesData(row.clinicPricesData),
				categoryIds: row.categoryIds
					? row.categoryIds.split(',').map(Number)
					: [],
				clinicDoctors,
				tariffs,
				referenceInfo: buildReferenceInfo(
					(referenceInfoRows as any[])[0],
					locale,
				),
			};
		} catch (error) {
			console.error('API Error - medical service data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medical service data',
			});
		}
	},
);
