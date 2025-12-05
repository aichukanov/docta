<template>
	<div class="lab-test-clinic-wrapper">
		<div class="clinic-summary-custom">
			<div class="location-wrapper">
				<div class="location-info">
					<div class="clinic-header">
						<span class="clinic-name">{{ clinic.name }}</span>
						<div v-if="hasPrice" class="price-badge">
							<span class="price-value">{{ priceInfo.price }} €</span>
							<span v-if="priceInfo.code" class="price-code">{{
								priceInfo.code
							}}</span>
						</div>
					</div>

					<div class="location-address">
						<el-icon><LocationFilled /></el-icon>
						<span>{{ clinic.address }}</span>
					</div>

					<ConsultationLanguages :languageIds="clinic.languageIds">
						{{ t('LanguageAssistance') }}
					</ConsultationLanguages>
				</div>
				<div class="location-buttons">
					<ClinicShowOnMapButton
						:clinic="clinic"
						@click="$emit('show-on-map')"
					/>
					<ClinicRouteButton :clinic="clinic" />
				</div>
			</div>
			<div v-if="hasContacts(clinic)" class="contacts-wrapper">
				<el-collapse expand-icon-position="left">
					<el-collapse-item :title="t('Contacts')">
						<ContactsList :list="clinic" />
					</el-collapse-item>
				</el-collapse>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { hasContacts } from '../contacts/utils';
import type { ClinicData } from '~/interfaces/doctor';
import type { LabTestClinicPrice } from '~/interfaces/lab-test';

const props = defineProps<{
	clinic: ClinicData;
	priceInfo?: LabTestClinicPrice;
}>();

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const { t } = useI18n({
	useScope: 'local',
});

const hasPrice = computed(() => {
	return props.priceInfo && props.priceInfo.price && props.priceInfo.price > 0;
});
</script>

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
.clinic-summary-custom {
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

.clinic-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	flex-wrap: wrap;
	width: 100%;
}

.clinic-name {
	font-size: var(--font-size-lg);
	font-weight: 600;
}

.price-badge {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	padding: var(--spacing-xs) var(--spacing-md);
	background: #4f46e5;
	border-radius: var(--border-radius-sm);
	color: white;
	font-size: var(--font-size-md);
	font-weight: 600;
	white-space: nowrap;
}

.price-value {
	font-size: 1.1rem;
	font-weight: 700;
}

.price-code {
	padding: 2px var(--spacing-xs);
	background: rgba(255, 255, 255, 0.2);
	border-radius: 4px;
	font-size: var(--font-size-sm);
	font-weight: 500;
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

@media (max-width: 950px) {
	.location-wrapper {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
	}
}

@media (max-width: 500px) {
	.clinic-header {
		flex-direction: column;
		align-items: flex-start;
		gap: var(--spacing-sm);
	}

	.price-badge {
		font-size: var(--font-size-sm);
		padding: var(--spacing-xs) var(--spacing-sm);
	}

	.price-value {
		font-size: 1rem;
	}
}

@media (max-width: 400px) {
	.clinic-summary-custom {
		padding: var(--spacing-lg);
	}
}
</style>
