<script setup lang="ts">
import type { AdminBranchRow } from '~/common/insurance-company-admin';

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const slug = ref('');
const nameSr = ref('');
const nameSrCyrl = ref('');
const nameRu = ref('');
const website = ref('');
const phone = ref('');
const email = ref('');
const facebook = ref('');
const instagram = ref('');
const telegram = ref('');
const whatsapp = ref('');
const viber = ref('');
const logoUrl = ref('');
const branches = ref<AdminBranchRow[]>([]);

const clearFields = () => {
	slug.value = '';
	nameSr.value = '';
	nameSrCyrl.value = '';
	nameRu.value = '';
	website.value = '';
	phone.value = '';
	email.value = '';
	facebook.value = '';
	instagram.value = '';
	telegram.value = '';
	whatsapp.value = '';
	viber.value = '';
	logoUrl.value = '';
	branches.value = [];
};

const addCompany = async () => {
	if (!nameSr.value) {
		alert('Нужно ввести название (SR)');
		return;
	}
	if (branches.value.some((b) => b.cityId == null || !b.address_sr)) {
		alert('У каждого филиала должны быть заполнены город и адрес (SR)');
		return;
	}

	await $fetch('/api/insurance-companies/add', {
		method: 'POST',
		body: {
			slug: slug.value,
			name_sr: nameSr.value,
			name_sr_cyrl: nameSrCyrl.value,
			name_ru: nameRu.value,
			website: website.value,
			phone: phone.value,
			email: email.value,
			facebook: facebook.value,
			instagram: instagram.value,
			telegram: telegram.value,
			whatsapp: whatsapp.value,
			viber: viber.value,
			logoUrl: logoUrl.value,
			branches: branches.value,
		},
	});

	clearFields();
	emit('updated');
	alert('Страховая компания добавлена');
};
</script>

<template>
	<div>
		<div class="insurance-company-add-form">
			<AdminEditableField
				label="Логотип"
				type="photo"
				image-category="insurance-companies"
				v-model:value="logoUrl"
			/>
			<AdminFieldGroup title="Название">
				<AdminEditableField label="Название (SR)" v-model:value="nameSr" />
				<AdminEditableField
					label="Название (SR-CYRL)"
					v-model:value="nameSrCyrl"
					:translate-from="nameSr"
				/>
				<AdminEditableField label="Название (RU)" v-model:value="nameRu" />
			</AdminFieldGroup>
			<AdminSlugField v-model:value="slug" :nameSource="nameSr" />

			<AdminEditableField label="Вебсайт" v-model:value="website" />
			<AdminEditableField label="Телефон" v-model:value="phone" />
			<AdminEditableField label="Email" v-model:value="email" />
			<AdminEditableField label="Facebook" v-model:value="facebook" />
			<AdminEditableField label="Instagram" v-model:value="instagram" />
			<AdminEditableField label="Telegram" v-model:value="telegram" />
			<AdminEditableField label="Whatsapp" v-model:value="whatsapp" />
			<AdminEditableField label="Viber" v-model:value="viber" />

			<AdminInsuranceCompanyBranchesEditor v-model="branches" />
		</div>

		<el-button type="primary" @click="addCompany">
			Добавить страховую компанию
		</el-button>
	</div>
</template>

<style scoped>
.insurance-company-add-form {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);

	margin-bottom: var(--spacing-md);
}
</style>
