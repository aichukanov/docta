type ConsentValue = 'accepted' | 'declined' | null;

const isModalActive = ref(false);

export function useCookieControl() {
	const consentCookie = useCookie<ConsentValue>('ncc_c', {
		maxAge: 60 * 60 * 24 * 365, // 1 year
		default: () => null,
	});

	const isConsentGiven = computed(() => consentCookie.value === 'accepted');
	const isConsentDecided = computed(() => consentCookie.value !== null);

	const giveConsent = () => {
		consentCookie.value = 'accepted';
	};

	const declineConsent = () => {
		consentCookie.value = 'declined';
	};

	const revokeConsent = () => {
		consentCookie.value = null;
	};

	return {
		isConsentGiven: readonly(isConsentGiven),
		isConsentDecided: readonly(isConsentDecided),
		isModalActive,
		giveConsent,
		declineConsent,
		revokeConsent,
	};
}
