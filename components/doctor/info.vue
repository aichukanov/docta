<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorData } from '~/interfaces/doctor';

const props = withDefaults(
	defineProps<{
		doctor: DoctorData;
		short?: boolean;
	}>(),
	{
		short: false,
	},
);

const { t, locale } = useI18n();

const doctorLink = computed(() => ({
	name: 'doctors-doctorId',
	params: { doctorId: props.doctor.id },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="doctor-wrapper" :class="{ 'doctor-wrapper__short': short }">
		<DoctorAvatar
			:name="doctor.name"
			:photoUrl="doctor.photoUrl"
			:size="short ? 40 : 120"
		/>
		<div class="doctor-info">
			<h3 class="doctor-name">
				<NuxtLink :to="doctorLink" class="doctor-name-link">
					{{ doctor.name }}
				</NuxtLink>
			</h3>
			<div
				v-if="doctor.professionalTitle && !short"
				class="doctor-professional-title"
			>
				{{ doctor.professionalTitle }}
			</div>
			<DoctorSpecialties :doctor="doctor" />
			<ConsultationLanguages v-if="!short" :languageIds="doctor.languageIds">
				{{ t('DoctorLanguages') }}
			</ConsultationLanguages>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"DoctorLanguages": "The doctor speaks the following languages:"
	},
	"ru": {
		"DoctorLanguages": "Врач владеет следующими языками:"
	},
	"de": {
		"DoctorLanguages": "Der Arzt spricht die folgenden Sprachen:"
	},
	"tr": {
		"DoctorLanguages": "Doktor aşağıdaki dilleri konuşmaktadır:"
	},
	"sr": {
		"DoctorLanguages": "Doktor govori sledeće jezike:"
	},
	"ba": {
		"DoctorLanguages": "Doktor govori sljedeće jezike:"
	},
	"me": {
		"DoctorLanguages": "Doktor govori sljedeće jezike:"
	}
}
</i18n>

<style scoped lang="less">
.doctor-wrapper {
	display: flex;
	gap: var(--spacing-2xl);

	.doctor-info {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-sm);
		flex: 1;
	}

	.doctor-name {
		margin: 0;
		font-size: var(--font-size-2xl);
		font-weight: 700;
		color: var(--color-text-primary);
		line-height: 1.2;
		letter-spacing: -0.01em;
	}

	.doctor-name-link {
		color: var(--color-primary);
		text-decoration: none;
	}

	.doctor-name-link:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}

	.doctor-professional-title {
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-medium);
		color: var(--color-text-secondary);
		line-height: 1.4;
		font-style: italic;
		opacity: 0.85;
	}

	&.doctor-wrapper__short {
		gap: var(--spacing-md);

		.doctor-info {
			gap: var(--spacing-xs);
		}

		.doctor-name {
			font-size: var(--font-size-xl);
			font-weight: initial;
		}

		.doctor-specialty {
			font-weight: initial;
		}
	}
}

@media (max-width: 500px) {
	.doctor-wrapper {
		// flex-direction: column;
		gap: var(--spacing-md);
	}
}

@media (max-width: 300px) {
	.doctor-wrapper {
		flex-direction: column;
		padding: 0 var(--spacing-sm);
	}
}
</style>
