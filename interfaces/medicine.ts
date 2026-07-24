// Лекарство в списке /medicines (ответ /api/medicines/list)
export interface MedicineListItem {
	id: number;
	slug: string;
	name: string;
	strength: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	pharmaFormId: number | null;
	manufacturer: string | null;
	country: string | null;
	// Действующие вещества одной строкой через запятую (GROUP_CONCAT)
	substances: string | null;
	dispensingModeId: number | null;
	isActive: boolean;
	atcCode: string | null;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
}

export interface MedicineList {
	items: MedicineListItem[];
	totalCount: number;
}

export interface MedicineSubstance {
	id: number;
	name: string;
}

// Одно вещество в составе зарубежного продукта, с состоянием сопоставления
// относительно веществ текущей карточки: matched — есть в карточке; extra — лишнее.
export interface MedicineForeignSubstance {
	name: string;
	state: 'matched' | 'extra';
}

// Зарубежный продукт (бренд рынка) с НАБОРОМ веществ и результатом set-matching
// против состава карточки. strength/pharmaForm — описательная справка.
export interface MedicineForeignProduct {
	brand: string;
	strength: string | null;
	// локализованное имя формы (из med_pharma_forms) + сербский src для иконки
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	pharmaFormId: number | null;
	note: string | null;
	// matched-вещества идут первыми, затем extra
	substances: MedicineForeignSubstance[];
	// вещества карточки, которых нет в продукте (показываются перечёркнутыми)
	missing: string[];
	matchedCount: number;
	// наборы действующих веществ полностью совпадают
	fullMatch: boolean;
	// дозировка продукта содержит все дозы карточки (для подсветки бейджа/ранга)
	doseMatch: boolean;
	// форма продукта совпадает с формой карточки (сироп↔сироп)
	formMatch: boolean;
	// полное совпадение: вещества + форма + доза (условие для галочки ✓)
	exactMatch: boolean;
}

// Продукты одного рынка (RU/UA/TR/DE/PL/US). market — код рынка, ярлык из i18n.
export interface MedicineForeignMarket {
	market: string;
	products: MedicineForeignProduct[];
}

// exact — состав совпадает полностью; superset — содержит весь состав плюс
// дополнительные вещества; partial — только часть состава.
export type MedicineAnalogMatchType = 'exact' | 'superset' | 'partial';

export interface MedicineAnalog {
	id: number;
	slug: string;
	name: string;
	strength: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	pharmaFormId: number | null;
	dispensingModeId: number | null;
	manufacturer: string | null;
	substances: string | null;
	// per-substance бейджи относительно текущей карточки (matched/extra) + отсутствующие
	substanceList: MedicineForeignSubstance[];
	missingSubstances: string[];
	matchType: MedicineAnalogMatchType;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
}

// Ответ /api/medicines/details. Даты приходят строками после сериализации.
export interface MedicineDetails {
	id: number;
	cinmedId: number | null;
	slug: string;
	name: string;
	strength: string | null;
	packaging: string | null;
	detailPackaging: string | null;
	authorizationNumber: string | null;
	authorizationDate: string | null;
	atcCode: string | null;
	isActive: boolean;
	detailUrl: string | null;
	updatedAt: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	pharmaFormId: number | null;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
	manufacturerId: number | null;
	manufacturer: string | null;
	manufacturerAddress: string | null;
	country: string | null;
	authorizationHolder: string | null;
	dispensingModeId: number | null;
	atcGroup: string | null;
	atcGroupCode: string | null;
	substances: MedicineSubstance[];
	analogs: MedicineAnalog[];
	// Зарубежные торговые названия того же вещества, сгруппированы по рынку.
	foreignBrands: MedicineForeignMarket[];
}
