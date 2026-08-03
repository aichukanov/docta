import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

/**
 * Отмечает пару как «не дубликат».
 *
 * Решение хранится, чтобы кандидат не всплывал при каждом прогоне детектора:
 * почти-дубликатов сотни, и без этого ревью пришлось бы делать заново каждый раз.
 *
 * Обратной операции нет намеренно: если пару отклонили ошибочно, статус
 * возвращается в pending руками через SQL — это редкий случай, а лишняя
 * кнопка «вернуть» в очереди только путает.
 *
 * POST /api/services/duplicates/dismiss { candidateId }
 */
export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/services/duplicates/dismiss')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.candidateId)) {
			setResponseStatus(event, 400, 'Invalid candidate id');
			return false;
		}

		await executeQuery(
			`UPDATE medical_service_duplicate_candidates
			 SET status = 'dismissed', decided_at = NOW()
			 WHERE id = ? AND status = 'pending'`,
			[body.candidateId],
		);

		return true;
	} catch (error) {
		console.error('API Error - dismiss duplicate candidate:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to dismiss duplicate candidate',
		});
	}
});
