<script setup lang="ts">
import { hasContacts } from '../contacts/utils';
import type { ClinicService, ClinicData } from '~/interfaces/clinic';
import type { ClinicServiceBySpecialty } from '~/server/api/clinics/services-by-specialties';

const props = defineProps<{
	clinic: ClinicData;
	priceInfo?: ClinicService;
	services?: ClinicServiceBySpecialty[];
}>();

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const summaryI18n = {
	'en': {
		Contacts: 'Contacts',
		AvailableServices: 'Services',
	},
	'ru': {
		Contacts: 'Контакты',
		AvailableServices: 'Услуги',
	},
	'de': {
		Contacts: 'Kontakte',
		AvailableServices: 'Leistungen',
	},
	'tr': {
		Contacts: 'İletişim',
		AvailableServices: 'Hizmetler',
	},
	'sr': {
		Contacts: 'Kontakti',
		AvailableServices: 'Usluge',
	},
	'sr-cyrl': {
		Contacts: 'Контакти',
		AvailableServices: 'Услуге',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: summaryI18n,
});

const hasServices = computed(() => props.services && props.services.length > 0);
const hasContent = computed(() => hasServices.value);
</script>

<template>
	<div class="clinic-summary">
		<ClinicSummaryHeader
			:clinic="clinic"
			:price="priceInfo?.price"
			@show-on-map="$emit('show-on-map')"
		/>

		<div v-if="hasContent" class="clinic-content">
			<PricedItemsSection
				v-if="hasServices"
				:title="t('AvailableServices')"
				:items="services"
				routeName="services-serviceId"
				routeParamName="serviceId"
			/>

			<!-- Слот для дополнительного контента (лекарства и т.д.) -->
			<slot name="additional-content" />
		</div>

		<footer v-if="hasContacts" class="clinic-footer">
			<el-collapse expand-icon-position="left">
				<el-collapse-item :title="t('Contacts')">
					<ContactsList :list="clinic" />
				</el-collapse-item>
			</el-collapse>
		</footer>
	</div>
</template>

<style scoped lang="less">
.clinic-summary {
	display: flex;
	flex-direction: column;
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-lg);
	overflow: hidden;
}

.clinic-content {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-surface-secondary);
	border-top: 1px solid var(--color-border-light);
}

.clinic-footer {
	border-top: 1px solid var(--color-border-light);
	padding: 0 var(--spacing-xl);
}

@media (max-width: 600px) {
	.clinic-content {
		padding: var(--spacing-md);
	}

	.clinic-footer {
		padding: 0 var(--spacing-md);
	}
}
</style>
