import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
} from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { validateBody } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices> => {
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

			const locale = body.locale || 'en';

			const priceOrder = getPriceOrderBySQL();
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
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', IFNULL(price, ''), ':', IFNULL(price_min, ''), ':', IFNULL(price_max, ''), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
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

			// Reference tariffs (FZOCG and similar). Multiple rows per service —
			// e.g. a single procedure can be tariffed under both PZZ and sekundarna.
			// Ordered by tariff_source for stable card sequence.
			const [tariffRows] = await connection.execute(
				`SELECT
					id, tariff_source, code, scheme,
					price_eur, price_odjeljenje_eur, price_ambulanta_eur,
					price_operacija_eur, price_anestezija_eur, price_ukupno_eur,
					coefficient, base_coefficient_eur,
					name_sr_latin, section, subsection,
					amended_from, effective_from, source_signed_number
				FROM medical_service_tariffs
				WHERE medical_service_id = ?
				ORDER BY FIELD(tariff_source,
					'fzocg-pzz','fzocg-sekundarna','fzocg-drg',
					'fzocg-transfuziologija','fzocg-apotekarska',
					'fzocg-medicinsko-pomagala','fzocg-van-mreze'
				), code`,
				[row.id],
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

			const tariffs = (tariffRows as any[]).map((t) => ({
				id: t.id,
				tariffSource: t.tariff_source,
				code: t.code,
				scheme: t.scheme,
				priceEur: t.price_eur != null ? Number(t.price_eur) : null,
				priceOdjeljenjeEur:
					t.price_odjeljenje_eur != null
						? Number(t.price_odjeljenje_eur)
						: null,
				priceAmbulantaEur:
					t.price_ambulanta_eur != null ? Number(t.price_ambulanta_eur) : null,
				priceOperacijaEur:
					t.price_operacija_eur != null ? Number(t.price_operacija_eur) : null,
				priceAnestezijaEur:
					t.price_anestezija_eur != null
						? Number(t.price_anestezija_eur)
						: null,
				priceUkupnoEur:
					t.price_ukupno_eur != null ? Number(t.price_ukupno_eur) : null,
				coefficient: t.coefficient != null ? Number(t.coefficient) : null,
				baseCoefficientEur:
					t.base_coefficient_eur != null
						? Number(t.base_coefficient_eur)
						: null,
				nameSrLatin: t.name_sr_latin,
				section: t.section,
				subsection: t.subsection,
				amendedFrom: t.amended_from
					? new Date(t.amended_from).toISOString().slice(0, 10)
					: null,
				effectiveFrom: t.effective_from
					? new Date(t.effective_from).toISOString().slice(0, 10)
					: null,
				sourceSignedNumber: t.source_signed_number,
			}));

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
				tariffs,
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
