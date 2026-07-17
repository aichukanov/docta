<script setup lang="ts">
import workingHoursI18n from '~/i18n/working-hours';
import type {
	DaySchedule,
	DayType,
	DayOfWeek,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const props = defineProps<{
	modelValue: Record<DayOfWeek, DaySchedule>;
}>();

const emit = defineEmits<{
	(e: 'update:modelValue', value: Record<DayOfWeek, DaySchedule>): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: workingHoursI18n.messages,
});

const DAY_TYPES: DayType[] = [
	'regular',
	'24/7',
	'closed',
	'on_demand',
	'not_specified',
];

const DAY_TYPE_LABEL_KEYS: Record<DayType, string> = {
	'regular': 'DayTypeRegular',
	'24/7': 'DayType24_7',
	'closed': 'DayTypeClosed',
	'on_demand': 'DayTypeOnDemand',
	'not_specified': 'DayTypeNotSpecified',
};

const dayShortKey = (day: DayOfWeek) =>
	`${day.charAt(0).toUpperCase()}${day.slice(1)}Short`;

const clone = <T,>(value: T): T => JSON.parse(JSON.stringify(value));

const schedule = reactive<Record<DayOfWeek, DaySchedule>>(
	clone(props.modelValue),
);

let syncingFromProp = false;

watch(
	() => props.modelValue,
	(next) => {
		if (JSON.stringify(next) === JSON.stringify(schedule)) return;
		syncingFromProp = true;
		for (const day of DAYS_OF_WEEK) {
			schedule[day] = clone(next[day]);
		}
		nextTick(() => {
			syncingFromProp = false;
		});
	},
	{ deep: true },
);

watch(
	schedule,
	() => {
		if (syncingFromProp) return;
		emit('update:modelValue', clone(schedule));
	},
	{ deep: true },
);

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

const copyToAll = (sourceDay: DayOfWeek) => {
	const source = clone(schedule[sourceDay]);
	for (const day of DAYS_OF_WEEK) {
		schedule[day] = clone(source);
	}
};
</script>

<template>
	<div class="wh-editor">
		<div v-for="day in DAYS_OF_WEEK" :key="day" class="wh-editor__day">
			<div class="wh-editor__day-header">
				<span class="wh-editor__day-label">{{ t(dayShortKey(day)) }}</span>
				<el-select
					:model-value="schedule[day].type"
					@update:model-value="(val: DayType) => setDayType(day, val)"
					size="small"
					class="wh-editor__type-select"
				>
					<el-option
						v-for="type in DAY_TYPES"
						:key="type"
						:label="t(DAY_TYPE_LABEL_KEYS[type])"
						:value="type"
					/>
				</el-select>
				<el-button
					size="small"
					class="wh-editor__copy-btn"
					@click="copyToAll(day)"
				>
					{{ t('CopyToAll') }}
				</el-button>
			</div>

			<div v-if="schedule[day].type === 'regular'" class="wh-editor__intervals">
				<div
					v-for="(interval, idx) in schedule[day].intervals"
					:key="idx"
					class="wh-editor__interval"
				>
					<el-time-picker
						v-model="interval.start"
						format="HH:mm"
						value-format="HH:mm"
						:clearable="false"
						size="small"
						class="wh-editor__time"
					/>
					<span class="wh-editor__separator">–</span>
					<el-time-picker
						v-model="interval.end"
						format="HH:mm"
						value-format="HH:mm"
						:clearable="false"
						size="small"
						class="wh-editor__time"
					/>
					<el-button
						v-if="(schedule[day].intervals?.length || 0) > 1"
						size="small"
						type="danger"
						plain
						@click="removeInterval(day, idx)"
					>
						<IconClose :size="10" />
					</el-button>
				</div>
				<el-button
					v-if="(schedule[day].intervals?.length || 0) < 3"
					size="small"
					@click="addInterval(day)"
				>
					+ {{ t('AddInterval') }}
				</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped>
.wh-editor {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.wh-editor__day {
	background: var(--color-bg-secondary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-sm);
}

.wh-editor__day-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

.wh-editor__day-label {
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-sm);
	color: var(--color-text-primary);
	min-width: 32px;
}

.wh-editor__type-select {
	width: 170px;
}

.wh-editor__copy-btn {
	margin-left: auto;
}

.wh-editor__intervals {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-xs);
	padding-left: 40px;
}

.wh-editor__interval {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.wh-editor__time {
	width: 110px;
}

.wh-editor__separator {
	color: var(--color-text-secondary);
}

@media (max-width: 640px) {
	.wh-editor__intervals {
		padding-left: 0;
	}
}
</style>
