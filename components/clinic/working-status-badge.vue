<script setup lang="ts">
import { calculateStatus } from '~/common/clinic-working-hours';
import workingHoursI18n from '~/i18n/working-hours';
import type {
	DayOfWeek,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';

const props = defineProps<{
	workingHours?: Omit<WorkingHours, 'clinicId'> | null;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: workingHoursI18n.messages,
});

const ON_DAY_KEYS: Record<DayOfWeek, string> = {
	monday: 'OnDayMonday',
	tuesday: 'OnDayTuesday',
	wednesday: 'OnDayWednesday',
	thursday: 'OnDayThursday',
	friday: 'OnDayFriday',
	saturday: 'OnDaySaturday',
	sunday: 'OnDaySunday',
};

const status = computed(() => {
	if (!props.workingHours) return null;
	return calculateStatus({ clinicId: 0, ...props.workingHours });
});

const detail = computed(() => {
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
	<div
		v-if="status"
		class="status-badge"
		:class="{ 'status-badge--open': status.isOpen }"
	>
		<span class="status-badge__dot" />
		<span>{{ status.isOpen ? t('OpenNow') : t('ClosedNow') }}</span>
		<template v-if="detail">
			<span class="status-badge__detail">·</span>
			<span class="status-badge__detail">{{ detail }}</span>
		</template>
	</div>
</template>

<style scoped lang="less">
.status-badge {
	display: flex;
	align-items: baseline;
	flex-wrap: wrap;
	gap: var(--spacing-xs) var(--spacing-sm);
	font-size: var(--font-size-sm);
	color: var(--color-danger-dark);
	font-weight: 500;
}

.status-badge--open {
	color: var(--color-primary-green);
}

.status-badge__dot {
	width: 10px;
	height: 10px;
	border-radius: 50%;
	background: currentColor;
	flex-shrink: 0;
	align-self: center;
}

.status-badge__detail {
	color: var(--color-text-secondary);
	font-weight: 400;
}
</style>
