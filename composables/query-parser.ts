type NullableString = string | null;
export type QueryValue = NullableString | NullableString[];

export function getArrayFromQuery(value: QueryValue) {
	if (!value) {
		return [];
	} else if (typeof value === 'string') {
		return [parseInt(value)];
	} else {
		return (value as string[]).map((value) => parseInt(value));
	}
}

export function getNumberFromQuery(value: QueryValue, min = 0) {
	if (value && typeof value === 'string') {
		const intValue = parseInt(value);
		return intValue > min ? intValue : null;
	}

	return null;
}

export function getStringFromQuery(value: QueryValue) {
	return (Array.isArray(value) ? value[0] : value)?.slice(0, 100) || '';
}
