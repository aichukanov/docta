import { locales } from '~/composables/use-locale';

type Messages = Record<string, Record<string, string>>;
type MessageList = { messages: Messages };

export function combineI18nMessages(messageLists: MessageList[]): Messages {
	const combined: Messages = Object.fromEntries(
		locales.map((locale) => [locale, {}]),
	);

	for (let i = 0; i < messageLists.length; i++) {
		const { messages } = messageLists[i];
		for (const locale in messages) {
			if (!combined[locale]) {
				console.error(`Locale "${locale}" not found in combined messages`);
				continue;
			}

			combined[locale] = Object.assign(combined[locale], messages[locale]);
		}
	}

	return combined;
}
