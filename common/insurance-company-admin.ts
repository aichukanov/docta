export interface AdminBranchRow {
	id: number | null;
	cityId: number | null;
	address_sr: string;
	address_sr_cyrl: string;
	town_sr: string;
	town_sr_cyrl: string;
	postalCode: string;
	latitude: string;
	longitude: string;
	phone: string;
	email: string;
	workingHours: string;
}

export const createEmptyBranch = (): AdminBranchRow => ({
	id: null,
	cityId: null,
	address_sr: '',
	address_sr_cyrl: '',
	town_sr: '',
	town_sr_cyrl: '',
	postalCode: '',
	latitude: '',
	longitude: '',
	phone: '',
	email: '',
	workingHours: '',
});
