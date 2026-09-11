import type { MedicalServiceTariff } from '~/interfaces/medical-service-tariff';

/**
 * Справочные тарифы ФЗОЦГ для детальной страницы каталога.
 *
 * Таблица называется medical_service_tariffs по историческим причинам — она
 * обслуживает оба каталога. Часть кодов прайса лабораторная (разделы K01/K02 —
 * микробиология, L01 — патогистология, Z01 — биохимия и гематология), и такие
 * строки ссылаются на lab_tests, а не на medical_services.
 *
 * Заполнена всегда максимум одна из двух ссылок, но ограничением БД это не
 * выражено: MySQL 8 не пускает в CHECK колонку, по которой у внешнего ключа
 * стоит ON DELETE SET NULL (подробности в конце миграции 028). Поэтому каждый
 * запрос ниже читает строго ПО ОДНОЙ колонке — так нарушенная строка не
 * покажется в двух каталогах сразу.
 *
 * Строк на одну запись каталога бывает несколько: одна и та же процедура
 * тарифицируется и по PZZ, и по «секундарному» прайсу. Порядок карточек
 * фиксируем по источнику, чтобы выдача не прыгала между запросами.
 */

const TARIFF_COLUMNS = `
	id, tariff_source, code, scheme,
	price_eur, price_odjeljenje_eur, price_ambulanta_eur,
	price_operacija_eur, price_anestezija_eur, price_ukupno_eur,
	coefficient, base_coefficient_eur,
	name_sr_latin, section, subsection,
	amended_from, effective_from, source_signed_number
`;

const TARIFF_ORDER = `
	ORDER BY FIELD(tariff_source,
		'fzocg-pzz','fzocg-sekundarna','fzocg-drg',
		'fzocg-transfuziologija','fzocg-apotekarska',
		'fzocg-medicinsko-pomagala','fzocg-van-mreze'
	), code
`;

const num = (value: unknown): number | null =>
	value != null ? Number(value) : null;

const day = (value: unknown): string | null =>
	value ? new Date(value as string).toISOString().slice(0, 10) : null;

function mapTariff(t: any): MedicalServiceTariff {
	return {
		id: t.id,
		tariffSource: t.tariff_source,
		code: t.code,
		scheme: t.scheme,
		priceEur: num(t.price_eur),
		priceOdjeljenjeEur: num(t.price_odjeljenje_eur),
		priceAmbulantaEur: num(t.price_ambulanta_eur),
		priceOperacijaEur: num(t.price_operacija_eur),
		priceAnestezijaEur: num(t.price_anestezija_eur),
		priceUkupnoEur: num(t.price_ukupno_eur),
		coefficient: num(t.coefficient),
		baseCoefficientEur: num(t.base_coefficient_eur),
		nameSrLatin: t.name_sr_latin,
		section: t.section,
		subsection: t.subsection,
		amendedFrom: day(t.amended_from),
		effectiveFrom: day(t.effective_from),
		sourceSignedNumber: t.source_signed_number,
	};
}

/**
 * Тарифы услуги. `connection` — уже открытое соединение вызывающего:
 * детальная страница и так делает несколько запросов подряд, брать под тарифы
 * отдельное соединение незачем.
 */
export async function fetchServiceTariffs(
	connection: any,
	medicalServiceId: number,
): Promise<MedicalServiceTariff[]> {
	const [rows] = await connection.execute(
		`SELECT ${TARIFF_COLUMNS}
		 FROM medical_service_tariffs
		 WHERE medical_service_id = ?
		 ${TARIFF_ORDER}`,
		[medicalServiceId],
	);
	return (rows as any[]).map(mapTariff);
}

/** Тарифы анализа — лабораторные коды прайса, см. комментарий выше. */
export async function fetchLabTestTariffs(
	connection: any,
	labTestId: number,
): Promise<MedicalServiceTariff[]> {
	const [rows] = await connection.execute(
		`SELECT ${TARIFF_COLUMNS}
		 FROM medical_service_tariffs
		 WHERE lab_test_id = ?
		 ${TARIFF_ORDER}`,
		[labTestId],
	);
	return (rows as any[]).map(mapTariff);
}
