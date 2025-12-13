<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n();
const { locale } = useI18n({ useScope: 'global' });
const route = useRoute();

const indexPageLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));

const doctorsPageLink = computed(() => ({
	name: 'doctors',
	query: getRegionalQuery(locale.value),
}));

const clinicsPageLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const labTestsPageLink = computed(() => ({
	name: 'labtests',
	query: getRegionalQuery(locale.value),
}));

const medicalServicesPageLink = computed(() => ({
	name: 'services',
	query: getRegionalQuery(locale.value),
}));

const medicationsPageLink = computed(() => ({
	name: 'medications',
	query: getRegionalQuery(locale.value),
}));

const isActiveSection = (section: string) => {
	return route.path.startsWith(`/${section}`);
};
</script>

<template>
	<header class="app-header">
		<div class="app-header__main">
			<div class="app-header__main-content">
				<NuxtLink
					class="app-header__brand"
					:to="indexPageLink"
					:aria-label="t('GoToMainPage')"
				>
					<div class="app-header__logo"></div>
				</NuxtLink>

				<nav class="app-header__nav">
					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('doctors') }"
						:to="doctorsPageLink"
					>
						<IconDoctor class="nav-icon" />
						<span>{{ t('Doctors') }}</span>
					</NuxtLink>
					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('clinics') }"
						:to="clinicsPageLink"
					>
						<IconClinic class="nav-icon" />
						<span>{{ t('Clinics') }}</span>
					</NuxtLink>
					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('labtests') }"
						:to="labTestsPageLink"
					>
						<IconLabTest class="nav-icon" />
						<span>{{ t('LabTests') }}</span>
					</NuxtLink>
					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('services') }"
						:to="medicalServicesPageLink"
					>
						<IconMedicalService class="nav-icon" />
						<span>{{ t('MedicalServices') }}</span>
					</NuxtLink>
					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('medications') }"
						:to="medicationsPageLink"
					>
						<IconMedication class="nav-icon" />
						<span>{{ t('Medications') }}</span>
					</NuxtLink>
				</nav>

				<div class="app-header__actions">
					<LanguageSwitcher />
				</div>
			</div>
		</div>
	</header>
</template>

<i18n lang="json">
{
	"en": {
		"GoToMainPage": "Go to main page",
		"Doctors": "Doctors",
		"Clinics": "Clinics",
		"LabTests": "Lab Tests",
		"MedicalServices": "Medical Services",
		"Medications": "Medications"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу",
		"Doctors": "Врачи",
		"Clinics": "Клиники",
		"LabTests": "Анализы",
		"MedicalServices": "Услуги",
		"Medications": "Лекарства"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Lekari",
		"Clinics": "Klinike",
		"LabTests": "Analize",
		"MedicalServices": "Usluge",
		"Medications": "Lekovi"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen",
		"Doctors": "Ärzte",
		"Clinics": "Kliniken",
		"LabTests": "Labortests",
		"MedicalServices": "Medizinische Dienstleistungen",
		"Medications": "Medikamente"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git",
		"Doctors": "Doktorlar",
		"Clinics": "Klinikler",
		"LabTests": "Laboratuvar Testleri",
		"MedicalServices": "Tıbbi Hizmetler",
		"Medications": "İlaçlar"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.app-header {
	position: sticky;
	top: 0;
	z-index: var(--z-header);
	background: white;
	border-bottom: 1px solid @light-gray-color;
	transition: all 0.3s ease;

	&__main {
		width: 100%;
	}

	&__main-content {
		display: flex;
		align-items: center;
		justify-content: space-between;
		height: 60px;
		gap: @base-padding;
		padding: 0 @base-padding;
		box-sizing: border-box;
	}

	&__brand {
		display: flex;
		align-items: center;
		text-decoration: none;
		color: inherit;
		gap: 12px;
		flex-shrink: 0;
		transition: opacity 0.2s ease;

		&:hover {
			opacity: 0.8;
		}
	}

	&__logo {
		width: 120px;
		height: 30px;
		background-image: url('/logo-site.png');
		background-size: contain;
		background-repeat: no-repeat;
		background-position: center;
		flex-shrink: 0;
	}

	&__nav {
		display: flex;
		align-items: center;
		gap: var(--spacing-lg);
		flex: 1;
		margin-left: var(--spacing-lg);
	}

	&__nav-link {
		display: flex;
		align-items: center;
		gap: var(--spacing-xs);
		font-size: var(--font-size-md);
		font-weight: 500;
		color: #4b5563;
		text-decoration: none;
		padding: var(--spacing-sm) var(--spacing-sm);
		border-radius: var(--border-radius-sm);
		transition: all 0.2s ease;
		white-space: nowrap;

		.nav-icon {
			width: 18px;
			height: 18px;
			flex-shrink: 0;
		}

		&:hover {
			color: #4f46e5;
			background: rgba(79, 70, 229, 0.06);
		}

		&.is-active {
			color: #4f46e5;
			font-weight: 600;
			background: rgba(79, 70, 229, 0.1);
		}
	}

	&__actions {
		display: flex;
		align-items: center;
		gap: @base-offset;
		flex-shrink: 0;
	}
}

@media only screen and (max-width: 700px) {
	.app-header {
		&__main-content {
			height: 50px;
			gap: var(--spacing-md);
		}

		&__nav {
			gap: var(--spacing-md);
			margin-left: var(--spacing-md);
		}

		&__nav-link {
			font-size: var(--font-size-sm);
		}
	}
}

@media only screen and (max-width: 500px) {
	.app-header {
		&__main-content {
			padding: 0 @base-offset;
		}

		&__nav {
			gap: var(--spacing-sm);
			margin-left: var(--spacing-sm);
		}
	}
}
</style>
