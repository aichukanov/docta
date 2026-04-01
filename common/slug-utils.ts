const SERBIAN_TRANSLITERATION: Record<string, string> = {
	č: 'c',
	ć: 'c',
	š: 's',
	ž: 'z',
	đ: 'dj',
	Č: 'C',
	Ć: 'C',
	Š: 'S',
	Ž: 'Z',
	Đ: 'Dj',
};

function transliterate(str: string): string {
	return str.replace(
		/[čćšžđČĆŠŽĐ]/g,
		(char) => SERBIAN_TRANSLITERATION[char] || char,
	);
}

export function generateSlug(name: string): string {
	return transliterate(name)
		.toLowerCase()
		.replace(/[^a-z0-9\s-]/g, '')
		.replace(/[\s]+/g, '-')
		.replace(/-+/g, '-')
		.replace(/^-|-$/g, '');
}
