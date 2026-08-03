import { URLS } from './constants';

/**
 * Описание раздела-листинга. Все семь листингов рендерятся одним компонентом
 * `components/list-page.vue`, а все детальные страницы — одним
 * `components/entity-page/index.vue`, поэтому общий контракт (карточки,
 * пагинация, переход в карточку, кнопка «к поиску») проверяется одним
 * параметризованным спеком, а не семью почти одинаковыми файлами.
 *
 * Различается только разметка самой карточки — она и вынесена в конфиг.
 */
export interface ListingSection {
	/** Сегмент URL и часть имени теста */
	key: string;
	url: string;
	/** Селектор названия внутри `.results-list-item` */
	nameSelector: string;
	/** Есть ли раздел в главном меню шапки (проверяется в navigation.spec) */
	inHeaderNav: boolean;
}

export const LISTING_SECTIONS: ListingSection[] = [
	{
		key: 'doctors',
		url: URLS.DOCTORS,
		nameSelector: '.doctor-name',
		inHeaderNav: true,
	},
	{
		key: 'clinics',
		url: URLS.CLINICS,
		nameSelector: '.clinic-name',
		inHeaderNav: true,
	},
	{
		key: 'labtests',
		url: URLS.LABTESTS,
		nameSelector: '.lab-test-name',
		inHeaderNav: true,
	},
	{
		key: 'services',
		url: URLS.SERVICES,
		nameSelector: '.service-name',
		inHeaderNav: true,
	},
	{
		key: 'medicines',
		url: URLS.MEDICINES,
		nameSelector: '.medicine-name',
		inHeaderNav: true,
	},
	{
		key: 'medications',
		url: URLS.MEDICATIONS,
		nameSelector: '.list-card-header',
		inHeaderNav: false,
	},
	{
		key: 'insurance-companies',
		url: URLS.INSURANCE_COMPANIES,
		nameSelector: '.insurance-summary-card__name',
		inHeaderNav: false,
	},
];

/**
 * URL детальной страницы: `/<раздел>/<слаг>`.
 *
 * Именно слаг, не число: числовые ID отдают 301 на слаг
 * (server/common/redirect/slug-redirects.ts), поэтому в адресной строке
 * числа оказаться не должно.
 */
export function detailUrlPattern(key: string): RegExp {
	return new RegExp(`/${key}/(?!\\d+(?:[/?#]|$))[^/?#]+`);
}

/** URL листинга: `/<раздел>` без хвоста детальной страницы */
export function listUrlPattern(key: string): RegExp {
	return new RegExp(`/${key}(?:/)?(?:\\?.*)?$`);
}
