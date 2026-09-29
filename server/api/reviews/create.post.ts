import { getCurrentUser } from '~/server/common/auth';
import { doctorIsPublicSql } from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { executeQuery } from '~/server/common/db-mysql';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);
	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);

	const { entityType, entityId, relatedEntityId, rating, text, locale } = body;

	// Validate entity
	if (
		!entityType ||
		!['doctor', 'clinic', 'insurance_company'].includes(entityType) ||
		!entityId ||
		typeof entityId !== 'number'
	) {
		createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	}

	// Validate rating
	if (!rating || typeof rating !== 'number' || rating < 1 || rating > 5) {
		createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_RATING);
	}

	const trimmedText = (text || '').trim();

	// Verify primary entity exists
	if (entityType === 'doctor') {
		const rows = await executeQuery(
			`SELECT id FROM doctors WHERE id = ? AND ${doctorIsPublicSql('doctors')}`,
			[entityId],
		);
		if (rows.length === 0)
			createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	} else if (entityType === 'insurance_company') {
		// У страховых нет черновиков и скрытия — достаточно существования
		const rows = await executeQuery(
			`SELECT id FROM insurance_companies WHERE id = ?`,
			[entityId],
		);
		if (rows.length === 0)
			createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	} else {
		// Черновики не принимают отзывы — публично их страниц не существует
		const rows = await executeQuery(
			`SELECT id FROM clinics WHERE id = ? AND ${clinicIsPublicSql('clinics')}`,
			[entityId],
		);
		if (rows.length === 0)
			createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	}

	// Determine target FKs based on entityType + optional related entity
	// (related — только для пары врач/клиника)
	let doctorId: number | null = null;
	let clinicId: number | null = null;
	let insuranceCompanyId: number | null = null;

	if (entityType === 'insurance_company') {
		insuranceCompanyId = entityId;
	} else if (entityType === 'doctor') {
		doctorId = entityId;
		if (relatedEntityId && typeof relatedEntityId === 'number') {
			const clinicRows = await executeQuery(
				`SELECT dc.clinic_id FROM doctor_clinics dc
				WHERE dc.doctor_id = ? AND dc.clinic_id = ?`,
				[entityId, relatedEntityId],
			);
			if (clinicRows.length > 0) {
				clinicId = relatedEntityId;
			}
		}
	} else {
		clinicId = entityId;
		if (relatedEntityId && typeof relatedEntityId === 'number') {
			const doctorRows = await executeQuery(
				`SELECT dc.doctor_id FROM doctor_clinics dc
				JOIN doctors d ON dc.doctor_id = d.id AND ${doctorIsPublicSql('d')}
				WHERE dc.clinic_id = ? AND dc.doctor_id = ?`,
				[entityId, relatedEntityId],
			);
			if (doctorRows.length > 0) {
				doctorId = relatedEntityId;
			}
		}
	}

	// Check for duplicate (same user + same primary entity, within last 3 months)
	const primaryColumns: Record<string, string> = {
		doctor: 'doctor_id',
		clinic: 'clinic_id',
		insurance_company: 'insurance_company_id',
	};
	const primaryColumn = primaryColumns[entityType];
	const duplicateRows = await executeQuery(
		`SELECT id FROM reviews
		WHERE user_id = ? AND ${primaryColumn} = ? AND provider = 'docta_me'
			AND created_at > DATE_SUB(NOW(), INTERVAL 3 MONTH)`,
		[user!.id, entityId],
	);
	if (duplicateRows.length > 0) {
		createErrorResponse(409, ERROR_CODES.REVIEW_DUPLICATE);
	}

	// Determine original language from locale
	const validLocales = ['sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr'];
	const originalLanguage = validLocales.includes(locale) ? locale : 'en';

	// Build localized text field
	const localeToColumn: Record<string, string> = {
		'sr': 'text_sr',
		'sr-cyrl': 'text_sr_cyrl',
		'en': 'text_en',
		'ru': 'text_ru',
		'de': 'text_de',
		'tr': 'text_tr',
	};
	const textColumn = localeToColumn[originalLanguage] || 'text_en';

	// Пост-модерация: отзыв публикуется сразу со статусом 'pending',
	// админ позже одобряет или отклоняет его в очереди модерации
	const rows = await executeQuery(
		`INSERT INTO reviews
			(user_id, doctor_id, clinic_id, insurance_company_id, provider, rating, original_language, original_text, ${textColumn}, status, published_at, likes_count, created_at, updated_at)
		VALUES (?, ?, ?, ?, 'docta_me', ?, ?, ?, ?, 'pending', NOW(), 0, NOW(), NOW())`,
		[
			user!.id,
			doctorId,
			clinicId,
			insuranceCompanyId,
			rating,
			originalLanguage,
			trimmedText,
			trimmedText,
		],
	);

	const insertId = (rows as any).insertId;

	return createSuccessResponse(SUCCESS_CODES.REVIEW_CREATED, { id: insertId });
});
