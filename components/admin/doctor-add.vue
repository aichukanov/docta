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

const props = withDefaults(
	defineProps<{
		clinics: ClinicData[];
		services?: ServiceListItem[];
	}>(),
	{
		services: () => [],
	},
);

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const doctorName = ref('');
const doctorNameRu = ref('');
const doctorNameSrCyrl = ref('');
const doctorNameEn = ref('');
const doctorProfessionalTitle = ref('');
const doctorEmail = ref('');
const doctorPhone = ref('');
const doctorWebsite = ref('');
const doctorPhotoUrl = ref('');
const doctorFacebook = ref('');
const doctorInstagram = ref('');
const doctorTelegram = ref('');
const doctorWhatsapp = ref('');
const doctorViber = ref('');

const clinicIds = ref<number[]>([]);
const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([1]);
const servicePrices = ref<DoctorServicePrice[]>([]);

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

const addServicePrice = () => {
	servicePrices.value.push({
		clinicId: 0,
		serviceId: 0,
		price: null,
		priceMax: null,
	});
};

const removeServicePrice = (index: number) => {
	servicePrices.value.splice(index, 1);
};

const clearFields = () => {
	doctorName.value = '';
	doctorNameRu.value = '';
	doctorNameSrCyrl.value = '';
	doctorNameEn.value = '';
	doctorProfessionalTitle.value = '';
	doctorEmail.value = '';
	doctorPhone.value = '';
	doctorWebsite.value = '';
	doctorPhotoUrl.value = '';
	doctorFacebook.value = '';
	doctorInstagram.value = '';
	doctorTelegram.value = '';
	doctorWhatsapp.value = '';
	doctorViber.value = '';
	clinicIds.value = [];
	specialtyIds.value = [];
	languageIds.value = [1];
	servicePrices.value = [];
};

const addDoctor = async () => {
	if (
		!doctorName.value ||
		!clinicIds.value.length ||
		!specialtyIds.value.length ||
		!languageIds.value.length
	) {
		alert('Имя, клиника, специализация и язык обязательны');
		return;
	}

	await $fetch('/api/doctors/add', {
		method: 'POST',
		body: {
			name: doctorName.value,
			name_ru: doctorNameRu.value,
			name_sr_cyrl: doctorNameSrCyrl.value,
			name_en: doctorNameEn.value,
			professionalTitle: doctorProfessionalTitle.value,
			email: doctorEmail.value,
			phone: doctorPhone.value,
			website: doctorWebsite.value,
			photoUrl: doctorPhotoUrl.value,
			facebook: doctorFacebook.value,
			instagram: doctorInstagram.value,
			telegram: doctorTelegram.value,
			whatsapp: doctorWhatsapp.value,
			viber: doctorViber.value,
			clinicIds: clinicIds.value,
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
			servicePrices: servicePrices.value,
		},
	});

	clearFields();
	emit('updated');
	alert('Врач добавлен');
};
</script>

<template>
	<div class="doctor-add">
		<AdminFieldGroup title="Имя">
			<AdminEditableField label="Имя" v-model:value="doctorName" />
			<AdminEditableField label="Имя (RU)" v-model:value="doctorNameRu" />
			<AdminEditableField
				label="Имя (SR кириллица)"
				v-model:value="doctorNameSrCyrl"
				:translate-from="doctorName"
			/>
			<AdminEditableField label="Имя (EN)" v-model:value="doctorNameEn" />
		</AdminFieldGroup>
		<AdminEditableField
			label="Профессиональное звание"
			v-model:value="doctorProfessionalTitle"
		/>
		<AdminEditableField
			label="Фото"
			type="photo"
			v-model:value="doctorPhotoUrl"
		/>
		<AdminEditableField label="Email" v-model:value="doctorEmail" />
		<AdminEditableField label="Телефон" v-model:value="doctorPhone" />
		<AdminEditableField label="Вебсайт" v-model:value="doctorWebsite" />
		<AdminEditableField label="Facebook" v-model:value="doctorFacebook" />
		<AdminEditableField label="Instagram" v-model:value="doctorInstagram" />
		<AdminEditableField label="Telegram" v-model:value="doctorTelegram" />
		<AdminEditableField label="Whatsapp" v-model:value="doctorWhatsapp" />
		<AdminEditableField label="Viber" v-model:value="doctorViber" />

		<FilterClinicSelect :clinics="clinics" v-model:value="clinicIds" />
		<FilterSpecialtySelect v-model:value="specialtyIds" />
		<FilterLanguageSelect v-model:value="languageIds" />

		<div class="service-prices-section">
			<div class="section-header">
				<h4>Услуги врача (по клиникам с ценами)</h4>
				<el-button size="small" @click="addServicePrice">+ Добавить</el-button>
			</div>

			<div
				v-for="(sp, index) in servicePrices"
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
				<el-button type="danger" size="small" @click="removeServicePrice(index)"
					>×</el-button
				>
			</div>

			<div v-if="!servicePrices.length" class="no-services">
				Нет привязанных услуг
			</div>
		</div>

		<div>
			<el-button type="primary" @click="addDoctor">Добавить врача</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.doctor-add {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.service-prices-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

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
</style>
