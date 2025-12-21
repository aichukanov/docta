<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { hasContacts } from '../contacts/utils';
import type { ClinicService } from '~/interfaces/clinic-service';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	clinic: ClinicData;
	priceInfo?: ClinicService;
	linkable?: boolean;
}>();

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const { t, n, locale } = useI18n();

const hasPrice = computed(() => {
	return props.priceInfo?.price != null;
});

const clinicLink = computed(() => ({
	name: 'clinics-clinicId',
	params: { clinicId: props.clinic.id },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="clinic-summary">
		<div class="location-wrapper">
			<div class="location-info">
				<div class="clinic-name-container">
					<NuxtLink
						v-if="linkable"
						:to="clinicLink"
						class="clinic-name clinic-name-link"
					>
						{{ clinic.name }}
					</NuxtLink>
					<span v-else class="clinic-name">{{ clinic.name }}</span>

					<div v-if="hasPrice" class="price-badge">
						<span class="price-value">{{
							n(priceInfo.price, { style: 'currency', currency: 'EUR' })
						}}</span>
					</div>
				</div>

				<div class="location-address">
					<el-icon><LocationFilled /></el-icon>
					<ClinicLocationAddress :clinic="clinic" />
				</div>

				<ConsultationLanguages :languageIds="clinic.languageIds">
					{{ t('LanguageAssistance') }}
				</ConsultationLanguages>
			</div>
			<div class="location-buttons">
				<ClinicShowOnMapButton :clinic="clinic" @click="$emit('show-on-map')" />
				<ClinicRouteButton :clinic="clinic" />
			</div>
		</div>
		<div v-if="hasContacts" class="contacts-wrapper">
			<el-collapse expand-icon-position="left">
				<el-collapse-item :title="t('Contacts')">
					<ContactsList :list="clinic" />
				</el-collapse-item>
			</el-collapse>
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
	}
}
</i18n>

<style scoped lang="less">
.clinic-summary {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-md) var(--spacing-lg);
}

.location-wrapper {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: var(--spacing-lg);

	.location-info {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: var(--spacing-sm);
		flex: 1;
	}
}

.clinic-name-container {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
}

.clinic-name {
	font-size: var(--font-size-lg);
	font-weight: 600;

	&.clinic-name-link {
		color: var(--color-primary);
		text-decoration: none;

		&:hover {
			color: var(--color-primary-dark);
			text-decoration: underline;
		}
	}
}

.location-address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
}

.location-buttons {
	display: flex;
	min-width: 180px;
	flex-direction: column;
	gap: var(--spacing-sm);
	align-items: stretch;
}

.contacts-wrapper {
	display: flex;
	flex-direction: column;
	align-items: stretch;
}

.price-badge {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-xs) var(--spacing-md);
	background: var(--color-primary);
	border-radius: var(--border-radius-sm);
	color: white;
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	white-space: nowrap;

	.price-value {
		font-size: var(--font-size-2xl);
		font-weight: var(--font-weight-bold);
	}
}

@media (max-width: 950px) {
	.location-wrapper {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
	}
}

@media (max-width: 400px) {
	.clinic-summary {
		padding: var(--spacing-lg);
	}
}
</style>
