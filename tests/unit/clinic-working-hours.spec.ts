import { test, expect } from '@playwright/test';
import {
	calculateStatus,
	timeToMinutes,
	getDayOfWeek,
	formatIntervals,
	validateWorkingHoursData,
} from '../../common/clinic-working-hours';
import type { WorkingHours } from '../../interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '../../interfaces/clinic-working-hours';

// --- timeToMinutes ---

test.describe('timeToMinutes', () => {
	test('converts 00:00', () => {
		expect(timeToMinutes('00:00')).toBe(0);
	});

	test('converts 09:30', () => {
		expect(timeToMinutes('09:30')).toBe(570);
	});

	test('converts 23:59', () => {
		expect(timeToMinutes('23:59')).toBe(1439);
	});
});

// --- getDayOfWeek ---

test.describe('getDayOfWeek', () => {
	test('returns monday for 2026-03-30', () => {
		expect(getDayOfWeek(new Date('2026-03-30T12:00:00'))).toBe('monday');
	});

	test('returns sunday for 2026-03-29', () => {
		expect(getDayOfWeek(new Date('2026-03-29T12:00:00'))).toBe('sunday');
	});

	test('returns wednesday for 2026-04-01', () => {
		expect(getDayOfWeek(new Date('2026-04-01T12:00:00'))).toBe('wednesday');
	});
});

// --- formatIntervals ---

test.describe('formatIntervals', () => {
	test('formats single interval', () => {
		expect(formatIntervals([{ start: '09:00', end: '18:00' }])).toBe(
			'09:00–18:00',
		);
	});

	test('formats multiple intervals', () => {
		expect(
			formatIntervals([
				{ start: '09:00', end: '13:00' },
				{ start: '15:00', end: '19:00' },
			]),
		).toBe('09:00–13:00, 15:00–19:00');
	});

	test('returns empty string for empty array', () => {
		expect(formatIntervals([])).toBe('');
	});
});

// --- calculateStatus ---

function makeSchedule(override: Partial<WorkingHours> = {}): WorkingHours {
	const base: WorkingHours = {
		clinicId: 1,
		monday: { type: 'regular', intervals: [{ start: '08:00', end: '20:00' }] },
		tuesday: { type: 'regular', intervals: [{ start: '08:00', end: '20:00' }] },
		wednesday: {
			type: 'regular',
			intervals: [{ start: '08:00', end: '20:00' }],
		},
		thursday: {
			type: 'regular',
			intervals: [{ start: '08:00', end: '20:00' }],
		},
		friday: { type: 'regular', intervals: [{ start: '08:00', end: '20:00' }] },
		saturday: {
			type: 'regular',
			intervals: [{ start: '09:00', end: '15:00' }],
		},
		sunday: { type: 'closed' },
	};
	return { ...base, ...override };
}

test.describe('calculateStatus', () => {
	test('open during working hours', () => {
		// Monday 10:00
		const result = calculateStatus(
			makeSchedule(),
			new Date('2026-03-30T10:00:00'),
		);
		expect(result.isOpen).toBe(true);
		expect(result.type).toBe('open_until');
		expect(result.time).toBe('20:00');
	});

	test('closed after working hours, opens tomorrow', () => {
		// Monday 21:00 → opens Tuesday 08:00
		const result = calculateStatus(
			makeSchedule(),
			new Date('2026-03-30T21:00:00'),
		);
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('opens_day');
		expect(result.offsetDays).toBe(1);
		expect(result.time).toBe('08:00');
		expect(result.day).toBe('tuesday');
	});

	test('closed before working hours, opens today', () => {
		// Monday 06:00 → opens at 08:00 today
		const result = calculateStatus(
			makeSchedule(),
			new Date('2026-03-30T06:00:00'),
		);
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('opens_today');
		expect(result.time).toBe('08:00');
	});

	test('closed on sunday, opens monday', () => {
		// Sunday 12:00 → opens Monday 08:00
		const result = calculateStatus(
			makeSchedule(),
			new Date('2026-03-29T12:00:00'),
		);
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('opens_day');
		expect(result.offsetDays).toBe(1);
		expect(result.day).toBe('monday');
		expect(result.time).toBe('08:00');
	});

	test('24/7 is always open', () => {
		const schedule = makeSchedule();
		for (const day of DAYS_OF_WEEK) {
			schedule[day] = { type: '24/7' };
		}
		const result = calculateStatus(schedule, new Date('2026-03-30T03:00:00'));
		expect(result.isOpen).toBe(true);
		expect(result.type).toBe('open_24_7');
	});

	test('on_demand returns on_demand', () => {
		const schedule = makeSchedule({ monday: { type: 'on_demand' } });
		const result = calculateStatus(schedule, new Date('2026-03-30T10:00:00'));
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('on_demand');
	});

	test('not_specified returns not_specified', () => {
		const schedule = makeSchedule({ monday: { type: 'not_specified' } });
		const result = calculateStatus(schedule, new Date('2026-03-30T10:00:00'));
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('not_specified');
	});

	test('lunch break - closed between intervals', () => {
		const schedule = makeSchedule({
			monday: {
				type: 'regular',
				intervals: [
					{ start: '09:00', end: '13:00' },
					{ start: '15:00', end: '19:00' },
				],
			},
		});

		// Monday 14:00 - during lunch break
		const result = calculateStatus(schedule, new Date('2026-03-30T14:00:00'));
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('opens_today');
		expect(result.time).toBe('15:00');
	});

	test('lunch break - open in second interval', () => {
		const schedule = makeSchedule({
			monday: {
				type: 'regular',
				intervals: [
					{ start: '09:00', end: '13:00' },
					{ start: '15:00', end: '19:00' },
				],
			},
		});

		// Monday 16:00
		const result = calculateStatus(schedule, new Date('2026-03-30T16:00:00'));
		expect(result.isOpen).toBe(true);
		expect(result.type).toBe('open_until');
		expect(result.time).toBe('19:00');
	});

	test('saturday closed, sunday closed → opens monday', () => {
		const schedule = makeSchedule({
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});

		// Saturday 12:00 → opens Monday (2 days)
		const result = calculateStatus(schedule, new Date('2026-03-28T12:00:00'));
		expect(result.isOpen).toBe(false);
		expect(result.type).toBe('opens_day');
		expect(result.offsetDays).toBe(2);
		expect(result.day).toBe('monday');
	});
});

// --- validateWorkingHoursData ---

test.describe('validateWorkingHoursData', () => {
	test('valid schedule has no errors', () => {
		const errors = validateWorkingHoursData({
			monday: {
				type: 'regular',
				intervals: [{ start: '09:00', end: '18:00' }],
			},
			tuesday: {
				type: 'regular',
				intervals: [{ start: '09:00', end: '18:00' }],
			},
			wednesday: { type: 'closed' },
			thursday: { type: '24/7' },
			friday: { type: 'on_demand' },
			saturday: { type: 'not_specified' },
			sunday: { type: 'closed' },
		});
		expect(errors).toHaveLength(0);
	});

	test('missing day returns error', () => {
		const errors = validateWorkingHoursData({
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors[0]).toContain('monday');
	});

	test('invalid type returns error', () => {
		const errors = validateWorkingHoursData({
			monday: { type: 'invalid_type' },
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors[0]).toContain('monday');
	});

	test('regular without intervals returns error', () => {
		const errors = validateWorkingHoursData({
			monday: { type: 'regular', intervals: [] },
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
	});

	test('start >= end returns error', () => {
		const errors = validateWorkingHoursData({
			monday: {
				type: 'regular',
				intervals: [{ start: '18:00', end: '09:00' }],
			},
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors.some((e) => e.includes('start must be before end'))).toBe(
			true,
		);
	});

	test('overlapping intervals returns error', () => {
		const errors = validateWorkingHoursData({
			monday: {
				type: 'regular',
				intervals: [
					{ start: '09:00', end: '14:00' },
					{ start: '13:00', end: '18:00' },
				],
			},
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors.some((e) => e.includes('overlap'))).toBe(true);
	});

	test('more than 3 intervals returns error', () => {
		const errors = validateWorkingHoursData({
			monday: {
				type: 'regular',
				intervals: [
					{ start: '08:00', end: '10:00' },
					{ start: '11:00', end: '13:00' },
					{ start: '14:00', end: '16:00' },
					{ start: '17:00', end: '19:00' },
				],
			},
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors.some((e) => e.includes('maximum'))).toBe(true);
	});

	test('invalid time format returns error', () => {
		const errors = validateWorkingHoursData({
			monday: {
				type: 'regular',
				intervals: [{ start: '25:00', end: '18:00' }],
			},
			tuesday: { type: 'closed' },
			wednesday: { type: 'closed' },
			thursday: { type: 'closed' },
			friday: { type: 'closed' },
			saturday: { type: 'closed' },
			sunday: { type: 'closed' },
		});
		expect(errors.length).toBeGreaterThan(0);
		expect(errors.some((e) => e.includes('invalid format'))).toBe(true);
	});
});
