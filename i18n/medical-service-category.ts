import { MedicalServiceCategory } from '~/enums/medical-service-category';

export default {
	messages: {
		'en': {
			ServiceCategory: 'Category',
			AnyServiceCategory: 'Any category',
			SearchServiceCategory: 'Search category',
			ServiceCategoryNotFound: 'Category not found',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]: 'MRI',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]: 'MSCT',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]: 'X-Ray',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]:
				'Ultrasound',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Physiotherapy',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Gastroenterology',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Gynecology',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Cardiology',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'General Medicine',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Orthopedics',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Otorhinolaryngology (ENT)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Pulmonology',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Medical Transport',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Surgical Examination',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Ambulatory Surgery',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Gynecological Surgery',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'General Surgery',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Abdominal Surgery',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Plastic Surgery',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Pain Therapy',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Dentistry',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Neurology',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]: 'Urology',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Ophthalmology',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Dermatology & Aesthetics',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Pediatrics',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Endocrinology',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Allergology',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Laboratory Services',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Injections & Infusions',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Home Visits',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Wound Care',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Ophthalmic Surgery',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Orthodontics',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Pediatric Dentistry',
		},
		'ru': {
			ServiceCategory: 'Категория',
			AnyServiceCategory: 'Любая категория',
			SearchServiceCategory: 'Поиск категории',
			ServiceCategoryNotFound: 'Категория не найдена',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]: 'МРТ',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]: 'МСКТ',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]: 'Рентген',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]: 'УЗИ',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Физиотерапия',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Гастроэнтерология',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Гинекология',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Кардиология',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'Общая медицина',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Ортопедия',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Оториноларингология (ЛОР)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Пульмонология',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Санитарный транспорт',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Осмотр хирурга',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Амбулаторная хирургия',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Гинекологическая хирургия',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'Общая хирургия',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Абдоминальная хирургия',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Пластическая хирургия',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Терапия боли',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Стоматология',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Неврология',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]:
				'Урология',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Офтальмология',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Дерматология и эстетика',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Педиатрия',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Эндокринология',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Аллергология',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Лабораторные услуги',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Инъекции и инфузии',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Домашние визиты',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Обработка ран',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Офтальмохирургия',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Ортодонтия',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Детская стоматология',
		},
		'sr': {
			ServiceCategory: 'Kategorija',
			AnyServiceCategory: 'Bilo koja kategorija',
			SearchServiceCategory: 'Pretraži kategoriju',
			ServiceCategoryNotFound: 'Kategorija nije pronađena',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]:
				'Magnetna rezonanca (MR)',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]:
				'Multislajsni skener (MSCT)',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]:
				'Rendgen (RTG)',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]:
				'Ultrazvuk (UZ)',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Fizioterapija',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Gastroenterologija',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Ginekologija',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Kardiologija',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'Opšta medicina',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Ortopedija',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Otorinolaringologija (ORL)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Pulmologija',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Sanitetski prevoz',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Specijalistički pregled hirurga',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Ambulantna hirurgija',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Ginekološka hirurgija',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'Opšta hirurgija',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Abdominalna hirurgija',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Plastična hirurgija',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Terapija bola',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Stomatologija',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Neurologija',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]:
				'Urologija',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Oftalmologija',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Dermatologija i estetika',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Pedijatrija',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Endokrinologija',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Alergologija',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Laboratorijske usluge',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Injekcije i infuzije',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Kućne posete',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Nega rana',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Oftalmološka hirurgija',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Ortodoncija',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Dečja stomatologija',
		},
		'sr-cyrl': {
			ServiceCategory: 'Категорија',
			AnyServiceCategory: 'Било која категорија',
			SearchServiceCategory: 'Претражи категорију',
			ServiceCategoryNotFound: 'Категорија није пронађена',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]:
				'Магнетна резонанца (МР)',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]:
				'Мултислајсни скенер (МСЦТ)',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]:
				'Рендген (РТГ)',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]:
				'Ултразвук (УЗ)',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Физиотерапија',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Гастроентерологија',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Гинекологија',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Кардиологија',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'Општа медицина',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Ортопедија',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Оториноларингологија (ОРЛ)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Пулмологија',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Санитетски превоз',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Специјалистички преглед хирурга',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Амбулантна хирургија',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Гинеколошка хирургија',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'Општа хирургија',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Абдоминална хирургија',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Пластична хирургија',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Терапија бола',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Стоматологија',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Неурологија',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]:
				'Урологија',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Офталмологија',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Дерматологија и естетика',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Педијатрија',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Ендокринологија',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Алергологија',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Лабораторијске услуге',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Ињекције и инфузије',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Кућне посете',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Нега рана',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Офталмолошка хирургија',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Ортодонција',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Дечја стоматологија',
		},
		'de': {
			ServiceCategory: 'Kategorie',
			AnyServiceCategory: 'Beliebige Kategorie',
			SearchServiceCategory: 'Kategorie suchen',
			ServiceCategoryNotFound: 'Kategorie nicht gefunden',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]: 'MRT',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]: 'MSCT',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]: 'Röntgen',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]:
				'Ultraschall',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Physiotherapie',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Gastroenterologie',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Gynäkologie',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Kardiologie',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'Allgemeinmedizin',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Orthopädie',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Hals-Nasen-Ohren-Heilkunde (HNO)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Pneumologie',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Krankentransport',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Chirurgische Untersuchung',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Ambulante Chirurgie',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Gynäkologische Chirurgie',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'Allgemeinchirurgie',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Abdominalchirurgie',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Plastische Chirurgie',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Schmerztherapie',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Zahnmedizin',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Neurologie',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]:
				'Urologie',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Augenheilkunde',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Dermatologie & Ästhetik',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Pädiatrie',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Endokrinologie',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Allergologie',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Laborleistungen',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Injektionen & Infusionen',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Hausbesuche',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Wundversorgung',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Augenchirurgie',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Kieferorthopädie',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Kinderzahnheilkunde',
		},
		'tr': {
			ServiceCategory: 'Kategori',
			AnyServiceCategory: 'Herhangi bir kategori',
			SearchServiceCategory: 'Kategori ara',
			ServiceCategoryNotFound: 'Kategori bulunamadı',

			[`medical_service_category_${MedicalServiceCategory.MRI}`]: 'MR',
			[`medical_service_category_${MedicalServiceCategory.MSCT}`]: 'MSBT',
			[`medical_service_category_${MedicalServiceCategory.XRAY}`]: 'Röntgen',
			[`medical_service_category_${MedicalServiceCategory.ULTRASOUND}`]:
				'Ultrason',
			[`medical_service_category_${MedicalServiceCategory.PHYSIOTHERAPY}`]:
				'Fizyoterapi',
			[`medical_service_category_${MedicalServiceCategory.GASTROENTEROLOGY}`]:
				'Gastroenteroloji',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGY}`]:
				'Jinekoloji',
			[`medical_service_category_${MedicalServiceCategory.CARDIOLOGY}`]:
				'Kardiyoloji',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_MEDICINE}`]:
				'Genel Tıp',
			[`medical_service_category_${MedicalServiceCategory.ORTHOPEDICS}`]:
				'Ortopedi',
			[`medical_service_category_${MedicalServiceCategory.ENT}`]:
				'Kulak Burun Boğaz (KBB)',
			[`medical_service_category_${MedicalServiceCategory.PULMONOLOGY}`]:
				'Göğüs Hastalıkları',
			[`medical_service_category_${MedicalServiceCategory.MEDICAL_TRANSPORT}`]:
				'Sağlık Taşımacılığı',
			[`medical_service_category_${MedicalServiceCategory.SURGICAL_EXAMINATION}`]:
				'Cerrahi Muayene',
			[`medical_service_category_${MedicalServiceCategory.AMBULATORY_SURGERY}`]:
				'Ayakta Cerrahi',
			[`medical_service_category_${MedicalServiceCategory.GYNECOLOGICAL_SURGERY}`]:
				'Jinekolojik Cerrahi',
			[`medical_service_category_${MedicalServiceCategory.GENERAL_SURGERY}`]:
				'Genel Cerrahi',
			[`medical_service_category_${MedicalServiceCategory.ABDOMINAL_SURGERY}`]:
				'Karın Cerrahisi',
			[`medical_service_category_${MedicalServiceCategory.PLASTIC_SURGERY}`]:
				'Plastik Cerrahi',
			[`medical_service_category_${MedicalServiceCategory.PAIN_THERAPY}`]:
				'Ağrı Tedavisi',
			[`medical_service_category_${MedicalServiceCategory.DENTISTRY}`]:
				'Diş Hekimliği',
			[`medical_service_category_${MedicalServiceCategory.NEUROLOGY}`]:
				'Nöroloji',
			[`medical_service_category_${MedicalServiceCategory.UROLOGY}`]: 'Üroloji',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMOLOGY}`]:
				'Göz Hastalıkları',
			[`medical_service_category_${MedicalServiceCategory.DERMATOLOGY}`]:
				'Dermatoloji ve Estetik',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRICS}`]:
				'Pediatri',
			[`medical_service_category_${MedicalServiceCategory.ENDOCRINOLOGY}`]:
				'Endokrinoloji',
			[`medical_service_category_${MedicalServiceCategory.ALLERGOLOGY}`]:
				'Alerji',
			[`medical_service_category_${MedicalServiceCategory.LABORATORY_SERVICES}`]:
				'Laboratuvar Hizmetleri',
			[`medical_service_category_${MedicalServiceCategory.INJECTIONS_INFUSIONS}`]:
				'Enjeksiyonlar ve İnfüzyonlar',
			[`medical_service_category_${MedicalServiceCategory.HOME_VISITS}`]:
				'Ev Ziyaretleri',
			[`medical_service_category_${MedicalServiceCategory.WOUND_CARE}`]:
				'Yara Bakımı',
			[`medical_service_category_${MedicalServiceCategory.OPHTHALMIC_SURGERY}`]:
				'Göz Cerrahisi',
			[`medical_service_category_${MedicalServiceCategory.ORTHODONTICS}`]:
				'Ortodonti',
			[`medical_service_category_${MedicalServiceCategory.PEDIATRIC_DENTISTRY}`]:
				'Çocuk Diş Hekimliği',
		},
	},
};
