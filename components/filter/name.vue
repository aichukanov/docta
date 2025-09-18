<template>
	<FilterWrapper :label="t('DoctorName')">
		<el-input
			v-model="name"
			:placeholder="t('InsertDoctorName')"
			size="large"
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
const { name } = useFilters();

const { t } = useI18n();
</script>

<i18n lang="json">
{
	"ru": { "DoctorName": "Имя врача", "InsertDoctorName": "Введите имя врача" },
	"en": {
		"DoctorName": "Doctor name",
		"InsertDoctorName": "Insert doctor name"
	},
	"sr": { "DoctorName": "Име врача", "InsertDoctorName": "Унесите име врача" },
	"ba": { "DoctorName": "Име врача", "InsertDoctorName": "Унесите име врача" },
	"me": { "DoctorName": "Име врача", "InsertDoctorName": "Унесите име врача" },
	"de": { "DoctorName": "Arztname", "InsertDoctorName": "Arztname eingeben" },
	"tr": { "DoctorName": "Doktor adı", "InsertDoctorName": "Doktor adı girin" }
}
</i18n>
