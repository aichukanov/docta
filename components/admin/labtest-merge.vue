<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

interface LabTestListItem {
	id: number;
	name: string;
}

const props = defineProps<{
	labTests: LabTestListItem[];
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const labTestId1 = ref<number | null>(null);
const labTestId2 = ref<number | null>(null);

const selectedLabTest1 = computed(() =>
	props.labTests.find((lt) => lt.id === labTestId1.value),
);

const selectedLabTest2 = computed(() =>
	props.labTests.find((lt) => lt.id === labTestId2.value),
);

const mergeLabTests = async () => {
	if (
		!labTestId1.value ||
		!labTestId2.value ||
		labTestId1.value === labTestId2.value
	) {
		alert('Выберите два разных анализа');
		return;
	}

	const msg = `Объединить анализы?\n\nОСТАВИТЬ: ${selectedLabTest1.value?.name} (ID: ${labTestId1.value})\nУДАЛИТЬ: ${selectedLabTest2.value?.name} (ID: ${labTestId2.value})\n\nДанные из второго анализа будут перенесены в первый.`;

	if (!confirm(msg)) return;

	await $fetch('/api/labtests/merge', {
		method: 'POST',
		body: {
			primaryLabTestId: labTestId1.value,
			secondaryLabTestId: labTestId2.value,
		},
	});

	labTestId1.value = null;
	labTestId2.value = null;

	emit('updated');
	alert('Анализы объединены');
};
</script>

<template>
	<div class="labtest-merge">
		<div class="merge-info">
			<p>
				<strong>Объединение анализов:</strong> выберите два анализа. Первый
				будет оставлен, второй удалён. Все связи (клиники, категории, синонимы)
				будут перенесены.
			</p>
		</div>

		<div class="flex-block">
			<div class="merge-column">
				<h4>Оставить (основной)</h4>
				<AdminLabtestInfo
					:labTests="labTests"
					@selected="labTestId1 = $event"
				/>
			</div>
			<div class="merge-column">
				<h4>Удалить (дубликат)</h4>
				<AdminLabtestInfo
					:labTests="labTests"
					@selected="labTestId2 = $event"
				/>
			</div>
		</div>

		<div class="merge-action">
			<el-button
				type="warning"
				size="large"
				@click="mergeLabTests"
				:disabled="!labTestId1 || !labTestId2 || labTestId1 === labTestId2"
			>
				Объединить анализы
			</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.labtest-merge {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.merge-info {
	padding: var(--spacing-md);
	background: rgba(245, 158, 11, 0.1);
	border: 1px solid rgba(245, 158, 11, 0.3);
	border-radius: var(--border-radius-md);

	p {
		margin: 0;
	}
}

.flex-block {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-lg);

	& > .merge-column {
		flex: 1 1 50%;
		max-width: 50%;

		h4 {
			margin: 0 0 var(--spacing-md) 0;
			color: var(--color-text-primary);
		}
	}
}

.merge-action {
	display: flex;
	justify-content: center;
	padding-top: var(--spacing-md);
	border-top: 1px solid var(--color-border-primary);
}

@media (max-width: 768px) {
	.flex-block {
		flex-direction: column;

		& > .merge-column {
			max-width: 100%;
		}
	}
}
</style>
