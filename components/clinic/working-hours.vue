<script setup lang="ts">
import {
	calculateStatus,
	formatIntervals,
	getDayOfWeek,
} from '~/common/clinic-working-hours';
import workingHoursI18n from '~/i18n/working-hours';
import type {
	DayOfWeek,
	DaySchedule,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const props = defineProps<{ clinicId: number }>();

const { t } = useI18n({
	useScope: 'local',
	messages: workingHoursI18n.messages,
});

const { data: schedule } = await useFetch<WorkingHours>(
	'/api/clinics/working-hours',
	{
		key: `clinic-wh-${props.clinicId}`,
		method: 'POST',
		body: { clinicId: props.clinicId },
	},
);

const hasSchedule = computed(() => {
	if (!schedule.value) return false;
	return DAYS_OF_WEEK.some(
		(day) => schedule.value![day]?.type !== 'not_specified',
	);
});

const currentDay = computed(() => getDayOfWeek(new Date()));

const status = computed(() => {
	if (!schedule.value) return null;
	return calculateStatus(schedule.value);
});

const DAY_NAME_KEYS: Record<DayOfWeek, string> = {
	monday: 'Monday',
	tuesday: 'Tuesday',
	wednesday: 'Wednesday',
	thursday: 'Thursday',
	friday: 'Friday',
	saturday: 'Saturday',
	sunday: 'Sunday',
};

const formatDayHours = (ds: DaySchedule): string => {
	if (ds.type === 'regular' && ds.intervals)
		return formatIntervals(ds.intervals);
	if (ds.type === '24/7') return t('Open24_7');
	if (ds.type === 'closed') return t('Closed');
	if (ds.type === 'on_demand') return t('OnDemand');
	return t('NotSpecified');
};

const ON_DAY_KEYS: Record<DayOfWeek, string> = {
	monday: 'OnDayMonday',
	tuesday: 'OnDayTuesday',
	wednesday: 'OnDayWednesday',
	thursday: 'OnDayThursday',
	friday: 'OnDayFriday',
	saturday: 'OnDaySaturday',
	sunday: 'OnDaySunday',
};

const statusText = computed(() => {
	const s = status.value;
	if (!s) return '';
	switch (s.type) {
		case 'open_24_7':
			return t('Open24_7');
		case 'open_until':
			return t('OpenUntil', { time: s.time });
		case 'opens_today':
			return t('OpensAt', { time: s.time });
		case 'opens_day':
			if (s.offsetDays === 1) {
				return t('OpensTomorrow', { time: s.time });
			}
			return t('OpensOnDay', { day: t(ON_DAY_KEYS[s.day!]), time: s.time });
		case 'on_demand':
			return t('OnDemand');
		case 'not_specified':
			return t('NotSpecified');
		default:
			return '';
	}
});
</script>

<template>
	<div v-if="hasSchedule" class="working-hours">
		<div
			class="working-hours__status"
			:class="{ 'working-hours__status--open': status?.isOpen }"
		>
			<span class="working-hours__dot" />
			<span>{{ status?.isOpen ? t('OpenNow') : t('ClosedNow') }}</span>
			<template v-if="statusText">
				<span class="working-hours__status-detail">·</span>
				<span class="working-hours__status-detail">{{ statusText }}</span>
			</template>
		</div>

		<div class="working-hours__grid">
			<div
				v-for="day in DAYS_OF_WEEK"
				:key="day"
				class="working-hours__row"
				:class="{ 'working-hours__row--current': day === currentDay }"
			>
				<span class="working-hours__day-name">{{ t(DAY_NAME_KEYS[day]) }}</span>
				<span class="working-hours__day-hours">{{
					formatDayHours(schedule![day])
				}}</span>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
.working-hours {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.working-hours__status {
	display: flex;
	align-items: baseline;
	gap: var(--spacing-sm);
	font-size: var(--font-size-md);
	color: #dc2626;
	font-weight: 500;
}

.working-hours__status--open {
	color: #16a34a;
}

.working-hours__dot {
	width: 10px;
	height: 10px;
	border-radius: 50%;
	background: currentColor;
	flex-shrink: 0;
}

.working-hours__status-detail {
	color: var(--color-text-secondary);
	font-weight: 400;
}

.working-hours__grid {
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.working-hours__row {
	display: flex;
	justify-content: space-between;
	padding: 4px 0;
	border-radius: var(--border-radius-sm);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
}

.working-hours__row--current {
	background: var(--color-surface-secondary);
	color: var(--color-text-primary);
	font-weight: 600;
}

.working-hours__day-name {
	min-width: 32px;
}

.working-hours__day-hours {
	text-align: right;
}
</style>
