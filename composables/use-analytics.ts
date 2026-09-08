import type { ComputedRef, InjectionKey } from 'vue';
import type {
	AnalyticsAuthProvider,
	AnalyticsEntityRef,
	AnalyticsEntityType,
	AnalyticsEventName,
	AnalyticsEvents,
} from '~/types/analytics';

type Mixpanel = (typeof import('mixpanel-browser'))['default'];

// mixpanel-browser подключается динамически: библиотека не попадает в общий
// бандл и грузится только после согласия пользователя на аналитику
let mixpanelInstance: Mixpanel | null = null;
let mixpanelLoadPromise: Promise<void> | null = null;

// Первичный запуск аналитики — в простое браузера после гидрации. SDK Mixpanel
// и gtag.js вместе ~290 КБ JS; стартуя прямо в setup, они конкурировали с LCP
// и давали основную часть TBT (docs/audit/lighthouse-perf-2026-09.md, этап 2).
// `timeout` — чтобы на занятой вкладке запуск не откладывался бесконечно.
// Safari без requestIdleCallback — просто пауза.
const runWhenIdle = (fn: () => void) => {
	if (typeof window.requestIdleCallback === 'function') {
		window.requestIdleCallback(() => fn(), { timeout: 3000 });
	} else {
		window.setTimeout(fn, 2000);
	}
};

// Тип страницы по имени роута — идёт в super property page_type и в каждое
// событие, чтобы воронки различали источник (service_detail → clinic и т.п.)
const ROUTE_PAGE_TYPES: Record<string, string> = {
	'index': 'home',
	'clinics': 'clinic_list',
	'clinics-clinicSlug': 'clinic_detail',
	'clinics-clinicSlug-reviews': 'clinic_reviews',
	'clinics-clinicSlug-doctors': 'clinic_doctors',
	'clinics-clinicSlug-services': 'clinic_services',
	'clinics-clinicSlug-labtests': 'clinic_labtests',
	'doctors': 'doctor_list',
	'doctors-doctorSlug': 'doctor_detail',
	'doctors-doctorSlug-reviews': 'doctor_reviews',
	'services': 'service_list',
	'services-serviceSlug': 'service_detail',
	'labtests': 'labtest_list',
	'labtests-labTestSlug': 'labtest_detail',
	'medicines': 'medicine_list',
	'medicines-medicineSlug': 'medicine_detail',
	'articles': 'article_list',
};

export function getPageType(routeName: unknown): string {
	if (typeof routeName !== 'string') return 'other';
	if (routeName in ROUTE_PAGE_TYPES) return ROUTE_PAGE_TYPES[routeName];
	if (routeName.startsWith('articles-')) return 'article';
	// служебные страницы (login, profile, about…) — имя роута как есть
	return routeName;
}

// Целевой тип сущности по имени детального роута — для карточек, которые
// получают routeName пропсом (PricedItemCard, ListCard)
const DETAIL_ROUTE_ENTITY_TYPES: Record<string, AnalyticsEntityType> = {
	'clinics-clinicSlug': 'clinic',
	'doctors-doctorSlug': 'doctor',
	'services-serviceSlug': 'service',
	'labtests-labTestSlug': 'labtest',
	'medicines-medicineSlug': 'medicine',
};

export function getEntityTypeByRouteName(
	routeName?: string,
): AnalyticsEntityType | null {
	if (!routeName) return null;
	return DETAIL_ROUTE_ENTITY_TYPES[routeName] ?? null;
}

// Контактные компоненты переиспользуются на разных страницах и не знают,
// чьи контакты рендерят — сущность-владелец передаётся через provide/inject
const analyticsEntityKey: InjectionKey<ComputedRef<AnalyticsEntityRef | null>> =
	Symbol('analytics-entity');

const emptyAnalyticsEntity = computed<AnalyticsEntityRef | null>(() => null);

export function provideAnalyticsEntity(
	entity: ComputedRef<AnalyticsEntityRef | null>,
): void {
	provide(analyticsEntityKey, entity);
}

export function useAnalyticsEntity(): ComputedRef<AnalyticsEntityRef | null> {
	return inject(analyticsEntityKey, emptyAnalyticsEntity);
}

export function useAnalytics() {
	const config = useRuntimeConfig();
	const { gtag, initialize: initializeGTag } = useGtag();
	const { isConsentGiven } = useCookieControl();
	const router = useRouter();
	// $i18n вместо useI18n(): композабл вызывается и вне setup (плагины)
	const i18nLocale = useNuxtApp().$i18n.locale;

	const registerSuperProperties = (mixpanel: Mixpanel, routeName: unknown) => {
		mixpanel.register({
			locale: i18nLocale.value,
			page_type: getPageType(routeName),
		});
	};

	const initMixpanel = () => {
		if (!import.meta.client) return;
		if (!config.public.mixpanelToken || !isConsentGiven.value) return;
		if (mixpanelInstance) {
			mixpanelInstance.opt_in_tracking();
			return;
		}

		if (!mixpanelLoadPromise) {
			mixpanelLoadPromise = import('mixpanel-browser').then(
				({ default: mixpanel }) => {
					if (!isConsentGiven.value) {
						mixpanelLoadPromise = null;
						return;
					}

					mixpanel.init(config.public.mixpanelToken, {
						debug: import.meta.dev,
						track_pageview: true,
						persistence: 'localStorage',
						ignore_dnt: true,
						api_host: 'https://api-eu.mixpanel.com',
					});
					registerSuperProperties(mixpanel, router.currentRoute.value.name);

					// track_pageview: true фиксирует только полную загрузку страницы —
					// клиентские переходы трекаем сами, заодно обновляя super properties
					router.afterEach((to, from) => {
						if (
							!isConsentGiven.value ||
							!from.matched.length ||
							to.fullPath === from.fullPath
						)
							return;
						registerSuperProperties(mixpanel, to.name);
						mixpanel.track_pageview();
					});

					mixpanelInstance = mixpanel;
				},
			);
		}
	};

	// Скрипт gtag.js модуль сам не подключает (`enabled: false` в nuxt.config) —
	// иначе он уезжал бы в <head> и грузился в критическом пути у всех.
	// Команды до его загрузки не теряются: они копятся в dataLayer.
	const loadGTag = () => {
		if (!import.meta.client || !config.public.gtagEnabled) return;
		initializeGTag();
	};

	// Точка входа для первичного запуска из layout: всё тяжёлое — после
	// гидрации и в простое. Смена согласия позже (клик по баннеру)
	// обрабатывается watch'ем в layout и стартует сразу.
	const startAnalytics = () => {
		if (!import.meta.client) return;
		onNuxtReady(() => {
			runWhenIdle(() => {
				loadGTag();
				if (isConsentGiven.value) {
					initMixpanel();
					initGTag();
				} else {
					disableAnalytics();
				}
			});
		});
	};

	const initGTag = () => {
		if (!import.meta.client) return;
		gtag('consent', 'update', {
			ad_user_data: 'granted',
			ad_personalization: 'granted',
			ad_storage: 'granted',
			analytics_storage: 'granted',
		});
	};

	const disableAnalytics = () => {
		if (!import.meta.client) return;
		gtag('consent', 'update', {
			ad_user_data: 'denied',
			ad_personalization: 'denied',
			ad_storage: 'denied',
			analytics_storage: 'denied',
		});

		mixpanelInstance?.opt_out_tracking({ delete_user: false });
	};

	// События не отправляются без согласия; если SDK ещё грузится после
	// согласия — событие не теряется, а ждёт окончания загрузки. Если
	// загрузка ещё не начата (отложенный старт), первое событие её запускает.
	const withMixpanel = (fn: (mixpanel: Mixpanel) => void) => {
		if (!import.meta.client || !isConsentGiven.value) return;

		if (mixpanelInstance) {
			fn(mixpanelInstance);
			return;
		}

		if (!mixpanelLoadPromise) initMixpanel();
		mixpanelLoadPromise?.then(() => {
			if (mixpanelInstance) fn(mixpanelInstance);
		});
	};

	const trackEvent = <E extends AnalyticsEventName>(
		eventName: E,
		properties: AnalyticsEvents[E],
	) => {
		withMixpanel((mixpanel) => {
			mixpanel.track(eventName, {
				page_type: getPageType(router.currentRoute.value.name),
				...properties,
			});
		});
	};

	const identifyUser = (
		userId: number | string,
		properties?: { auth_provider?: AnalyticsAuthProvider },
	) => {
		withMixpanel((mixpanel) => {
			mixpanel.identify(String(userId));
			if (properties?.auth_provider) {
				mixpanel.people.set({ auth_provider: properties.auth_provider });
			}
		});
	};

	const resetUser = () => {
		withMixpanel((mixpanel) => {
			mixpanel.reset();
		});
	};

	return {
		startAnalytics,
		initMixpanel,
		initGTag,
		disableAnalytics,
		trackEvent,
		identifyUser,
		resetUser,
	};
}
