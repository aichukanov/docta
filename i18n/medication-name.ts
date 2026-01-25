import { Medication } from '~/enums/medication';

export default {
	messages: {
		'en': {
			// Обезболивающие и противовоспалительные
			[`medication_${Medication.PARACETAMOL}`]: 'Paracetamol',
			[`medication_${Medication.IBUPROFEN}`]: 'Ibuprofen',
			[`medication_${Medication.ASPIRIN}`]: 'Aspirin',
			[`medication_${Medication.DICLOFENAC}`]: 'Diclofenac',
			[`medication_${Medication.KETOPROFEN}`]: 'Ketoprofen',
			[`medication_${Medication.NAPROXEN}`]: 'Naproxen',
			[`medication_${Medication.NIMESULIDE}`]: 'Nimesulide',
			[`medication_${Medication.MELOXICAM}`]: 'Meloxicam',

			// Антибиотики
			[`medication_${Medication.AMOXICILLIN}`]: 'Amoxicillin',
			[`medication_${Medication.AZITHROMYCIN}`]: 'Azithromycin',
			[`medication_${Medication.CIPROFLOXACIN}`]: 'Ciprofloxacin',
			[`medication_${Medication.CLARITHROMYCIN}`]: 'Clarithromycin',
			[`medication_${Medication.DOXYCYCLINE}`]: 'Doxycycline',
			[`medication_${Medication.CEPHALEXIN}`]: 'Cephalexin',
			[`medication_${Medication.METRONIDAZOLE}`]: 'Metronidazole',
			[`medication_${Medication.AMOXICILLIN_CLAVULANATE}`]:
				'Amoxicillin + Clavulanate',

			// Антигистаминные
			[`medication_${Medication.LORATADINE}`]: 'Loratadine',
			[`medication_${Medication.CETIRIZINE}`]: 'Cetirizine',
			[`medication_${Medication.DESLORATADINE}`]: 'Desloratadine',
			[`medication_${Medication.FEXOFENADINE}`]: 'Fexofenadine',
			[`medication_${Medication.LEVOCETIRIZINE}`]: 'Levocetirizine',

			// Препараты для ЖКТ
			[`medication_${Medication.OMEPRAZOLE}`]: 'Omeprazole',
			[`medication_${Medication.PANTOPRAZOLE}`]: 'Pantoprazole',
			[`medication_${Medication.RANITIDINE}`]: 'Ranitidine',
			[`medication_${Medication.DOMPERIDONE}`]: 'Domperidone',
			[`medication_${Medication.METOCLOPRAMIDE}`]: 'Metoclopramide',
			[`medication_${Medication.LACTULOSE}`]: 'Lactulose',
			[`medication_${Medication.BISACODYL}`]: 'Bisacodyl',
			[`medication_${Medication.LOPERAMIDE}`]: 'Loperamide',

			// Сердечно-сосудистые препараты
			[`medication_${Medication.AMLODIPINE}`]: 'Amlodipine',
			[`medication_${Medication.ATENOLOL}`]: 'Atenolol',
			[`medication_${Medication.BISOPROLOL}`]: 'Bisoprolol',
			[`medication_${Medication.ENALAPRIL}`]: 'Enalapril',
			[`medication_${Medication.LOSARTAN}`]: 'Losartan',
			[`medication_${Medication.VALSARTAN}`]: 'Valsartan',
			[`medication_${Medication.ATORVASTATIN}`]: 'Atorvastatin',
			[`medication_${Medication.ROSUVASTATIN}`]: 'Rosuvastatin',
			[`medication_${Medication.SIMVASTATIN}`]: 'Simvastatin',
			[`medication_${Medication.ASPIRIN_CARDIO}`]: 'Aspirin Cardio',
			[`medication_${Medication.CLOPIDOGREL}`]: 'Clopidogrel',

			// Препараты для дыхательной системы
			[`medication_${Medication.SALBUTAMOL}`]: 'Salbutamol',
			[`medication_${Medication.BUDESONIDE}`]: 'Budesonide',
			[`medication_${Medication.FLUTICASONE}`]: 'Fluticasone',
			[`medication_${Medication.AMBROXOL}`]: 'Ambroxol',
			[`medication_${Medication.BROMHEXINE}`]: 'Bromhexine',
			[`medication_${Medication.ACETYLCYSTEINE}`]: 'Acetylcysteine',

			// Противодиабетические препараты
			[`medication_${Medication.METFORMIN}`]: 'Metformin',
			[`medication_${Medication.GLIBENCLAMIDE}`]: 'Glibenclamide',
			[`medication_${Medication.GLICLAZIDE}`]: 'Gliclazide',
			[`medication_${Medication.INSULIN_GLARGINE}`]: 'Insulin Glargine',
			[`medication_${Medication.INSULIN_ASPART}`]: 'Insulin Aspart',

			// Гормональные препараты
			[`medication_${Medication.LEVOTHYROXINE}`]: 'Levothyroxine',
			[`medication_${Medication.PREDNISOLONE}`]: 'Prednisolone',
			[`medication_${Medication.DEXAMETHASONE}`]: 'Dexamethasone',
			[`medication_${Medication.HYDROCORTISONE}`]: 'Hydrocortisone',

			// Витамины и минералы
			[`medication_${Medication.VITAMIN_D3}`]: 'Vitamin D3',
			[`medication_${Medication.VITAMIN_B12}`]: 'Vitamin B12',
			[`medication_${Medication.FOLIC_ACID}`]: 'Folic Acid',
			[`medication_${Medication.IRON_SULFATE}`]: 'Iron Sulfate',
			[`medication_${Medication.CALCIUM_CARBONATE}`]: 'Calcium Carbonate',
			[`medication_${Medication.MAGNESIUM_B6}`]: 'Magnesium B6',
			[`medication_${Medication.MULTIVITAMIN}`]: 'Multivitamin',

			// Неврологические препараты
			[`medication_${Medication.DIAZEPAM}`]: 'Diazepam',
			[`medication_${Medication.ALPRAZOLAM}`]: 'Alprazolam',
			[`medication_${Medication.GABAPENTIN}`]: 'Gabapentin',
			[`medication_${Medication.PREGABALIN}`]: 'Pregabalin',
			[`medication_${Medication.CARBAMAZEPINE}`]: 'Carbamazepine',

			// Антидепрессанты
			[`medication_${Medication.SERTRALINE}`]: 'Sertraline',
			[`medication_${Medication.ESCITALOPRAM}`]: 'Escitalopram',
			[`medication_${Medication.FLUOXETINE}`]: 'Fluoxetine',
			[`medication_${Medication.VENLAFAXINE}`]: 'Venlafaxine',

			// Противовирусные
			[`medication_${Medication.ACYCLOVIR}`]: 'Acyclovir',
			[`medication_${Medication.OSELTAMIVIR}`]: 'Oseltamivir',
			[`medication_${Medication.VALACICLOVIR}`]: 'Valaciclovir',

			// Противогрибковые
			[`medication_${Medication.FLUCONAZOLE}`]: 'Fluconazole',
			[`medication_${Medication.CLOTRIMAZOLE}`]: 'Clotrimazole',
			[`medication_${Medication.TERBINAFINE}`]: 'Terbinafine',

			// Препараты для мочеполовой системы
			[`medication_${Medication.TAMSULOSIN}`]: 'Tamsulosin',
			[`medication_${Medication.SILDENAFIL}`]: 'Sildenafil',
			[`medication_${Medication.TADALAFIL}`]: 'Tadalafil',
			[`medication_${Medication.DROTAVERINE}`]: 'Drotaverine',

			// Офтальмологические препараты
			[`medication_${Medication.TIMOLOL}`]: 'Timolol',
			[`medication_${Medication.LATANOPROST}`]: 'Latanoprost',
			[`medication_${Medication.ARTIFICIAL_TEARS}`]: 'Artificial Tears',

			// Антисептики и дезинфицирующие средства
			[`medication_${Medication.CHLORHEXIDINE}`]: 'Chlorhexidine',
			[`medication_${Medication.HYDROGEN_PEROXIDE}`]: 'Hydrogen Peroxide',
			[`medication_${Medication.IODINE_SOLUTION}`]: 'Iodine Solution',

			// Другие препараты
			[`medication_${Medication.INSULIN_NPH}`]: 'Insulin NPH',
			[`medication_${Medication.WARFARIN}`]: 'Warfarin',
			[`medication_${Medication.ALLOPURINOL}`]: 'Allopurinol',
			[`medication_${Medication.COLCHICINE}`]: 'Colchicine',
			[`medication_${Medication.FUROSEMIDE}`]: 'Furosemide',
			[`medication_${Medication.SPIRONOLACTONE}`]: 'Spironolactone',
			[`medication_${Medication.DIGOXIN}`]: 'Digoxin',
			[`medication_${Medication.NITROGLYCERIN}`]: 'Nitroglycerin',
			[`medication_${Medication.ISOSORBIDE_MONONITRATE}`]:
				'Isosorbide Mononitrate',
			[`medication_${Medication.TRAMADOL}`]: 'Tramadol',
			[`medication_${Medication.CODEINE}`]: 'Codeine',
			[`medication_${Medication.MORPHINE}`]: 'Morphine',
			[`medication_${Medication.BACLOFEN}`]: 'Baclofen',
		},
		'ru': {
			// Обезболивающие и противовоспалительные
			[`medication_${Medication.PARACETAMOL}`]: 'Парацетамол',
			[`medication_${Medication.IBUPROFEN}`]: 'Ибупрофен',
			[`medication_${Medication.ASPIRIN}`]: 'Аспирин',
			[`medication_${Medication.DICLOFENAC}`]: 'Диклофенак',
			[`medication_${Medication.KETOPROFEN}`]: 'Кетопрофен',
			[`medication_${Medication.NAPROXEN}`]: 'Напроксен',
			[`medication_${Medication.NIMESULIDE}`]: 'Нимесулид',
			[`medication_${Medication.MELOXICAM}`]: 'Мелоксикам',

			// Антибиотики
			[`medication_${Medication.AMOXICILLIN}`]: 'Амоксициллин',
			[`medication_${Medication.AZITHROMYCIN}`]: 'Азитромицин',
			[`medication_${Medication.CIPROFLOXACIN}`]: 'Ципрофлоксацин',
			[`medication_${Medication.CLARITHROMYCIN}`]: 'Кларитромицин',
			[`medication_${Medication.DOXYCYCLINE}`]: 'Доксициклин',
			[`medication_${Medication.CEPHALEXIN}`]: 'Цефалексин',
			[`medication_${Medication.METRONIDAZOLE}`]: 'Метронидазол',
			[`medication_${Medication.AMOXICILLIN_CLAVULANATE}`]:
				'Амоксициллин + Клавуланат',

			// Антигистаминные
			[`medication_${Medication.LORATADINE}`]: 'Лоратадин',
			[`medication_${Medication.CETIRIZINE}`]: 'Цетиризин',
			[`medication_${Medication.DESLORATADINE}`]: 'Дезлоратадин',
			[`medication_${Medication.FEXOFENADINE}`]: 'Фексофенадин',
			[`medication_${Medication.LEVOCETIRIZINE}`]: 'Левоцетиризин',

			// Препараты для ЖКТ
			[`medication_${Medication.OMEPRAZOLE}`]: 'Омепразол',
			[`medication_${Medication.PANTOPRAZOLE}`]: 'Пантопразол',
			[`medication_${Medication.RANITIDINE}`]: 'Ранитидин',
			[`medication_${Medication.DOMPERIDONE}`]: 'Домперидон',
			[`medication_${Medication.METOCLOPRAMIDE}`]: 'Метоклопрамид',
			[`medication_${Medication.LACTULOSE}`]: 'Лактулоза',
			[`medication_${Medication.BISACODYL}`]: 'Бисакодил',
			[`medication_${Medication.LOPERAMIDE}`]: 'Лоперамид',

			// Сердечно-сосудистые препараты
			[`medication_${Medication.AMLODIPINE}`]: 'Амлодипин',
			[`medication_${Medication.ATENOLOL}`]: 'Атенолол',
			[`medication_${Medication.BISOPROLOL}`]: 'Бисопролол',
			[`medication_${Medication.ENALAPRIL}`]: 'Эналаприл',
			[`medication_${Medication.LOSARTAN}`]: 'Лозартан',
			[`medication_${Medication.VALSARTAN}`]: 'Валсартан',
			[`medication_${Medication.ATORVASTATIN}`]: 'Аторвастатин',
			[`medication_${Medication.ROSUVASTATIN}`]: 'Розувастатин',
			[`medication_${Medication.SIMVASTATIN}`]: 'Симвастатин',
			[`medication_${Medication.ASPIRIN_CARDIO}`]: 'Аспирин Кардио',
			[`medication_${Medication.CLOPIDOGREL}`]: 'Клопидогрель',

			// Препараты для дыхательной системы
			[`medication_${Medication.SALBUTAMOL}`]: 'Сальбутамол',
			[`medication_${Medication.BUDESONIDE}`]: 'Будесонид',
			[`medication_${Medication.FLUTICASONE}`]: 'Флутиказон',
			[`medication_${Medication.AMBROXOL}`]: 'Амброксол',
			[`medication_${Medication.BROMHEXINE}`]: 'Бромгексин',
			[`medication_${Medication.ACETYLCYSTEINE}`]: 'Ацетилцистеин',

			// Противодиабетические препараты
			[`medication_${Medication.METFORMIN}`]: 'Метформин',
			[`medication_${Medication.GLIBENCLAMIDE}`]: 'Глибенкламид',
			[`medication_${Medication.GLICLAZIDE}`]: 'Гликлазид',
			[`medication_${Medication.INSULIN_GLARGINE}`]: 'Инсулин Гларгин',
			[`medication_${Medication.INSULIN_ASPART}`]: 'Инсулин Аспарт',

			// Гормональные препараты
			[`medication_${Medication.LEVOTHYROXINE}`]: 'Левотироксин',
			[`medication_${Medication.PREDNISOLONE}`]: 'Преднизолон',
			[`medication_${Medication.DEXAMETHASONE}`]: 'Дексаметазон',
			[`medication_${Medication.HYDROCORTISONE}`]: 'Гидрокортизон',

			// Витамины и минералы
			[`medication_${Medication.VITAMIN_D3}`]: 'Витамин D3',
			[`medication_${Medication.VITAMIN_B12}`]: 'Витамин B12',
			[`medication_${Medication.FOLIC_ACID}`]: 'Фолиевая кислота',
			[`medication_${Medication.IRON_SULFATE}`]: 'Сульфат железа',
			[`medication_${Medication.CALCIUM_CARBONATE}`]: 'Карбонат кальция',
			[`medication_${Medication.MAGNESIUM_B6}`]: 'Магний B6',
			[`medication_${Medication.MULTIVITAMIN}`]: 'Мультивитамин',

			// Неврологические препараты
			[`medication_${Medication.DIAZEPAM}`]: 'Диазепам',
			[`medication_${Medication.ALPRAZOLAM}`]: 'Алпразолам',
			[`medication_${Medication.GABAPENTIN}`]: 'Габапентин',
			[`medication_${Medication.PREGABALIN}`]: 'Прегабалин',
			[`medication_${Medication.CARBAMAZEPINE}`]: 'Карбамазепин',

			// Антидепрессанты
			[`medication_${Medication.SERTRALINE}`]: 'Сертралин',
			[`medication_${Medication.ESCITALOPRAM}`]: 'Эсциталопрам',
			[`medication_${Medication.FLUOXETINE}`]: 'Флуоксетин',
			[`medication_${Medication.VENLAFAXINE}`]: 'Венлафаксин',

			// Противовирусные
			[`medication_${Medication.ACYCLOVIR}`]: 'Ацикловир',
			[`medication_${Medication.OSELTAMIVIR}`]: 'Осельтамивир',
			[`medication_${Medication.VALACICLOVIR}`]: 'Валацикловир',

			// Противогрибковые
			[`medication_${Medication.FLUCONAZOLE}`]: 'Флуконазол',
			[`medication_${Medication.CLOTRIMAZOLE}`]: 'Клотримазол',
			[`medication_${Medication.TERBINAFINE}`]: 'Тербинафин',

			// Препараты для мочеполовой системы
			[`medication_${Medication.TAMSULOSIN}`]: 'Тамсулозин',
			[`medication_${Medication.SILDENAFIL}`]: 'Силденафил',
			[`medication_${Medication.TADALAFIL}`]: 'Тадалафил',
			[`medication_${Medication.DROTAVERINE}`]: 'Дротаверин',

			// Офтальмологические препараты
			[`medication_${Medication.TIMOLOL}`]: 'Тимолол',
			[`medication_${Medication.LATANOPROST}`]: 'Латанопрост',
			[`medication_${Medication.ARTIFICIAL_TEARS}`]: 'Искусственные слёзы',

			// Антисептики и дезинфицирующие средства
			[`medication_${Medication.CHLORHEXIDINE}`]: 'Хлоргексидин',
			[`medication_${Medication.HYDROGEN_PEROXIDE}`]: 'Перекись водорода',
			[`medication_${Medication.IODINE_SOLUTION}`]: 'Раствор йода',

			// Другие препараты
			[`medication_${Medication.INSULIN_NPH}`]: 'Инсулин НПХ',
			[`medication_${Medication.WARFARIN}`]: 'Варфарин',
			[`medication_${Medication.ALLOPURINOL}`]: 'Аллопуринол',
			[`medication_${Medication.COLCHICINE}`]: 'Колхицин',
			[`medication_${Medication.FUROSEMIDE}`]: 'Фуросемид',
			[`medication_${Medication.SPIRONOLACTONE}`]: 'Спиронолактон',
			[`medication_${Medication.DIGOXIN}`]: 'Дигоксин',
			[`medication_${Medication.NITROGLYCERIN}`]: 'Нитроглицерин',
			[`medication_${Medication.ISOSORBIDE_MONONITRATE}`]:
				'Изосорбида мононитрат',
			[`medication_${Medication.TRAMADOL}`]: 'Трамадол',
			[`medication_${Medication.CODEINE}`]: 'Кодеин',
			[`medication_${Medication.MORPHINE}`]: 'Морфин',
			[`medication_${Medication.BACLOFEN}`]: 'Баклофен',
		},
		'sr': {
			// Обезболивающие и противовоспалительные
			[`medication_${Medication.PARACETAMOL}`]: 'Paracetamol',
			[`medication_${Medication.IBUPROFEN}`]: 'Ibuprofen',
			[`medication_${Medication.ASPIRIN}`]: 'Aspirin',
			[`medication_${Medication.DICLOFENAC}`]: 'Diklofenak',
			[`medication_${Medication.KETOPROFEN}`]: 'Ketoprofen',
			[`medication_${Medication.NAPROXEN}`]: 'Naproksen',
			[`medication_${Medication.NIMESULIDE}`]: 'Nimesulid',
			[`medication_${Medication.MELOXICAM}`]: 'Meloksikam',

			// Антибиотики
			[`medication_${Medication.AMOXICILLIN}`]: 'Amoksicilin',
			[`medication_${Medication.AZITHROMYCIN}`]: 'Azitromicin',
			[`medication_${Medication.CIPROFLOXACIN}`]: 'Ciprofloksacin',
			[`medication_${Medication.CLARITHROMYCIN}`]: 'Klaritromicin',
			[`medication_${Medication.DOXYCYCLINE}`]: 'Doksiciklin',
			[`medication_${Medication.CEPHALEXIN}`]: 'Cefaleksin',
			[`medication_${Medication.METRONIDAZOLE}`]: 'Metronidazol',
			[`medication_${Medication.AMOXICILLIN_CLAVULANATE}`]:
				'Amoksicilin + Klavulanat',

			// Антигистаминные
			[`medication_${Medication.LORATADINE}`]: 'Loratadin',
			[`medication_${Medication.CETIRIZINE}`]: 'Cetirizin',
			[`medication_${Medication.DESLORATADINE}`]: 'Dezloratadin',
			[`medication_${Medication.FEXOFENADINE}`]: 'Feksofenadin',
			[`medication_${Medication.LEVOCETIRIZINE}`]: 'Levocetirizin',

			// Препараты для ЖКТ
			[`medication_${Medication.OMEPRAZOLE}`]: 'Omeprazol',
			[`medication_${Medication.PANTOPRAZOLE}`]: 'Pantoprazol',
			[`medication_${Medication.RANITIDINE}`]: 'Ranitidin',
			[`medication_${Medication.DOMPERIDONE}`]: 'Domperidon',
			[`medication_${Medication.METOCLOPRAMIDE}`]: 'Metoklopramid',
			[`medication_${Medication.LACTULOSE}`]: 'Laktuloza',
			[`medication_${Medication.BISACODYL}`]: 'Bisakodil',
			[`medication_${Medication.LOPERAMIDE}`]: 'Loperamid',

			// Сердечно-сосудистые препараты
			[`medication_${Medication.AMLODIPINE}`]: 'Amlodipin',
			[`medication_${Medication.ATENOLOL}`]: 'Atenolol',
			[`medication_${Medication.BISOPROLOL}`]: 'Bisoprolol',
			[`medication_${Medication.ENALAPRIL}`]: 'Enalapril',
			[`medication_${Medication.LOSARTAN}`]: 'Losartan',
			[`medication_${Medication.VALSARTAN}`]: 'Valsartan',
			[`medication_${Medication.ATORVASTATIN}`]: 'Atorvastatin',
			[`medication_${Medication.ROSUVASTATIN}`]: 'Rozuvastatin',
			[`medication_${Medication.SIMVASTATIN}`]: 'Simvastatin',
			[`medication_${Medication.ASPIRIN_CARDIO}`]: 'Aspirin Cardio',
			[`medication_${Medication.CLOPIDOGREL}`]: 'Klopidogrel',

			// Препараты для дыхательной системы
			[`medication_${Medication.SALBUTAMOL}`]: 'Salbutamol',
			[`medication_${Medication.BUDESONIDE}`]: 'Budezonid',
			[`medication_${Medication.FLUTICASONE}`]: 'Flutikazon',
			[`medication_${Medication.AMBROXOL}`]: 'Ambroksol',
			[`medication_${Medication.BROMHEXINE}`]: 'Bromheksin',
			[`medication_${Medication.ACETYLCYSTEINE}`]: 'Acetilcistein',

			// Противодиабетические препараты
			[`medication_${Medication.METFORMIN}`]: 'Metformin',
			[`medication_${Medication.GLIBENCLAMIDE}`]: 'Glibenklamid',
			[`medication_${Medication.GLICLAZIDE}`]: 'Gliklazid',
			[`medication_${Medication.INSULIN_GLARGINE}`]: 'Insulin Glargin',
			[`medication_${Medication.INSULIN_ASPART}`]: 'Insulin Aspart',

			// Гормональные препараты
			[`medication_${Medication.LEVOTHYROXINE}`]: 'Levotiroksin',
			[`medication_${Medication.PREDNISOLONE}`]: 'Prednizolon',
			[`medication_${Medication.DEXAMETHASONE}`]: 'Deksametazon',
			[`medication_${Medication.HYDROCORTISONE}`]: 'Hidrokortizon',

			// Витамины и минералы
			[`medication_${Medication.VITAMIN_D3}`]: 'Vitamin D3',
			[`medication_${Medication.VITAMIN_B12}`]: 'Vitamin B12',
			[`medication_${Medication.FOLIC_ACID}`]: 'Folna kiselina',
			[`medication_${Medication.IRON_SULFATE}`]: 'Sulfat gvožđa',
			[`medication_${Medication.CALCIUM_CARBONATE}`]: 'Kalcijum karbonat',
			[`medication_${Medication.MAGNESIUM_B6}`]: 'Magnezijum B6',
			[`medication_${Medication.MULTIVITAMIN}`]: 'Multivitamin',

			// Неврологические препараты
			[`medication_${Medication.DIAZEPAM}`]: 'Diazepam',
			[`medication_${Medication.ALPRAZOLAM}`]: 'Alprazolam',
			[`medication_${Medication.GABAPENTIN}`]: 'Gabapentin',
			[`medication_${Medication.PREGABALIN}`]: 'Pregabalin',
			[`medication_${Medication.CARBAMAZEPINE}`]: 'Karbamazepin',

			// Антидепрессанты
			[`medication_${Medication.SERTRALINE}`]: 'Sertralin',
			[`medication_${Medication.ESCITALOPRAM}`]: 'Escitalopram',
			[`medication_${Medication.FLUOXETINE}`]: 'Fluoksetin',
			[`medication_${Medication.VENLAFAXINE}`]: 'Venlafaksin',

			// Противовирусные
			[`medication_${Medication.ACYCLOVIR}`]: 'Aciklovir',
			[`medication_${Medication.OSELTAMIVIR}`]: 'Oseltamivir',
			[`medication_${Medication.VALACICLOVIR}`]: 'Valaciklovir',

			// Противогрибковые
			[`medication_${Medication.FLUCONAZOLE}`]: 'Flukonazol',
			[`medication_${Medication.CLOTRIMAZOLE}`]: 'Klotrimazol',
			[`medication_${Medication.TERBINAFINE}`]: 'Terbinafin',

			// Препараты для мочеполовой системы
			[`medication_${Medication.TAMSULOSIN}`]: 'Tamsulosin',
			[`medication_${Medication.SILDENAFIL}`]: 'Sildenafil',
			[`medication_${Medication.TADALAFIL}`]: 'Tadalafil',
			[`medication_${Medication.DROTAVERINE}`]: 'Drotaverin',

			// Офтальмологические препараты
			[`medication_${Medication.TIMOLOL}`]: 'Timolol',
			[`medication_${Medication.LATANOPROST}`]: 'Latanoprost',
			[`medication_${Medication.ARTIFICIAL_TEARS}`]: 'Vještačke suze',

			// Антисептики и дезинфицирующие средства
			[`medication_${Medication.CHLORHEXIDINE}`]: 'Hlorheksidin',
			[`medication_${Medication.HYDROGEN_PEROXIDE}`]: 'Vodonik peroksid',
			[`medication_${Medication.IODINE_SOLUTION}`]: 'Rastvor joda',

			// Другие препараты
			[`medication_${Medication.INSULIN_NPH}`]: 'Insulin NPH',
			[`medication_${Medication.WARFARIN}`]: 'Varfarin',
			[`medication_${Medication.ALLOPURINOL}`]: 'Alopurinol',
			[`medication_${Medication.COLCHICINE}`]: 'Kolhicin',
			[`medication_${Medication.FUROSEMIDE}`]: 'Furosemid',
			[`medication_${Medication.SPIRONOLACTONE}`]: 'Spironolakton',
			[`medication_${Medication.DIGOXIN}`]: 'Digoksin',
			[`medication_${Medication.NITROGLYCERIN}`]: 'Nitroglicerin',
			[`medication_${Medication.ISOSORBIDE_MONONITRATE}`]:
				'Izosorbid mononitrat',
			[`medication_${Medication.TRAMADOL}`]: 'Tramadol',
			[`medication_${Medication.CODEINE}`]: 'Kodein',
			[`medication_${Medication.MORPHINE}`]: 'Morfin',
			[`medication_${Medication.BACLOFEN}`]: 'Baklofen',
		},
		'sr-cyrl': {
			// Обезболивающие и противовоспалительные
			[`medication_${Medication.PARACETAMOL}`]: 'Парацетамол',
			[`medication_${Medication.IBUPROFEN}`]: 'Ибупрофен',
			[`medication_${Medication.ASPIRIN}`]: 'Аспирин',
			[`medication_${Medication.DICLOFENAC}`]: 'Диклофенак',
			[`medication_${Medication.KETOPROFEN}`]: 'Кетопрофен',
			[`medication_${Medication.NAPROXEN}`]: 'Напроксен',
			[`medication_${Medication.NIMESULIDE}`]: 'Нимесулид',
			[`medication_${Medication.MELOXICAM}`]: 'Мелоксикам',

			// Антибиотики
			[`medication_${Medication.AMOXICILLIN}`]: 'Амоксицилин',
			[`medication_${Medication.AZITHROMYCIN}`]: 'Азитромицин',
			[`medication_${Medication.CIPROFLOXACIN}`]: 'Ципрофлоксацин',
			[`medication_${Medication.CLARITHROMYCIN}`]: 'Кларитромицин',
			[`medication_${Medication.DOXYCYCLINE}`]: 'Доксициклин',
			[`medication_${Medication.CEPHALEXIN}`]: 'Цефалексин',
			[`medication_${Medication.METRONIDAZOLE}`]: 'Метронидазол',
			[`medication_${Medication.AMOXICILLIN_CLAVULANATE}`]:
				'Амоксицилин + Клавуланат',

			// Антигистаминные
			[`medication_${Medication.LORATADINE}`]: 'Лоратадин',
			[`medication_${Medication.CETIRIZINE}`]: 'Цетиризин',
			[`medication_${Medication.DESLORATADINE}`]: 'Дезлоратадин',
			[`medication_${Medication.FEXOFENADINE}`]: 'Фексофенадин',
			[`medication_${Medication.LEVOCETIRIZINE}`]: 'Левоцетиризин',

			// Препараты для ЖКТ
			[`medication_${Medication.OMEPRAZOLE}`]: 'Омепразол',
			[`medication_${Medication.PANTOPRAZOLE}`]: 'Пантопразол',
			[`medication_${Medication.RANITIDINE}`]: 'Ранитидин',
			[`medication_${Medication.DOMPERIDONE}`]: 'Домперидон',
			[`medication_${Medication.METOCLOPRAMIDE}`]: 'Метоклопрамид',
			[`medication_${Medication.LACTULOSE}`]: 'Лактулоза',
			[`medication_${Medication.BISACODYL}`]: 'Бисакодил',
			[`medication_${Medication.LOPERAMIDE}`]: 'Лоперамид',

			// Сердечно-сосудистые препараты
			[`medication_${Medication.AMLODIPINE}`]: 'Амлодипин',
			[`medication_${Medication.ATENOLOL}`]: 'Атенолол',
			[`medication_${Medication.BISOPROLOL}`]: 'Бизопролол',
			[`medication_${Medication.ENALAPRIL}`]: 'Еналаприл',
			[`medication_${Medication.LOSARTAN}`]: 'Лозартан',
			[`medication_${Medication.VALSARTAN}`]: 'Валсартан',
			[`medication_${Medication.ATORVASTATIN}`]: 'Аторвастатин',
			[`medication_${Medication.ROSUVASTATIN}`]: 'Розувастатин',
			[`medication_${Medication.SIMVASTATIN}`]: 'Симвастатин',
			[`medication_${Medication.ASPIRIN_CARDIO}`]: 'Аспирин Кардио',
			[`medication_${Medication.CLOPIDOGREL}`]: 'Клопидогрел',

			// Препараты для дыхательной системы
			[`medication_${Medication.SALBUTAMOL}`]: 'Салбутамол',
			[`medication_${Medication.BUDESONIDE}`]: 'Будезонид',
			[`medication_${Medication.FLUTICASONE}`]: 'Флутиказон',
			[`medication_${Medication.AMBROXOL}`]: 'Амброксал',
			[`medication_${Medication.BROMHEXINE}`]: 'Бромхексин',
			[`medication_${Medication.ACETYLCYSTEINE}`]: 'Ацетилцистеин',

			// Противодиабетические препараты
			[`medication_${Medication.METFORMIN}`]: 'Метформин',
			[`medication_${Medication.GLIBENCLAMIDE}`]: 'Глибенкламид',
			[`medication_${Medication.GLICLAZIDE}`]: 'Гликлазид',
			[`medication_${Medication.INSULIN_GLARGINE}`]: 'Инсулин Гларгин',
			[`medication_${Medication.INSULIN_ASPART}`]: 'Инсулин Аспарт',

			// Гормональные препараты
			[`medication_${Medication.LEVOTHYROXINE}`]: 'Левотироксин',
			[`medication_${Medication.PREDNISOLONE}`]: 'Преднизолон',
			[`medication_${Medication.DEXAMETHASONE}`]: 'Дексаметазон',
			[`medication_${Medication.HYDROCORTISONE}`]: 'Хидрокортизон',

			// Витамины и минералы
			[`medication_${Medication.VITAMIN_D3}`]: 'Витамин D3',
			[`medication_${Medication.VITAMIN_B12}`]: 'Витамин B12',
			[`medication_${Medication.FOLIC_ACID}`]: 'Фолна киселина',
			[`medication_${Medication.IRON_SULFATE}`]: 'Сулфат гвожђа',
			[`medication_${Medication.CALCIUM_CARBONATE}`]: 'Калцијум карбонат',
			[`medication_${Medication.MAGNESIUM_B6}`]: 'Магнезијум B6',
			[`medication_${Medication.MULTIVITAMIN}`]: 'Мултивитамин',

			// Неврологические препараты
			[`medication_${Medication.DIAZEPAM}`]: 'Диазепам',
			[`medication_${Medication.ALPRAZOLAM}`]: 'Алпразолам',
			[`medication_${Medication.GABAPENTIN}`]: 'Габапентин',
			[`medication_${Medication.PREGABALIN}`]: 'Прегабалин',
			[`medication_${Medication.CARBAMAZEPINE}`]: 'Карбамазепин',

			// Антидепрессанты
			[`medication_${Medication.SERTRALINE}`]: 'Сертралин',
			[`medication_${Medication.ESCITALOPRAM}`]: 'Есциталопрам',
			[`medication_${Medication.FLUOXETINE}`]: 'Флуоксетин',
			[`medication_${Medication.VENLAFAXINE}`]: 'Венлафаксин',

			// Противовирусные
			[`medication_${Medication.ACYCLOVIR}`]: 'Ацикловир',
			[`medication_${Medication.OSELTAMIVIR}`]: 'Осельтамивир',
			[`medication_${Medication.VALACICLOVIR}`]: 'Валацикловир',

			// Противогрибковые
			[`medication_${Medication.FLUCONAZOLE}`]: 'Флуконазол',
			[`medication_${Medication.CLOTRIMAZOLE}`]: 'Клотримазол',
			[`medication_${Medication.TERBINAFINE}`]: 'Тербинафин',

			// Препараты для мочеполовой системы
			[`medication_${Medication.TAMSULOSIN}`]: 'Тамсулозин',
			[`medication_${Medication.SILDENAFIL}`]: 'Силденафил',
			[`medication_${Medication.TADALAFIL}`]: 'Тадалафил',
			[`medication_${Medication.DROTAVERINE}`]: 'Дротаверин',

			// Офтальмологические препараты
			[`medication_${Medication.TIMOLOL}`]: 'Тимолол',
			[`medication_${Medication.LATANOPROST}`]: 'Латанопрост',
			[`medication_${Medication.ARTIFICIAL_TEARS}`]: 'Вјештачке сузе',

			// Антисептики и дезинфицирующие средства
			[`medication_${Medication.CHLORHEXIDINE}`]: 'Хлорхексидин',
			[`medication_${Medication.HYDROGEN_PEROXIDE}`]: 'Водоник пероксид',
			[`medication_${Medication.IODINE_SOLUTION}`]: 'Раствор јода',

			// Другие препараты
			[`medication_${Medication.INSULIN_NPH}`]: 'Инсулин NPH',
			[`medication_${Medication.WARFARIN}`]: 'Варфарин',
			[`medication_${Medication.ALLOPURINOL}`]: 'Алопуринол',
			[`medication_${Medication.COLCHICINE}`]: 'Колхицин',
			[`medication_${Medication.FUROSEMIDE}`]: 'Фуросемид',
			[`medication_${Medication.SPIRONOLACTONE}`]: 'Спиронолактон',
			[`medication_${Medication.DIGOXIN}`]: 'Дигоксин',
			[`medication_${Medication.NITROGLYCERIN}`]: 'Нитроглицерин',
			[`medication_${Medication.ISOSORBIDE_MONONITRATE}`]:
				'Изосорбид мононитрат',
			[`medication_${Medication.TRAMADOL}`]: 'Трамадол',
			[`medication_${Medication.CODEINE}`]: 'Кодеин',
			[`medication_${Medication.MORPHINE}`]: 'Морфин',
			[`medication_${Medication.BACLOFEN}`]: 'Баклофен',
		},
	},
};
