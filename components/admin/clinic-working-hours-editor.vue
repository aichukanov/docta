<script setup lang="ts">
import type {
	DaySchedule,
	DayType,
	DayOfWeek,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import {
	DAYS_OF_WEEK,
	DEFAULT_DAY_SCHEDULE,
} from '~/interfaces/clinic-working-hours';
import { validateWorkingHoursData } from '~/common/clinic-working-hours';

const props = defineProps<{ clinicId: number }>();

const DAY_TYPES: DayType[] = [
	'regular',
	'24/7',
	'closed',
	'on_demand',
	'not_specified',
];

const DAY_TYPE_LABELS: Record<DayType, string> = {
	'regular': 'Рабочий день',
	'24/7': 'Круглосуточно',
	'closed': 'Выходной',
	'on_demand': 'По записи',
	'not_specified': 'Не указано',
};

const DAY_LABELS: Record<DayOfWeek, string> = {
	monday: 'Пн',
	tuesday: 'Вт',
	wednesday: 'Ср',
	thursday: 'Чт',
	friday: 'Пт',
	saturday: 'Сб',
	sunday: 'Вс',
};

const schedule = reactive<Record<DayOfWeek, DaySchedule>>(
	Object.fromEntries(
		DAYS_OF_WEEK.map((day) => [day, { type: 'not_specified' as DayType }]),
	) as Record<DayOfWeek, DaySchedule>,
);

const isLoading = ref(false);
const isSaving = ref(false);
const statusMessage = ref('');

const loadSchedule = async () => {
	isLoading.value = true;
	try {
		const data = await $fetch<WorkingHours>('/api/clinics/working-hours', {
			method: 'POST',
			body: { clinicId: props.clinicId },
		});
		if (data) {
			for (const day of DAYS_OF_WEEK) {
				schedule[day] = data[day] || { type: 'not_specified' };
				if (schedule[day].type === 'regular' && !schedule[day].intervals) {
					schedule[day].intervals = [{ start: '09:00', end: '17:00' }];
				}
			}
		}
	} catch (error) {
		console.error('Failed to load working hours:', error);
	} finally {
		isLoading.value = false;
	}
};

const saveSchedule = async () => {
	const errors = validateWorkingHoursData(schedule);
	if (errors.length > 0) {
		alert('Ошибки валидации:\n' + errors.join('\n'));
		return;
	}

	isSaving.value = true;
	statusMessage.value = '';
	try {
		await $fetch('/api/clinics/update-working-hours', {
			method: 'POST',
			body: {
				clinicId: props.clinicId,
				...schedule,
			},
		});
		statusMessage.value = 'График сохранён';
		setTimeout(() => (statusMessage.value = ''), 3000);
	} catch (error) {
		console.error('Failed to save working hours:', error);
		statusMessage.value = 'Ошибка сохранения';
	} finally {
		isSaving.value = false;
	}
};

const setDayType = (day: DayOfWeek, type: DayType) => {
	schedule[day].type = type;
	if (type === 'regular' && !schedule[day].intervals?.length) {
		schedule[day].intervals = [{ start: '09:00', end: '17:00' }];
	}
	if (type !== 'regular') {
		delete schedule[day].intervals;
	}
};

const addInterval = (day: DayOfWeek) => {
	if (!schedule[day].intervals) schedule[day].intervals = [];
	if (schedule[day].intervals!.length < 3) {
		schedule[day].intervals!.push({ start: '09:00', end: '17:00' });
	}
};

const removeInterval = (day: DayOfWeek, index: number) => {
	schedule[day].intervals?.splice(index, 1);
	if (schedule[day].intervals?.length === 0) {
		schedule[day].intervals = [{ start: '09:00', end: '17:00' }];
	}
};

const copyToWeekdays = (sourceDay: DayOfWeek) => {
	const weekdays: DayOfWeek[] = [
		'monday',
		'tuesday',
		'wednesday',
		'thursday',
		'friday',
	];
	const source = JSON.parse(JSON.stringify(schedule[sourceDay]));
	for (const day of weekdays) {
		schedule[day] = JSON.parse(JSON.stringify(source));
	}
};

const copyToWeekend = (sourceDay: DayOfWeek) => {
	const source = JSON.parse(JSON.stringify(schedule[sourceDay]));
	schedule.saturday = JSON.parse(JSON.stringify(source));
	schedule.sunday = JSON.parse(JSON.stringify(source));
};

const copyToAll = (sourceDay: DayOfWeek) => {
	const source = JSON.parse(JSON.stringify(schedule[sourceDay]));
	for (const day of DAYS_OF_WEEK) {
		schedule[day] = JSON.parse(JSON.stringify(source));
	}
};

const set24_7 = () => {
	for (const day of DAYS_OF_WEEK) {
		schedule[day] = { type: '24/7' };
	}
};

watch(
	() => props.clinicId,
	() => loadSchedule(),
	{ immediate: true },
);
</script>

<template>
	<div class="wh-editor">
		<div class="wh-header">
			<h4>График работы</h4>
			<el-button size="small" @click="set24_7">24/7</el-button>
		</div>

		<div v-if="isLoading" class="wh-loading">Загрузка...</div>

		<div v-else class="wh-days">
			<div v-for="day in DAYS_OF_WEEK" :key="day" class="wh-day">
				<div class="wh-day-header">
					<span class="wh-day-label">{{ DAY_LABELS[day] }}</span>
					<el-select
						:model-value="schedule[day].type"
						@update:model-value="(val: DayType) => setDayType(day, val)"
						size="small"
						class="wh-type-select"
					>
						<el-option
							v-for="type in DAY_TYPES"
							:key="type"
							:label="DAY_TYPE_LABELS[type]"
							:value="type"
						/>
					</el-select>

					<div class="wh-day-actions">
						<el-button size="small" @click="copyToWeekdays(day)" title="Пн–Пт">
							→ Пн–Пт
						</el-button>
						<el-button size="small" @click="copyToWeekend(day)" title="Сб–Вс">
							→ Сб–Вс
						</el-button>
						<el-button size="small" @click="copyToAll(day)" title="Все">
							→ Все
						</el-button>
					</div>
				</div>

				<div v-if="schedule[day].type === 'regular'" class="wh-intervals">
					<div
						v-for="(interval, idx) in schedule[day].intervals"
						:key="idx"
						class="wh-interval"
					>
						<el-time-picker
							v-model="interval.start"
							format="HH:mm"
							value-format="HH:mm"
							:clearable="false"
							size="small"
							class="wh-time-picker"
						/>
						<span class="wh-separator">–</span>
						<el-time-picker
							v-model="interval.end"
							format="HH:mm"
							value-format="HH:mm"
							:clearable="false"
							size="small"
							class="wh-time-picker"
						/>
						<el-button
							v-if="(schedule[day].intervals?.length || 0) > 1"
							size="small"
							type="danger"
							plain
							@click="removeInterval(day, idx)"
						>
							✕
						</el-button>
					</div>
					<el-button
						v-if="(schedule[day].intervals?.length || 0) < 3"
						size="small"
						@click="addInterval(day)"
					>
						+ Интервал
					</el-button>
				</div>
			</div>
		</div>

		<div class="wh-footer">
			<el-button type="primary" @click="saveSchedule" :loading="isSaving">
				Сохранить график
			</el-button>
			<span v-if="statusMessage" class="wh-status">{{ statusMessage }}</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.wh-editor {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);
}

.wh-header {
	display: flex;
	justify-content: space-between;
	align-items: center;

	h4 {
		margin: 0;
		color: var(--color-text-primary);
	}
}

.wh-loading {
	color: var(--color-text-secondary);
	font-style: italic;
	padding: var(--spacing-sm) 0;
}

.wh-days {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.wh-day {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-sm);
}

.wh-day-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

.wh-day-label {
	font-weight: 600;
	min-width: 30px;
}

.wh-type-select {
	width: 160px;
}

.wh-day-actions {
	display: flex;
	gap: 4px;
	margin-left: auto;
}

.wh-intervals {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-xs);
	padding-left: 38px;
}

.wh-interval {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.wh-time-picker {
	width: 120px;
}

.wh-separator {
	color: var(--color-text-secondary);
}

.wh-footer {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
}

.wh-status {
	color: var(--color-text-secondary);
	font-size: 13px;
}
</style>
