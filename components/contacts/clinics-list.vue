<template>
	<div class="clinic-section">
		<h4 class="clinic-name">
			<a
				v-if="clinic.website"
				:href="clinic.website"
				target="_blank"
				rel="noopener noreferrer"
				class="clinic-website-link"
			>
				{{ clinic.clinicName }}
			</a>
			<span v-else>{{ clinic.clinicName }}</span>
		</h4>

		<ContactsList v-if="hasClinicContacts(clinic)" :list="clinic" />
		<p v-else class="no-contacts">
			{{ t('NoContacts') }}
		</p>
	</div>
</template>

<script setup lang="ts">
import type { DoctorClinicFull } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: DoctorClinicFull;
}>();

const { t } = useI18n();

function hasClinicContacts(clinic: DoctorClinicFull): boolean {
	return !!(
		clinic.phone ||
		clinic.email ||
		clinic.facebook ||
		clinic.instagram ||
		clinic.telegram ||
		clinic.whatsapp ||
		clinic.viber
	);
}
</script>

<style scoped>
.clinic-section {
	padding: var(--spacing-md);
	background: var(--color-bg-soft);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
}

.clinic-name {
	margin: 0 0 var(--spacing-md) 0;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.clinic-website-link {
	color: var(--color-primary);
	text-decoration: none;
	transition: color var(--transition-base);
}

.clinic-website-link:hover {
	color: var(--color-primary-dark);
	text-decoration: underline;
}

.no-contacts {
	margin: 0;
	padding: var(--spacing-sm);
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	font-style: italic;
	text-align: center;
	background: var(--color-surface-tertiary);
	border-radius: var(--border-radius-sm);
}

@media (max-width: 768px) {
	.clinic-section {
		padding: var(--spacing-sm);
	}

	.clinic-name {
		font-size: var(--font-size-md);
		margin-bottom: var(--spacing-sm);
	}
}
</style>
