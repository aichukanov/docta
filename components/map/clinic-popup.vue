<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { hasContacts } from '../contacts/utils';
import type { ClinicData, ClinicServiceItem } from '~/interfaces/clinic';

const props = defineProps<{
	clinic: ClinicData;
	services: ClinicServiceItem[];
}>();

const { t, locale } = useI18n();
const servicesListRef = ref<HTMLElement>();
const pageNumber = ref(1);
const PAGE_LIMIT = 20;

const clinicLink = computed(() => ({
	name: 'clinics-clinicId',
	params: { clinicId: props.clinic.id },
	query: getRegionalQuery(locale.value),
}));

const servicesOnPage = computed(() => {
	return props.services.slice(
		(pageNumber.value - 1) * PAGE_LIMIT,
		pageNumber.value * PAGE_LIMIT,
	);
});

watch(pageNumber, () => {
	if (servicesListRef.value) {
		servicesListRef.value.scrollTo(0, 0);
	}
});
</script>

<template>
	<div class="clinic-popup">
		<div class="clinic-name-container">
			<NuxtLink :to="clinicLink" class="clinic-name">
				{{ clinic.name }}
			</NuxtLink>
		</div>

		<ClinicRouteButton :clinic="clinic">
			<ClinicLocationAddress :clinic="clinic" />
		</ClinicRouteButton>

		<ConsultationLanguages :languageIds="clinic.languageIds">
			{{ t('LanguageAssistance') }}
		</ConsultationLanguages>

		<div v-if="hasContacts(clinic)" class="contacts-wrapper">
			<el-collapse expand-icon-position="left">
				<el-collapse-item :title="t('Contacts')">
					<ContactsList :list="clinic" />
				</el-collapse-item>
			</el-collapse>
		</div>

		<div v-if="services.length > 0" class="services-list" ref="servicesListRef">
			<div v-for="service in servicesOnPage" :key="service.id">
				<slot :service="service" />
			</div>
			<Pagination
				v-if="services.length > PAGE_LIMIT"
				align="center"
				:total="services.length"
				:page-size="PAGE_LIMIT"
				v-model:current-page="pageNumber"
			/>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"Contacts": "Contacts",
		"LanguageAssistance": "The clinic provides assistance in:"
	},
	"ru": {
		"Contacts": "Контакты",
		"LanguageAssistance": "В клинике предоставляется сопровождение на следующих языках:"
	},
	"de": {
		"Contacts": "Kontakte",
		"LanguageAssistance": "Die Klinik bietet Unterstützung in:"
	},
	"tr": {
		"Contacts": "İletişim",
		"LanguageAssistance": "Klinik aşağıdaki dillerde destek sunar:"
	},
	"sr": {
		"Contacts": "Kontakti",
		"LanguageAssistance": "Klinika pruža pomoć na sledećim jezicima:"
	},
	"ba": {
		"Contacts": "Kontakti",
		"LanguageAssistance": "Klinika pruža podršku na sljedećim jezicima:"
	},
	"me": {
		"Contacts": "Kontakti",
		"LanguageAssistance": "Klinika pruža podršku na sljedećim jezicima:"
	}
}
</i18n>

<style scoped lang="less">
.clinic-popup {
	overflow-x: hidden;
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-sm);
}

.services-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-sm);
	margin-right: -20px; // fix inner leaflet margin
	padding-right: var(--spacing-sm);
	max-height: 200px;
	overflow-y: auto;
	overflow-x: hidden;
	align-self: stretch;
}

.clinic-name-container {
	word-wrap: break-word;
	overflow-wrap: break-word;

	.clinic-name {
		font-size: var(--font-size-xl);
		font-weight: 600;
		color: var(--color-primary);
		text-decoration: none;

		&:hover {
			text-decoration: underline;
		}
	}
}

.contacts-wrapper {
	margin-top: var(--spacing-xs);
	align-self: stretch;
}
</style>
