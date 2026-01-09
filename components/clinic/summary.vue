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
		AvailableServices: 'Specialty services',
	},
	'ru': {
		Contacts: 'Контакты',
		AvailableServices: 'Профильные услуги',
	},
	'de': {
		Contacts: 'Kontakte',
		AvailableServices: 'Fachleistungen',
	},
	'tr': {
		Contacts: 'İletişim',
		AvailableServices: 'Uzmanlık hizmetleri',
	},
	'sr': {
		Contacts: 'Kontakti',
		AvailableServices: 'Profilne usluge',
	},
	'sr-cyrl': {
		Contacts: 'Контакти',
		AvailableServices: 'Профилне услуге',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: summaryI18n,
});

const hasServices = computed(() => props.services && props.services.length > 0);
const hasFooterContent = computed(() => hasServices.value || hasContacts);

// Услуги открыты по умолчанию
const activeCollapse = ref<string[]>(hasServices.value ? ['services'] : []);
</script>

<template>
	<div class="clinic-summary">
		<ClinicSummaryHeader
			:clinic="clinic"
			:price="priceInfo?.price"
			@show-on-map="$emit('show-on-map')"
		/>

		<footer v-if="hasFooterContent" class="clinic-footer">
			<el-collapse v-model="activeCollapse" expand-icon-position="left">
				<el-collapse-item v-if="hasServices" name="services">
					<template #title>
						<span class="collapse-title">
							{{ t('AvailableServices') }}
							<span class="collapse-count">({{ services.length }})</span>
						</span>
					</template>
					<ClinicServiceSectionContent :items="services" :initialLimit="2">
						<template #default="{ item }">
							<PricedItemCard
								:id="item.id"
								:name="item.name"
								:localName="item.localName"
								:price="item.price"
								:priceMax="item.priceMax"
								routeName="services-serviceId"
								routeParamName="serviceId"
							/>
						</template>
					</ClinicServiceSectionContent>
				</el-collapse-item>

				<el-collapse-item
					v-if="hasContacts"
					name="contacts"
					:title="t('Contacts')"
				>
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

.clinic-footer {
	border-top: 1px solid var(--color-border-light);
	padding: 0 var(--spacing-xl);
}

.collapse-title {
	font-weight: var(--font-weight-medium);

	.collapse-count {
		color: var(--color-text-muted);
		font-weight: var(--font-weight-normal);
		margin-left: var(--spacing-xs);
	}
}

@media (max-width: 600px) {
	.clinic-footer {
		padding: 0 var(--spacing-md);
	}
}
</style>
