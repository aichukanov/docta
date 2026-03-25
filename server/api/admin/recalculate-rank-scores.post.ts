import { requireAdmin } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	await recalculateEntityRankScores();
	return { success: true };
});
