type ConsentValue = 'accepted' | 'declined' | null;

const isModalActive = ref(false);

export function useCookieControl() {
	const consentCookie = useCookie<ConsentValue>('ncc_c', {
		maxAge: 60 * 60 * 24 * 365, // 1 year
		default: () => null,
	});

	// Одно значение на приложение. У каждого вызова useCookie() свой ref, и
	// между ними Nuxt разносит новое значение асинхронно (событие cookieStore).
	// Из-за этого watch в layout по своему ref'у уже вызывал initMixpanel(), а
	// композабл аналитики по своему ещё видел «согласия нет» и выходил —
	// Mixpanel после клика «Разрешить» не стартовал до следующей полной
	// загрузки. useState синхронен и SSR-безопасен; cookie остаётся хранилищем,
	// а watch подхватывает смену из другой вкладки.
	const consent = useState<ConsentValue>(
		'cookie-consent',
		() => consentCookie.value,
	);
	watch(consentCookie, (value) => {
		consent.value = value;
	});

	const setConsent = (value: ConsentValue) => {
		consent.value = value;
		consentCookie.value = value;
	};

	const isConsentGiven = computed(() => consent.value === 'accepted');
	const isConsentDecided = computed(() => consent.value !== null);

	const giveConsent = () => setConsent('accepted');
	const declineConsent = () => setConsent('declined');
	const revokeConsent = () => setConsent(null);

	return {
		isConsentGiven: readonly(isConsentGiven),
		isConsentDecided: readonly(isConsentDecided),
		isModalActive,
		giveConsent,
		declineConsent,
		revokeConsent,
	};
}
