import type { Connection } from 'mysql2/promise';
import type { H3Event } from 'h3';
import type { User } from '~/server/utils/session';
import type { ClinicStatus } from '~/interfaces/clinic';
import type { DayOfWeek, DaySchedule } from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';
import { getCurrentUser } from '~/server/common/auth';
import {
	validateCityId,
	validateClinicTypeIds,
	validateDoctorLanguageIds,
} from '~/common/validation';
import { validateWorkingHoursData } from '~/common/clinic-working-hours';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';

export type ClinicWorkingHoursBody = Record<DayOfWeek, DaySchedule>;

// Тело формы кабинета клиники (my-create / my-update).
export interface ClinicCabinetBody {
	nameSr: string;
	nameSrCyrl?: string;
	nameRu?: string;
	cityId: number;
	addressSr?: string;
	addressSrCyrl?: string;
	townSr?: string;
	townSrCyrl?: string;
	postalCode?: string;
	latitude?: number | null;
	longitude?: number | null;
	phone?: string;
	email?: string;
	website?: string;
	facebook?: string;
	instagram?: string;
	telegram?: string;
	whatsapp?: string;
	viber?: string;
	descriptionSr?: string;
	descriptionSrCyrl?: string;
	descriptionRu?: string;
	descriptionEn?: string;
	descriptionDe?: string;
	descriptionTr?: string;
	logoUrl?: string;
	languageIds: number[];
	clinicTypeIds?: number[];
	workingHours?: ClinicWorkingHoursBody;
}

export async function requireUser(event: H3Event): Promise<User> {
	const user = await getCurrentUser(event);
	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}
	return user!;
}

function isValidCoordinate(value: unknown, max: number): boolean {
	return (
		value == null ||
		(typeof value === 'number' && Number.isFinite(value) && Math.abs(value) <= max)
	);
}

/** Валидация тела формы кабинета. Бросает 400 с кодом при ошибке. */
export function validateClinicCabinetBody(
	body: ClinicCabinetBody,
	from: string,
): void {
	if (!body || typeof body !== 'object') {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	if (!body.nameSr?.trim()) {
		createErrorResponse(400, ERROR_CODES.CLINIC_NAME_REQUIRED);
	}

	if (!validateCityId(body, from)) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	if (
		!validateDoctorLanguageIds(body, from) ||
		body.languageIds.length === 0
	) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	if (
		body.clinicTypeIds !== undefined &&
		!validateClinicTypeIds(body, from)
	) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	if (
		!isValidCoordinate(body.latitude, 90) ||
		!isValidCoordinate(body.longitude, 180) ||
		(body.latitude == null) !== (body.longitude == null)
	) {
		createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA);
	}

	if (body.workingHours !== undefined) {
		const errors = validateWorkingHoursData(body.workingHours);
		if (errors.length > 0) {
			createErrorResponse(400, ERROR_CODES.CLINIC_INVALID_DATA, errors);
		}
	}
}

export interface OwnedClinicRow {
	id: number;
	slug: string;
	status: ClinicStatus;
	created_by: number | null;
	name_sr: string;
	address_sr: string;
	postal_code: string | null;
	latitude: number | null;
	longitude: number | null;
	phone: string | null;
	email: string | null;
	website: string | null;
	facebook: string | null;
	instagram: string | null;
	telegram: string | null;
	whatsapp: string | null;
	viber: string | null;
}

/**
 * Загружает клинику и проверяет права: владелец или админ.
 * Бросает 404/403 с кодом при отсутствии доступа.
 */
export async function getOwnedClinic(
	connection: Connection,
	clinicId: number,
	user: User,
): Promise<OwnedClinicRow> {
	const [rows]: any = await connection.execute(
		`SELECT id, slug, status, created_by, name_sr, address_sr, postal_code,
			latitude, longitude,
			phone, email, website, facebook, instagram, telegram, whatsapp, viber
		 FROM clinics WHERE id = ?`,
		[clinicId],
	);

	if (!rows.length) {
		createErrorResponse(404, ERROR_CODES.CLINIC_NOT_FOUND);
	}

	const clinic = rows[0] as OwnedClinicRow;
	const isOwner = clinic.created_by != null && clinic.created_by === user.id;
	if (!isOwner && !user.is_admin) {
		createErrorResponse(403, ERROR_CODES.CLINIC_NOT_OWN);
	}

	return clinic;
}

/** Diff-синхронизация M:N связи клиники (языки, типы). */
export async function syncClinicRelation(
	connection: Connection,
	clinicId: number,
	table: 'clinic_languages' | 'clinic_clinic_types',
	column: 'language_id' | 'clinic_type_id',
	newIds: number[],
): Promise<void> {
	const [existingRows]: any = await connection.execute(
		`SELECT ${column} FROM ${table} WHERE clinic_id = ?`,
		[clinicId],
	);
	const existingIds: number[] = existingRows.map((r: any) => r[column]);

	const toRemove = existingIds.filter((id) => !newIds.includes(id));
	const toAdd = newIds.filter((id) => !existingIds.includes(id));

	if (toRemove.length) {
		const ph = toRemove.map(() => '?').join(',');
		await connection.execute(
			`DELETE FROM ${table} WHERE clinic_id = ? AND ${column} IN (${ph})`,
			[clinicId, ...toRemove],
		);
	}

	for (const id of toAdd) {
		await connection.execute(
			`INSERT INTO ${table} (clinic_id, ${column}) VALUES (?, ?)`,
			[clinicId, id],
		);
	}
}

/** Upsert графика работы клиники (та же схема, что в update-working-hours). */
export async function upsertClinicWorkingHours(
	connection: Connection,
	clinicId: number,
	workingHours: ClinicWorkingHoursBody,
): Promise<void> {
	await connection.execute(
		`INSERT INTO clinic_working_hours
			(clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?)
		 ON DUPLICATE KEY UPDATE
			monday = VALUES(monday),
			tuesday = VALUES(tuesday),
			wednesday = VALUES(wednesday),
			thursday = VALUES(thursday),
			friday = VALUES(friday),
			saturday = VALUES(saturday),
			sunday = VALUES(sunday),
			updated_at = CURRENT_TIMESTAMP`,
		[clinicId, ...DAYS_OF_WEEK.map((day) => JSON.stringify(workingHours[day]))],
	);
}

/** Поля UPDATE/INSERT, общие для my-create и my-update. */
export function clinicFieldParams(body: ClinicCabinetBody) {
	return {
		columns: [
			'name_sr',
			'name_sr_cyrl',
			'name_ru',
			'city_id',
			'address_sr',
			'address_sr_cyrl',
			'town_sr',
			'town_sr_cyrl',
			'postal_code',
			'latitude',
			'longitude',
			'phone',
			'email',
			'website',
			'facebook',
			'instagram',
			'telegram',
			'whatsapp',
			'viber',
			'description_sr',
			'description_sr_cyrl',
			'description_ru',
			'description_en',
			'description_de',
			'description_tr',
			'logo_url',
		],
		values: [
			body.nameSr.trim(),
			body.nameSrCyrl?.trim() || '',
			body.nameRu?.trim() || '',
			body.cityId,
			body.addressSr?.trim() || '',
			body.addressSrCyrl?.trim() || '',
			body.townSr?.trim() || '',
			body.townSrCyrl?.trim() || '',
			body.postalCode?.trim() || '',
			body.latitude ?? null,
			body.longitude ?? null,
			body.phone?.trim() || '',
			body.email?.trim() || '',
			body.website?.trim() || '',
			body.facebook?.trim() || '',
			body.instagram?.trim() || '',
			body.telegram?.trim() || '',
			body.whatsapp?.trim() || '',
			body.viber?.trim() || '',
			body.descriptionSr?.trim() || '',
			body.descriptionSrCyrl?.trim() || '',
			body.descriptionRu?.trim() || '',
			body.descriptionEn?.trim() || '',
			body.descriptionDe?.trim() || '',
			body.descriptionTr?.trim() || '',
			body.logoUrl?.trim() || '',
		],
	};
}
