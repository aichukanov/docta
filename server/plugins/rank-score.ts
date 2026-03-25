/**
 * Пересчитывает rank_score врачей и клиник при старте сервера
 * и затем каждые 6 часов.
 *
 * 6 часов — разумный интервал: новые отзывы появляются нечасто,
 * а формула учитывает возраст через экспоненциальное затухание,
 * которое меняется плавно (не принципиально, обновился score
 * сейчас или через пару часов).
 */
const SIX_HOURS_MS = 6 * 60 * 60 * 1000;

let intervalId: ReturnType<typeof setInterval> | null = null;

export default defineNitroPlugin((nitro) => {
	// Пересчёт при старте (не блокируем загрузку сервера)
	runRecalculation();
	intervalId = setInterval(runRecalculation, SIX_HOURS_MS);

	nitro.hooks.hook('close', () => {
		if (intervalId) clearInterval(intervalId);
	});
});

async function runRecalculation() {
	try {
		await recalculateEntityRankScores();
		console.log('[rank-score] Recalculated entity rank scores');
	} catch (error) {
		console.error('[rank-score] Failed to recalculate:', error);
	}
}
