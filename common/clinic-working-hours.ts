import type {
	WorkingHours,
	WorkingHoursStatus,
	DayOfWeek,
	DaySchedule,
	TimeInterval,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

export function timeToMinutes(time: string): number {
	const [hours, minutes] = time.split(':').map(Number);
	return hours * 60 + minutes;
}

export function getDayOfWeek(date: Date): DayOfWeek {
	const days: DayOfWeek[] = [
		'sunday',
		'monday',
		'tuesday',
		'wednesday',
		'thursday',
		'friday',
		'saturday',
	];
	return days[date.getDay()];
}

function findNextInterval(
	intervals: TimeInterval[],
	currentMinutes: number,
): TimeInterval | null {
	for (const interval of intervals) {
		if (timeToMinutes(interval.start) > currentMinutes) {
			return interval;
		}
	}
	return null;
}

interface NextOpen {
	day: DayOfWeek;
	time: string; // HH:mm
	offsetDays: number; // 1 = tomorrow, 2 = day after, etc.
}

function findNextOpenTime(
	schedule: WorkingHours,
	currentTime: Date,
): NextOpen | null {
	const currentDayIndex = DAYS_OF_WEEK.indexOf(getDayOfWeek(currentTime));

	for (let offset = 1; offset <= 7; offset++) {
		const nextIndex = (currentDayIndex + offset) % 7;
		const day = DAYS_OF_WEEK[nextIndex];
		const daySchedule = schedule[day];

		if (daySchedule.type === '24/7') {
			return { day, time: '00:00', offsetDays: offset };
		}

		if (
			daySchedule.type === 'regular' &&
			daySchedule.intervals &&
			daySchedule.intervals.length > 0
		) {
			return { day, time: daySchedule.intervals[0].start, offsetDays: offset };
		}
	}

	return null;
}

function closedResult(
	schedule: WorkingHours,
	currentTime: Date,
): WorkingHoursStatus {
	const next = findNextOpenTime(schedule, currentTime);
	if (!next) {
		return { isOpen: false, type: 'closed' };
	}
	if (next.offsetDays === 1) {
		return {
			isOpen: false,
			type: 'opens_day',
			time: next.time,
			day: next.day,
			offsetDays: 1,
		};
	}
	return {
		isOpen: false,
		type: 'opens_day',
		time: next.time,
		day: next.day,
		offsetDays: next.offsetDays,
	};
}

export function calculateStatus(
	schedule: WorkingHours,
	currentTime: Date = new Date(),
): WorkingHoursStatus {
	const dayOfWeek = getDayOfWeek(currentTime);
	const daySchedule = schedule[dayOfWeek];

	if (daySchedule.type === '24/7') {
		return { isOpen: true, type: 'open_24_7' };
	}

	if (daySchedule.type === 'closed') {
		return closedResult(schedule, currentTime);
	}

	if (daySchedule.type === 'on_demand') {
		return { isOpen: false, type: 'on_demand' };
	}

	if (daySchedule.type === 'not_specified') {
		return { isOpen: false, type: 'not_specified' };
	}

	// type === 'regular'
	const currentMinutes = currentTime.getHours() * 60 + currentTime.getMinutes();

	for (const interval of daySchedule.intervals || []) {
		const startMinutes = timeToMinutes(interval.start);
		const endMinutes = timeToMinutes(interval.end);

		if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
			return { isOpen: true, type: 'open_until', time: interval.end };
		}
	}

	// Закрыто — ищем следующий интервал сегодня
	const nextInterval = findNextInterval(
		daySchedule.intervals || [],
		currentMinutes,
	);
	if (nextInterval) {
		return { isOpen: false, type: 'opens_today', time: nextInterval.start };
	}

	// Сегодня больше не откроется
	return closedResult(schedule, currentTime);
}

export function formatIntervals(intervals: TimeInterval[]): string {
	if (!intervals || intervals.length === 0) return '';
	return intervals.map((i) => `${i.start}–${i.end}`).join(', ');
}

// --- Валидация ---

const TIME_REGEX = /^([01]\d|2[0-3]):([0-5]\d)$/;
const VALID_DAY_TYPES = [
	'regular',
	'24/7',
	'closed',
	'on_demand',
	'not_specified',
];
const MAX_INTERVALS_PER_DAY = 3;

function intervalsOverlap(a: TimeInterval, b: TimeInterval): boolean {
	const aStart = timeToMinutes(a.start);
	const aEnd = timeToMinutes(a.end);
	const bStart = timeToMinutes(b.start);
	const bEnd = timeToMinutes(b.end);
	return aStart < bEnd && aEnd > bStart;
}

export function validateWorkingHoursData(data: any): string[] {
	const errors: string[] = [];

	for (const day of DAYS_OF_WEEK) {
		if (!data[day]) {
			errors.push(`${day} is required`);
			continue;
		}

		const ds = data[day];

		if (!ds.type || !VALID_DAY_TYPES.includes(ds.type)) {
			errors.push(`${day}.type must be one of: ${VALID_DAY_TYPES.join(', ')}`);
			continue;
		}

		if (ds.type !== 'regular') continue;

		if (!Array.isArray(ds.intervals) || ds.intervals.length === 0) {
			errors.push(`${day}: regular day must have at least one interval`);
			continue;
		}

		if (ds.intervals.length > MAX_INTERVALS_PER_DAY) {
			errors.push(`${day}: maximum ${MAX_INTERVALS_PER_DAY} intervals per day`);
		}

		for (let i = 0; i < ds.intervals.length; i++) {
			const interval = ds.intervals[i];

			if (!interval.start || !interval.end) {
				errors.push(`${day}.intervals[${i}]: start and end are required`);
				continue;
			}

			if (!TIME_REGEX.test(interval.start)) {
				errors.push(
					`${day}.intervals[${i}].start: invalid format (expected HH:mm)`,
				);
			}
			if (!TIME_REGEX.test(interval.end)) {
				errors.push(
					`${day}.intervals[${i}].end: invalid format (expected HH:mm)`,
				);
			}

			if (timeToMinutes(interval.start) >= timeToMinutes(interval.end)) {
				errors.push(`${day}.intervals[${i}]: start must be before end`);
			}

			// Проверка пересечений
			for (let j = i + 1; j < ds.intervals.length; j++) {
				if (intervalsOverlap(interval, ds.intervals[j])) {
					errors.push(`${day}: intervals ${i + 1} and ${j + 1} overlap`);
				}
			}
		}
	}

	return errors;
}
