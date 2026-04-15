<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

interface ServiceListItem {
	id: number;
	name: string;
}

interface DoctorServicePrice {
	clinicId: number;
	serviceId: number;
	price: number | null;
	priceMax: number | null;
}

interface UserListItem {
	id: number;
	email: string;
	name: string;
}

interface DoctorAdminDetails {
	id: number;
	slug: string;
	userId: number | null;
	hidden: boolean;
	name: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_en: string;
	description_sr: string;
	description_sr_cyrl: string;
	description_ru: string;
	description_en: string;
	description_de: string;
	description_tr: string;
	specialtyIds: number[];
	languageIds: number[];
	clinicIds: number[];
	professionalTitle: string;
	photoUrl: string;
	phone: string;
	email: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
	website: string;
	servicePrices: DoctorServicePrice[];
}

const props = withDefaults(
	defineProps<{
		doctors: DoctorData[];
		clinics: ClinicData[];
		services?: ServiceListItem[];
		editable?: boolean;
	}>(),
	{
		editable: false,
		services: () => [],
	},
);

const emit = defineEmits<{
	(e: 'selected', doctorId: number): void;
	(e: 'updated'): void;
}>();

const doctorId = ref<number | null>(null);
const doctorModel = ref<DoctorAdminDetails | null>(null);
const originalDoctor = ref<DoctorAdminDetails | null>(null);
const isLoading = ref(false);

const selectedDoctor = computed(() => {
	return props.doctors.find((doctor) => doctor.id === doctorId.value);
});

const doctorOptions = computed(() => {
	return props.doctors.map((doctor) => ({
		label: doctor.name,
		value: doctor.id,
	}));
});

const clinicOptions = computed(() =>
	props.clinics.map((c) => ({
		label: c.name,
		value: c.id,
	})),
);

const serviceOptions = computed(() =>
	props.services.map((s) => ({
		label: s.name,
		value: s.id,
	})),
);

// Remote search для пользователей — не рендерим тысячи el-option разом
const userSearchResults = ref<{ label: string; value: number }[]>([]);
const isSearchingUsers = ref(false);

const formatUserOption = (u: UserListItem) => ({
	label: `id = "${u.id}" | email = "${u.email}" | name = "${u.name}"`,
	value: u.id,
});

const searchUsers = async (query: string) => {
	if (!query || query.length < 2) {
		userSearchResults.value = [];
		return;
	}
	isSearchingUsers.value = true;
	try {
		const users = await $fetch<UserListItem[]>('/api/users/list', {
			method: 'POST',
			body: { query },
		});
		userSearchResults.value = users.map(formatUserOption);
	} catch (e) {
		console.error('Failed to search users:', e);
	} finally {
		isSearchingUsers.value = false;
	}
};

// Подгрузить текущего привязанного пользователя при загрузке врача
const loadCurrentUser = async (userId: number) => {
	try {
		const users = await $fetch<UserListItem[]>('/api/users/list', {
			method: 'POST',
			body: { query: String(userId) },
		});
		if (users.length > 0) {
			userSearchResults.value = users.map(formatUserOption);
		}
	} catch (e) {
		console.error('Failed to load current user:', e);
	}
};

// Услуги врача: управление
const addServicePrice = () => {
	if (!doctorModel.value) return;
	doctorModel.value.servicePrices.push({
		clinicId: 0,
		serviceId: 0,
		price: null,
		priceMax: null,
	});
};

const removeServicePrice = (index: number) => {
	if (!doctorModel.value) return;
	doctorModel.value.servicePrices.splice(index, 1);
};

const fieldModified = (field: keyof DoctorAdminDetails) =>
	originalDoctor.value?.[field] !== doctorModel.value?.[field];

const hiddenModified = computed(() => fieldModified('hidden'));
const userIdModified = computed(() => fieldModified('userId'));

const slugModified = computed(() => fieldModified('slug'));
const nameModified = computed(() => fieldModified('name'));
const nameRuModified = computed(() => fieldModified('name_ru'));
const nameSrCyrlModified = computed(() => fieldModified('name_sr_cyrl'));
const nameEnModified = computed(() => fieldModified('name_en'));

const professionalTitleModified = computed(() =>
	fieldModified('professionalTitle'),
);
const photoUrlModified = computed(() => fieldModified('photoUrl'));
const emailModified = computed(() => fieldModified('email'));
const phoneModified = computed(() => fieldModified('phone'));
const websiteModified = computed(() => fieldModified('website'));
const facebookModified = computed(() => fieldModified('facebook'));
const instagramModified = computed(() => fieldModified('instagram'));
const telegramModified = computed(() => fieldModified('telegram'));
const whatsappModified = computed(() => fieldModified('whatsapp'));
const viberModified = computed(() => fieldModified('viber'));

const descriptionSrModified = computed(() => fieldModified('description_sr'));
const descriptionSrCyrlModified = computed(() =>
	fieldModified('description_sr_cyrl'),
);
const descriptionRuModified = computed(() => fieldModified('description_ru'));
const descriptionEnModified = computed(() => fieldModified('description_en'));
const descriptionDeModified = computed(() => fieldModified('description_de'));
const descriptionTrModified = computed(() => fieldModified('description_tr'));

const clinicIdsModified = computed(() => {
	if (!originalDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = [...originalDoctor.value.clinicIds].sort();
	const modelIds = [...doctorModel.value.clinicIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const specialtyIdsModified = computed(() => {
	if (!originalDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = [...originalDoctor.value.specialtyIds].sort();
	const modelIds = [...doctorModel.value.specialtyIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const languageIdsModified = computed(() => {
	if (!originalDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = [...originalDoctor.value.languageIds].sort();
	const modelIds = [...doctorModel.value.languageIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const servicePricesModified = computed(() => {
	if (!originalDoctor.value || !doctorModel.value) return false;
	return (
		JSON.stringify(originalDoctor.value.servicePrices) !==
		JSON.stringify(doctorModel.value.servicePrices)
	);
});

const hasChanges = computed(() => {
	return (
		hiddenModified.value ||
		userIdModified.value ||
		slugModified.value ||
		nameModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		nameEnModified.value ||
		professionalTitleModified.value ||
		photoUrlModified.value ||
		emailModified.value ||
		phoneModified.value ||
		websiteModified.value ||
		facebookModified.value ||
		instagramModified.value ||
		telegramModified.value ||
		whatsappModified.value ||
		viberModified.value ||
		descriptionSrModified.value ||
		descriptionSrCyrlModified.value ||
		descriptionRuModified.value ||
		descriptionEnModified.value ||
		descriptionDeModified.value ||
		descriptionTrModified.value ||
		clinicIdsModified.value ||
		specialtyIdsModified.value ||
		languageIdsModified.value ||
		servicePricesModified.value
	);
});

const loadDoctorDetails = async (id: number) => {
	isLoading.value = true;
	try {
		const data = await $fetch<DoctorAdminDetails | null>(
			'/api/doctors/admin-details',
			{
				method: 'POST',
				body: { doctorId: id },
			},
		);

		if (data) {
			originalDoctor.value = JSON.parse(JSON.stringify(data));
			doctorModel.value = data;
			if (data.userId) {
				loadCurrentUser(data.userId);
			} else {
				userSearchResults.value = [];
			}
		}
	} catch (e) {
		console.error('Failed to load doctor details:', e);
	} finally {
		isLoading.value = false;
	}
};

const saveChanges = async () => {
	if (!doctorModel.value || !hasChanges.value) {
		return;
	}

	if (
		!doctorModel.value.name ||
		!doctorModel.value.clinicIds.length ||
		!doctorModel.value.specialtyIds.length ||
		!doctorModel.value.languageIds.length
	) {
		alert('Имя, клиника, специализация и язык обязательны');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/doctors/update', {
		method: 'POST',
		body: doctorModel.value,
	});

	emit('updated');
	alert('Врач обновлён');

	// Перезагружаем данные
	if (doctorId.value) {
		await loadDoctorDetails(doctorId.value);
	}
};

const deleteDoctor = async () => {
	if (!doctorId.value) {
		alert('Выберите врача');
		return;
	}

	if (!confirm('Вы уверены, что хотите удалить врача?')) {
		return;
	}

	await $fetch('/api/doctors/remove', {
		method: 'POST',
		body: {
			doctorId: doctorId.value,
		},
	});

	doctorId.value = null;
	doctorModel.value = null;

	emit('updated');
	alert('Врач удален');
};

watch(doctorId, async (newDoctorId) => {
	emit('selected', newDoctorId!);
	if (newDoctorId) {
		await loadDoctorDetails(newDoctorId);
	} else {
		doctorModel.value = null;
		originalDoctor.value = null;
	}
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="doctorOptions"
			v-model:value="doctorId"
			placeholder="Выберите врача"
			placeholderSearch="Введите часть имени врача"
		/>

		<div v-if="isLoading" class="loading">Загрузка...</div>

		<div v-else-if="doctorModel" class="doctor-info">
			<div
				class="hidden-toggle"
				:class="{ modified: hiddenModified, active: doctorModel.hidden }"
			>
				<el-switch
					v-model="doctorModel.hidden"
					active-text="Профиль скрыт"
					inactive-text="Профиль виден"
					:disabled="!editable"
				/>
				<span v-if="doctorModel.hidden" class="hidden-hint">
					Врач не отображается в публичных списках, страница отдаёт 404
				</span>
			</div>

			<div class="user-link-section" :class="{ modified: userIdModified }">
				<label class="user-link-label">Привязанный пользователь</label>
				<el-select
					v-model="doctorModel.userId"
					filterable
					remote
					clearable
					:remote-method="searchUsers"
					:loading="isSearchingUsers"
					placeholder="Не привязан"
					:disabled="!editable"
					class="user-link-select"
				>
					<el-option
						v-for="user in userSearchResults"
						:key="user.value"
						:label="user.label"
						:value="user.value"
					/>
				</el-select>
			</div>

			<AdminFieldGroup title="Имя">
				<AdminEditableField
					label="Имя"
					v-model:value="doctorModel.name"
					:modified="nameModified"
					@reset="doctorModel.name = originalDoctor?.name || ''"
				/>
				<AdminEditableField
					label="Имя (RU)"
					v-model:value="doctorModel.name_ru"
					:modified="nameRuModified"
					@reset="doctorModel.name_ru = originalDoctor?.name_ru || ''"
				/>
				<AdminEditableField
					label="Имя (SR кириллица)"
					v-model:value="doctorModel.name_sr_cyrl"
					:modified="nameSrCyrlModified"
					:translate-from="doctorModel.name"
					@reset="doctorModel.name_sr_cyrl = originalDoctor?.name_sr_cyrl || ''"
				/>
				<AdminEditableField
					label="Имя (EN)"
					v-model:value="doctorModel.name_en"
					:readonly="!editable"
					:modified="nameEnModified"
					@reset="doctorModel.name_en = originalDoctor?.name_en || ''"
				/>
			</AdminFieldGroup>
			<AdminSlugField
				v-model:value="doctorModel.slug"
				:nameSource="doctorModel.name"
				:modified="slugModified"
				@reset="doctorModel.slug = originalDoctor?.slug || ''"
			/>
			<AdminEditableField
				label="Профессиональное звание"
				v-model:value="doctorModel.professionalTitle"
				:readonly="!editable"
				:modified="professionalTitleModified"
				@reset="
					doctorModel.professionalTitle =
						originalDoctor?.professionalTitle || ''
				"
			/>
			<AdminEditableField
				label="Фото"
				v-model:value="doctorModel.photoUrl"
				type="photo"
				:modified="photoUrlModified"
				@reset="doctorModel.photoUrl = originalDoctor?.photoUrl || ''"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="doctorModel.email"
				:readonly="!editable"
				:modified="emailModified"
				@reset="doctorModel.email = originalDoctor?.email || ''"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="doctorModel.phone"
				:readonly="!editable"
				:modified="phoneModified"
				@reset="doctorModel.phone = originalDoctor?.phone || ''"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="doctorModel.website"
				:readonly="!editable"
				:modified="websiteModified"
				@reset="doctorModel.website = originalDoctor?.website || ''"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="doctorModel.facebook"
				:readonly="!editable"
				:modified="facebookModified"
				@reset="doctorModel.facebook = originalDoctor?.facebook || ''"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="doctorModel.instagram"
				:readonly="!editable"
				:modified="instagramModified"
				@reset="doctorModel.instagram = originalDoctor?.instagram || ''"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="doctorModel.telegram"
				:readonly="!editable"
				:modified="telegramModified"
				@reset="doctorModel.telegram = originalDoctor?.telegram || ''"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="doctorModel.whatsapp"
				:readonly="!editable"
				:modified="whatsappModified"
				@reset="doctorModel.whatsapp = originalDoctor?.whatsapp || ''"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="doctorModel.viber"
				:readonly="!editable"
				:modified="viberModified"
				@reset="doctorModel.viber = originalDoctor?.viber || ''"
			/>

			<AdminFieldGroup title="Описание">
				<AdminEditableField
					label="Описание (SR)"
					type="textarea"
					v-model:value="doctorModel.description_sr"
					:readonly="!editable"
					:modified="descriptionSrModified"
					@reset="
						doctorModel.description_sr = originalDoctor?.description_sr || ''
					"
				/>
				<AdminEditableField
					label="Описание (SR-CYRL)"
					type="textarea"
					v-model:value="doctorModel.description_sr_cyrl"
					:readonly="!editable"
					:modified="descriptionSrCyrlModified"
					:translate-from="doctorModel.description_sr"
					@reset="
						doctorModel.description_sr_cyrl =
							originalDoctor?.description_sr_cyrl || ''
					"
				/>
				<AdminEditableField
					label="Описание (EN)"
					type="textarea"
					v-model:value="doctorModel.description_en"
					:readonly="!editable"
					:modified="descriptionEnModified"
					@reset="
						doctorModel.description_en = originalDoctor?.description_en || ''
					"
				/>
				<AdminEditableField
					label="Описание (RU)"
					type="textarea"
					v-model:value="doctorModel.description_ru"
					:readonly="!editable"
					:modified="descriptionRuModified"
					@reset="
						doctorModel.description_ru = originalDoctor?.description_ru || ''
					"
				/>
				<AdminEditableField
					label="Описание (DE)"
					type="textarea"
					v-model:value="doctorModel.description_de"
					:readonly="!editable"
					:modified="descriptionDeModified"
					@reset="
						doctorModel.description_de = originalDoctor?.description_de || ''
					"
				/>
				<AdminEditableField
					label="Описание (TR)"
					type="textarea"
					v-model:value="doctorModel.description_tr"
					:readonly="!editable"
					:modified="descriptionTrModified"
					@reset="
						doctorModel.description_tr = originalDoctor?.description_tr || ''
					"
				/>
			</AdminFieldGroup>

			<FilterClinicSelect
				:clinics="clinics"
				v-model:value="doctorModel.clinicIds"
			/>

			<FilterSpecialtySelect v-model:value="doctorModel.specialtyIds" />

			<FilterLanguageSelect v-model:value="doctorModel.languageIds" />

			<div
				class="service-prices-section"
				:class="{ modified: servicePricesModified }"
			>
				<div class="section-header">
					<h4>Услуги врача (по клиникам с ценами)</h4>
					<el-button size="small" @click="addServicePrice"
						>+ Добавить</el-button
					>
				</div>

				<div
					v-for="(sp, index) in doctorModel.servicePrices"
					:key="index"
					class="service-price-row"
				>
					<el-select
						v-model="sp.clinicId"
						filterable
						placeholder="Клиника"
						class="clinic-select"
					>
						<el-option
							v-for="clinic in clinicOptions"
							:key="clinic.value"
							:label="clinic.label"
							:value="clinic.value"
						/>
					</el-select>
					<el-select
						v-model="sp.serviceId"
						filterable
						placeholder="Услуга"
						class="service-select"
					>
						<el-option
							v-for="service in serviceOptions"
							:key="service.value"
							:label="service.label"
							:value="service.value"
						/>
					</el-select>
					<el-input
						v-model="sp.price"
						placeholder="Цена"
						type="number"
						class="price-input"
					/>
					<el-input
						v-model="sp.priceMax"
						placeholder="Макс. цена"
						type="number"
						class="price-input"
					/>
					<el-button
						type="danger"
						size="small"
						@click="removeServicePrice(index)"
						>×</el-button
					>
				</div>

				<div v-if="!doctorModel.servicePrices.length" class="no-services">
					Нет привязанных услуг
				</div>
			</div>

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteDoctor"> Удалить </el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.doctor-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-primary);
	padding-top: var(--spacing-lg);
}

.loading {
	padding: var(--spacing-lg);
	color: var(--color-text-secondary);
}

.service-prices-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: var(--color-warning);
	}

	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;

		h4 {
			margin: 0;
			color: var(--color-text-primary);
		}
	}

	.service-price-row {
		display: flex;
		gap: var(--spacing-sm);
		align-items: center;

		.clinic-select {
			flex: 1.5;
		}

		.service-select {
			flex: 2;
		}

		.price-input {
			flex: 1;
			max-width: 120px;
		}
	}

	.no-services {
		color: var(--color-text-secondary);
	}
}

.hidden-toggle {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-md);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);
	background: var(--color-surface-secondary);

	&.modified {
		border-color: var(--color-warning);
	}

	&.active {
		background: var(--color-danger-bg);
		border-color: var(--color-danger-border);
	}

	.hidden-hint {
		font-size: 0.85em;
		color: var(--color-danger);
	}
}

.user-link-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: var(--color-warning);
	}

	.user-link-label {
		font-weight: 500;
		color: var(--color-text-primary);
		font-size: 0.9em;
	}

	.user-link-select {
		width: 100%;
	}
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
