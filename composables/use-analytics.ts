// mixpanel-browser подключается динамически: библиотека не попадает в общий
// бандл и грузится только после согласия пользователя на аналитику
let mixpanelInstance: (typeof import('mixpanel-browser'))['default'] | null =
	null;
let mixpanelLoadPromise: Promise<void> | null = null;

export function useAnalytics() {
	const config = useRuntimeConfig();
	const { gtag } = useGtag();
	const { isConsentGiven } = useCookieControl();

	const initMixpanel = () => {
		if (!import.meta.client) return;
		if (!config.public.mixpanelToken || !isConsentGiven.value) return;

		if (!mixpanelLoadPromise) {
			mixpanelLoadPromise = import('mixpanel-browser').then(
				({ default: mixpanel }) => {
					mixpanel.init(config.public.mixpanelToken, {
						debug: import.meta.dev,
						track_pageview: true,
						persistence: 'localStorage',
						ignore_dnt: true,
						api_host: 'https://api-eu.mixpanel.com',
					});
					mixpanelInstance = mixpanel;
				},
			);
		}
	};

	const initCloudflare = () => {
		if (typeof window === 'undefined') {
			return;
		}

		const domain = window.location.hostname;

		if (domain === 'localhost') {
			console.log('Cloudflare is not initialized on localhost');
			return;
		}

		const token = config.public.cloudflareToken;

		if (!token) {
			console.error('Token for cloudflare is not defined. Domain:', domain);
			return;
		}

		const script = document.createElement('script');
		script.async = true;
		script.src = 'https://static.cloudflareinsights.com/beacon.min.js';
		script.dataset.cfBeacon = JSON.stringify({
			token: token,
		});

		document.body.appendChild(script);
	};

	const initGTag = () => {
		gtag('consent', 'update', {
			ad_user_data: 'granted',
			ad_personalization: 'granted',
			ad_storage: 'granted',
			analytics_storage: 'granted',
		});
	};

	const trackEvent = (eventName: string, properties?: Record<string, any>) => {
		if (isConsentGiven.value) {
			mixpanelInstance?.track(eventName, properties);
		}
	};

	const identifyUser = (userId: string) => {
		if (isConsentGiven.value) {
			mixpanelInstance?.identify(userId);
		}
	};

	return {
		initMixpanel,
		initCloudflare,
		initGTag,
		trackEvent,
		identifyUser,
	};
}
