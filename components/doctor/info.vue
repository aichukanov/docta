<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorData } from '~/interfaces/doctor';

const props = withDefaults(
	defineProps<{
		service: DoctorData;
		short?: boolean;
		isMainHeading?: boolean;
		headingLevel?: 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6';
	}>(),
	{
		short: false,
		isMainHeading: false,
		headingLevel: 'h2',
	},
);

const { t, locale } = useI18n();

const headingTag = computed(() => {
	if (props.isMainHeading) return 'h1';
	return props.headingLevel;
});

const doctorLink = computed(() => ({
	name: 'doctors-doctorId',
	params: { doctorId: props.service.id },
	query: getRegionalQuery(locale.value),
}));

const avatarName = computed(() => {
	return props.service.localName && props.service.localName.trim() !== ''
		? props.service.localName
		: props.service.name;
});
</script>

<template>
	<div class="doctor-wrapper" :class="{ 'doctor-wrapper__short': short }">
		<DoctorAvatar
			:name="avatarName"
			:photoUrl="service.photoUrl"
			:size="short ? 40 : 120"
		/>
		<div class="doctor-info">
			<component :is="headingTag" class="doctor-name">
				<NuxtLink :to="doctorLink" class="doctor-name-link">
					{{ service.name }}
				</NuxtLink>
				<div v-if="service.localName && !short" class="doctor-original-name">
					{{ service.localName }}
				</div>
				<div
					v-if="service.professionalTitle && !short"
					class="doctor-professional-title"
				>
					{{ service.professionalTitle }}
				</div>
			</component>
			<DoctorSpecialties :doctor="service" />
			<ConsultationLanguages v-if="!short" :languageIds="service.languageIds">
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
	"sr-cyrl": {
		"DoctorLanguages": "Доктор говори следеће језике:"
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

	.doctor-original-name {
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-medium);
		color: var(--color-text-secondary);
		margin-top: var(--spacing-xs);
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
