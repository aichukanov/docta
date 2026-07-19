const TABLE_TO_ENTITY_TYPE: Record<string, string> = {
	clinics: 'clinics',
	doctors: 'doctors',
	medical_services: 'services',
	lab_tests: 'labtests',
	medications: 'medications',
	med_medicines: 'medicines',
	insurance_companies: 'insurance-companies',
};

/**
 * Ensures a slug is unique in the given table.
 * If a duplicate exists, appends -2, -3, etc.
 * Also checks slug_redirects to avoid collisions with old slugs.
 */
export async function ensureUniqueSlug(
	connection: any,
	table: string,
	baseSlug: string,
	excludeId?: number,
): Promise<string> {
	const entityType = TABLE_TO_ENTITY_TYPE[table] || table;

	// Вырожденные слаги недопустимы: пустой ломает ссылки, а чисто числовой
	// занят легаси-пространством `/{entity}/{id}` — redirect-мидлвар
	// (server/common/redirect/slug-redirects.ts) трактует его как ID и уводит
	// 301-ом на ЧУЖУЮ сущность. Префиксуем единственным числом типа: 5 → clinic-5.
	if (!baseSlug || /^\d+$/.test(baseSlug)) {
		const prefix = entityType.replace(/s$/, '');
		baseSlug = baseSlug ? `${prefix}-${baseSlug}` : prefix;
	}

	let slug = baseSlug;
	let suffix = 2;

	while (true) {
		const query = excludeId
			? `SELECT id FROM ${table} WHERE slug = ? AND id != ?`
			: `SELECT id FROM ${table} WHERE slug = ?`;
		const params = excludeId ? [slug, excludeId] : [slug];

		const [existing] = await connection.execute(query, params);
		if ((existing as any[]).length > 0) {
			slug = `${baseSlug}-${suffix}`;
			suffix++;
			continue;
		}

		// Also check slug_redirects — old slug pointing to a DIFFERENT entity
		const [redirectConflict] = await connection.execute(
			`SELECT entity_id FROM slug_redirects WHERE entity_type = ? AND old_slug = ? AND entity_id != ?`,
			[entityType, slug, excludeId || 0],
		);
		if ((redirectConflict as any[]).length > 0) {
			slug = `${baseSlug}-${suffix}`;
			suffix++;
			continue;
		}

		return slug;
	}
}

/**
 * Saves old slug as a redirect if slug changed.
 * Call BEFORE updating the slug in the main table.
 */
export async function saveSlugRedirect(
	connection: any,
	table: string,
	entityId: number,
	newSlug: string,
): Promise<void> {
	const entityType = TABLE_TO_ENTITY_TYPE[table] || table;

	// Get current slug
	const [rows] = await connection.execute(
		`SELECT slug FROM ${table} WHERE id = ?`,
		[entityId],
	);
	const oldSlug = (rows as any[])[0]?.slug;

	if (!oldSlug || oldSlug === newSlug) {
		return; // No change
	}

	// Save redirect: old_slug → this entity
	await connection.execute(
		`INSERT INTO slug_redirects (entity_type, old_slug, entity_id)
		 VALUES (?, ?, ?)
		 ON DUPLICATE KEY UPDATE entity_id = VALUES(entity_id)`,
		[entityType, oldSlug, entityId],
	);

	// If new slug was previously a redirect, remove it (it's now canonical)
	await connection.execute(
		`DELETE FROM slug_redirects WHERE entity_type = ? AND old_slug = ?`,
		[entityType, newSlug],
	);
}
