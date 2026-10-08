<template>
	<ContactsLine
		:value="scheduleUrlWithUtm"
		link
		:tooltip="t('DoctorScheduleHint')"
		contactType="doctor_schedule"
	>
		<IconDoctor :size="20" class="messenger-icon" />
		<span>{{ t('DoctorSchedule') }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { normalizeWebsiteUrl } from './utils';
import { SITE_NAME } from '~/common/constants';

// Сам график не храним: у клиник он недельный или месячный и без
// автоматической синхронизации устарел бы через неделю. Только ссылка —
// см. prd/doctor-schedules/.
const props = defineProps<{
	scheduleUrl: string;
}>();

const { t } = useI18n();

const scheduleUrlWithUtm = computed(() => {
	const normalized = normalizeWebsiteUrl(props.scheduleUrl) ?? props.scheduleUrl;
	try {
		const url = new URL(normalized);
		url.searchParams.set('utm_source', SITE_NAME);
		return url.toString();
	} catch {
		return normalized;
	}
});
</script>

<style scoped src="./style.css" />

<i18n lang="json">
{
	"en": {
		"DoctorSchedule": "Doctors' schedule on the clinic website",
		"DoctorScheduleHint": "The clinic updates this schedule itself"
	},
	"ru": {
		"DoctorSchedule": "График приёма врачей на сайте клиники",
		"DoctorScheduleHint": "График обновляет сама клиника"
	},
	"sr": {
		"DoctorSchedule": "Raspored rada ljekara na sajtu klinike",
		"DoctorScheduleHint": "Raspored ažurira sama klinika"
	},
	"sr-cyrl": {
		"DoctorSchedule": "Распоред рада љекара на сајту клинике",
		"DoctorScheduleHint": "Распоред ажурира сама клиника"
	},
	"de": {
		"DoctorSchedule": "Sprechzeiten der Ärzte auf der Website der Klinik",
		"DoctorScheduleHint": "Die Klinik pflegt diesen Plan selbst"
	},
	"tr": {
		"DoctorSchedule": "Klinik sitesinde doktorların çalışma takvimi",
		"DoctorScheduleHint": "Takvimi klinik kendisi günceller"
	}
}
</i18n>
