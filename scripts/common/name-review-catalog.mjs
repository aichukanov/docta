/**
 * Каталоги, по которым идёт вычитка названий: услуги (036/037, сентябрь 2026)
 * и анализы. Конвейер общий — scan-name-quality → build-name-review-roster →
 * батчи агентов → validate-name-batches → build-service-names-sql; различаются
 * только таблицы, папка батчей и номера миграций.
 *
 * Каталог выбирается флагом `--catalog svc|lab`, по умолчанию — услуги, чтобы
 * прежние команды из data/service-names/README.md работали как раньше.
 */

import { resolve } from 'node:path';

export const CATALOGS = {
	svc: {
		key: 'svc',
		noun: 'услуг',
		table: 'medical_services',
		clinicTable: 'clinic_medical_services',
		fk: 'medical_service_id',
		synonymTable: 'medical_service_synonyms',
		categoryRelTable: 'medical_service_categories_relations',
		categoryRelColumn: 'medical_service_category_id',
		categoryTable: 'medical_service_categories',
		hasSpecialties: true,
		dir: 'data/service-names',
		searchApi: 'server/api/services/list.ts',
		migrations: {
			fix: '036-service-names-mechanical.sql',
			review: '037-service-names-review.sql',
		},
		audit: 'docs/audit/service-names-2026-09.md',
	},
	lab: {
		key: 'lab',
		noun: 'анализов',
		table: 'lab_tests',
		clinicTable: 'clinic_lab_tests',
		fk: 'lab_test_id',
		synonymTable: 'lab_test_synonyms',
		categoryRelTable: 'lab_test_categories_relations',
		categoryRelColumn: 'category_id',
		categoryTable: 'lab_test_categories',
		hasSpecialties: false,
		dir: 'data/labtest-names',
		searchApi: 'server/api/labtests/list.ts',
		migrations: {
			fix: '046-labtest-names-mechanical.sql',
			review: '047-labtest-names-review.sql',
		},
		audit: 'docs/audit/labtest-names-2026-10.md',
	},
};

/** Каталог из `--catalog svc|lab`; путь к папке батчей — абсолютный от ROOT. */
export function catalogFromArgv(root, argv = process.argv) {
	const i = argv.indexOf('--catalog');
	const key = i > -1 ? argv[i + 1] : 'svc';
	const c = CATALOGS[key];
	if (!c) throw new Error(`неизвестный каталог «${key}» — svc или lab`);
	return { ...c, dirAbs: resolve(root, c.dir) };
}
