<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	clinic: ClinicData;
	price?: number | null;
}>();

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const headerI18n = {
	'en': {
		LanguageAssistance: 'The clinic provides assistance in:',
	},
	'ru': {
		LanguageAssistance:
			'В клинике предоставляется сопровождение на следующих языках:',
	},
	'de': {
		LanguageAssistance: 'Die Klinik bietet Unterstützung in:',
	},
	'tr': {
		LanguageAssistance: 'Klinik aşağıdaki dillerde destek sunar:',
	},
	'sr': {
		LanguageAssistance: 'Klinika pruža pomoć na sledećim jezicima:',
	},
	'sr-cyrl': {
		LanguageAssistance: 'Клиника пружа помоћ на следећим језицима:',
	},
};

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: headerI18n,
});

const localizedName = computed(() =>
	getLocalizedName(props.clinic, locale.value),
);

const hasPrice = computed(() => props.price != null);

const clinicLink = computed(() => ({
	name: 'clinics-clinicId',
	params: { clinicId: props.clinic.id },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<header class="clinic-header">
		<div class="clinic-info">
			<div class="clinic-name-row">
				<NuxtLink :to="clinicLink" class="clinic-name">
					{{ localizedName }}
				</NuxtLink>
				<div v-if="hasPrice" class="price-badge">
					{{ n(price, { style: 'currency', currency: 'EUR' }) }}
				</div>
			</div>

			<div class="clinic-address">
				<el-icon class="address-icon"><LocationFilled /></el-icon>
				<ClinicLocationAddress :clinic="clinic" />
			</div>

			<ConsultationLanguages :languageIds="clinic.languageIds">
				{{ t('LanguageAssistance') }}
			</ConsultationLanguages>
		</div>

		<div class="clinic-actions">
			<ClinicShowOnMapButton :clinic="clinic" @click="$emit('show-on-map')" />
			<ClinicRouteButton :clinic="clinic" />
		</div>
	</header>
</template>

<style scoped lang="less">
.clinic-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-surface-primary);
}

.clinic-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	flex: 1;
	min-width: 0;
}

.clinic-name-row {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--spacing-md);
}

.clinic-name {
	font-size: var(--font-size-xl);
	font-weight: 600;
	color: var(--color-primary);
	text-decoration: none;
	overflow-wrap: break-word;

	&:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}
}

.price-badge {
	padding: var(--spacing-xs) var(--spacing-md);
	background: var(--color-primary);
	border-radius: var(--border-radius-sm);
	color: white;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-bold);
	white-space: nowrap;
}

.clinic-address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);

	.address-icon {
		flex-shrink: 0;
		color: var(--color-text-muted);
	}
}

.clinic-actions {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	min-width: 160px;
}

@media (max-width: 950px) {
	.clinic-header {
		flex-direction: column;
		gap: var(--spacing-md);
	}

	.clinic-actions {
		flex-direction: row;
		width: 100%;
		min-width: unset;
	}
}

@media (max-width: 600px) {
	.clinic-header {
		padding: var(--spacing-md);
	}
}
</style>

