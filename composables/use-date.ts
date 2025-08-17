export function getStartOfDay(timestamp: number) {
	if (!timestamp) {
		throw new Error('Incorrect timestamp: ' + timestamp);
	}

	const startOfDayTime = new Date(timestamp);
	startOfDayTime.setUTCHours(0, 0, 0, 0);
	return startOfDayTime.getTime();
}

export function daysLeft(timestamp: number) {
	if (!timestamp) {
		throw new Error('Incorrect timestamp: ' + timestamp);
	}

	const oneDay = 24 * 60 * 60 * 1000;
	const today = getStartOfDay(new Date().getTime());
	const date = getStartOfDay(timestamp);
	return (today - date) / oneDay;
}
