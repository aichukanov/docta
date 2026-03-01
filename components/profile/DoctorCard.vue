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
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([specialtyI18n, doctorProfileI18n]),
});

const specialties = computed(() => {
	if (!props.doctor.specialtyIds) return [];
	return props.doctor.specialtyIds
		.split(',')
		.map((id) => t(`specialty_${id}`))
		.filter(Boolean);
});
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
			<DoctorAvatar
				:name="doctor.name"
				:photo-url="doctor.photoUrl"
				:size="72"
			/>
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
