// Подписи сворачиваемых секций карточки клиники (components/clinic/summary.vue).
//
// Словарь вынесен из SFC в модуль не ради порядка: внутри `<script setup>`
// top-level `const` попадает в тело `setup()` и пересоздаётся на каждый
// экземпляр, а карточка клиники рендерится десятками на листинге. В браузере
// vue-i18n держит messages в обычном `ref`, то есть каждая копия обрастала
// собственными reactive-прокси и своей картой зависимостей. Модульный объект
// один на все экземпляры, и прокси поверх него Vue тоже переиспользует.
export default {
	messages: {
		'en': {
			Contacts: 'Contacts',
			AvailableServices: 'Specialty services',
			Doctors: 'Specialists',
		},
		'ru': {
			Contacts: 'Контакты',
			AvailableServices: 'Профильные услуги',
			Doctors: 'Специалисты',
		},
		'de': {
			Contacts: 'Kontakte',
			AvailableServices: 'Fachleistungen',
			Doctors: 'Spezialisten',
		},
		'tr': {
			Contacts: 'İletişim',
			AvailableServices: 'Uzmanlık hizmetleri',
			Doctors: 'Uzmanlar',
		},
		'sr': {
			Contacts: 'Kontakti',
			AvailableServices: 'Profilne usluge',
			Doctors: 'Stručnjaci',
		},
		'sr-cyrl': {
			Contacts: 'Контакти',
			AvailableServices: 'Профилне услуге',
			Doctors: 'Стручњаци',
		},
	},
};
