<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import IconDoctor from '~/components/icon/doctor.vue';
import IconClinic from '~/components/icon/clinic.vue';
import IconLabTest from '~/components/icon/lab-test.vue';
import IconMedicalService from '~/components/icon/medical-service.vue';
import IconMedication from '~/components/icon/medication.vue';
import IconLightbulb from '~/components/icon/lightbulb.vue';
import IconClose from '~/components/icon/close.vue';

const { t, locale } = useI18n();
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
	name: 'medicines',
	query: getRegionalQuery(locale.value),
}));

const articlesPageLink = computed(() => ({
	name: 'articles',
	query: getRegionalQuery(locale.value),
}));

const isActiveSection = (section: string) => {
	return route.path.startsWith(`/${section}`);
};

const navItems = computed(() => [
	{
		key: 'doctors',
		to: doctorsPageLink.value,
		icon: IconDoctor,
		label: t('Doctors'),
	},
	{
		key: 'clinics',
		to: clinicsPageLink.value,
		icon: IconClinic,
		label: t('Clinics'),
	},
	{
		key: 'labtests',
		to: labTestsPageLink.value,
		icon: IconLabTest,
		label: t('LabTests'),
	},
	{
		key: 'services',
		to: medicalServicesPageLink.value,
		icon: IconMedicalService,
		label: t('MedicalServices'),
	},
	{
		key: 'medicines',
		to: medicationsPageLink.value,
		icon: IconMedication,
		label: t('Medications'),
	},
]);

const articlesNavItem = computed(() => ({
	key: 'articles',
	to: articlesPageLink.value,
	icon: IconLightbulb,
	label: t('Articles'),
}));

// Мобильная шторка с навигацией, локацией и логином — см. feedback_visual_decisions
const isDrawerOpen = ref(false);

function openDrawer() {
	isDrawerOpen.value = true;
}

function closeDrawer() {
	isDrawerOpen.value = false;
}

function onKeydown(e: KeyboardEvent) {
	if (e.key === 'Escape') {
		closeDrawer();
	}
}

watch(
	() => route.fullPath,
	() => closeDrawer(),
);

watch(isDrawerOpen, (open) => {
	if (!import.meta.client) return;
	document.body.style.overflow = open ? 'hidden' : '';
});

onMounted(() => {
	document.addEventListener('keydown', onKeydown);
});

onBeforeUnmount(() => {
	document.removeEventListener('keydown', onKeydown);
	document.body.style.overflow = '';
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
						v-for="item in navItems"
						:key="item.key"
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection(item.key) }"
						:to="item.to"
					>
						<component :is="item.icon" class="nav-icon" />
						<span>{{ item.label }}</span>
					</NuxtLink>

					<div class="app-header__nav-divider" aria-hidden="true"></div>

					<NuxtLink
						class="app-header__nav-link"
						:class="{ 'is-active': isActiveSection(articlesNavItem.key) }"
						:to="articlesNavItem.to"
					>
						<component :is="articlesNavItem.icon" class="nav-icon" />
						<span>{{ articlesNavItem.label }}</span>
					</NuxtLink>
				</nav>

				<div class="app-header__actions">
					<AppHeaderAuthLink />

					<LocationSelector />
					<LanguageSwitcher />
				</div>

				<div class="app-header__mobile-controls">
					<LanguageSwitcher smaller />

					<button
						type="button"
						class="app-header__burger"
						:aria-label="t('OpenMenu')"
						:aria-expanded="isDrawerOpen"
						aria-controls="app-header-drawer"
						@click="openDrawer"
					>
						<span></span>
						<span></span>
						<span></span>
					</button>
				</div>
			</div>
		</div>

		<Transition name="app-header-fade">
			<div
				v-if="isDrawerOpen"
				class="app-header__backdrop"
				@click="closeDrawer"
			></div>
		</Transition>

		<Transition name="app-header-slide">
			<div
				v-if="isDrawerOpen"
				id="app-header-drawer"
				class="app-header__drawer"
				role="dialog"
				aria-modal="true"
				:aria-label="t('MobileMenu')"
			>
				<div class="app-header__drawer-top" @click="closeDrawer">
					<AppHeaderAuthLink drawer :avatar-size="36" />

					<button
						type="button"
						class="app-header__drawer-close"
						:aria-label="t('CloseMenu')"
						@click="closeDrawer"
					>
						<IconClose :size="20" />
					</button>
				</div>

				<div class="app-header__drawer-location">
					<LocationSelector />
				</div>

				<nav class="app-header__drawer-nav">
					<NuxtLink
						v-for="item in navItems"
						:key="item.key"
						class="app-header__drawer-link"
						:class="{ 'is-active': isActiveSection(item.key) }"
						:to="item.to"
						@click="closeDrawer"
					>
						<component :is="item.icon" class="nav-icon" />
						<span>{{ item.label }}</span>
					</NuxtLink>

					<div class="app-header__drawer-divider" aria-hidden="true"></div>

					<NuxtLink
						class="app-header__drawer-link"
						:class="{ 'is-active': isActiveSection(articlesNavItem.key) }"
						:to="articlesNavItem.to"
						@click="closeDrawer"
					>
						<component :is="articlesNavItem.icon" class="nav-icon" />
						<span>{{ articlesNavItem.label }}</span>
					</NuxtLink>
				</nav>
			</div>
		</Transition>
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
		"OpenMenu": "Open menu",
		"CloseMenu": "Close menu",
		"MobileMenu": "Navigation menu"
	},
	"ru": {
		"GoToMainPage": "Перейти на главную страницу",
		"Doctors": "Врачи",
		"Clinics": "Клиники",
		"LabTests": "Анализы",
		"MedicalServices": "Услуги",
		"Medications": "Лекарства",
		"Articles": "Статьи",
		"OpenMenu": "Открыть меню",
		"CloseMenu": "Закрыть меню",
		"MobileMenu": "Меню навигации"
	},
	"sr": {
		"GoToMainPage": "Idi na početnu stranicu",
		"Doctors": "Lekari",
		"Clinics": "Klinike",
		"LabTests": "Analize",
		"MedicalServices": "Usluge",
		"Medications": "Lekovi",
		"Articles": "Članci",
		"OpenMenu": "Otvorite meni",
		"CloseMenu": "Zatvorite meni",
		"MobileMenu": "Navigacioni meni"
	},
	"sr-cyrl": {
		"GoToMainPage": "Иди на почетну страницу",
		"Doctors": "Лекари",
		"Clinics": "Клинике",
		"LabTests": "Анализе",
		"MedicalServices": "Услуге",
		"Medications": "Лекови",
		"Articles": "Чланци",
		"OpenMenu": "Отворите мени",
		"CloseMenu": "Затворите мени",
		"MobileMenu": "Навигациони мени"
	},
	"de": {
		"GoToMainPage": "Zur Startseite gehen",
		"Doctors": "Ärzte",
		"Clinics": "Kliniken",
		"LabTests": "Labortests",
		"MedicalServices": "Medizinische Dienstleistungen",
		"Medications": "Medikamente",
		"Articles": "Artikel",
		"OpenMenu": "Menü öffnen",
		"CloseMenu": "Menü schließen",
		"MobileMenu": "Navigationsmenü"
	},
	"tr": {
		"GoToMainPage": "Ana sayfaya git",
		"Doctors": "Doktorlar",
		"Clinics": "Klinikler",
		"LabTests": "Laboratuvar Testleri",
		"MedicalServices": "Tıbbi Hizmetler",
		"Medications": "İlaçlar",
		"Articles": "Makaleler",
		"OpenMenu": "Menüyü aç",
		"CloseMenu": "Menüyü kapat",
		"MobileMenu": "Gezinme menüsü"
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
		font-size: var(--font-size-base);
		font-weight: 500;
		color: var(--color-text-secondary);
		text-decoration: none;
		padding: var(--spacing-sm) var(--spacing-md);
		border-radius: var(--border-radius-sm);
		transition: all 0.2s ease;
		white-space: nowrap;

		.nav-icon {
			width: 20px;
			height: 20px;
			flex-shrink: 0;
		}

		&:hover {
			color: var(--color-primary);
			background: rgba(79, 70, 229, 0.06);
		}

		&.is-active {
			color: var(--color-primary);
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
		/* Сжимаемый (min-width: 0), чтобы при нехватке места первым
		   ужималось имя пользователя, а не ломалась шапка */
		min-width: 0;
	}

	// Компактные контролы (переключатель языка + гамбургер), только мобильные экраны
	&__mobile-controls {
		display: none;
		align-items: center;
		gap: var(--spacing-sm);
		flex-shrink: 0;

		// Высота триггера языка по умолчанию — по контенту (auto);
		// здесь выравниваем её с квадратной кнопкой-гамбургером (40px)
		:deep(.language-switcher__trigger) {
			height: 40px;
		}
	}

	&__burger {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		gap: 4px;
		width: 40px;
		height: 40px;
		padding: 0;
		background: var(--color-bg-secondary);
		border: 1px solid var(--color-border-secondary);
		border-radius: var(--border-radius-md);
		cursor: pointer;
		flex-shrink: 0;

		span {
			display: block;
			width: 18px;
			height: 2px;
			background: var(--color-text-primary);
			border-radius: 2px;
		}

		&:hover {
			background: var(--color-bg-tertiary);
		}
	}

	&__backdrop {
		position: fixed;
		inset: 0;
		background: rgba(15, 23, 42, 0.45);
		z-index: var(--z-modal);
	}

	&__drawer {
		position: fixed;
		top: 0;
		right: 0;
		bottom: 0;
		width: min(320px, 85vw);
		background: white;
		z-index: calc(var(--z-modal) + 1);
		display: flex;
		flex-direction: column;
		box-shadow: -8px 0 24px rgba(0, 0, 0, 0.12);
		overflow-y: auto;
		box-sizing: border-box;
		padding: var(--spacing-lg);
	}

	&__drawer-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--spacing-md);
		padding-bottom: var(--spacing-lg);
		border-bottom: 1px solid var(--color-border-secondary);
		margin-bottom: var(--spacing-lg);
	}

	&__drawer-close {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 36px;
		height: 36px;
		flex-shrink: 0;
		background: var(--color-bg-secondary);
		border: 1px solid var(--color-border-secondary);
		border-radius: var(--border-radius-md);
		color: var(--color-text-secondary);
		cursor: pointer;

		&:hover {
			background: var(--color-bg-tertiary);
		}
	}

	&__drawer-location {
		margin-bottom: var(--spacing-lg);

		:deep(.header-location) {
			width: 100%;
		}
	}

	&__drawer-nav {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
	}

	&__drawer-link {
		display: flex;
		align-items: center;
		gap: var(--spacing-md);
		padding: var(--spacing-md);
		border-radius: var(--border-radius-md);
		color: var(--color-text-secondary);
		text-decoration: none;
		font-size: var(--font-size-base);
		font-weight: 500;

		.nav-icon {
			width: 22px;
			height: 22px;
			flex-shrink: 0;
		}

		&:hover {
			background: var(--color-bg-secondary);
		}

		&.is-active {
			color: var(--color-primary);
			font-weight: 600;
			background: rgba(79, 70, 229, 0.1);
		}
	}

	&__drawer-divider {
		height: 1px;
		background: var(--color-border-secondary);
		margin: var(--spacing-sm) 0;
	}
}

.app-header-fade-enter-active,
.app-header-fade-leave-active {
	transition: opacity 0.2s ease;
}

.app-header-fade-enter-from,
.app-header-fade-leave-to {
	opacity: 0;
}

.app-header-slide-enter-active,
.app-header-slide-leave-active {
	transition: transform 0.25s ease;
}

.app-header-slide-enter-from,
.app-header-slide-leave-to {
	transform: translateX(100%);
}

@media only screen and (max-width: 1024px) {
	.app-header {
		&__main-content {
			flex-wrap: nowrap;
			padding: var(--spacing-sm) var(--spacing-md);
		}

		&__nav,
		&__actions {
			display: none;
		}

		&__mobile-controls {
			display: flex;
		}
	}
}
</style>
