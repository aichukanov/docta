export const URLS = {
	HOME: '/',
	CLINICS: '/clinics',
	DOCTORS: '/doctors',
	SERVICES: '/services',
	LABTESTS: '/labtests',
	// Реестр лекарств ЦИнМЕД, пункт «Lekovi» в шапке. Был ещё почти
	// одноимённый `/medications` (лекарства с ценами по клиникам) — раздел снят
	// с сайта, его адреса отвечают 301/410 (server/common/redirect/
	// removed-medications.ts). Имена путались постоянно, поэтому оговорка
	// оставлена здесь же.
	MEDICINES: '/medicines',
	INSURANCE_COMPANIES: '/insurance-companies',
	ARTICLES: '/articles',
} as const;
