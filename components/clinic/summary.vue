<template>
	<div class="clinic-summary">
		<div class="location-wrapper">
			<div class="location-info">
				<div class="clinic-name-container">
					<el-link
						v-if="clinic.website"
						:href="clinic.website"
						underline="hover"
						target="_blank"
						class="clinic-name"
					>
						{{ clinic.name }}
					</el-link>
					<span v-else class="clinic-name">{{ clinic.name }}</span>
				</div>
				<div v-if="clinic.address" class="location-address">
					<el-icon><LocationFilled /></el-icon>
					<span>{{ clinic.address }}</span>
				</div>
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

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import type { ContactList } from '~/interfaces/contacts';
import { hasContacts } from '../contacts/utils';

const props = defineProps<{
	clinic: ClinicData;
}>();

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const { t } = useI18n();
</script>

<i18n lang="json">
{
	"en": {
		"Contacts": "Contacts"
	},
	"ru": {
		"Contacts": "Контакты"
	},
	"de": {
		"Contacts": "Kontakte"
	},
	"tr": {
		"Contacts": "İletişim"
	},
	"sr": {
		"Contacts": "Kontakti"
	},
	"ba": {
		"Contacts": "Kontakti"
	},
	"me": {
		"Contacts": "Kontakti"
	}
}
</i18n>

<style scoped lang="less">
.clinic-summary {
	display: flex;
	flex-direction: column;
	min-width: 210px;
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
		gap: var(--spacing-xs);
		flex: 1;
	}
}

.clinic-name-container {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.clinic-name {
	font-size: var(--font-size-lg);
	font-weight: 600;
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
	gap: var(--spacing-xs);
	align-items: stretch;
}

.contacts-wrapper {
	display: flex;
	flex-direction: column;
	align-items: stretch;
}

@media (max-width: 768px) {
	.location-wrapper {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
		padding: var(--spacing-md);
	}
}
</style>
