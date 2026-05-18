/**
 * Reference tariff row from `medical_service_tariffs` table.
 * Represents a state-insurance pricelist entry (FZOCG and similar) — NOT a clinic price.
 */
export type TariffSource =
	| 'fzocg-pzz'
	| 'fzocg-sekundarna'
	| 'fzocg-drg'
	| 'fzocg-transfuziologija'
	| 'fzocg-apotekarska'
	| 'fzocg-medicinsko-pomagala'
	| 'fzocg-van-mreze';

export type TariffScheme = 'single' | 'dual' | 'operacija' | 'coefficient';

export interface MedicalServiceTariff {
	id: number;
	tariffSource: TariffSource;
	code: string;
	scheme: TariffScheme;

	priceEur: number | null;
	priceOdjeljenjeEur: number | null;
	priceAmbulantaEur: number | null;
	priceOperacijaEur: number | null;
	priceAnestezijaEur: number | null;
	priceUkupnoEur: number | null;
	coefficient: number | null;
	baseCoefficientEur: number | null;

	nameSrLatin: string | null;
	section: string | null;
	subsection: string | null;
	amendedFrom: string | null;
	effectiveFrom: string | null;
	sourceSignedNumber: string | null;
}
