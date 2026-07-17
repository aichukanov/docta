/**
 * Маскирует email для публичного отображения (prd/user-profile, FR-17..FR-20):
 * первая буква локальной части + звёздочки, первая буква домена + звёздочки,
 * расширение домена частично скрыто.
 *
 * maskEmail('user@gmail.com')   -> 'u*****@g****.*om'
 * maskEmail('admin@example.org') -> 'a*****@e****.*rg'
 */
export function maskEmail(email: string): string {
	const atIndex = email.indexOf('@');
	if (atIndex <= 0 || atIndex === email.length - 1) {
		return '*****';
	}

	const localPart = email.slice(0, atIndex);
	const domain = email.slice(atIndex + 1);

	const [domainName, ...extensions] = domain.split('.');
	if (!domainName) {
		return '*****';
	}

	const maskedLocal = localPart[0] + '*****';
	const maskedDomain = domainName[0] + '****';
	const maskedExtension = extensions
		.map((ext) => (ext.length <= 2 ? ext : '*' + ext.slice(1)))
		.join('.');

	return maskedExtension
		? `${maskedLocal}@${maskedDomain}.${maskedExtension}`
		: `${maskedLocal}@${maskedDomain}`;
}
