export const URLS = {
	HOME: '/',
	CLINICS: '/clinics',
	DOCTORS: '/doctors',
	SERVICES: '/services',
	LABTESTS: '/labtests',
	// Два разных раздела, названия легко перепутать:
	// /medicines — реестр лекарств (пункт «Lekovi» в шапке),
	// /medications — лекарства, которые продают клиники.
	MEDICINES: '/medicines',
	MEDICATIONS: '/medications',
	INSURANCE_COMPANIES: '/insurance-companies',
	ARTICLES: '/articles',
} as const;
