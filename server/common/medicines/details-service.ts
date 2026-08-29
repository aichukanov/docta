// Сервис детальной карточки лекарства: собирает ядро + вещества + аналоги ЧГ +
// зарубежные бренды. Хендлер (server/api/medicines/details.ts) — тонкая обёртка.
import { doseMatches } from '~/common/strength-label';
import { getPharmaFormCategory } from '~/enums/pharma-form';
import type {
	MedicineAnalog,
	MedicineDetails,
	MedicineForeignMarket,
} from '~/interfaces/medicine';
import {
	type Conn,
	localizedField,
	localizedNameSql,
	localizedReferenceSql,
	mapPack,
	nameFieldFor,
	placeholders,
	referenceLocaleSuffix,
	withConnection,
} from './helpers';
import { matchSubstanceSet } from './substance-match';

const MARKET_ORDER = ['RU', 'UA', 'TR', 'DE', 'PL', 'US'];
const FOREIGN_TOP_N = 5;
const ANALOG_LIMIT = 60;

type SubstanceRow = {
	id: number;
	src: string;
	name: string;
	nameEn: string;
	// Справка из med_substance_reference_info (миграция 024); NULL, пока текста нет
	refWhat: string | null;
	refUsedFor: string | null;
	refCaution: string | null;
};
interface PageMaps {
	ids: number[];
	idSet: Set<number>;
	nameById: Map<number, string>;
}

// «id::~::name || id::~::name» → [{id,name}] (разделители безопасны для данных)
const parsePairs = (s: string | null): { id: number; name: string }[] =>
	String(s || '')
		.split('||~||')
		.filter(Boolean)
		.map((p) => {
			const [id, name] = p.split('::~::');
			return { id: Number(id), name };
		});

const localizedName = (row: SubstanceRow) => row.name || row.nameEn || row.src;

async function fetchMedicine(conn: Conn, slug: string, nameField: string) {
	const [rows] = await conn.execute(
		`
		SELECT
			m.id, m.cinmed_id, m.slug, m.name, m.strength, m.packaging,
			m.detail_packaging, m.authorization_number, m.authorization_date,
			m.atc_code, m.is_active, m.detail_url, m.updated_at,
			m.pack_total, m.pack_unit, m.pack_container_count, m.pack_per_container,
			m.pack_volume, m.pack_volume_unit, m.pack_parse_status,
			m.pharmaceutical_form_id as pharmaFormId,
			pf.name as pharmaFormSrc, pf.${nameField} as pharmaForm, pf.name_en as pharmaFormEn,
			mfg.id as manufacturerId, mfg.name as manufacturer, mfg.full_address as manufacturerAddress,
			c.${nameField} as country, c.name_en as countryEn,
			ah.name as authorizationHolder, m.dispensing_mode_id,
			ag.${nameField} as atcGroup, ag.name_en as atcGroupEn, ag.code as atcGroupCode
		FROM med_medicines m
		LEFT JOIN med_pharma_forms pf ON pf.id = m.pharmaceutical_form_id
		LEFT JOIN med_manufacturers mfg ON mfg.id = m.manufacturer_id
		LEFT JOIN countries c ON c.id = mfg.country_id
		LEFT JOIN med_auth_holders ah ON ah.id = m.authorization_holder_id
		LEFT JOIN med_atc_groups ag ON ag.id = m.atc_group_id
		WHERE m.slug = ?
		LIMIT 1
	`,
		[slug],
	);
	return (rows as any[])[0] || null;
}

async function fetchSubstances(
	conn: Conn,
	medId: number,
	nameField: string,
	locale?: string,
): Promise<SubstanceRow[]> {
	const suffix = referenceLocaleSuffix(locale);
	const [rows] = await conn.execute(
		`
		SELECT s.id, s.name as src, s.${nameField} as name, s.name_en as nameEn,
			${localizedReferenceSql('sri', 'what', suffix)} as refWhat,
			${localizedReferenceSql('sri', 'used_for', suffix)} as refUsedFor,
			${localizedReferenceSql('sri', 'caution', suffix)} as refCaution
		FROM med_medicine_substances mms
		JOIN med_substances s ON s.id = mms.substance_id
		LEFT JOIN med_substance_reference_info sri ON sri.substance_id = s.id
		WHERE mms.medicine_id = ?
	`,
		[medId],
	);
	return rows as SubstanceRow[];
}

// Аналоги ЧГ: сравнение множеств веществ. matchType — exact/superset/partial;
// плюс per-substance бейджи (matched/extra/missing) через общий matchSubstanceSet.
async function fetchAnalogs(
	conn: Conn,
	med: any,
	page: PageMaps,
	nameField: string,
): Promise<MedicineAnalog[]> {
	if (page.ids.length === 0) return [];
	const target = page.ids.length;
	const ph = placeholders(target);
	const nameExpr = localizedNameSql('s3', nameField);
	const [rows] = await conn.execute(
		`
		SELECT
			m2.id, m2.slug, m2.name, m2.strength, m2.pharmaceutical_form_id as pharmaFormId,
			pf2.${nameField} as pharmaForm, pf2.name_en as pharmaFormEn, pf2.name as pharmaFormSrc,
			m2.dispensing_mode_id,
			m2.pack_total, m2.pack_unit, m2.pack_container_count, m2.pack_per_container,
			m2.pack_volume, m2.pack_volume_unit, m2.pack_parse_status,
			mfg2.name as manufacturer,
			GROUP_CONCAT(DISTINCT ${nameExpr} ORDER BY ${nameExpr} SEPARATOR ', ') as substances,
			GROUP_CONCAT(DISTINCT CONCAT(mms3.substance_id, '::~::', ${nameExpr}) SEPARATOR '||~||') as substancePairs,
			COUNT(DISTINCT mms3.substance_id) as substanceTotal,
			COUNT(DISTINCT CASE WHEN mms3.substance_id IN (${ph}) THEN mms3.substance_id END) as substanceShared
		FROM med_medicine_substances mms2
		JOIN med_medicines m2 ON m2.id = mms2.medicine_id
		LEFT JOIN med_pharma_forms pf2 ON pf2.id = m2.pharmaceutical_form_id
		LEFT JOIN med_manufacturers mfg2 ON mfg2.id = m2.manufacturer_id
		LEFT JOIN med_medicine_substances mms3 ON mms3.medicine_id = m2.id
		LEFT JOIN med_substances s3 ON s3.id = mms3.substance_id
		WHERE mms2.substance_id IN (${ph}) AND m2.id != ? AND m2.is_active = 1
		GROUP BY m2.id, pf2.id, mfg2.id
		ORDER BY (substanceShared = ?) DESC, substanceTotal ASC, m2.name ASC
		LIMIT ${ANALOG_LIMIT}
	`,
		[...page.ids, ...page.ids, med.id, target],
	);

	return (rows as any[]).map((row) => {
		const total = Number(row.substanceTotal);
		const shared = Number(row.substanceShared);
		const match = matchSubstanceSet(
			page.idSet,
			page.nameById,
			parsePairs(row.substancePairs),
		);
		return {
			id: row.id,
			slug: row.slug,
			name: row.name,
			strength: row.strength,
			pharmaForm: localizedField(row, 'pharmaForm'),
			pharmaFormSrc: row.pharmaFormSrc || null,
			pharmaFormId: row.pharmaFormId ?? null,
			dispensingModeId: row.dispensing_mode_id || null,
			manufacturer: row.manufacturer,
			substances: row.substances || null,
			substanceList: match.substances,
			missingSubstances: match.missing,
			matchType:
				shared === target
					? total === target
						? 'exact'
						: 'superset'
					: 'partial',
			...mapPack(row),
		};
	});
}

// Зарубежные бренды (med_foreign_products) с set-matching, сопоставлением формы и
// дозы, ранжированием и топ-N на рынок. Свой try/catch: без применённой миграции
// таблиц нет — фича пустая, не 500.
async function fetchForeignBrands(
	conn: Conn,
	med: any,
	page: PageMaps,
	nameField: string,
): Promise<MedicineForeignMarket[]> {
	if (page.ids.length === 0) return [];
	try {
		const ph = placeholders(page.ids.length);
		const [rows] = await conn.execute(
			`
			SELECT p.id AS productId, p.market_code, p.brand_name, p.strength, p.note, p.sort_order,
				p.pharma_form_id AS formId,
				pf.name AS formSrc, ${localizedNameSql('pf', nameField)} AS formName,
				fps.substance_id, ${localizedNameSql('s', nameField)} AS substanceName
			FROM med_foreign_products p
			JOIN med_foreign_product_substances fps ON fps.product_id = p.id
			JOIN med_substances s ON s.id = fps.substance_id
			LEFT JOIN med_pharma_forms pf ON pf.id = p.pharma_form_id
			WHERE p.id IN (
				SELECT DISTINCT product_id FROM med_foreign_product_substances WHERE substance_id IN (${ph})
			)
			ORDER BY FIELD(p.market_code, 'RU', 'UA', 'TR', 'DE', 'PL', 'US'), p.sort_order, p.id
		`,
			page.ids,
		);

		const pageFormCat = getPharmaFormCategory(med.pharmaFormId);

		// строки → продукты
		const productMap = new Map<number, any>();
		for (const r of rows as any[]) {
			let p = productMap.get(r.productId);
			if (!p) {
				p = {
					market: r.market_code,
					brand: r.brand_name,
					strength: r.strength || null,
					pharmaForm: r.formName || null,
					pharmaFormSrc: r.formSrc || null,
					pharmaFormId: r.formId ?? null,
					note: r.note || null,
					sortOrder: r.sort_order ?? 0,
					subs: [] as { id: number; name: string }[],
				};
				productMap.set(r.productId, p);
			}
			p.subs.push({ id: Number(r.substance_id), name: r.substanceName || '' });
		}

		// set-matching + флаги формы/дозы + группировка по рынку
		const byMarket = new Map<string, any[]>();
		for (const p of productMap.values()) {
			const match = matchSubstanceSet(page.idSet, page.nameById, p.subs);
			if (match.matchedCount === 0) continue;
			p.match = match;
			p.formMatch =
				pageFormCat !== 'other' &&
				getPharmaFormCategory(p.pharmaFormId) === pageFormCat;
			p.doseMatch = doseMatches(med.strength, p.strength);
			if (!byMarket.has(p.market)) byMarket.set(p.market, []);
			byMarket.get(p.market)!.push(p);
		}

		// Ранг: 1) больше совпавших веществ; 2) меньше лишних; 3) совпала форма;
		// 4) совпала доза; 5) меньше отсутствующих; 6) порядок агента (флагман первым).
		const rank = (a: any, b: any) =>
			b.match.matchedCount - a.match.matchedCount ||
			a.match.extraCount - b.match.extraCount ||
			(b.formMatch ? 1 : 0) - (a.formMatch ? 1 : 0) ||
			(b.doseMatch ? 1 : 0) - (a.doseMatch ? 1 : 0) ||
			a.match.missing.length - b.match.missing.length ||
			a.sortOrder - b.sortOrder;

		return MARKET_ORDER.filter((m) => byMarket.has(m)).map((market) => ({
			market,
			products: byMarket
				.get(market)!
				.sort(rank)
				.slice(0, FOREIGN_TOP_N)
				.map((p) => ({
					brand: p.brand,
					strength: p.strength,
					pharmaForm: p.pharmaForm,
					pharmaFormSrc: p.pharmaFormSrc,
					pharmaFormId: p.pharmaFormId,
					note: p.note,
					substances: p.match.substances,
					missing: p.match.missing,
					matchedCount: p.match.matchedCount,
					fullMatch: p.match.fullMatch,
					doseMatch: p.doseMatch,
					formMatch: p.formMatch,
					// галочку ✓ ставим только при полном совпадении: вещества + форма + доза
					exactMatch: p.match.fullMatch && p.formMatch && p.doseMatch,
				})),
		}));
	} catch {
		return [];
	}
}

function assembleDetails(
	med: any,
	substances: SubstanceRow[],
	analogs: MedicineAnalog[],
	foreignBrands: MedicineForeignMarket[],
): MedicineDetails {
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
		pharmaForm: localizedField(med, 'pharmaForm'),
		pharmaFormSrc: med.pharmaFormSrc || null,
		pharmaFormId: med.pharmaFormId ?? null,
		...mapPack(med),
		manufacturerId: med.manufacturerId || null,
		manufacturer: med.manufacturer,
		manufacturerAddress: med.manufacturerAddress,
		country: localizedField(med, 'country'),
		authorizationHolder: med.authorizationHolder,
		dispensingModeId: med.dispensing_mode_id || null,
		atcGroup: localizedField(med, 'atcGroup'),
		atcGroupCode: med.atcGroupCode,
		substances: substances.map((s) => ({
			id: s.id,
			name: localizedName(s),
			reference:
				s.refWhat || s.refUsedFor || s.refCaution
					? {
							what: s.refWhat || '',
							usedFor: s.refUsedFor || '',
							caution: s.refCaution || '',
						}
					: null,
		})),
		analogs,
		foreignBrands,
	};
}

export async function getMedicineDetails(
	slug: string,
	locale: string,
): Promise<MedicineDetails | null> {
	const nameField = nameFieldFor(locale);
	return withConnection(async (conn) => {
		const med = await fetchMedicine(conn, slug, nameField);
		if (!med) return null;
		const substances = await fetchSubstances(conn, med.id, nameField, locale);
		const page: PageMaps = {
			ids: substances.map((s) => Number(s.id)),
			idSet: new Set(substances.map((s) => Number(s.id))),
			nameById: new Map(
				substances.map((s) => [Number(s.id), localizedName(s)]),
			),
		};
		const analogs = await fetchAnalogs(conn, med, page, nameField);
		const foreignBrands = await fetchForeignBrands(conn, med, page, nameField);
		return assembleDetails(med, substances, analogs, foreignBrands);
	});
}
