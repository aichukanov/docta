import { getConnection } from '~/server/common/db-mysql';

/**
 * Слаги лекарств (цены в клиниках, раздел `/medications` — не путать с
 * регистром ЦИнМЕД `/medicines`).
 *
 * Раздела не было в sitemap вообще: генератор отдавал только подстраницы
 * клиник вида `/clinics/<slug>/medications`, но ни листинг, ни карточки.
 * Яндекс нашёл и держал в индексе 32 таких URL сам.
 * См. prd/silent-200-index-hygiene, итерация 2.
 *
 * Берём только лекарства, у которых есть хотя бы одна опубликованная клиника:
 * карточка без цен нечего предложить в выдаче. Тот же принцип, что у
 * clinic-subpages — в sitemap попадает лишь то, что стоит индексировать.
 */
export async function getMedicationSlugs(): Promise<string[]> {
	// SQL отдельной константой, а не инлайном в execute<any[]>(…): esbuild не
	// разбирает generic-вызов, за которым сразу идёт шаблонная строка.
	const sql = `
		SELECT DISTINCT m.slug
		FROM medications m
		JOIN clinic_medications cm ON cm.medication_id = m.id
		JOIN clinics c ON c.id = cm.clinic_id AND c.status = 'published'
		WHERE m.slug IS NOT NULL AND m.slug != ''
	`;

	const connection = await getConnection();

	try {
		const [rows] = await connection.execute<any[]>(sql);
		return (rows as Array<{ slug: string }>).map((r) => r.slug);
	} finally {
		await connection.end();
	}
}
