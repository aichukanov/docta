<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';
import cityI18n from '~/i18n/city';
import languageI18n from '~/i18n/language';
import { combineI18nMessages } from '~/i18n/utils';
import { CityId, CITY_POSTAL_CODES } from '~/enums/cities';
import { LanguageId } from '~/enums/language';
import type { ClinicMyListItem } from '~/server/api/clinics/my-list';
import type {
	DayOfWeek,
	DaySchedule,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import { DEFAULT_WORKING_HOURS, DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const props = defineProps<{
	// null — создание новой клиники
	clinic: ClinicMyListItem | null;
}>();

const emit = defineEmits<{
	(e: 'saved'): void;
	(e: 'cancel'): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicProfileI18n, cityI18n, languageI18n]),
});

const isCreate = computed(() => props.clinic == null);

const form = reactive({
	nameSr: props.clinic?.nameSr || '',
	nameSrCyrl: props.clinic?.nameSrCyrl || '',
	nameRu: props.clinic?.nameRu || '',
	cityId: props.clinic?.cityId ?? null,
	addressSr: props.clinic?.addressSr || '',
	addressSrCyrl: props.clinic?.addressSrCyrl || '',
	townSr: props.clinic?.townSr || '',
	townSrCyrl: props.clinic?.townSrCyrl || '',
	postalCode: props.clinic?.postalCode || '',
	latitude: props.clinic?.latitude ?? null,
	longitude: props.clinic?.longitude ?? null,
	phone: props.clinic?.phone || '',
	email: props.clinic?.email || '',
	website: props.clinic?.website || '',
	facebook: props.clinic?.facebook || '',
	instagram: props.clinic?.instagram || '',
	telegram: props.clinic?.telegram || '',
	whatsapp: props.clinic?.whatsapp || '',
	viber: props.clinic?.viber || '',
	descriptionSr: props.clinic?.descriptionSr || '',
	descriptionSrCyrl: props.clinic?.descriptionSrCyrl || '',
	descriptionRu: props.clinic?.descriptionRu || '',
	descriptionEn: props.clinic?.descriptionEn || '',
	descriptionDe: props.clinic?.descriptionDe || '',
	descriptionTr: props.clinic?.descriptionTr || '',
	logoUrl: props.clinic?.logoUrl || '',
	// Сербский предвыбран: клиник без сопровождения на сербском не бывает,
	// а если вдруг — пользователь снимет сам
	languageIds: props.clinic?.languageIds
		? props.clinic.languageIds.split(',').map(Number)
		: [LanguageId.SR],
	clinicTypeIds: props.clinic?.clinicTypeIds
		? props.clinic.clinicTypeIds.split(',').map(Number)
		: [],
});

// --- Локализованные поля (вкладки по языкам, как у врача) ---

const nameLanguages = [
	{ key: 'nameSr', code: 'SR' },
	{ key: 'nameSrCyrl', code: 'SR-CYRL' },
	{ key: 'nameRu', code: 'RU' },
];

const addressLanguages = [
	{ key: 'addressSr', code: 'SR' },
	{ key: 'addressSrCyrl', code: 'SR-CYRL' },
];

const townLanguages = [
	{ key: 'townSr', code: 'SR' },
	{ key: 'townSrCyrl', code: 'SR-CYRL' },
];

const descriptionLanguages = [
	{ key: 'descriptionSr', code: 'SR' },
	{ key: 'descriptionSrCyrl', code: 'SR-CYRL' },
	{ key: 'descriptionRu', code: 'RU' },
	{ key: 'descriptionEn', code: 'EN' },
	{ key: 'descriptionDe', code: 'DE' },
	{ key: 'descriptionTr', code: 'TR' },
];

function makeLocalizedComputed(keys: string[]) {
	return computed({
		get: () => {
			const result: Record<string, string> = {};
			for (const key of keys) {
				result[key] = (form as any)[key];
			}
			return result;
		},
		set: (val: Record<string, string>) => {
			Object.assign(form, val);
		},
	});
}

const names = makeLocalizedComputed(nameLanguages.map((l) => l.key));
const addresses = makeLocalizedComputed(addressLanguages.map((l) => l.key));
const towns = makeLocalizedComputed(townLanguages.map((l) => l.key));
const descriptions = makeLocalizedComputed(
	descriptionLanguages.map((l) => l.key),
);

// --- Город и языки сопровождения ---

const cities = computed(() =>
	Object.values(CityId)
		.filter(Number)
		.map((id) => ({ value: id as number, text: t(`city_${id}`) }))
		.sort((a, b) => a.text.localeCompare(b.text)),
);

// Индекс автоподставляется из выбранного города, пока пользователь
// не ввёл свой (своим считаем всё, что не равно индексу прежнего города)
watch(
	() => form.cityId,
	(cityId, prevCityId) => {
		if (!cityId) return;
		const prevAutoCode = prevCityId
			? CITY_POSTAL_CODES[prevCityId as CityId]
			: '';
		if (!form.postalCode.trim() || form.postalCode === prevAutoCode) {
			form.postalCode = CITY_POSTAL_CODES[cityId as CityId] || '';
		}
	},
);

const CLINIC_LANGUAGES = [
	LanguageId.SR,
	LanguageId.EN,
	LanguageId.RU,
	LanguageId.IT,
	LanguageId.FR,
	LanguageId.DE,
];

const languages = computed(() =>
	CLINIC_LANGUAGES.map((id) => ({ value: id, text: t(`language_${id}`) })),
);

// --- Логотип ---

const logoInput = ref<HTMLInputElement | null>(null);
const { isUploading, preview, upload, setPreview, revokePreview } =
	useImageUpload();

const logoDisplayUrl = computed(() => preview.value || form.logoUrl || '');

function triggerLogoUpload() {
	logoInput.value?.click();
}

async function onLogoFileChange(e: Event) {
	const file = (e.target as HTMLInputElement).files?.[0];
	if (!file) return;

	setPreview(file);
	const url = await upload(file, 'clinics');

	if (url) {
		form.logoUrl = url;
		ElMessage.success(t('LogoUpdated'));
	}

	if (logoInput.value) {
		logoInput.value.value = '';
	}
}

function removeLogo() {
	form.logoUrl = '';
	revokePreview();
}

// --- График работы ---

const workingHours = ref<Record<DayOfWeek, DaySchedule> | null>(null);

onMounted(async () => {
	if (!props.clinic) {
		workingHours.value = JSON.parse(JSON.stringify(DEFAULT_WORKING_HOURS));
		return;
	}
	try {
		const data = await $fetch<WorkingHours>('/api/clinics/working-hours', {
			method: 'POST',
			body: { clinicId: props.clinic.id },
		});
		const schedule = {} as Record<DayOfWeek, DaySchedule>;
		for (const day of DAYS_OF_WEEK) {
			schedule[day] = data?.[day] || { type: 'not_specified' };
		}
		workingHours.value = schedule;
	} catch {
		workingHours.value = JSON.parse(JSON.stringify(DEFAULT_WORKING_HOURS));
	}
});

// --- Координаты ---

function onMapPick(latitude: number, longitude: number) {
	form.latitude = latitude;
	form.longitude = longitude;
}

function onMapClear() {
	form.latitude = null;
	form.longitude = null;
}

// --- Сохранение ---

const isSaving = ref(false);

function validate(): string | null {
	if (!form.nameSr.trim()) return t('ValidationNameRequired');
	if (!form.cityId) return t('ValidationCityRequired');
	if (!form.addressSr.trim()) return t('ValidationAddressRequired');
	if (!form.postalCode.trim()) return t('ValidationPostalCodeRequired');
	if (!form.languageIds.length) return t('ValidationLanguagesRequired');
	const hasContact = [
		form.phone,
		form.email,
		form.website,
		form.facebook,
		form.instagram,
		form.telegram,
		form.whatsapp,
		form.viber,
	].some((value) => value.trim());
	if (!hasContact) return t('ValidationContactRequired');
	return null;
}

async function save() {
	const error = validate();
	if (error) {
		ElMessage.warning(error);
		return;
	}

	isSaving.value = true;
	try {
		const body: Record<string, unknown> = {
			nameSr: form.nameSr,
			nameSrCyrl: form.nameSrCyrl,
			nameRu: form.nameRu,
			cityId: form.cityId,
			addressSr: form.addressSr,
			addressSrCyrl: form.addressSrCyrl,
			townSr: form.townSr,
			townSrCyrl: form.townSrCyrl,
			postalCode: form.postalCode,
			latitude: form.latitude,
			longitude: form.longitude,
			phone: form.phone,
			email: form.email,
			website: form.website,
			facebook: form.facebook,
			instagram: form.instagram,
			telegram: form.telegram,
			whatsapp: form.whatsapp,
			viber: form.viber,
			descriptionSr: form.descriptionSr,
			descriptionSrCyrl: form.descriptionSrCyrl,
			descriptionRu: form.descriptionRu,
			descriptionEn: form.descriptionEn,
			descriptionDe: form.descriptionDe,
			descriptionTr: form.descriptionTr,
			logoUrl: form.logoUrl,
			languageIds: form.languageIds,
			clinicTypeIds: form.clinicTypeIds,
		};

		if (workingHours.value) {
			body.workingHours = workingHours.value;
		}

		if (props.clinic) {
			await $fetch('/api/clinics/my-update', {
				method: 'POST',
				body: { ...body, clinicId: props.clinic.id },
			});
			ElMessage.success(t('ClinicSaved'));
		} else {
			await $fetch('/api/clinics/my-create', {
				method: 'POST',
				body,
			});
			ElMessage.success(t('ClinicCreated'));
		}

		emit('saved');
	} catch {
		ElMessage.error(t('ErrorSaving'));
	} finally {
		isSaving.value = false;
	}
}
</script>

<template>
	<section class="clinic-form">
		<div class="clinic-form__header">
			<IconEdit v-if="!isCreate" :size="20" />
			<IconClinic v-else :size="20" />
			<h2 class="clinic-form__title">
				{{ isCreate ? t('CreateClinicTitle') : t('EditClinicTitle') }}
			</h2>
		</div>

		<!-- Логотип -->
		<div class="clinic-form__logo-section">
			<div class="clinic-form__logo-wrap">
				<ClinicLogo :logoUrl="logoDisplayUrl" :name="form.nameSr" :size="80" />
				<button
					class="clinic-form__logo-upload"
					:title="t('ChangeLogo')"
					:disabled="isUploading"
					@click="triggerLogoUpload"
				>
					<IconCamera v-if="!isUploading" :size="14" />
					<span v-else class="clinic-form__logo-spinner" />
				</button>
				<button
					v-if="logoDisplayUrl"
					class="clinic-form__logo-remove"
					:title="t('RemoveLogo')"
					@click="removeLogo"
				>
					<IconClose :size="10" />
				</button>
				<input
					ref="logoInput"
					type="file"
					accept="image/jpeg,image/png,image/webp,image/gif"
					hidden
					@change="onLogoFileChange"
				/>
			</div>
			<div class="clinic-form__logo-hint">{{ t('ChangeLogo') }}</div>
		</div>

		<!-- Основная информация -->
		<div class="clinic-form__section">
			<h3 class="clinic-form__section-title">{{ t('SectionMain') }}</h3>

			<div class="clinic-form__field">
				<label class="clinic-form__label">{{ t('FieldName') }} *</label>
				<LocalizedFieldEditor :languages="nameLanguages" v-model="names" />
			</div>

			<FilterClinicTypeSelect v-model:value="form.clinicTypeIds" />

			<div class="clinic-form__field">
				<label class="clinic-form__label">{{ t('FieldCity') }} *</label>
				<el-select
					v-model="form.cityId"
					:placeholder="t('FieldCityPlaceholder')"
					size="large"
					filterable
				>
					<el-option
						v-for="{ text, value } in cities"
						:key="value"
						:label="text"
						:value="value"
					/>
				</el-select>
			</div>

			<div class="clinic-form__field">
				<label class="clinic-form__label">{{ t('FieldAddress') }} *</label>
				<LocalizedFieldEditor
					:languages="addressLanguages"
					v-model="addresses"
					placeholder="Jovana Tomaševića 30"
				/>
			</div>

			<div class="clinic-form__row">
				<div class="clinic-form__field clinic-form__field--grow">
					<label class="clinic-form__label">{{ t('FieldTown') }}</label>
					<LocalizedFieldEditor
						:languages="townLanguages"
						v-model="towns"
						placeholder="Sutomore"
					/>
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldPostalCode') }} *</label>
					<el-input
						v-model="form.postalCode"
						class="clinic-form__postal"
						placeholder="85000"
					/>
				</div>
			</div>

			<div class="clinic-form__field">
				<label class="clinic-form__label">{{ t('FieldLanguages') }} *</label>
				<el-select
					v-model="form.languageIds"
					:placeholder="t('FieldLanguagesPlaceholder')"
					size="large"
					multiple
					collapse-tags
					collapse-tags-tooltip
				>
					<el-option
						v-for="{ text, value } in languages"
						:key="value"
						:label="text"
						:value="value"
					/>
				</el-select>
			</div>
		</div>

		<!-- Расположение -->
		<div class="clinic-form__section">
			<h3 class="clinic-form__section-title">{{ t('SectionLocation') }}</h3>
			<ClientOnly>
				<ProfileClinicMapPicker
					:latitude="form.latitude"
					:longitude="form.longitude"
					@pick="onMapPick"
					@clear="onMapClear"
				/>
			</ClientOnly>
		</div>

		<!-- Контакты -->
		<div class="clinic-form__section">
			<div class="clinic-form__section-header">
				<h3 class="clinic-form__section-title">{{ t('SectionContacts') }} *</h3>
				<span class="clinic-form__markdown-hint">{{ t('ContactsRequiredHint') }}</span>
			</div>
			<div class="clinic-form__contacts">
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldPhone') }}</label>
					<el-input v-model="form.phone" type="tel" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldEmail') }}</label>
					<el-input v-model="form.email" type="email" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldWebsite') }}</label>
					<el-input v-model="form.website" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldWhatsapp') }}</label>
					<el-input v-model="form.whatsapp" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldViber') }}</label>
					<el-input v-model="form.viber" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldTelegram') }}</label>
					<el-input v-model="form.telegram" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldFacebook') }}</label>
					<el-input v-model="form.facebook" />
				</div>
				<div class="clinic-form__field">
					<label class="clinic-form__label">{{ t('FieldInstagram') }}</label>
					<el-input v-model="form.instagram" />
				</div>
			</div>
		</div>

		<!-- График работы -->
		<div class="clinic-form__section">
			<h3 class="clinic-form__section-title">{{ t('SectionWorkingHours') }}</h3>
			<ProfileClinicWorkingHoursEditor
				v-if="workingHours"
				v-model="workingHours"
			/>
		</div>

		<!-- Описание -->
		<div class="clinic-form__section">
			<div class="clinic-form__section-header">
				<h3 class="clinic-form__section-title">{{ t('SectionDescription') }}</h3>
				<span class="clinic-form__markdown-hint">{{ t('MarkdownHint') }}</span>
			</div>
			<LocalizedFieldEditor
				:languages="descriptionLanguages"
				v-model="descriptions"
				type="markdown"
			/>
		</div>

		<div class="clinic-form__actions">
			<el-button @click="emit('cancel')">{{ t('BtnCancel') }}</el-button>
			<el-button type="primary" :loading="isSaving" @click="save">
				{{ isCreate ? t('BtnCreate') : t('BtnSave') }}
			</el-button>
		</div>
	</section>
</template>

<style scoped>
.clinic-form {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-2xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.clinic-form__header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	color: var(--color-primary);
}

.clinic-form__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.clinic-form__logo-section {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--spacing-sm);
}

.clinic-form__logo-wrap {
	position: relative;
}

.clinic-form__logo-upload {
	position: absolute;
	bottom: -2px;
	right: -2px;
	width: 28px;
	height: 28px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-primary);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.clinic-form__logo-upload:hover {
	background: var(--color-primary-dark, #3730a3);
	transform: scale(1.1);
}

.clinic-form__logo-upload:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

.clinic-form__logo-spinner {
	width: 14px;
	height: 14px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: #fff;
	border-radius: 50%;
	animation: clinic-logo-spin 0.6s linear infinite;
}

.clinic-form__logo-remove {
	position: absolute;
	top: -4px;
	right: -4px;
	width: 20px;
	height: 20px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-danger);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.clinic-form__logo-remove:hover {
	background: var(--color-danger-dark);
	transform: scale(1.1);
}

@keyframes clinic-logo-spin {
	to {
		transform: rotate(360deg);
	}
}

.clinic-form__logo-hint {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}

.clinic-form__section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-secondary);
}

.clinic-form__section-header {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.clinic-form__section-title {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.clinic-form__markdown-hint {
	font-size: var(--font-size-xs);
	color: var(--color-text-tertiary);
}

.clinic-form__field {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.clinic-form__field--grow {
	flex: 1;
	min-width: 0;
}

.clinic-form__label {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
}

.clinic-form__row {
	display: flex;
	gap: var(--spacing-lg);
	align-items: flex-start;
}

.clinic-form__postal {
	width: 140px;
}

.clinic-form__contacts {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: var(--spacing-lg);
}

.clinic-form__actions {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-secondary);
}

@media (max-width: 640px) {
	.clinic-form {
		padding: var(--spacing-xl) var(--spacing-lg);
	}

	.clinic-form__contacts {
		grid-template-columns: 1fr;
	}

	.clinic-form__row {
		flex-direction: column;
	}

	.clinic-form__postal {
		width: 100%;
	}
}
</style>
