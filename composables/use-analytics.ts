import mixpanel from 'mixpanel-browser';

export function useAnalytics() {
	const config = useRuntimeConfig();
	const { gtag } = useGtag();
	const { isConsentGiven } = useCookieControl();

	const initMixpanel = () => {
		if (config.public.mixpanelToken && isConsentGiven.value) {
			mixpanel.init(config.public.mixpanelToken, {
				debug: process.env.NODE_ENV !== 'production',
				track_pageview: true,
				persistence: 'localStorage',
				ignore_dnt: true,
			});
		}
	};

	const initCloudflare = () => {
		if (typeof window === 'undefined' || !isConsentGiven.value) {
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
			mixpanel.track(eventName, properties);
		}
	};

	const identifyUser = (userId: string) => {
		if (isConsentGiven.value) {
			mixpanel.identify(userId);
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
