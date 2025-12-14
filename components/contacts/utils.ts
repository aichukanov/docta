import type { ContactList } from '~/interfaces/contacts';

export {
	formatPhoneNumber,
	isAbsoluteUrl,
	isPhoneNumber,
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
	normalizeWebsiteUrl,
	splitContacts,
} from '~/common/contacts';

export function hasContacts(list: ContactList): boolean {
	return !!(
		list.website ||
		list.phone ||
		list.email ||
		list.facebook ||
		list.instagram ||
		list.telegram ||
		list.whatsapp ||
		list.viber
	);
}
