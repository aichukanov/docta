<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t, locale } = useI18n();
const route = useRoute();
const { isAuthenticated, currentUser, isLoading } = useAuth();

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

const articlesPageLink = computed(() => ({
	name: 'articles',
	query: getRegionalQuery(locale.value),
}));

const profilePageLink = computed(() => ({
	path: '/profile',
	query: getRegionalQuery(locale.value),
}));

const loginPageLink = computed(() => ({
	path: '/login',
	query: getRegionalQuery(locale.value),
}));

const isActiveSection = (section: string) => {
	return route.path.startsWith(`/${section}`);
};

// Аватар пользователя

const userDisplayName = computed(() => {
	const user = currentUser.value;
	if (!user) return '';
	if (user.name) return user.name;
	if (user.email) return user.email.split('@')[0];
	return '';
});
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

					<div class="app-header__nav-divider" aria-hidden="true"></div>

					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection('articles') }"
						:to="articlesPageLink"
					>
						<IconLightbulb class="nav-icon" />
						<span>{{ t('Articles') }}</span>
					</NuxtLink>
				</nav>

				<div class="app-header__actions">
					<ClientOnly>
						<template v-if="!isLoading">
							<!-- Залогиненный пользователь -->
							<NuxtLink
								v-if="isAuthenticated && currentUser"
								class="app-header__user"
								:to="profilePageLink"
								:aria-label="t('GoToProfile')"
							>
								<DoctorAvatar
									:name="userDisplayName"
									:photo-url="currentUser?.photo_url"
									:size="32"
								/>
								<span class="app-header__user-name">{{ userDisplayName }}</span>
							</NuxtLink>

							<!-- Кнопка входа -->
							<NuxtLink
								v-else
								class="app-header__login-btn"
								:to="loginPageLink"
							>
								<IconUser class="app-header__login-icon" :size="16" />
								<span>{{ t('Login') }}</span>
							</NuxtLink>
						</template>
					</ClientOnly>

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
		"Medications": "Medications",
		"Articles": "Articles",
		"Login": "Log in",
		"GoToProfile": "Go to profile"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу",
		"Doctors": "Врачи",
		"Clinics": "Клиники",
		"LabTests": "Анализы",
		"MedicalServices": "Услуги",
		"Medications": "Лекарства",
		"Articles": "Статьи",
		"Login": "Войти",
		"GoToProfile": "Перейти в профиль"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Lekari",
		"Clinics": "Klinike",
		"LabTests": "Analize",
		"MedicalServices": "Usluge",
		"Medications": "Lekovi",
		"Articles": "Članci",
		"Login": "Prijavite se",
		"GoToProfile": "Idite na profil"
	},
	"sr-cyrl": {
		"GoToMainPage": "Иди на почетну страницу",
		"Doctors": "Лекари",
		"Clinics": "Клинике",
		"LabTests": "Анализе",
		"MedicalServices": "Услуге",
		"Medications": "Лекови",
		"Articles": "Чланци",
		"Login": "Пријавите се",
		"GoToProfile": "Идите на профил"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen",
		"Doctors": "Ärzte",
		"Clinics": "Kliniken",
		"LabTests": "Labortests",
		"MedicalServices": "Medizinische Dienstleistungen",
		"Medications": "Medikamente",
		"Articles": "Artikel",
		"Login": "Anmelden",
		"GoToProfile": "Zum Profil gehen"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git",
		"Doctors": "Doktorlar",
		"Clinics": "Klinikler",
		"LabTests": "Laboratuvar Testleri",
		"MedicalServices": "Tıbbi Hizmetler",
		"Medications": "İlaçlar",
		"Articles": "Makaleler",
		"Login": "Giriş yap",
		"GoToProfile": "Profile git"
	}
}
</i18n>

<style lang="less" scoped>
.app-header {
	position: sticky;
	top: 0;
	z-index: var(--z-header);
	background: white;
	border-bottom: 1px solid var(--color-bg-muted);
	transition: all 0.3s ease;
	box-sizing: border-box;
	height: auto;
	min-height: 60px;

	&__main {
		width: 100%;
	}

	&__main-content {
		display: flex;
		align-items: center;
		justify-content: space-between;
		min-height: 60px;
		gap: var(--spacing-lg);
		padding: 0 var(--spacing-lg);
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
		width: 100px;
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

	&__nav-divider {
		width: 1px;
		height: 20px;
		background-color: var(--color-bg-muted);
		margin: 0 var(--spacing-xs);
		flex-shrink: 0;
	}

	&__actions {
		display: flex;
		align-items: center;
		gap: var(--spacing-md);
		flex-shrink: 0;
	}

	&__user {
		display: flex;
		align-items: center;
		gap: var(--spacing-sm);
		text-decoration: none;
		color: var(--color-text-primary);
		padding: 4px 10px 4px 4px;
		border-radius: var(--border-radius-xl);
		transition: all var(--transition-base);
		cursor: pointer;

		&:hover {
			background: rgba(79, 70, 229, 0.06);
			color: var(--color-primary);
		}
	}

	&__user-avatar {
		width: 32px;
		height: 32px;
		border-radius: var(--border-radius-full);
		object-fit: cover;
		flex-shrink: 0;
		border: 2px solid var(--color-border-secondary);
		transition: border-color var(--transition-base);

		.app-header__user:hover & {
			border-color: rgba(79, 70, 229, 0.3);
		}
	}

	&__user-name {
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-medium);
		white-space: nowrap;
		max-width: 120px;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	&__login-btn {
		display: flex;
		align-items: center;
		gap: var(--spacing-xs);
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-medium);
		color: white;
		background: var(--color-primary);
		text-decoration: none;
		padding: var(--spacing-sm) var(--spacing-lg);
		border-radius: var(--border-radius-lg);
		transition: all var(--transition-base);
		white-space: nowrap;

		&:hover {
			background: var(--color-primary-dark);
			box-shadow: var(--shadow-hover);
		}
	}

	&__login-icon {
		width: 16px;
		height: 16px;
		flex-shrink: 0;
	}
}

@media only screen and (max-width: 1024px) {
	.app-header {
		&__main-content {
			height: auto;
			padding: var(--spacing-sm) var(--spacing-md);
			flex-wrap: wrap;
			gap: var(--spacing-xs) var(--spacing-md);
		}

		&__nav {
			order: 3;
			width: 100%;
			flex: none;
			margin-left: 0;
			justify-content: flex-start;
			flex-wrap: nowrap;
			overflow-x: auto;
			padding: var(--spacing-xs) 0 var(--spacing-sm);
			gap: var(--spacing-xs);
			scrollbar-width: none; /* Firefox */
		}

		&__nav-link {
			font-size: var(--font-size-sm);
			padding: var(--spacing-sm) var(--spacing-md);
			background: var(--color-bg-secondary);
			border: 1px solid var(--color-border-secondary);
			flex-direction: column;
			gap: 4px;
			min-width: 90px;
			align-items: center;
			justify-content: center;
			flex-shrink: 0;

			.nav-icon {
				width: 20px;
				height: 20px;
			}

			span {
				font-size: 10px;
				text-transform: uppercase;
				letter-spacing: 0.5px;
			}

			&:hover {
				background: var(--color-bg-tertiary);
			}

			&.is-active {
				background: rgba(79, 70, 229, 0.08);
				border-color: rgba(79, 70, 229, 0.3);
			}
		}

		&__nav-divider {
			display: none;
		}

		&__nav-link:last-child {
			margin-left: var(--spacing-sm);
		}

		&__actions {
			order: 2;
		}

		&__brand {
			order: 1;
		}

		&__user-name {
			display: none;
		}

		&__user {
			padding: 2px;
		}

		&__login-btn {
			padding: var(--spacing-sm) var(--spacing-md);
			font-size: var(--font-size-sm);
		}
	}
}

@media only screen and (max-width: 500px) {
	.app-header {
		&__main-content {
			padding: var(--spacing-sm) var(--spacing-sm);
		}
	}
}
</style>
