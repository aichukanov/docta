import { LanguageId } from '~/enums/language';

/**
 * Слаги всех статей — источник для sitemap.
 *
 * Раньше список жил захардкоженным массивом из ДВУХ слагов прямо в
 * `server/common/sitemap/sitemap.ts`, при 17 статьях в `pages/articles/`.
 * Расхождение было молчаливым и стоило 15 страниц: в индексе Яндекса нашлись
 * ровно те две статьи, что были в sitemap, и ни одной больше — для этого
 * раздела sitemap и есть канал обнаружения, листинг `/articles` не работает.
 * См. prd/silent-200-index-hygiene, итерация 2.
 *
 * Массив явный: страницы статичные, а читать файлы в рантайме Nitro нельзя.
 * За актуальностью следит `tests/unit/article-slugs.spec.ts` — он падает, если
 * список разошёлся с файлами `pages/articles/` или со ссылками на листинге.
 * Добавил статью — допиши слаг сюда.
 */
export const ARTICLE_SLUGS = [
	'birth-in-montenegro',
	'child-healthcare-in-montenegro',
	'clinics-with-language-support',
	'dentistry-in-montenegro',
	'health-insurance-for-residence-permit',
	'healthcare-in-bar',
	'healthcare-in-budva',
	'healthcare-in-kotor',
	'healthcare-in-podgorica',
	'healthcare-system-in-montenegro',
	'lab-tests-and-checkups',
	'medications-not-available-in-montenegro',
	'mental-health-in-montenegro',
	'pharmacies-and-medications',
	'russian-speaking-doctors-in-montenegro',
	'tourist-healthcare-in-montenegro',
	'weekend-medical-help-in-montenegro',
];

// Языки для статьи «Клиники с языковой поддержкой» (без сербского — он по умолчанию).
// Используется и на /articles для подсчёта цифр в мета-строке карточки.
export const CLINIC_SUPPORT_LANGUAGE_IDS = [
	LanguageId.EN,
	LanguageId.RU,
	LanguageId.DE,
	LanguageId.TR,
	LanguageId.IT,
	LanguageId.FR,
];
