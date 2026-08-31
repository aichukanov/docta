<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { ERROR_CODES } from '~/server/utils/api-codes';
import type { DoctorMyProfile } from '~/server/api/doctors/my-profile';
import type { DoctorProfileStatus } from '~/interfaces/doctor';

const toast = useToast();

const { t } = useI18n({
	useScope: 'local',
	messages: doctorProfileI18n.messages,
});

const { data: doctor } = await useFetch<DoctorMyProfile | null>(
	'/api/doctors/my-profile',
	{ key: 'my-doctor-profile' },
);

const isToggling = ref(false);
const isEditing = ref(false);

// Скрытие админом важнее собственного статуса: врач его не снимет
const status = computed<DoctorProfileStatus | null>(() =>
	doctor.value
		? doctor.value.hiddenByAdmin
			? 'hidden_by_admin'
			: doctor.value.isDraft
				? 'draft'
				: doctor.value.hidden
					? 'hidden'
					: 'public'
		: null,
);

async function toggleVisibility() {
	if (!doctor.value) return;

	const msg = doctor.value.hidden ? t('confirmShow') : t('confirmHide');
	if (!confirm(msg)) return;

	isToggling.value = true;
	try {
		const result = await $fetch('/api/doctors/toggle-visibility', {
			method: 'POST',
		});
		doctor.value.hidden = result.hidden;
		toast.success(t('visibilityUpdated'));
	} catch (e: any) {
		if (e?.data?.data?.code === ERROR_CODES.DOCTOR_PROFILE_HIDDEN_BY_ADMIN) {
			toast.warning(t('errorHiddenByAdmin'));
		} else {
			toast.error(t('errorUpdating'));
		}
	} finally {
		isToggling.value = false;
	}
}

async function onSaved() {
	isEditing.value = false;
	await refreshNuxtData('my-doctor-profile');
}

function onPhotoUpdated(url: string) {
	if (doctor.value) {
		doctor.value.photoUrl = url;
	}
}
</script>

<template>
	<ProfileDoctorEditForm
		v-if="doctor && isEditing"
		:doctor="doctor"
		@saved="onSaved"
		@cancel="isEditing = false"
	/>
	<ProfileDoctorCard
		v-else-if="doctor && status"
		:doctor="doctor"
		:status="status"
		:is-toggling="isToggling"
		@toggle-visibility="toggleVisibility"
		@edit="isEditing = true"
		@photo-updated="onPhotoUpdated"
	/>
	<ProfileDoctorEmptyState v-else />
</template>
