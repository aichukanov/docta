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

interface DoctorAdminDetails {
	id: number;
	name: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_en: string;
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

const nameModified = computed(
	() => originalDoctor.value?.name !== doctorModel.value?.name,
);

const nameRuModified = computed(
	() => originalDoctor.value?.name_ru !== doctorModel.value?.name_ru,
);

const nameSrCyrlModified = computed(
	() => originalDoctor.value?.name_sr_cyrl !== doctorModel.value?.name_sr_cyrl,
);

const nameEnModified = computed(
	() => originalDoctor.value?.name_en !== doctorModel.value?.name_en,
);

const professionalTitleModified = computed(
	() =>
		originalDoctor.value?.professionalTitle !==
		doctorModel.value?.professionalTitle,
);

const photoUrlModified = computed(
	() => originalDoctor.value?.photoUrl !== doctorModel.value?.photoUrl,
);

const emailModified = computed(
	() => originalDoctor.value?.email !== doctorModel.value?.email,
);

const phoneModified = computed(
	() => originalDoctor.value?.phone !== doctorModel.value?.phone,
);

const websiteModified = computed(
	() => originalDoctor.value?.website !== doctorModel.value?.website,
);

const facebookModified = computed(
	() => originalDoctor.value?.facebook !== doctorModel.value?.facebook,
);

const instagramModified = computed(
	() => originalDoctor.value?.instagram !== doctorModel.value?.instagram,
);

const telegramModified = computed(
	() => originalDoctor.value?.telegram !== doctorModel.value?.telegram,
);

const whatsappModified = computed(
	() => originalDoctor.value?.whatsapp !== doctorModel.value?.whatsapp,
);

const viberModified = computed(
	() => originalDoctor.value?.viber !== doctorModel.value?.viber,
);

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
				@reset="doctorModel.name_sr_cyrl = originalDoctor?.name_sr_cyrl || ''"
			/>
			<AdminEditableField
				label="Имя (EN)"
				v-model:value="doctorModel.name_en"
				:readonly="!editable"
				:modified="nameEnModified"
				@reset="doctorModel.name_en = originalDoctor?.name_en || ''"
			/>
			<AdminEditableField
				label="Профессиональное звание"
				v-model:value="doctorModel.professionalTitle"
				:readonly="!editable"
				:modified="professionalTitleModified"
				@reset="
					doctorModel.professionalTitle = originalDoctor?.professionalTitle || ''
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
					<el-button size="small" @click="addServicePrice">+ Добавить</el-button>
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
		border-color: #f59e0b;
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
		font-style: italic;
	}
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
