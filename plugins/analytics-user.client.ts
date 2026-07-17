// Связывает auth-флоу с аналитикой: identify при логине, reset при логауте.
// Плагин, а не вызов в сторе: стор выполняется и на сервере, а identify имеет
// смысл только в браузере и только после согласия на cookies.
export default defineNuxtPlugin(() => {
	const userStore = useUserStore();
	const { identifyUser, resetUser } = useAnalytics();
	const { isConsentGiven } = useCookieControl();

	watch(
		[() => userStore.user, isConsentGiven],
		([user, consentGiven], [prevUser]) => {
			if (!consentGiven) return;

			if (user) {
				identifyUser(user.id, { auth_provider: user.auth_provider });
			} else if (prevUser) {
				// был залогинен и вышел — отвязываем устройство от профиля
				resetUser();
			}
		},
		{ immediate: true },
	);
});
