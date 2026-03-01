import type { Connection } from 'mysql2/promise';

interface SyncRelationParams {
	connection: Connection;
	doctorId: number;
	table: string;
	column: string;
	newIds: number[];
}

/**
 * Sync a many-to-many relation for a doctor (specialties, languages, clinics).
 * Performs a diff: removes missing IDs, inserts new ones.
 */
export async function syncDoctorRelation({
	connection,
	doctorId,
	table,
	column,
	newIds,
}: SyncRelationParams): Promise<void> {
	const [existingRows]: any = await connection.execute(
		`SELECT ${column} FROM ${table} WHERE doctor_id = ?`,
		[doctorId],
	);
	const existingIds: number[] = existingRows.map((r: any) => r[column]);

	const toRemove = existingIds.filter((id) => !newIds.includes(id));
	const toAdd = newIds.filter((id) => !existingIds.includes(id));

	if (toRemove.length) {
		const ph = toRemove.map(() => '?').join(',');
		await connection.execute(
			`DELETE FROM ${table} WHERE doctor_id = ? AND ${column} IN (${ph})`,
			[doctorId, ...toRemove],
		);
	}

	for (const id of toAdd) {
		await connection.execute(
			`INSERT INTO ${table} (doctor_id, ${column}) VALUES (?, ?)`,
			[doctorId, id],
		);
	}
}
