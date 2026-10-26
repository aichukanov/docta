import type { Connection } from 'mysql2/promise';
import { CAUTION_RANK_FACTOR } from '~/common/ranking';
import type { Complaint, ComplaintStatus } from '~/interfaces/reputation';
import type { ComplaintType, ReputationEntity } from '~/enums/complaint-type';

/**
 * Таблицы раздела «Репутация» (prd/clinic-reputation/). Клиники и врачи живут
 * в отдельных таблицах с одинаковым набором колонок: FK разные, а словарь
 * типов, статусы и правила показа общие. Ключ — литеральный union, поэтому
 * подстановка в SQL безопасна (значение не приходит из запроса).
 */
const COMPLAINT_TABLES: Record<
	ReputationEntity,
	{ table: string; idColumn: string; responseColumn: string }
> = {
	clinic: {
		table: 'clinic_complaints',
		idColumn: 'clinic_id',
		responseColumn: 'clinic_response',
	},
	doctor: {
		table: 'doctor_complaints',
		idColumn: 'doctor_id',
		responseColumn: 'doctor_response',
	},
};

export function getComplaintTable(entity: ReputationEntity) {
	return COMPLAINT_TABLES[entity];
}

/**
 * Публичные жалобы раздела «Репутация»: только активные, без внутренней
 * заметки об источнике (source_note). Формулировки живут в i18n по коду `type`.
 */
export async function fetchReputation(
	connection: Connection,
	entity: ReputationEntity,
	entityId: number,
): Promise<Complaint[]> {
	const { table, idColumn, responseColumn } = COMPLAINT_TABLES[entity];
	const [rows] = await connection.execute(
		`SELECT
			complaint_type as type,
			status,
			review_id as reviewId,
			article_slug as articleSlug,
			incident_date as incidentDate,
			${responseColumn} as response
		FROM ${table}
		WHERE ${idColumn} = ? AND is_active = 1
		ORDER BY status = 'confirmed' DESC, complaint_type ASC`,
		[entityId],
	);
	return (rows as any[]).map((row) => ({
		type: row.type as ComplaintType,
		status: row.status as ComplaintStatus,
		reviewId: row.reviewId ?? undefined,
		articleSlug: row.articleSlug ?? undefined,
		incidentDate: row.incidentDate
			? new Date(row.incidentDate).toISOString().slice(0, 10)
			: undefined,
		response: row.response ?? undefined,
	}));
}

/** Типы активных подтверждённых жалоб — только они дают бейдж «Осторожно» */
export function getCautionTypes(complaints: Complaint[]): ComplaintType[] {
	return complaints.filter((c) => c.status === 'confirmed').map((c) => c.type);
}

/**
 * SQL-подзапрос для списковых эндпоинтов: GROUP_CONCAT типов активных
 * подтверждённых жалоб сущности `alias`. Таблицы крошечные, подзапрос дешёвый.
 */
export function cautionTypesSql(
	entity: ReputationEntity,
	alias: string,
): string {
	const { table, idColumn } = COMPLAINT_TABLES[entity];
	return `(
		SELECT GROUP_CONCAT(cc.complaint_type ORDER BY cc.complaint_type)
		FROM ${table} cc
		WHERE cc.${idColumn} = ${alias}.id AND cc.is_active = 1 AND cc.status = 'confirmed'
	)`;
}

/**
 * SQL-множитель ранжирования: клиника или врач с активными подтверждёнными
 * жалобами получает CAUTION_RANK_FACTOR к композитному скору (зеркало
 * hasCaution в common/ranking.ts). Вставляется в ORDER BY каталогов
 * (server/api/clinics/list.ts, server/api/doctors/list.ts); в
 * GROUP_CONCAT-подзапросы страниц позиций не вставлять — там порядок
 * переранжирует клиент, а корректность подзапроса в ORDER BY GROUP_CONCAT
 * не гарантирована.
 */
export function cautionRankFactorSql(
	entity: ReputationEntity,
	alias: string,
): string {
	const { table, idColumn } = COMPLAINT_TABLES[entity];
	return `IF(EXISTS(
		SELECT 1 FROM ${table} cc
		WHERE cc.${idColumn} = ${alias}.id AND cc.is_active = 1 AND cc.status = 'confirmed'
	), ${CAUTION_RANK_FACTOR}, 1)`;
}

/** Разбор результата cautionTypesSql в массив кодов */
export function parseCautionTypes(
	value: string | null | undefined,
): ComplaintType[] {
	if (!value) return [];
	return String(value)
		.split(',')
		.map(Number)
		.filter(Boolean) as ComplaintType[];
}
