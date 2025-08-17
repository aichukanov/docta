const isModalActive = ref(false);

export function useCookieControl() {
	const isConsentGiven = useCookie<boolean>('ncc_c', {
		maxAge: 60 * 60 * 24 * 365, // 1 year
	});

	const giveConsent = () => {
		isConsentGiven.value = true;
	};

	const revokeConsent = () => {
		isConsentGiven.value = false;
	};

	return {
		isConsentGiven: readonly(isConsentGiven),
		isModalActive,
		giveConsent,
		revokeConsent,
	};
}
