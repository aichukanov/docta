<template>
	<div class="contacts-collapse" :class="{ open: isOpen }">
		<DsButton
			variant="outline"
			size="sm"
			@click="toggleCollapse()"
			class="collapse-trigger"
		>
			<span class="trigger-text">{{
				isOpen ? t('HideContacts') : t('ShowContacts')
			}}</span>
			<template #icon>
				<IconChevron
					:size="20"
					class="chevron-icon"
					:class="{ rotated: isOpen }"
				/>
			</template>
		</DsButton>

		<Transition name="collapse">
			<div v-show="isOpen" class="collapse-content">
				<!-- Контакты врача -->
				<div v-if="hasDoctorContacts" class="doctor-contacts">
					<ContactsList :list="doctor" />
				</div>

				<!-- Контакты клиник -->
				<div
					v-if="doctor.clinics && doctor.clinics.length > 0"
					class="clinics-contacts"
				>
					<ClinicsList
						v-for="clinic in doctor.clinics"
						:key="clinic.clinicId"
						:clinic="clinic"
					/>
				</div>
			</div>
		</Transition>
	</div>
</template>

<script setup lang="ts">
import { hasContacts } from './utils';
import type { DoctorWithClinics } from '~/interfaces/doctor';

const props = defineProps<{
	doctor: DoctorWithClinics;
}>();

const { t } = useI18n();

const isOpen = ref(false);

const hasDoctorContacts = computed(() => hasContacts(props.doctor));

function toggleCollapse(): void {
	isOpen.value = !isOpen.value;
}
</script>

<style scoped>
.contacts-collapse {
	border-top: 1px solid var(--color-border-light);
	margin-top: var(--spacing-lg);
}

.collapse-trigger {
	width: 100%;
	padding: var(--spacing-md) 0;
	background: transparent;
	border: none;
}

.trigger-text {
	flex: 1;
	text-align: left;
}

.chevron-icon {
	width: 20px;
	height: 20px;
	transition: transform var(--transition-base);
	color: var(--color-primary);
}

.chevron-icon.rotated {
	transform: rotate(180deg);
}

.collapse-content {
	padding-bottom: var(--spacing-lg);
}

/* Секции контактов */
.doctor-contacts {
	margin-bottom: var(--spacing-lg);
}

.clinics-contacts {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

/* Адаптивность */
@media (max-width: 768px) {
	.collapse-trigger {
		padding: var(--spacing-sm) 0;
		font-size: var(--font-size-sm);
	}
}
</style>

<i18n>
{
	"en": {
		"HideContacts": "Hide Contacts",
		"ShowContacts": "Show Contacts"
	},
	"sr": {
		"HideContacts": "Sakrij kontakte",
		"ShowContacts": "Prikaži kontakte"
	},
	"ru": {
		"HideContacts": "Скрыть контакты",
		"ShowContacts": "Показать контакты"
	},
	"me": {
		"HideContacts": "Sakrij kontakte",
		"ShowContacts": "Prikaži kontakte"
	},
	"ba": {
		"HideContacts": "Sakrij kontakte",
		"ShowContacts": "Prikaži kontakte"
	},
	"de": {
		"HideContacts": "Kontakte verbergen",
		"ShowContacts": "Kontakte anzeigen"
	},
	"tr": {
		"HideContacts": "Kişileri gizle",
		"ShowContacts": "Kişileri göster"
	}
}
</i18n>
