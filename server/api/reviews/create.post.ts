import { getCurrentUser } from '~/server/common/auth';
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
		!['doctor', 'clinic'].includes(entityType) ||
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
			'SELECT id FROM doctors WHERE id = ? AND hidden = 0',
			[entityId],
		);
		if (rows.length === 0) createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	} else {
		const rows = await executeQuery(
			'SELECT id FROM clinics WHERE id = ?',
			[entityId],
		);
		if (rows.length === 0) createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ENTITY);
	}

	// Determine doctor_id and clinic_id based on entityType + optional related entity
	let doctorId: number | null = null;
	let clinicId: number | null = null;

	if (entityType === 'doctor') {
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
				JOIN doctors d ON dc.doctor_id = d.id AND d.hidden = 0
				WHERE dc.clinic_id = ? AND dc.doctor_id = ?`,
				[entityId, relatedEntityId],
			);
			if (doctorRows.length > 0) {
				doctorId = relatedEntityId;
			}
		}
	}

	// Check for duplicate (same user + same primary entity, within last 3 months)
	const primaryColumn = entityType === 'doctor' ? 'doctor_id' : 'clinic_id';
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

	const rows = await executeQuery(
		`INSERT INTO reviews
			(user_id, doctor_id, clinic_id, provider, rating, original_language, original_text, ${textColumn}, published_at, likes_count, created_at, updated_at)
		VALUES (?, ?, ?, 'docta_me', ?, ?, ?, ?, NOW(), 0, NOW(), NOW())`,
		[user!.id, doctorId, clinicId, rating, originalLanguage, trimmedText, trimmedText],
	);

	const insertId = (rows as any).insertId;

	return createSuccessResponse(SUCCESS_CODES.REVIEW_CREATED, { id: insertId });
});
