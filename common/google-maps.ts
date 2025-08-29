export function createRouteUrl(latitude: number, longitude: number): string {
	if (!latitude || !longitude) {
		return '';
	}

	return `https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}&travelmode=driving`;
}
