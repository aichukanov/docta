export type DayType =
	| 'regular'
	| '24/7'
	| 'closed'
	| 'on_demand'
	| 'not_specified';

export type DayOfWeek =
	| 'monday'
	| 'tuesday'
	| 'wednesday'
	| 'thursday'
	| 'friday'
	| 'saturday'
	| 'sunday';

export const DAYS_OF_WEEK: DayOfWeek[] = [
	'monday',
	'tuesday',
	'wednesday',
	'thursday',
	'friday',
	'saturday',
	'sunday',
];

export interface TimeInterval {
	start: string; // HH:mm
	end: string; // HH:mm
}

export interface DaySchedule {
	type: DayType;
	intervals?: TimeInterval[]; // Только для type = 'regular'
}

export interface WorkingHours {
	clinicId: number;
	monday: DaySchedule;
	tuesday: DaySchedule;
	wednesday: DaySchedule;
	thursday: DaySchedule;
	friday: DaySchedule;
	saturday: DaySchedule;
	sunday: DaySchedule;
}

export interface WorkingHoursStatus {
	isOpen: boolean;
	type: 'open_24_7' | 'open_until' | 'opens_today' | 'opens_day' | 'on_demand' | 'not_specified' | 'closed';
	time?: string; // HH:mm — время открытия/закрытия
	day?: DayOfWeek; // день открытия (для opens_day)
	offsetDays?: number; // 1 = завтра
}

export const DEFAULT_DAY_SCHEDULE: DaySchedule = { type: 'not_specified' };

export const DEFAULT_WORKING_HOURS: Omit<WorkingHours, 'clinicId'> = {
	monday: DEFAULT_DAY_SCHEDULE,
	tuesday: DEFAULT_DAY_SCHEDULE,
	wednesday: DEFAULT_DAY_SCHEDULE,
	thursday: DEFAULT_DAY_SCHEDULE,
	friday: DEFAULT_DAY_SCHEDULE,
	saturday: DEFAULT_DAY_SCHEDULE,
	sunday: DEFAULT_DAY_SCHEDULE,
};
