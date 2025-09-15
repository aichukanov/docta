import { locales, Locale } from '~/composables/use-locale';

type MessageList = Record<Locale, Record<string, string>>;

export function combineI18nMessages(messageLists: MessageList[]): MessageList {
	const combined: MessageList = Object.fromEntries(
		locales.map((locale) => [locale, {}]),
	);

	for (let i = 0; i < messageLists.length; i++) {
		const { messages } = messageLists[i];
		for (const locale in messages) {
			combined[locale] = Object.assign(combined[locale], messages[locale]);
		}
	}

	return combined;
}
