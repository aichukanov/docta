<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import type { DoctorMyProfile } from '~/server/api/doctors/my-profile';
import type { DoctorProfileStatus } from '~/interfaces/doctor';

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

const status = computed<DoctorProfileStatus | null>(() =>
	doctor.value
		? doctor.value.isDraft
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
		ElMessage.success(t('visibilityUpdated'));
	} catch {
		ElMessage.error(t('errorUpdating'));
	} finally {
		isToggling.value = false;
	}
}

async function onSaved() {
	isEditing.value = false;
	await refreshNuxtData('my-doctor-profile');
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
	/>
	<ProfileDoctorEmptyState v-else />
</template>
