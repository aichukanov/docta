<script setup lang="ts">
import type { AdminBranchRow } from '~/common/insurance-company-admin';
import type { InsuranceCompanyAdminData } from '~/server/api/insurance-companies/admin-details';

interface InsuranceCompanyModel {
	id: number;
	slug: string;
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	website: string;
	phone: string;
	email: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
	logoUrl: string;
	branches: AdminBranchRow[];
}

const props = withDefaults(
	defineProps<{
		companies: { id: number; name: string }[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const companyId = ref<number | null>(null);
const companyModel = ref<InsuranceCompanyModel | null>(null);
const originalCompany = ref<InsuranceCompanyModel | null>(null);

const companyOptions = computed(() =>
	props.companies.map((company) => ({
		label: company.name,
		value: company.id,
	})),
);

const toModel = (
	data: InsuranceCompanyAdminData,
): InsuranceCompanyModel => ({
	id: data.id,
	slug: data.slug,
	name_sr: data.name_sr,
	name_sr_cyrl: data.name_sr_cyrl,
	name_ru: data.name_ru,
	website: data.website,
	phone: data.phone,
	email: data.email,
	facebook: data.facebook,
	instagram: data.instagram,
	telegram: data.telegram,
	whatsapp: data.whatsapp,
	viber: data.viber,
	logoUrl: data.logoUrl,
	branches: data.branches.map((branch) => ({
		id: branch.id,
		cityId: branch.cityId,
		address_sr: branch.address_sr,
		address_sr_cyrl: branch.address_sr_cyrl,
		town_sr: branch.town_sr,
		town_sr_cyrl: branch.town_sr_cyrl,
		postalCode: branch.postalCode,
		latitude: String(branch.latitude),
		longitude: String(branch.longitude),
		phone: branch.phone,
		email: branch.email,
		workingHours: branch.workingHours,
	})),
});

watch(companyId, async (id) => {
	if (id == null) {
		companyModel.value = null;
		originalCompany.value = null;
		return;
	}

	const data = await $fetch('/api/insurance-companies/admin-details', {
		method: 'POST',
		body: { companyId: id },
	});

	if (data) {
		companyModel.value = toModel(data);
		originalCompany.value = toModel(data);
	}
});

const fieldModified = (field: keyof InsuranceCompanyModel) =>
	JSON.stringify(originalCompany.value?.[field]) !==
	JSON.stringify(companyModel.value?.[field]);

const slugModified = computed(() => fieldModified('slug'));
const nameSrModified = computed(() => fieldModified('name_sr'));
const nameSrCyrlModified = computed(() => fieldModified('name_sr_cyrl'));
const nameRuModified = computed(() => fieldModified('name_ru'));
const websiteModified = computed(() => fieldModified('website'));
const phoneModified = computed(() => fieldModified('phone'));
const emailModified = computed(() => fieldModified('email'));
const facebookModified = computed(() => fieldModified('facebook'));
const instagramModified = computed(() => fieldModified('instagram'));
const telegramModified = computed(() => fieldModified('telegram'));
const whatsappModified = computed(() => fieldModified('whatsapp'));
const viberModified = computed(() => fieldModified('viber'));
const logoUrlModified = computed(() => fieldModified('logoUrl'));
const branchesModified = computed(() => fieldModified('branches'));

const hasChanges = computed(
	() =>
		slugModified.value ||
		nameSrModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		websiteModified.value ||
		phoneModified.value ||
		emailModified.value ||
		facebookModified.value ||
		instagramModified.value ||
		telegramModified.value ||
		whatsappModified.value ||
		viberModified.value ||
		logoUrlModified.value ||
		branchesModified.value,
);

const saveChanges = async () => {
	if (!companyModel.value || !hasChanges.value) return;

	if (!companyModel.value.name_sr) {
		alert('Название (SR) обязательно');
		return;
	}
	if (
		companyModel.value.branches.some((b) => b.cityId == null || !b.address_sr)
	) {
		alert('У каждого филиала должны быть заполнены город и адрес (SR)');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/insurance-companies/update', {
		method: 'POST',
		body: {
			id: companyModel.value.id,
			slug: companyModel.value.slug,
			name_sr: companyModel.value.name_sr,
			name_sr_cyrl: companyModel.value.name_sr_cyrl,
			name_ru: companyModel.value.name_ru,
			website: companyModel.value.website,
			phone: companyModel.value.phone,
			email: companyModel.value.email,
			facebook: companyModel.value.facebook,
			instagram: companyModel.value.instagram,
			telegram: companyModel.value.telegram,
			whatsapp: companyModel.value.whatsapp,
			viber: companyModel.value.viber,
			logoUrl: companyModel.value.logoUrl,
			branches: companyModel.value.branches,
		},
	});

	emit('updated');
};

const deleteCompany = async () => {
	if (!companyId.value) {
		alert('Выберите страховую компанию');
		return;
	}
	if (!confirm('Вы уверены, что хотите удалить страховую компанию?')) {
		return;
	}

	await $fetch('/api/insurance-companies/remove', {
		method: 'POST',
		body: { companyId: companyId.value },
	});

	companyId.value = null;
	companyModel.value = null;

	emit('updated');
	alert('Страховая компания удалена');
};
</script>

<template>
	<div>
		<FilterableSelect
			:items="companyOptions"
			v-model:value="companyId"
			placeholder="Выберите страховую компанию"
			placeholderSearch="Введите часть названия"
		/>

		<div v-if="companyModel" class="insurance-company-info">
			<AdminEditableField
				label="Логотип"
				type="photo"
				image-category="insurance-companies"
				v-model:value="companyModel.logoUrl"
				:readonly="!editable"
				:modified="logoUrlModified"
				@reset="companyModel.logoUrl = originalCompany?.logoUrl || ''"
			/>
			<AdminFieldGroup title="Название">
				<AdminEditableField
					label="Название (SR)"
					v-model:value="companyModel.name_sr"
					:readonly="!editable"
					:modified="nameSrModified"
					@reset="companyModel.name_sr = originalCompany?.name_sr || ''"
				/>
				<AdminEditableField
					label="Название (SR-CYRL)"
					v-model:value="companyModel.name_sr_cyrl"
					:readonly="!editable"
					:modified="nameSrCyrlModified"
					:translate-from="companyModel.name_sr"
					@reset="
						companyModel.name_sr_cyrl = originalCompany?.name_sr_cyrl || ''
					"
				/>
				<AdminEditableField
					label="Название (RU)"
					v-model:value="companyModel.name_ru"
					:readonly="!editable"
					:modified="nameRuModified"
					@reset="companyModel.name_ru = originalCompany?.name_ru || ''"
				/>
			</AdminFieldGroup>
			<AdminSlugField
				v-model:value="companyModel.slug"
				:nameSource="companyModel.name_sr"
				:modified="slugModified"
				@reset="companyModel.slug = originalCompany?.slug || ''"
			/>

			<AdminEditableField
				label="Вебсайт"
				v-model:value="companyModel.website"
				:readonly="!editable"
				:modified="websiteModified"
				@reset="companyModel.website = originalCompany?.website || ''"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="companyModel.phone"
				:readonly="!editable"
				:modified="phoneModified"
				@reset="companyModel.phone = originalCompany?.phone || ''"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="companyModel.email"
				:readonly="!editable"
				:modified="emailModified"
				@reset="companyModel.email = originalCompany?.email || ''"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="companyModel.facebook"
				:readonly="!editable"
				:modified="facebookModified"
				@reset="companyModel.facebook = originalCompany?.facebook || ''"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="companyModel.instagram"
				:readonly="!editable"
				:modified="instagramModified"
				@reset="companyModel.instagram = originalCompany?.instagram || ''"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="companyModel.telegram"
				:readonly="!editable"
				:modified="telegramModified"
				@reset="companyModel.telegram = originalCompany?.telegram || ''"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="companyModel.whatsapp"
				:readonly="!editable"
				:modified="whatsappModified"
				@reset="companyModel.whatsapp = originalCompany?.whatsapp || ''"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="companyModel.viber"
				:readonly="!editable"
				:modified="viberModified"
				@reset="companyModel.viber = originalCompany?.viber || ''"
			/>

			<AdminInsuranceCompanyBranchesEditor
				v-model="companyModel.branches"
				:class="{ modified: branchesModified }"
			/>

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteCompany">Удалить</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.insurance-company-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid black;
	padding-top: var(--spacing-lg);
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}

:deep(.modified) {
	border-color: var(--color-warning);
}
</style>
