<script setup lang="ts">
import { Plus } from '@element-plus/icons-vue';
import clinicProfileI18n from '~/i18n/clinic-profile';
import { ERROR_CODES } from '~/server/utils/api-codes';
import type { ClinicMyListItem } from '~/server/api/clinics/my-list';
import type { ClinicStatus } from '~/interfaces/clinic';

const toast = useToast();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});

const { data: clinics } = await useFetch<ClinicMyListItem[]>(
	'/api/clinics/my-list',
	{ key: 'my-clinics' },
);

const isFormOpen = ref(false);
// null при создании новой клиники
const editingClinic = ref<ClinicMyListItem | null>(null);
const togglingId = ref<number | null>(null);

function openCreate() {
	editingClinic.value = null;
	isFormOpen.value = true;
}

function openEdit(clinic: ClinicMyListItem) {
	editingClinic.value = clinic;
	isFormOpen.value = true;
}

async function onSaved() {
	isFormOpen.value = false;
	editingClinic.value = null;
	await refreshNuxtData('my-clinics');
}

async function setStatus(clinic: ClinicMyListItem, action: 'publish' | 'hide') {
	const msg = action === 'publish' ? t('ConfirmPublish') : t('ConfirmHide');
	if (!confirm(msg)) return;

	togglingId.value = clinic.id;
	try {
		const result = await $fetch<{ data?: { status: ClinicStatus } }>(
			'/api/clinics/my-set-status',
			{
				method: 'POST',
				body: { clinicId: clinic.id, action },
			},
		);
		if (result.data?.status) {
			clinic.status = result.data.status;
		}
		toast.success(t('StatusUpdated'));
	} catch (e: any) {
		if (e?.data?.data?.code === ERROR_CODES.CLINIC_INCOMPLETE) {
			toast.warning(t('ErrorClinicIncomplete'));
		} else if (e?.data?.data?.code === ERROR_CODES.CLINIC_HIDDEN_BY_ADMIN) {
			toast.warning(t('ErrorClinicHiddenByAdmin'));
		} else {
			toast.error(t('ErrorUpdatingStatus'));
		}
	} finally {
		togglingId.value = null;
	}
}
</script>

<template>
	<ProfileClinicEditForm
		v-if="isFormOpen"
		:clinic="editingClinic"
		@saved="onSaved"
		@cancel="isFormOpen = false"
	/>
	<template v-else-if="clinics && clinics.length">
		<div class="clinics-tab__header">
			<div class="clinics-tab__header-left">
				<div class="clinics-tab__icon">
					<IconClinic :size="20" />
				</div>
				<h2 class="clinics-tab__title">{{ t('MyClinics') }}</h2>
			</div>
			<el-button type="primary" plain :icon="Plus" @click="openCreate">
				{{ t('AddClinic') }}
			</el-button>
		</div>

		<ProfileClinicCard
			v-for="clinic in clinics"
			:key="clinic.id"
			:clinic="clinic"
			:is-toggling="togglingId === clinic.id"
			@edit="openEdit(clinic)"
			@publish="setStatus(clinic, 'publish')"
			@hide="setStatus(clinic, 'hide')"
		/>
	</template>
	<ProfileClinicsEmptyState v-else @create="openCreate" />
</template>

<style scoped>
.clinics-tab__header {
	background: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-xl);
	border: 1px solid var(--kit-color-border-secondary);
	box-shadow: var(--kit-shadow-sm);
	padding: var(--kit-spacing-lg) var(--kit-spacing-2xl);
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);
	flex-wrap: wrap;
}

.clinics-tab__header-left {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
}

.clinics-tab__icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	border-radius: var(--kit-border-radius-lg);
	background: var(--kit-color-primary-bg);
	color: var(--kit-color-primary);
	flex-shrink: 0;
}

.clinics-tab__title {
	font-size: var(--kit-font-size-2xl);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-heading);
	margin: 0;
}

@media (max-width: 640px) {
	.clinics-tab__header {
		padding: var(--kit-spacing-lg);
	}
}
</style>
