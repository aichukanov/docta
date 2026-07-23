import { getConnection } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';
import { validateBody } from '~/common/validation';
import type {
	MedicineAnalog,
	MedicineDetails,
	MedicineForeignMarket,
} from '~/interfaces/medicine';

export default defineEventHandler(
	async (event): Promise<MedicineDetails | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medicines/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid slug');
				return null;
			}

			const locale = body.locale || 'en';
			const nameField = getLocalizedNameField(locale) || 'name_en';

			const connection = await getConnection();

			// Main medicine data
			const [medRows] = await connection.execute(
				`
			SELECT
				m.id,
				m.cinmed_id,
				m.slug,
				m.name,
				m.strength,
				m.packaging,
				m.detail_packaging,
				m.authorization_number,
				m.authorization_date,
				m.atc_code,
				m.is_active,
				m.detail_url,
				m.updated_at,
				m.pack_total,
				m.pack_unit,
				m.pack_container_count,
				m.pack_per_container,
				m.pack_volume,
				m.pack_volume_unit,
				m.pack_parse_status,
				pf.name as pharmaFormSrc,
				pf.${nameField} as pharmaForm,
				pf.name_en as pharmaFormEn,
				mfg.id as manufacturerId,
				mfg.name as manufacturer,
				mfg.full_address as manufacturerAddress,
				c.${nameField} as country,
				c.name_en as countryEn,
				ah.name as authorizationHolder,
				m.dispensing_mode_id,
				ag.${nameField} as atcGroup,
				ag.name_en as atcGroupEn,
				ag.code as atcGroupCode
			FROM med_medicines m
			LEFT JOIN med_pharma_forms pf ON pf.id = m.pharmaceutical_form_id
			LEFT JOIN med_manufacturers mfg ON mfg.id = m.manufacturer_id
			LEFT JOIN countries c ON c.id = mfg.country_id
			LEFT JOIN med_auth_holders ah ON ah.id = m.authorization_holder_id
			LEFT JOIN med_atc_groups ag ON ag.id = m.atc_group_id
			WHERE m.slug = ?
			LIMIT 1
		`,
				[body.slug],
			);

			const med = (medRows as any[])[0];
			if (!med) {
				await connection.end();
				return null;
			}

			// Substances for this medicine
			const [subRows] = await connection.execute(
				`
			SELECT
				s.id,
				s.name as src,
				s.${nameField} as name,
				s.name_en as nameEn
			FROM med_medicine_substances mms
			JOIN med_substances s ON s.id = mms.substance_id
			WHERE mms.medicine_id = ?
		`,
				[med.id],
			);

			// Аналоги — сравнение МНОЖЕСТВ действующих веществ, не «хотя бы одно общее»:
			// exact — состав совпадает полностью; superset — содержит весь состав плюс
			// дополнительные вещества; partial — только часть состава. Сортировка:
			// сначала полные совпадения, внутри группы — от монопрепаратов к комбинациям
			// (тот же ключ даёт нужный порядок и в секции «компоненты по отдельности»).
			const substances = subRows as any[];
			let analogs: MedicineAnalog[] = [];

			if (substances.length > 0) {
				const substanceIds = substances.map((s: any) => s.id);
				const targetCount = substanceIds.length;
				const placeholders = substanceIds.map(() => '?').join(',');
				const [analogRows] = await connection.execute(
					`
				SELECT
					m2.id,
					m2.slug,
					m2.name,
					m2.strength,
					pf2.${nameField} as pharmaForm,
					pf2.name_en as pharmaFormEn,
					pf2.name as pharmaFormSrc,
					m2.dispensing_mode_id,
					m2.pack_total,
					m2.pack_unit,
					m2.pack_container_count,
					m2.pack_per_container,
					m2.pack_volume,
					m2.pack_volume_unit,
					m2.pack_parse_status,
					mfg2.name as manufacturer,
					GROUP_CONCAT(
						DISTINCT COALESCE(NULLIF(s3.${nameField}, ''), NULLIF(s3.name_en, ''), s3.name)
						ORDER BY COALESCE(NULLIF(s3.${nameField}, ''), NULLIF(s3.name_en, ''), s3.name)
						SEPARATOR ', '
					) as substances,
					COUNT(DISTINCT mms3.substance_id) as substanceTotal,
					COUNT(DISTINCT CASE WHEN mms3.substance_id IN (${placeholders})
						THEN mms3.substance_id END) as substanceShared
				FROM med_medicine_substances mms2
				JOIN med_medicines m2 ON m2.id = mms2.medicine_id
				LEFT JOIN med_pharma_forms pf2 ON pf2.id = m2.pharmaceutical_form_id
				LEFT JOIN med_manufacturers mfg2 ON mfg2.id = m2.manufacturer_id
				LEFT JOIN med_medicine_substances mms3 ON mms3.medicine_id = m2.id
				LEFT JOIN med_substances s3 ON s3.id = mms3.substance_id
				WHERE mms2.substance_id IN (${placeholders})
					AND m2.id != ?
					AND m2.is_active = 1
				GROUP BY m2.id, pf2.id, mfg2.id
				ORDER BY
					(substanceShared = ?) DESC,
					substanceTotal ASC,
					m2.name ASC
				LIMIT 60
			`,
					[...substanceIds, ...substanceIds, med.id, targetCount],
				);
				analogs = (analogRows as any[]).map((row: any) => {
					const total = Number(row.substanceTotal);
					const shared = Number(row.substanceShared);
					return {
						id: row.id,
						slug: row.slug,
						name: row.name,
						strength: row.strength,
						pharmaForm: row.pharmaForm || row.pharmaFormEn || null,
						pharmaFormSrc: row.pharmaFormSrc || null,
						dispensingModeId: row.dispensing_mode_id || null,
						manufacturer: row.manufacturer,
						substances: row.substances || null,
						matchType:
							shared === targetCount
								? total === targetCount
									? 'exact'
									: 'superset'
								: 'partial',
						pack_total: row.pack_total,
						pack_unit: row.pack_unit,
						pack_container_count: row.pack_container_count,
						pack_per_container: row.pack_per_container,
						pack_volume:
							row.pack_volume != null ? Number(row.pack_volume) : null,
						pack_volume_unit: row.pack_volume_unit,
						pack_parse_status: row.pack_parse_status,
					};
				});
			}

			// Зарубежные торговые названия того же вещества (med_foreign_brands),
			// сгруппированы по рынку в порядке RU/DE/PL/US. Отдельный try/catch:
			// пока миграция не применена, таблицы нет — фича просто пустая, не 500.
			let foreignBrands: MedicineForeignMarket[] = [];
			if (substances.length > 0) {
				try {
					const fbIds = substances.map((s: any) => s.id);
					const fbPlaceholders = fbIds.map(() => '?').join(',');
					const [fbRows] = await connection.execute(
						`
					SELECT fb.market_code, fb.brand_name, fb.strength, fb.pharma_form, fb.note,
						COALESCE(NULLIF(s.${nameField}, ''), NULLIF(s.name_en, ''), s.name) AS substanceName
					FROM med_foreign_brands fb
					JOIN med_substances s ON s.id = fb.substance_id
					WHERE fb.substance_id IN (${fbPlaceholders})
						-- не показываем бренд, совпадающий с самим МНН (Ибупрофен на карточке ибупрофена)
						AND LOWER(fb.brand_name) NOT IN (
							LOWER(COALESCE(s.name, '')),
							LOWER(COALESCE(s.name_en, '')),
							LOWER(COALESCE(s.name_ru, '')),
							LOWER(COALESCE(s.name_sr, '')),
							LOWER(COALESCE(s.name_de, '')),
							LOWER(COALESCE(s.name_tr, ''))
						)
					-- fb.id ASC = порядок вставки = порядок агента (флагман первым)
					ORDER BY FIELD(fb.market_code, 'RU', 'DE', 'PL', 'US'), fb.id
				`,
						fbIds,
					);
					const order = ['RU', 'DE', 'PL', 'US'];
					const byMarket = new Map<string, MedicineForeignMarket['brands']>();
					const seen = new Set<string>();
					for (const r of fbRows as any[]) {
						const key = `${r.market_code}|${r.brand_name}`;
						if (seen.has(key)) continue; // дедуп при мульти-веществе
						seen.add(key);
						if (!byMarket.has(r.market_code)) byMarket.set(r.market_code, []);
						byMarket.get(r.market_code)!.push({
							brand: r.brand_name,
							substance: r.substanceName || null,
							strength: r.strength || null,
							pharmaForm: r.pharma_form || null,
							note: r.note || null,
						});
					}
					foreignBrands = [...byMarket.keys()]
						.sort(
							(a, b) =>
								(order.indexOf(a) + 1 || 99) - (order.indexOf(b) + 1 || 99),
						)
						.map((market) => ({ market, brands: byMarket.get(market)! }));
				} catch {
					foreignBrands = [];
				}
			}

			await connection.end();

			return {
				id: med.id,
				cinmedId: med.cinmed_id,
				slug: med.slug,
				name: med.name,
				strength: med.strength,
				packaging: med.packaging,
				detailPackaging: med.detail_packaging,
				authorizationNumber: med.authorization_number,
				authorizationDate: med.authorization_date,
				atcCode: med.atc_code,
				isActive: !!med.is_active,
				detailUrl: med.detail_url,
				updatedAt: med.updated_at,
				pharmaForm: med.pharmaForm || med.pharmaFormEn || null,
				pharmaFormSrc: med.pharmaFormSrc || null,
				pack_total: med.pack_total,
				pack_unit: med.pack_unit,
				pack_container_count: med.pack_container_count,
				pack_per_container: med.pack_per_container,
				pack_volume: med.pack_volume != null ? Number(med.pack_volume) : null,
				pack_volume_unit: med.pack_volume_unit,
				pack_parse_status: med.pack_parse_status,
				manufacturerId: med.manufacturerId || null,
				manufacturer: med.manufacturer,
				manufacturerAddress: med.manufacturerAddress,
				country: med.country || med.countryEn || null,
				authorizationHolder: med.authorizationHolder,
				dispensingModeId: med.dispensing_mode_id || null,
				atcGroup: med.atcGroup || med.atcGroupEn || null,
				atcGroupCode: med.atcGroupCode,
				substances: substances.map((s: any) => ({
					id: s.id,
					name: s.name || s.nameEn || s.src,
				})),
				analogs,
				foreignBrands,
			};
		} catch (error) {
			console.error('API Error - medicine details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medicine data',
			});
		}
	},
);
