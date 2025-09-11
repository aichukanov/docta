import { CityId } from '~/enums/cities';

const sr = {
	City: 'Grad',
	AnyCity: 'Bilo koji grad',

	[CityId.PODGORICA]: 'Podgorica',
	[CityId.NIKSIC]: 'Nikšić',
	[CityId.BUDVA]: 'Budva',
	[CityId.TIVAT]: 'Tivat',
	[CityId.ULCINJ]: 'Ulcinj',
	[CityId.KOTOR]: 'Kotor',
};

export default {
	messages: {
		en: {
			City: 'City',
			AnyCity: 'Any city',
			[CityId.PODGORICA]: 'Podgorica',
			[CityId.NIKSIC]: 'Niksic',
			[CityId.BUDVA]: 'Budva',
			[CityId.TIVAT]: 'Tivat',
			[CityId.ULCINJ]: 'Ulcinj',
			[CityId.KOTOR]: 'Kotor',
		},
		ru: {
			City: 'Город',
			AnyCity: 'Любой город',

			[CityId.PODGORICA]: 'Подгорица',
			[CityId.NIKSIC]: 'Никшич',
			[CityId.BUDVA]: 'Будва',
			[CityId.TIVAT]: 'Тиват',
			[CityId.ULCINJ]: 'Ульцинь',
			[CityId.KOTOR]: 'Котор',
		},
		sr,
		ba: sr,
		me: sr,
		de: {
			City: 'Ort',
			AnyCity: 'Beliebiger Ort',

			[CityId.PODGORICA]: 'Podgorica',
			[CityId.NIKSIC]: 'Niksic',
			[CityId.BUDVA]: 'Budva',
			[CityId.TIVAT]: 'Tivat',
			[CityId.ULCINJ]: 'Ulcinj',
			[CityId.KOTOR]: 'Kotor',
		},
		tr: {
			City: 'Şehir',
			AnyCity: 'Herhangi bir şehir',

			[CityId.PODGORICA]: 'Podgorica',
			[CityId.NIKSIC]: 'Niksic',
			[CityId.BUDVA]: 'Budva',
			[CityId.TIVAT]: 'Tivat',
			[CityId.ULCINJ]: 'Ulcinj',
			[CityId.KOTOR]: 'Kotor',
		},
	},
};
