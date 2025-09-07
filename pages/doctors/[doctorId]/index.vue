<script setup lang="ts">
const { t } = useI18n();
const route = useRoute();

const { pending: isLoadingDoctor, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			doctorId: route.params.doctorId,
		})),
	},
);
</script>

<template>
	<div class="doctor-page">
		<div v-if="isLoadingDoctor" class="loading">
			<div class="loading-spinner"></div>
			<p>{{ t('LoadingDoctor') }}</p>
		</div>
		<div v-else>
			<DoctorInfo :doctor="doctorData" />
		</div>
		<!-- <div class="clinics-list">
			<ClinicSummary
				v-for="clinic in doctorClinics"
				:key="clinic.id"
				:clinic="clinic"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
		</div> -->
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctor-page {
	display: flex;
	flex-wrap: wrap;
	gap: @base-offset;
}
</style>

<i18n lang="json">
{
	"en": {
		"LoadingDoctor": "Loading doctor data..."
	},
	"ru": {
		"LoadingDoctor": "Загрузка данных о враче..."
	},
	"tr": {
		"LoadingDoctor": "Doktor verileri yükleniyor..."
	},
	"de": {
		"LoadingDoctor": "Doktor-Daten werden geladen..."
	},
	"sr": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	},
	"ba": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	},
	"me": {
		"LoadingDoctor": "Učitavanje podataka o lekaru..."
	}
}
</i18n>
