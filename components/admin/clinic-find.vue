<script setup lang="ts">
import { CityId } from '~/enums/cities';
import type { ClinicData } from '~/interfaces/clinic';

interface ClinicAdminModel extends ClinicData {
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	address_sr: string;
	address_sr_cyrl: string;
	town_sr: string;
	town_sr_cyrl: string;
	description_sr: string;
	description_sr_cyrl: string;
	description_en: string;
	description_ru: string;
	description_de: string;
	description_tr: string;
	languageIds: number[];
}

interface BillingService {
	id: number;
	name: string;
}

interface BillingPurchase {
	id: number;
	clinicId: number;
	price: number;
	purchasedAt: string;
	validUntil: string;
	serviceIds: number[];
	deleted: boolean;
}

const props = withDefaults(
	defineProps<{
		clinics: ClinicData[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const clinicId = ref<number | null>(null);
const clinicModel = ref<ClinicAdminModel | null>(null);
const cityIds = ref<CityId[]>([]);
const billingServices = ref<BillingService[]>([]);
const billingPurchases = ref<BillingPurchase[]>([]);
const isBillingLoading = ref(false);
const billingPurchaseModel = ref({
	serviceIds: [] as number[],
	price: '',
	purchasedAt: '',
	validUntil: '',
});
const showOnlyActiveBilling = ref(true);

const selectedClinic = computed(() => {
	return props.clinics.find((clinic) => clinic.id === clinicId.value);
});

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
		value: clinic.id,
	}));
});

const billingServiceOptions = computed(() =>
	billingServices.value.map((service) => ({
		label: service.name,
		value: service.id,
	})),
);

const billingServiceMap = computed(
	() =>
		new Map(billingServices.value.map((service) => [service.id, service.name])),
);

const formatDate = (value: string) => {
	if (!value) return '';
	const date = new Date(value);
	if (Number.isNaN(date.getTime())) return value;
	return date.toLocaleDateString('ru-RU');
};

const isExpired = (value: string) => {
	if (!value) return false;
	const date = new Date(value);
	if (Number.isNaN(date.getTime())) return false;
	return date.getTime() < Date.now();
};

const formatServices = (serviceIds: number[]) =>
	serviceIds
		.map((serviceId) => billingServiceMap.value.get(serviceId))
		.filter(Boolean)
		.join(', ');

const filteredBillingPurchases = computed(() => {
	if (!showOnlyActiveBilling.value) {
		return billingPurchases.value;
	}

	return billingPurchases.value.filter(
		(purchase) => !purchase.deleted && !isExpired(purchase.validUntil),
	);
});

const loadBillingServices = async () => {
	try {
		const data = await $fetch<{ services: BillingService[] }>(
			'/api/billing/services/list',
			{
				method: 'POST',
				body: {},
			},
		);
		billingServices.value = data?.services || [];
	} catch (error) {
		console.error('Failed to load billing services:', error);
	}
};

const loadBillingPurchases = async () => {
	if (!clinicId.value) {
		billingPurchases.value = [];
		return;
	}
	isBillingLoading.value = true;
	try {
		const data = await $fetch<{ purchases: BillingPurchase[] }>(
			'/api/billing/clinic-purchases/list',
			{
				method: 'POST',
				body: { clinicId: clinicId.value },
			},
		);
		billingPurchases.value = data?.purchases || [];
	} catch (error) {
		console.error('Failed to load billing purchases:', error);
	} finally {
		isBillingLoading.value = false;
	}
};

const resetBillingPurchase = () => {
	billingPurchaseModel.value = {
		serviceIds: [],
		price: '',
		purchasedAt: '',
		validUntil: '',
	};
};

const addBillingPurchase = async () => {
	if (!clinicId.value) {
		alert('Выберите клинику');
		return;
	}
	if (
		billingPurchaseModel.value.serviceIds.length === 0 ||
		!billingPurchaseModel.value.price ||
		!billingPurchaseModel.value.purchasedAt ||
		!billingPurchaseModel.value.validUntil
	) {
		alert('Выберите услуги, цену и даты действия пакета');
		return;
	}

	await $fetch('/api/billing/clinic-purchases/add', {
		method: 'POST',
		body: {
			clinicId: clinicId.value,
			serviceIds: billingPurchaseModel.value.serviceIds,
			price: billingPurchaseModel.value.price,
			purchasedAt: billingPurchaseModel.value.purchasedAt,
			validUntil: billingPurchaseModel.value.validUntil,
		},
	});

	resetBillingPurchase();
	await loadBillingPurchases();
	alert('Покупка добавлена');
};

const deleteBillingPurchase = async (purchaseId: number) => {
	if (!confirm('Пометить покупку как удаленную?')) {
		return;
	}

	await $fetch('/api/billing/clinic-purchases/delete', {
		method: 'POST',
		body: {
			purchaseId,
		},
	});

	await loadBillingPurchases();
	alert('Покупка помечена как удаленная');
};

const restoreBillingPurchase = async (purchaseId: number) => {
	if (!confirm('Восстановить покупку?')) {
		return;
	}

	await $fetch('/api/billing/clinic-purchases/restore', {
		method: 'POST',
		body: {
			purchaseId,
		},
	});

	await loadBillingPurchases();
	alert('Покупка восстановлена');
};

watch(cityIds, (newCityIds) => {
	if (clinicModel.value && newCityIds.length > 0) {
		clinicModel.value.cityId = newCityIds[0];
	}
});

const nameSrModified = computed(
	() => selectedClinic.value?.name_sr !== clinicModel.value?.name_sr,
);

const nameSrCyrlModified = computed(
	() => selectedClinic.value?.name_sr_cyrl !== clinicModel.value?.name_sr_cyrl,
);

const nameRuModified = computed(
	() => selectedClinic.value?.name_ru !== clinicModel.value?.name_ru,
);

const addressSrModified = computed(
	() => selectedClinic.value?.address_sr !== clinicModel.value?.address_sr,
);

const addressSrCyrlModified = computed(
	() =>
		selectedClinic.value?.address_sr_cyrl !==
		clinicModel.value?.address_sr_cyrl,
);

const townSrModified = computed(
	() => selectedClinic.value?.town_sr !== clinicModel.value?.town_sr,
);

const townSrCyrlModified = computed(
	() => selectedClinic.value?.town_sr_cyrl !== clinicModel.value?.town_sr_cyrl,
);

const postalCodeModified = computed(
	() => selectedClinic.value?.postalCode !== clinicModel.value?.postalCode,
);

const latitudeModified = computed(
	() => selectedClinic.value?.latitude !== clinicModel.value?.latitude,
);

const longitudeModified = computed(
	() => selectedClinic.value?.longitude !== clinicModel.value?.longitude,
);

const phoneModified = computed(
	() => selectedClinic.value?.phone !== clinicModel.value?.phone,
);

const emailModified = computed(
	() => selectedClinic.value?.email !== clinicModel.value?.email,
);

const websiteModified = computed(
	() => selectedClinic.value?.website !== clinicModel.value?.website,
);

const facebookModified = computed(
	() => selectedClinic.value?.facebook !== clinicModel.value?.facebook,
);

const instagramModified = computed(
	() => selectedClinic.value?.instagram !== clinicModel.value?.instagram,
);

const telegramModified = computed(
	() => selectedClinic.value?.telegram !== clinicModel.value?.telegram,
);

const whatsappModified = computed(
	() => selectedClinic.value?.whatsapp !== clinicModel.value?.whatsapp,
);

const viberModified = computed(
	() => selectedClinic.value?.viber !== clinicModel.value?.viber,
);

const cityIdModified = computed(
	() => selectedClinic.value?.cityId !== clinicModel.value?.cityId,
);

const descriptionSrModified = computed(
	() =>
		selectedClinic.value?.description_sr !== clinicModel.value?.description_sr,
);

const descriptionEnModified = computed(
	() =>
		selectedClinic.value?.description_en !== clinicModel.value?.description_en,
);

const descriptionRuModified = computed(
	() =>
		selectedClinic.value?.description_ru !== clinicModel.value?.description_ru,
);

const descriptionDeModified = computed(
	() =>
		selectedClinic.value?.description_de !== clinicModel.value?.description_de,
);

const descriptionTrModified = computed(
	() =>
		selectedClinic.value?.description_tr !== clinicModel.value?.description_tr,
);

const descriptionSrCyrlModified = computed(
	() =>
		selectedClinic.value?.description_sr_cyrl !==
		clinicModel.value?.description_sr_cyrl,
);

const languageIdsModified = computed(() => {
	if (!selectedClinic.value || !clinicModel.value) {
		return false;
	}
	const originalIds = selectedClinic.value.languageIds
		.split(',')
		.map(Number)
		.sort();
	const modelIds = [...clinicModel.value.languageIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const hasChanges = computed(() => {
	return (
		nameSrModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		addressSrModified.value ||
		addressSrCyrlModified.value ||
		townSrModified.value ||
		townSrCyrlModified.value ||
		postalCodeModified.value ||
		latitudeModified.value ||
		longitudeModified.value ||
		phoneModified.value ||
		emailModified.value ||
		websiteModified.value ||
		facebookModified.value ||
		instagramModified.value ||
		telegramModified.value ||
		whatsappModified.value ||
		viberModified.value ||
		cityIdModified.value ||
		descriptionSrModified.value ||
		descriptionSrCyrlModified.value ||
		descriptionEnModified.value ||
		descriptionRuModified.value ||
		descriptionDeModified.value ||
		descriptionTrModified.value ||
		languageIdsModified.value
	);
});

const saveChanges = async () => {
	if (!clinicModel.value || !hasChanges.value) {
		return;
	}

	if (
		!clinicModel.value.name_sr ||
		!clinicModel.value.address_sr ||
		!clinicModel.value.languageIds.length
	) {
		alert('Название (SR), адрес (SR) и язык обязательны');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/clinics/update', {
		method: 'POST',
		body: {
			id: clinicModel.value.id,
			name_sr: clinicModel.value.name_sr,
			name_sr_cyrl: clinicModel.value.name_sr_cyrl,
			name_ru: clinicModel.value.name_ru,
			cityId: clinicModel.value.cityId,
			address_sr: clinicModel.value.address_sr,
			address_sr_cyrl: clinicModel.value.address_sr_cyrl,
			town_sr: clinicModel.value.town_sr,
			town_sr_cyrl: clinicModel.value.town_sr_cyrl,
			postalCode: clinicModel.value.postalCode,
			latitude: clinicModel.value.latitude,
			longitude: clinicModel.value.longitude,
			phone: clinicModel.value.phone,
			email: clinicModel.value.email,
			website: clinicModel.value.website,
			facebook: clinicModel.value.facebook,
			instagram: clinicModel.value.instagram,
			telegram: clinicModel.value.telegram,
			whatsapp: clinicModel.value.whatsapp,
			viber: clinicModel.value.viber,
			description_sr: clinicModel.value.description_sr,
			description_sr_cyrl: clinicModel.value.description_sr_cyrl,
			description_en: clinicModel.value.description_en,
			description_ru: clinicModel.value.description_ru,
			description_de: clinicModel.value.description_de,
			description_tr: clinicModel.value.description_tr,
			languageIds: clinicModel.value.languageIds,
		},
	});

	emit('updated');
};

const deleteClinic = async () => {
	if (!clinicId.value) {
		alert('Выберите клинику');
		return;
	}

	if (!confirm('Вы уверены, что хотите удалить клинику?')) {
		return;
	}

	await $fetch('/api/clinics/remove', {
		method: 'POST',
		body: {
			clinicId: clinicId.value,
		},
	});

	clinicId.value = null;
	clinicModel.value = null;

	emit('updated');
	alert('Клиника удалена');
};

watch(selectedClinic, async (clinic) => {
	if (clinic) {
		await loadBillingPurchases();
		// Получаем полные данные клиники из админского API
		const adminData = await $fetch('/api/clinics/admin-details', {
			method: 'POST',
			body: {
				clinicId: clinic.id,
			},
		});

		if (adminData) {
			clinicModel.value = {
				...clinic,
				name_sr: adminData.name_sr || '',
				name_sr_cyrl: adminData.name_sr_cyrl || '',
				name_ru: adminData.name_ru || '',
				address_sr: adminData.address_sr || '',
				address_sr_cyrl: adminData.address_sr_cyrl || '',
				town_sr: adminData.town_sr || '',
				town_sr_cyrl: adminData.town_sr_cyrl || '',
				description_sr: adminData.description_sr || '',
				description_sr_cyrl: adminData.description_sr_cyrl || '',
				description_en: adminData.description_en || '',
				description_ru: adminData.description_ru || '',
				description_de: adminData.description_de || '',
				description_tr: adminData.description_tr || '',
				postalCode: adminData.postalCode || '',
				languageIds: adminData.languageIds,
			};
			cityIds.value = [adminData.cityId];
		} else {
			// Fallback на данные из списка, если админский API недоступен
			clinicModel.value = {
				...clinic,
				name_sr: clinic.name || '',
				name_sr_cyrl: '',
				name_ru: '',
				address_sr: clinic.address || '',
				address_sr_cyrl: '',
				town_sr: clinic.town || '',
				town_sr_cyrl: '',
				description_sr: clinic.description || '',
				description_sr_cyrl: '',
				description_en: '',
				description_ru: '',
				description_de: '',
				description_tr: '',
				postalCode: clinic.postalCode || '',
				languageIds: clinic.languageIds.split(',').map(Number),
			};
			cityIds.value = [clinic.cityId];
		}
	}
});

onMounted(async () => {
	await loadBillingServices();
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="clinicOptions"
			v-model:value="clinicId"
			placeholder="Выберите клинику"
			placeholderSearch="Введите часть названия клиники"
		/>

		<div v-if="clinicModel" class="clinic-info">
			<AdminEditableField
				label="Название (SR)"
				v-model:value="clinicModel.name_sr"
				:modified="nameSrModified"
				@reset="
					clinicModel.name_sr =
						selectedClinic?.name_sr || selectedClinic?.name || ''
				"
			/>
			<AdminEditableField
				label="Название (SR-CYRL)"
				v-model:value="clinicModel.name_sr_cyrl"
				:readonly="!editable"
				:modified="nameSrCyrlModified"
				:translate-from="clinicModel.name_sr"
				@reset="clinicModel.name_sr_cyrl = selectedClinic?.name_sr_cyrl || ''"
			/>
			<AdminEditableField
				label="Название (RU)"
				v-model:value="clinicModel.name_ru"
				:readonly="!editable"
				:modified="nameRuModified"
				@reset="clinicModel.name_ru = selectedClinic?.name_ru || ''"
			/>
			<AdminEditableField
				label="Адрес (SR)"
				v-model:value="clinicModel.address_sr"
				:readonly="!editable"
				:modified="addressSrModified"
				@reset="
					clinicModel.address_sr =
						selectedClinic?.address_sr || selectedClinic?.address || ''
				"
			/>
			<AdminEditableField
				label="Адрес (SR-CYRL)"
				v-model:value="clinicModel.address_sr_cyrl"
				:readonly="!editable"
				:modified="addressSrCyrlModified"
				:translate-from="clinicModel.address_sr"
				@reset="
					clinicModel.address_sr_cyrl = selectedClinic?.address_sr_cyrl || ''
				"
			/>
			<AdminEditableField
				label="Town (SR)"
				v-model:value="clinicModel.town_sr"
				:readonly="!editable"
				:modified="townSrModified"
				@reset="
					clinicModel.town_sr =
						selectedClinic?.town_sr || selectedClinic?.town || ''
				"
			/>
			<AdminEditableField
				label="Town (SR-CYRL)"
				v-model:value="clinicModel.town_sr_cyrl"
				:readonly="!editable"
				:modified="townSrCyrlModified"
				:translate-from="clinicModel.town_sr"
				@reset="clinicModel.town_sr_cyrl = selectedClinic?.town_sr_cyrl || ''"
			/>
			<AdminEditableField
				label="Postal code"
				v-model:value="clinicModel.postalCode"
				:readonly="!editable"
				:modified="postalCodeModified"
				@reset="clinicModel.postalCode = selectedClinic?.postalCode || ''"
			/>
			<AdminEditableField
				label="Широта"
				v-model:value="clinicModel.latitude"
				:readonly="!editable"
				:modified="latitudeModified"
				@reset="clinicModel.latitude = selectedClinic?.latitude"
			/>
			<AdminEditableField
				label="Долгота"
				v-model:value="clinicModel.longitude"
				:readonly="!editable"
				:modified="longitudeModified"
				@reset="clinicModel.longitude = selectedClinic?.longitude"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="clinicModel.phone"
				:readonly="!editable"
				:modified="phoneModified"
				@reset="clinicModel.phone = selectedClinic?.phone"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="clinicModel.email"
				:readonly="!editable"
				:modified="emailModified"
				@reset="clinicModel.email = selectedClinic?.email"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="clinicModel.website"
				:readonly="!editable"
				:modified="websiteModified"
				@reset="clinicModel.website = selectedClinic?.website"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="clinicModel.facebook"
				:readonly="!editable"
				:modified="facebookModified"
				@reset="clinicModel.facebook = selectedClinic?.facebook"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="clinicModel.instagram"
				:readonly="!editable"
				:modified="instagramModified"
				@reset="clinicModel.instagram = selectedClinic?.instagram"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="clinicModel.telegram"
				:readonly="!editable"
				:modified="telegramModified"
				@reset="clinicModel.telegram = selectedClinic?.telegram"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="clinicModel.whatsapp"
				:readonly="!editable"
				:modified="whatsappModified"
				@reset="clinicModel.whatsapp = selectedClinic?.whatsapp"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="clinicModel.viber"
				:readonly="!editable"
				:modified="viberModified"
				@reset="clinicModel.viber = selectedClinic?.viber"
			/>

			<AdminEditableField
				label="Описание (SR)"
				type="textarea"
				v-model:value="clinicModel.description_sr"
				:readonly="!editable"
				:modified="descriptionSrModified"
				@reset="clinicModel.description_sr = selectedClinic?.description_sr"
			/>
			<AdminEditableField
				label="Описание (SR-CYRL)"
				type="textarea"
				v-model:value="clinicModel.description_sr_cyrl"
				:readonly="!editable"
				:modified="descriptionSrCyrlModified"
				:translate-from="clinicModel.description_sr"
				@reset="
					clinicModel.description_sr_cyrl = selectedClinic?.description_sr_cyrl
				"
			/>
			<AdminEditableField
				label="Описание (EN)"
				type="textarea"
				v-model:value="clinicModel.description_en"
				:readonly="!editable"
				:modified="descriptionEnModified"
				@reset="clinicModel.description_en = selectedClinic?.description_en"
			/>
			<AdminEditableField
				label="Описание (RU)"
				type="textarea"
				v-model:value="clinicModel.description_ru"
				:readonly="!editable"
				:modified="descriptionRuModified"
				@reset="clinicModel.description_ru = selectedClinic?.description_ru"
			/>
			<AdminEditableField
				label="Описание (DE)"
				type="textarea"
				v-model:value="clinicModel.description_de"
				:readonly="!editable"
				:modified="descriptionDeModified"
				@reset="clinicModel.description_de = selectedClinic?.description_de"
			/>
			<AdminEditableField
				label="Описание (TR)"
				type="textarea"
				v-model:value="clinicModel.description_tr"
				:readonly="!editable"
				:modified="descriptionTrModified"
				@reset="clinicModel.description_tr = selectedClinic?.description_tr"
			/>

			<FilterCitySelect v-model:value="cityIds" />

			<FilterLanguageSelect v-model:value="clinicModel.languageIds" />

			<div class="billing-section">
				<div class="section-header">
					<h4>Платные услуги (пакеты)</h4>
				</div>

				<div class="billing-form">
					<el-select
						v-model="billingPurchaseModel.serviceIds"
						filterable
						multiple
						placeholder="Выберите услуги"
						class="billing-select"
					>
						<el-option
							v-for="service in billingServiceOptions"
							:key="service.value"
							:label="service.label"
							:value="service.value"
						/>
					</el-select>
					<el-input
						v-model="billingPurchaseModel.price"
						placeholder="Цена (EUR)"
						type="number"
						class="billing-input"
					/>
					<el-input
						v-model="billingPurchaseModel.purchasedAt"
						placeholder="Дата покупки"
						type="date"
						class="billing-input"
					/>
					<el-input
						v-model="billingPurchaseModel.validUntil"
						placeholder="Дата окончания"
						type="date"
						class="billing-input"
					/>
					<el-button type="primary" @click="addBillingPurchase">
						Добавить покупку
					</el-button>
				</div>

				<div v-if="isBillingLoading" class="billing-loading">Загрузка...</div>
				<div class="billing-filter">
					<el-checkbox v-model="showOnlyActiveBilling">
						Только активные услуги
					</el-checkbox>
				</div>

				<div v-if="isBillingLoading" class="billing-loading">Загрузка...</div>
				<div v-else class="billing-list">
					<div
						v-for="purchase in filteredBillingPurchases"
						:key="purchase.id"
						class="billing-item"
						:class="{
							deleted: purchase.deleted,
							expired: !purchase.deleted && isExpired(purchase.validUntil),
						}"
					>
						<div class="billing-item-title">
							<span>Пакет #{{ purchase.id }}</span>
							<span class="billing-item-price">{{ purchase.price }} €</span>
						</div>
						<div class="billing-item-meta">
							<span>{{ formatDate(purchase.purchasedAt) }}</span>
							<span>→</span>
							<span>{{ formatDate(purchase.validUntil) }}</span>
						</div>
						<div v-if="purchase.deleted" class="billing-item-status">
							Удалено
						</div>
						<div
							v-else-if="isExpired(purchase.validUntil)"
							class="billing-item-status"
						>
							Пакет закончился
						</div>
						<div class="billing-item-services">
							{{ formatServices(purchase.serviceIds) || 'Без услуг' }}
						</div>
						<el-button
							v-if="!purchase.deleted"
							type="danger"
							size="small"
							@click="deleteBillingPurchase(purchase.id)"
						>
							Удалить
						</el-button>
						<el-button
							v-else
							type="primary"
							size="small"
							@click="restoreBillingPurchase(purchase.id)"
						>
							Восстановить
						</el-button>
					</div>
					<div v-if="!filteredBillingPurchases.length" class="billing-empty">
						Покупок пока нет
					</div>
				</div>
			</div>

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteClinic"> Удалить </el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.clinic-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid black;
	padding-top: var(--spacing-lg);
}

.billing-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);
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

.billing-form {
	display: grid;
	grid-template-columns: minmax(180px, 1.4fr) repeat(3, minmax(140px, 1fr)) auto;
	gap: var(--spacing-sm);
	align-items: center;
}

.billing-select {
	width: 100%;
}

.billing-input {
	width: 100%;
}

.billing-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.billing-filter {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	color: var(--color-text-secondary);
}

.billing-item {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-sm);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.billing-item.deleted {
	border-color: #ef4444;
	background: #fef2f2;
}

.billing-item.expired {
	border-color: #f59e0b;
	background: #fff7ed;
}

.billing-item-title {
	display: flex;
	justify-content: space-between;
	font-weight: 600;
}

.billing-item-price {
	color: var(--color-text-primary);
}

.billing-item-meta {
	display: flex;
	gap: var(--spacing-xs);
	color: var(--color-text-secondary);
	font-size: 13px;
}

.billing-item-services {
	color: var(--color-text-secondary);
	font-size: 13px;
}

.billing-item-status {
	font-size: 12px;
	font-weight: 600;
	color: #991b1b;
}

.billing-item.expired .billing-item-status {
	color: #b45309;
}

.billing-empty,
.billing-loading {
	color: var(--color-text-secondary);
	font-style: italic;
}

.billing-loading {
	padding: var(--spacing-xs) 0;
}

.billing-empty {
	padding: var(--spacing-xs) 0;
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
