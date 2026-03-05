<script setup lang="ts">
import specialtyI18n from '~/i18n/specialty';
import doctorProfileI18n from '~/i18n/doctor-profile';
import { combineI18nMessages } from '~/i18n/utils';
import type { DoctorMyProfile } from '~/server/api/doctors/my-profile';
import type { DoctorProfileStatus } from '~/interfaces/doctor';
import { Edit } from '@element-plus/icons-vue';

const props = defineProps<{
	doctor: DoctorMyProfile;
	status: DoctorProfileStatus;
	isToggling: boolean;
}>();

const emit = defineEmits<{
	(e: 'toggle-visibility'): void;
	(e: 'edit'): void;
	(e: 'photo-updated', url: string): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([specialtyI18n, doctorProfileI18n]),
});

const clinicsStore = useClinicsStore();
clinicsStore.fetchClinics();

const photoInput = ref<HTMLInputElement | null>(null);
const { isUploading, isRemoving, preview, upload, removePhoto, setPreview } =
	useImageUpload();

const photoDisplayUrl = computed(
	() => preview.value || props.doctor.photoUrl || null,
);

const canRemovePhoto = computed(
	() => preview.value || props.doctor.photoUrl?.startsWith('/uploads/'),
);

async function removeDoctorPhoto() {
	const ok = await removePhoto('doctors');
	if (ok) {
		emit('photo-updated', '');
	}
}

function triggerPhotoUpload() {
	photoInput.value?.click();
}

async function onPhotoFileChange(e: Event) {
	const file = (e.target as HTMLInputElement).files?.[0];
	if (!file) return;

	setPreview(file);
	const url = await upload(file, 'doctors');

	if (url) {
		emit('photo-updated', url);
	}

	if (photoInput.value) {
		photoInput.value.value = '';
	}
}

const specialties = computed(() => {
	if (!props.doctor.specialtyIds) return [];
	return props.doctor.specialtyIds
		.split(',')
		.map((id) => t(`specialty_${id}`))
		.filter(Boolean);
});

const clinicNames = computed(() =>
	clinicsStore.getClinicsByIds(props.doctor.clinicIds).map((c) => c.name),
);
</script>

<template>
	<section class="doctor-card">
		<div class="doctor-card__header">
			<div class="doctor-card__icon">
				<IconDoctor :size="20" />
			</div>
			<h2 class="doctor-card__title">{{ t('doctorProfile') }}</h2>
		</div>

		<div class="doctor-card__profile">
			<div class="doctor-card__avatar-wrap">
				<DoctorAvatar
					:name="doctor.name"
					:photo-url="photoDisplayUrl"
					:size="72"
				/>
				<button
					v-if="status !== 'draft'"
					class="doctor-card__avatar-upload"
					:title="t('changePhoto')"
					:disabled="isUploading"
					@click="triggerPhotoUpload"
				>
					<IconCamera v-if="!isUploading" :size="12" />
					<span v-else class="doctor-card__avatar-spinner" />
				</button>
				<button
					v-if="canRemovePhoto && status !== 'draft'"
					class="doctor-card__avatar-remove"
					:title="t('removePhoto')"
					:disabled="isRemoving"
					@click="removeDoctorPhoto"
				>
					<IconClose :size="8" />
				</button>
				<input
					ref="photoInput"
					type="file"
					accept="image/jpeg,image/png,image/webp,image/gif"
					hidden
					@change="onPhotoFileChange"
				/>
			</div>
			<div class="doctor-card__info">
				<div class="doctor-card__name">
					{{ doctor.name }}
					<span
						v-if="doctor.localName && doctor.localName !== doctor.name"
						class="doctor-card__local-name"
					>
						({{ doctor.localName }})
					</span>
				</div>
				<div v-if="doctor.professionalTitle" class="doctor-card__subtitle">
					{{ doctor.professionalTitle }}
				</div>
				<div v-if="specialties.length" class="doctor-card__meta">
					{{ specialties.join(', ') }}
				</div>
				<div v-if="clinicNames.length" class="doctor-card__meta">
					{{ clinicNames.join(', ') }}
				</div>
			</div>
		</div>

		<div v-if="status !== 'draft'" class="doctor-card__edit">
			<el-button plain @click="emit('edit')" :icon="Edit">
				{{ t('editProfile') }}
			</el-button>
		</div>

		<ProfileDoctorStatusBlock
			:status="status"
			:doctor-id="doctor.id"
			:is-toggling="isToggling"
			@toggle-visibility="emit('toggle-visibility')"
		/>
	</section>
</template>

<style scoped>
.doctor-card {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-2xl);
	box-shadow: var(--shadow-sm);
	border: 1px solid var(--color-border-secondary);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.doctor-card__header {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-md);
}

.doctor-card__icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	border-radius: var(--border-radius-lg);
	background: var(--color-primary-bg);
	color: var(--color-primary);
	flex-shrink: 0;
}

.doctor-card__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
	line-height: 40px;
}

.doctor-card__profile {
	display: flex;
	gap: var(--spacing-lg);
	align-items: flex-start;
}

.doctor-card__info {
	display: flex;
	flex-direction: column;
	gap: 4px;
	min-width: 0;
}

.doctor-card__name {
	font-size: var(--font-size-xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	line-height: 1.3;
}

.doctor-card__local-name {
	font-weight: var(--font-weight-normal);
	color: var(--color-text-secondary);
}

.doctor-card__subtitle {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.doctor-card__meta {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	line-height: 1.4;
}

.doctor-card__avatar-wrap {
	position: relative;
	flex-shrink: 0;
}

.doctor-card__avatar-upload {
	position: absolute;
	bottom: -2px;
	right: -2px;
	width: 24px;
	height: 24px;
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

.doctor-card__avatar-upload:hover {
	background: var(--color-primary-dark, #3730a3);
	transform: scale(1.1);
}

.doctor-card__avatar-upload:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

.doctor-card__avatar-spinner {
	width: 12px;
	height: 12px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: #fff;
	border-radius: 50%;
	animation: doctor-avatar-spin 0.6s linear infinite;
}

.doctor-card__avatar-remove {
	position: absolute;
	top: -4px;
	right: -4px;
	width: 18px;
	height: 18px;
	border-radius: 50%;
	border: 2px solid var(--color-bg-primary);
	background: var(--color-danger, #ef4444);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all var(--transition-base);
	padding: 0;
}

.doctor-card__avatar-remove:hover {
	background: var(--color-danger-dark, #dc2626);
	transform: scale(1.1);
}

.doctor-card__avatar-remove:disabled {
	cursor: not-allowed;
	opacity: 0.7;
}

@keyframes doctor-avatar-spin {
	to {
		transform: rotate(360deg);
	}
}

.doctor-card__edit {
	display: flex;
}

@media (max-width: 640px) {
	.doctor-card {
		padding: var(--spacing-xl) var(--spacing-lg);
	}

	.doctor-card__profile {
		flex-direction: column;
		align-items: center;
		text-align: center;
	}
}
</style>
