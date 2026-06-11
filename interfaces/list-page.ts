import type { ClinicPrice, ClinicServicesByClinicId } from './clinic';

// Базовая форма элемента listing-страницы (ListPage). Конкретные страницы
// передают свои типы через generic-параметр T компонента list-page.
export interface ListPageItem {
	id: number;
	slug?: string;
	name?: string;
	localName?: string;
	synonyms?: string[];
	clinicIds?: string;
	clinicCount?: number;
	clinicPrices?: ClinicPrice[];
	clinicServices?: ClinicServicesByClinicId;
}
