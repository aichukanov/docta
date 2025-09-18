<script setup lang="ts">
const clinicName = ref('');
const clinicAddress = ref('');
const clinicPhone = ref('');
const clinicEmail = ref('');
const clinicWebsite = ref('');
const cityIds = ref<number[]>([]);
</script>

<template>
	<div>
		<h2>Добавить клинику</h2>

		<el-input v-model="clinicName" placeholder="Название" />
		<el-input v-model="clinicAddress" placeholder="Адрес" />
		<el-input v-model="clinicPhone" placeholder="Телефон" />
		<el-input v-model="clinicEmail" placeholder="Email" />
		<el-input v-model="clinicWebsite" placeholder="Вебсайт" />

		<FilterCitySelect v-model:value="cityIds" :multiple="false" />
	</div>
</template>
