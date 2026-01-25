<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

interface ServiceListItem {
	id: number;
	name: string;
}

const props = defineProps<{
	services: ServiceListItem[];
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const serviceId1 = ref<number | null>(null);
const serviceId2 = ref<number | null>(null);

const selectedService1 = computed(() =>
	props.services.find((s) => s.id === serviceId1.value),
);

const selectedService2 = computed(() =>
	props.services.find((s) => s.id === serviceId2.value),
);

const mergeServices = async () => {
	if (
		!serviceId1.value ||
		!serviceId2.value ||
		serviceId1.value === serviceId2.value
	) {
		alert('Выберите две разные услуги');
		return;
	}

	const msg = `Объединить услуги?\n\nОСТАВИТЬ: ${selectedService1.value?.name} (ID: ${serviceId1.value})\nУДАЛИТЬ: ${selectedService2.value?.name} (ID: ${serviceId2.value})\n\nДанные из второй услуги будут перенесены в первую.`;

	if (!confirm(msg)) return;

	await $fetch('/api/services/merge', {
		method: 'POST',
		body: {
			primaryServiceId: serviceId1.value,
			secondaryServiceId: serviceId2.value,
		},
	});

	serviceId1.value = null;
	serviceId2.value = null;

	emit('updated');
	alert('Услуги объединены');
};
</script>

<template>
	<div class="service-merge">
		<div class="merge-info">
			<p>
				<strong>Объединение услуг:</strong> выберите две услуги. Первая будет
				оставлена, вторая удалена. Все связи (клиники, специальности) будут
				перенесены.
			</p>
		</div>

		<div class="flex-block">
			<div class="merge-column">
				<h4>Оставить (основная)</h4>
				<AdminServiceInfo
					:services="services"
					:clinics="clinics"
					@selected="serviceId1 = $event"
				/>
			</div>
			<div class="merge-column">
				<h4>Удалить (дубликат)</h4>
				<AdminServiceInfo
					:services="services"
					:clinics="clinics"
					@selected="serviceId2 = $event"
				/>
			</div>
		</div>

		<div class="merge-action">
			<el-button
				type="warning"
				size="large"
				@click="mergeServices"
				:disabled="!serviceId1 || !serviceId2 || serviceId1 === serviceId2"
			>
				Объединить услуги
			</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.service-merge {
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
