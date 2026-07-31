import {
	CLINIC_COUPON_PAYMENT_METHODS,
	CLINIC_COUPON_SCOPES,
} from '~/interfaces/clinic-coupon';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { requireAdmin } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import {
	downloadAndSaveImage,
	isExternalUrl,
} from '~/server/utils/image-processing';

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

/** Пустая строка из формы = «не задано» = NULL в БД. */
function nullableText(
	value: unknown,
	maxLength: number,
): string | null | false {
	if (value == null || value === '') return null;
	if (typeof value !== 'string') return false;
	const trimmed = value.trim();
	if (!trimmed) return null;
	return trimmed.length <= maxLength ? trimmed : false;
}

function nullableDate(value: unknown): string | null | false {
	if (value == null || value === '') return null;
	if (typeof value !== 'string' || !ISO_DATE.test(value)) return false;
	return Number.isNaN(Date.parse(value)) ? false : value;
}

/**
 * Создание и правка купона клиники из админки (`id` в теле — правка).
 *
 * Картинка купона сюда приходит уже готовым URL: файл загружается тем же
 * эндпоинтом, что логотипы и фото врачей (`/api/upload/admin-image`,
 * категория `coupons`), и в БД попадает только путь.
 */
export default defineEventHandler(
	async (event): Promise<{ id: number } | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/coupons/save')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const percent = Number(body.discountPercent);
			if (!Number.isInteger(percent) || percent < 1 || percent > 100) {
				setResponseStatus(event, 400, 'Invalid discount percent');
				return null;
			}

			// Без типов позиций купон негде показать — это не пустое поле, а ошибка
			const appliesTo: string[] = Array.isArray(body.appliesTo)
				? Array.from(new Set(body.appliesTo))
				: [];
			if (
				appliesTo.length === 0 ||
				!appliesTo.every((scope) =>
					(CLINIC_COUPON_SCOPES as readonly string[]).includes(scope),
				)
			) {
				setResponseStatus(event, 400, 'Invalid applies_to');
				return null;
			}

			const sourceName = nullableText(body.sourceName, 100);
			const rawImageUrl = nullableText(body.imageUrl, 500);
			const code = nullableText(body.code, 50);
			if (sourceName === false || rawImageUrl === false || code === false) {
				setResponseStatus(event, 400, 'Invalid text field');
				return null;
			}
			if (
				rawImageUrl &&
				!rawImageUrl.startsWith('/uploads/') &&
				!isExternalUrl(rawImageUrl)
			) {
				setResponseStatus(event, 400, 'Invalid image url');
				return null;
			}

			// Внешнюю картинку забираем к себе, как логотипы клиник и фото врачей:
			// купон пациент показывает на ресепшене, он не должен зависеть от
			// чужого хостинга
			const imageUrl =
				rawImageUrl && isExternalUrl(rawImageUrl)
					? await downloadAndSaveImage(rawImageUrl, 'coupons')
					: rawImageUrl;

			// Способ оплаты валидируем строго, а не через parse с фолбэком: молча
			// превратить «только наличные» в «любая оплата» — обмануть пациента
			if (
				body.paymentMethod != null &&
				!(CLINIC_COUPON_PAYMENT_METHODS as readonly unknown[]).includes(
					body.paymentMethod,
				)
			) {
				setResponseStatus(event, 400, 'Invalid payment method');
				return null;
			}
			const paymentMethod = body.paymentMethod ?? 'any';

			const validFrom = nullableDate(body.validFrom);
			const validUntil = nullableDate(body.validUntil);
			if (validFrom === false || validUntil === false) {
				setResponseStatus(event, 400, 'Invalid dates');
				return null;
			}
			if (validFrom && validUntil && validUntil < validFrom) {
				setResponseStatus(event, 400, 'Invalid dates range');
				return null;
			}

			const isActive = body.isActive === false ? 0 : 1;
			const couponId =
				body.id != null && validateNonNegativeInteger(body.id)
					? Number(body.id)
					: null;

			const connection = await getConnection();
			try {
				if (couponId != null) {
					// clinic_id в условии — чтобы правка не переехала на чужую клинику
					const [result]: any = await connection.execute(
						`UPDATE clinic_coupons SET
							discount_percent = ?,
							applies_to = ?,
							source_name = ?,
							image_url = ?,
							code = ?,
							payment_method = ?,
							valid_from = ?,
							valid_until = ?,
							is_active = ?
						WHERE id = ? AND clinic_id = ?`,
						[
							percent,
							appliesTo.join(','),
							sourceName,
							imageUrl,
							code,
							paymentMethod,
							validFrom,
							validUntil,
							isActive,
							couponId,
							Number(body.clinicId),
						],
					);
					await connection.end();
					if (result.affectedRows === 0) {
						setResponseStatus(event, 404, 'Coupon not found');
						return null;
					}
					return { id: couponId };
				}

				const [result]: any = await connection.execute(
					`INSERT INTO clinic_coupons
						(clinic_id, discount_percent, applies_to, source_name, image_url,
						 code, payment_method, valid_from, valid_until, is_active)
					 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
					[
						Number(body.clinicId),
						percent,
						appliesTo.join(','),
						sourceName,
						imageUrl,
						code,
						paymentMethod,
						validFrom,
						validUntil,
						isActive,
					],
				);
				await connection.end();
				return { id: result.insertId };
			} catch (err) {
				await connection.end();
				throw err;
			}
		} catch (error) {
			console.error('API Error - clinic coupon save:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to save clinic coupon',
			});
		}
	},
);
