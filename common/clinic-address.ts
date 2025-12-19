import type { ClinicData } from '~/interfaces/clinic';

export function formatClinicAddressLine(options: {
	clinic: Pick<ClinicData, 'address' | 'town' | 'postalCode'>;
	cityName?: string;
}) {
	const parts = [
		options.clinic.address,
		options.clinic.town,
		options.cityName,
		options.clinic.postalCode,
	]
		.map((v) => (typeof v === 'string' ? v.trim() : ''))
		.filter((v) => v.length > 0);

	return parts.join(', ');
}
