import type { Connection } from 'mysql2/promise';
import type {
	ClinicComplaint,
	ClinicComplaintStatus,
} from '~/interfaces/clinic-reputation';
import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

/**
 * Публичные жалобы раздела «Репутация» (prd/clinic-reputation/): только
 * активные, без внутренней заметки об источнике (source_note). Формулировки
 * живут в i18n по коду `type`.
 */
export async function fetchClinicReputation(
	connection: Connection,
	clinicId: number,
): Promise<ClinicComplaint[]> {
	const [rows] = await connection.execute(
		`SELECT
			complaint_type as type,
			status,
			review_id as reviewId,
			article_slug as articleSlug,
			incident_date as incidentDate,
			clinic_response as clinicResponse
		FROM clinic_complaints
		WHERE clinic_id = ? AND is_active = 1
		ORDER BY status = 'confirmed' DESC, complaint_type ASC`,
		[clinicId],
	);
	return (rows as any[]).map((row) => ({
		type: row.type as ClinicComplaintType,
		status: row.status as ClinicComplaintStatus,
		reviewId: row.reviewId ?? undefined,
		articleSlug: row.articleSlug ?? undefined,
		incidentDate: row.incidentDate
			? new Date(row.incidentDate).toISOString().slice(0, 10)
			: undefined,
		clinicResponse: row.clinicResponse ?? undefined,
	}));
}

/** Типы активных подтверждённых жалоб — только они дают бейдж «Осторожно» */
export function getCautionTypes(
	complaints: ClinicComplaint[],
): ClinicComplaintType[] {
	return complaints
		.filter((c) => c.status === 'confirmed')
		.map((c) => c.type);
}

/**
 * SQL-подзапрос для списковых эндпоинтов: GROUP_CONCAT типов активных
 * подтверждённых жалоб клиники `alias`. Таблица крошечная, подзапрос дешёвый.
 */
export function cautionTypesSql(alias: string): string {
	return `(
		SELECT GROUP_CONCAT(cc.complaint_type ORDER BY cc.complaint_type)
		FROM clinic_complaints cc
		WHERE cc.clinic_id = ${alias}.id AND cc.is_active = 1 AND cc.status = 'confirmed'
	)`;
}

/** Разбор результата cautionTypesSql в массив кодов */
export function parseCautionTypes(
	value: string | null | undefined,
): ClinicComplaintType[] {
	if (!value) return [];
	return String(value)
		.split(',')
		.map(Number)
		.filter(Boolean) as ClinicComplaintType[];
}
