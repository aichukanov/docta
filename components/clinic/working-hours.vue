<script setup lang="ts">
import {
	formatIntervals,
	getCurrentClinicDay,
} from '~/common/clinic-working-hours';
import workingHoursI18n from '~/i18n/working-hours';
import type {
	DayOfWeek,
	DaySchedule,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

// Расписание приходит пропом: страница клиники и так его грузит (ей нужен
// признак «расписание есть» и openingHoursSpecification для JSON-LD), а свой
// useFetch здесь шёл под другим ключом — тот же запрос уходил дважды и дважды
// же попадал в payload.
const props = defineProps<{ workingHours: WorkingHours | null }>();

const { t } = useI18n({
	useScope: 'local',
	messages: workingHoursI18n.messages,
});

const schedule = computed(() => props.workingHours);

const hasSchedule = computed(() => {
	if (!schedule.value) return false;
	return DAYS_OF_WEEK.some(
		(day) => schedule.value![day]?.type !== 'not_specified',
	);
});

const currentDay = getCurrentClinicDay();

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
</script>

<template>
	<div v-if="hasSchedule" class="working-hours">
		<ClinicWorkingStatusBadge :workingHours="schedule" />

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
	gap: var(--kit-spacing-sm);
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
	border-radius: var(--kit-border-radius-sm);
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-text-secondary);
}

.working-hours__row--current {
	background: var(--kit-color-surface-secondary);
	color: var(--kit-color-text-primary);
	font-weight: 600;
}

.working-hours__day-name {
	min-width: 32px;
}

.working-hours__day-hours {
	text-align: right;
}
</style>
