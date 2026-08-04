import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

/**
 * Отмечает пару анализов как «не дубликат».
 *
 * Решение хранится, чтобы кандидат не всплывал при каждом прогоне детектора.
 * Обратной операции нет намеренно: если пару отклонили ошибочно, статус
 * возвращается в pending руками через SQL.
 *
 * POST /api/labtests/duplicates/dismiss { candidateId }
 */
export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/labtests/duplicates/dismiss')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.candidateId)) {
			setResponseStatus(event, 400, 'Invalid candidate id');
			return false;
		}

		await executeQuery(
			`UPDATE lab_test_duplicate_candidates
			 SET status = 'dismissed', decided_at = NOW()
			 WHERE id = ? AND status = 'pending'`,
			[body.candidateId],
		);

		return true;
	} catch (error) {
		console.error('API Error - dismiss lab test duplicate candidate:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to dismiss duplicate candidate',
		});
	}
});
