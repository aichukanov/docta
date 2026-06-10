export type MedicineFormCategory =
	| 'tablet'
	| 'capsule'
	| 'syrup'
	| 'injection'
	| 'drops'
	| 'topical'
	| 'spray'
	| 'patch'
	| 'powder'
	| 'other';

// Rules are checked in order — priority matters: the route of administration
// beats the physical form. E.g. 'prašak za rastvor za injekciju' is a powder,
// but it ends up injected → 'injection'; 'prašak za inhalaciju' → 'spray'.
// Keywords are matched against the canonical (source, Serbian Latin) form
// name from the CInMED registry (med_pharma_forms.name), lowercased.
const FORM_CATEGORY_RULES: Array<{
	pattern: RegExp;
	category: MedicineFormCategory;
}> = [
	// Anything injected/infused, incl. pre-filled šprices, cartridges, pens
	// and solvents for parenteral use
	{
		pattern: /inj|inf|špric|sprc|kartridž|pen\b|parenteral/,
		category: 'injection',
	},
	// Inhalations and nebulization come before generic liquid forms
	{ pattern: /inhal|raspršiv|nebul/, category: 'spray' },
	{ pattern: /sprej/, category: 'spray' },
	// 'kapi za oči/uši/nos' and 'oralne kapi' (must not catch 'kapsula')
	{ pattern: /kapi\b/, category: 'drops' },
	{ pattern: /supozitor|vagitor/, category: 'other' },
	{ pattern: /flaster/, category: 'patch' },
	// Solid oral forms ('tablet' before 'za oralnu suspenziju' fallthrough)
	{ pattern: /tablet|pastil|lozeng|guma/, category: 'tablet' },
	{ pattern: /kapsul/, category: 'capsule' },
	// Oral liquids (incl. powders/granules dissolved into one) and
	// mouth rinses/gargles — all dispensed in a syrup-like bottle
	{
		pattern:
			/sirup|oralni rastvor|oralna suspenz|oralna emulz|za oralnu|liofilizat|ispiranje usta|grglja|usnu sluznicu/,
		category: 'syrup',
	},
	// Gels, creams, ointments, cutaneous solutions etc.
	{
		pattern: /gel|krem|mast|šampon|lak|pena|rastvor za kožu/,
		category: 'topical',
	},
	{ pattern: /prašak|prašk|granul/, category: 'powder' },
];

export function getMedicineFormCategory(
	formSrcName: string | null | undefined,
): MedicineFormCategory {
	const name = (formSrcName || '').toLowerCase().trim();
	if (!name) return 'other';

	for (const rule of FORM_CATEGORY_RULES) {
		if (rule.pattern.test(name)) {
			return rule.category;
		}
	}

	return 'other';
}
