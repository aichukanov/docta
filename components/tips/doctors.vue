<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { CityId } from '~/enums/cities';
import { PEDIATRIC_SPECIALTIES, SURGICAL_SPECIALTIES } from '~/enums/specialty';

const props = defineProps<{
	cityIds: number[];
	specialtyIds: number[];
}>();

const { t, locale } = useI18n({ useScope: 'local' });

// Clinic slugs
const CLINIC_DOM_ZDRAVLJA_BUDVA_SLUG = 'jzu-dom-zdravlja-budva';
const CLINIC_CLINICAL_CENTER_PODGORICA_SLUG =
	'klinicki-centar-crne-gore-podgorica';

// Clinic links
const clinicLink = (clinicSlug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug },
	query: getRegionalQuery(locale.value),
});

const cityClinicLink = (cityId: number) => ({
	name: 'clinics',
	query: { ...getRegionalQuery(locale.value), cityIds: String(cityId) },
});

const domZdravljaBudvaLink = computed(() =>
	clinicLink(CLINIC_DOM_ZDRAVLJA_BUDVA_SLUG),
);
const clinicalCenterLink = computed(() =>
	clinicLink(CLINIC_CLINICAL_CENTER_PODGORICA_SLUG),
);
const barClinicsLink = computed(() => cityClinicLink(CityId.BAR));

// Determine which city tips to show
const selectedCityId = computed(() => {
	if (props.cityIds.length === 1) {
		return props.cityIds[0];
	}
	return null;
});

// Determine specialty category for tips
const isPediatricSpecialty = computed(() => {
	return props.specialtyIds.some((id) => PEDIATRIC_SPECIALTIES.includes(id));
});

const isSurgicalSpecialty = computed(() => {
	return props.specialtyIds.some((id) => SURGICAL_SPECIALTIES.includes(id));
});

// Count displayed tips to control Clinical Center tip visibility
const displayedTipsCount = computed(() => {
	let count = 1; // TipEmergency is always shown

	if (selectedCityId.value === CityId.BUDVA) {
		if (isPediatricSpecialty.value) count++;
		if (isSurgicalSpecialty.value) count++;
		if (!isPediatricSpecialty.value && !isSurgicalSpecialty.value) count++;
	} else if (selectedCityId.value === CityId.TIVAT) {
		if (isPediatricSpecialty.value) count++;
		if (isSurgicalSpecialty.value) count++;
		if (!isPediatricSpecialty.value && !isSurgicalSpecialty.value) count++;
	} else if (selectedCityId.value === CityId.ULCINJ) {
		if (isPediatricSpecialty.value) count++;
		if (isSurgicalSpecialty.value) count++;
		if (!isPediatricSpecialty.value && !isSurgicalSpecialty.value) count++;
	} else if (selectedCityId.value === CityId.HERCEG_NOVI) {
		if (isPediatricSpecialty.value) count++;
		if (isSurgicalSpecialty.value) count++;
		if (!isPediatricSpecialty.value && !isSurgicalSpecialty.value) count++;
	} else if (selectedCityId.value === CityId.BAR) {
		count++;
	}

	return count;
});

const showClinicalCenterTip = computed(() => displayedTipsCount.value < 3);
</script>

<template>
	<!-- General tips (always shown) -->
	<TipsItem type="emergency" :text="t('TipEmergency')" />

	<!-- City + Specialty specific tips -->
	<TipsItem
		v-if="selectedCityId === CityId.BUDVA && isPediatricSpecialty"
		:text="t('TipPediatricBudva')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.BUDVA && isSurgicalSpecialty"
		:text="t('TipSurgeryBudva')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.TIVAT && isPediatricSpecialty"
		:text="t('TipPediatricTivat')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.TIVAT && isSurgicalSpecialty"
		:text="t('TipSurgeryTivat')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.ULCINJ && isPediatricSpecialty"
		:text="t('TipPediatricUlcinj')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.ULCINJ && isSurgicalSpecialty"
		:text="t('TipSurgeryUlcinj')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.HERCEG_NOVI && isPediatricSpecialty"
		:text="t('TipPediatricHercegNovi')"
	/>
	<TipsItem
		v-if="selectedCityId === CityId.HERCEG_NOVI && isSurgicalSpecialty"
		:text="t('TipSurgeryHercegNovi')"
	/>

	<!-- City-specific tips (shown when no specialty filter or specialty doesn't have specific tips) -->
	<TipsItem
		v-if="
			selectedCityId === CityId.BUDVA &&
			!isPediatricSpecialty &&
			!isSurgicalSpecialty
		"
	>
		{{ t('TipBudva1') }}
		<NuxtLink :to="domZdravljaBudvaLink">{{ t('TipDomZdravlja') }}</NuxtLink
		>.
		{{ t('TipBudva2') }}
		{{ t('TipBar') }},
		{{ t('TipCetinje') }}
		{{ t('And') }}
		{{ t('TipKotor') }}.
	</TipsItem>

	<TipsItem
		v-if="
			selectedCityId === CityId.TIVAT &&
			!isPediatricSpecialty &&
			!isSurgicalSpecialty
		"
	>
		{{ t('TipTivat') }}
		{{ t('TipKotor') }}
		{{ t('And') }}
		{{ t('TipRisan') }}.
	</TipsItem>

	<TipsItem
		v-if="
			selectedCityId === CityId.ULCINJ &&
			!isPediatricSpecialty &&
			!isSurgicalSpecialty
		"
	>
		{{ t('TipUlcinj') }}
		<NuxtLink :to="barClinicsLink">{{ t('TipBar') }}</NuxtLink
		>.
	</TipsItem>

	<TipsItem
		v-if="
			selectedCityId === CityId.HERCEG_NOVI &&
			!isPediatricSpecialty &&
			!isSurgicalSpecialty
		"
	>
		{{ t('TipHercegNovi') }}
		{{ t('TipKotor') }}
		{{ t('And') }}
		{{ t('TipRisan') }}.
	</TipsItem>

	<TipsItem v-if="selectedCityId === CityId.BAR" :text="t('TipBarCity')" />

	<TipsItem v-if="showClinicalCenterTip">
		{{ t('TipClinicalCenter1') }}
		<NuxtLink :to="clinicalCenterLink">{{ t('TipClinicalCenter2') }}</NuxtLink>
		{{ t('TipClinicalCenter3') }}
	</TipsItem>
</template>

<i18n lang="json">
{
	"en": {
		"TipBudva1": "Budva does not have its own hospital, only",
		"TipDomZdravlja": "Dom Zdravlya (polyclinic)",
		"TipBudva2": "The nearest hospitals are in",
		"TipBar": "Bar",
		"TipCetinje": "Cetinje",
		"TipKotor": "Kotor",
		"TipTivat": "Tivat does not have its own hospital. The nearest are in",
		"TipRisan": "Risan",
		"TipUlcinj": "Ulcinj does not have its own hospital. The nearest is in",
		"TipBarCity": "Bar has a Hospital with adult and pediatric departments and Dom Zdravlya (polyclinic).",
		"TipEmergency": "In case of emergency, call ambulance at 📞 124.",
		"TipClinicalCenter1": "The largest and most modern medical center is",
		"TipClinicalCenter2": "Clinical Center of Montenegro in Podgorica",
		"TipClinicalCenter3": "(261 doctors!).",
		"And": "and",
		"TipPediatricBudva": "Budva has Dom Zdravlja with a pediatric department, but there is no public hospital. In case of a nighttime emergency with a child, it is better to go directly to a hospital in Kotor or Bar.",
		"TipSurgeryBudva": "Budva has Dom Zdravlja (polyclinic), but no public hospital. Only outpatient appointments are available. The nearest operating room is in the Kotor hospital.",
		"TipPediatricTivat": "Tivat does not have a public hospital. In case of a nighttime emergency with a child, it is better to go directly to the hospitals in Kotor or Risan.",
		"TipSurgeryTivat": "Tivat has Dom Zdravlja (polyclinic), but no public hospital. Only outpatient care is available. The nearest operating rooms are in Kotor and Risan hospitals.",
		"TipPediatricUlcinj": "Ulcinj does not have a public hospital. In case of a nighttime emergency with a child, it is better to go directly to the hospital in Bar, which has a pediatric department.",
		"TipSurgeryUlcinj": "Ulcinj has Dom Zdravlja (polyclinic), but no public hospital. Only outpatient care is available. The nearest operating room is in the Bar hospital.",
		"TipHercegNovi": "Herceg Novi does not have its own hospital. The nearest are in",
		"TipPediatricHercegNovi": "Herceg Novi does not have a public hospital. In case of a nighttime emergency with a child, it is better to go directly to the hospitals in Kotor or Risan.",
		"TipSurgeryHercegNovi": "Herceg Novi has Dom Zdravlja (polyclinic), but no public hospital. Only outpatient care is available. The nearest operating rooms are in Kotor and Risan hospitals."
	},
	"ru": {
		"TipBudva1": "В Будве нет своей больницы, только",
		"TipDomZdravlja": "Дом Здравля (поликлиника)",
		"TipBudva2": "Ближайшие больницы находятся в",
		"TipBar": "Баре",
		"TipCetinje": "Цетине",
		"TipKotor": "Которе",
		"TipTivat": "В Тивате нет своей больницы. Ближайшие находятся в",
		"TipRisan": "Рисане",
		"TipUlcinj": "В Ульцине нет своей больницы. Ближайшая находится в",
		"TipBarCity": "В Баре есть Больница со взрослым и детским отделениями и Дом Здравля (поликлиника).",
		"TipEmergency": "В случае экстренной ситуации скорую помощь можно вызвать по номеру 📞 124.",
		"TipClinicalCenter1": "Самый большой и современный медицинский центр —",
		"TipClinicalCenter2": "Клинический центр Черногории в Подгорице",
		"TipClinicalCenter3": "(261 врач!).",
		"And": "и",
		"TipPediatricBudva": "В Будве есть Дом Здравля с детским отделением, но нет государственной больницы. В случае ночной экстренной ситуации с ребенком лучше сразу ехать в больницу Котора или Бара.",
		"TipSurgeryBudva": "В Будве есть Дом Здравля (поликлиника), но нет государственной больницы. Доступен только амбулаторный приём. Ближайшая операционная находится в больнице Котора.",
		"TipPediatricTivat": "В Тивате нет государственной больницы. В случае ночной экстренной ситуации с ребенком лучше сразу ехать в больницы Котора или Рисана.",
		"TipSurgeryTivat": "В Тивате есть Дом Здравля (поликлиника), но нет государственной больницы. Доступен только амбулаторный приём. Ближайшие операционные находятся в больницах Котора и Рисана.",
		"TipPediatricUlcinj": "В Ульцине нет государственной больницы. В случае ночной экстренной ситуации с ребенком лучше сразу ехать в больницу Бара, где есть детское отделение.",
		"TipSurgeryUlcinj": "В Ульцине есть Дом Здравля (поликлиника), но нет государственной больницы. Доступен только амбулаторный приём. Ближайшая операционная находится в больнице Бара.",
		"TipHercegNovi": "В Херцег-Нови нет своей больницы. Ближайшие находятся в",
		"TipPediatricHercegNovi": "В Херцег-Нови нет государственной больницы. В случае ночной экстренной ситуации с ребенком лучше сразу ехать в больницы Котора или Рисана.",
		"TipSurgeryHercegNovi": "В Херцег-Нови есть Дом Здравля (поликлиника), но нет государственной больницы. Доступен только амбулаторный приём. Ближайшие операционные находятся в больницах Котора и Рисана."
	},
	"sr": {
		"TipBudva1": "Budva nema svoju bolnicu, samo",
		"TipDomZdravlja": "Dom Zdravlja (poliklinika)",
		"TipBudva2": "Najbliže bolnice su u",
		"TipBar": "Baru",
		"TipCetinje": "Cetinju",
		"TipKotor": "Kotoru",
		"TipTivat": "Tivat nema svoju bolnicu. Najbliže su u",
		"TipRisan": "Risnu",
		"TipUlcinj": "Ulcinj nema svoju bolnicu. Najbliža je u",
		"TipBarCity": "Bar ima Bolnicu sa odeljenjima za odrasle i decu i Dom Zdravlja (poliklinika).",
		"TipEmergency": "U slučaju hitnosti, pozovite hitnu pomoć na 📞 124.",
		"TipClinicalCenter1": "Najveći i najsavremeniji medicinski centar je",
		"TipClinicalCenter2": "Klinički centar Crne Gore u Podgorici",
		"TipClinicalCenter3": "(261 lekar!).",
		"And": "i",
		"TipPediatricBudva": "Budva ima Dom Zdravlja sa dečijim odeljenjem, ali nema državnu bolnicu. U slučaju noćne hitne situacije sa detetom, bolje je odmah ići u bolnicu u Kotoru ili Baru.",
		"TipSurgeryBudva": "Budva ima Dom Zdravlja (polikliniku), ali nema državnu bolnicu. Dostupna je samo ambulantna nega. Najbliža operaciona sala je u bolnici u Kotoru.",
		"TipPediatricTivat": "Tivat nema državnu bolnicu. U slučaju noćne hitne situacije sa detetom, bolje je odmah ići u bolnice u Kotoru ili Risnu.",
		"TipSurgeryTivat": "Tivat ima Dom Zdravlja (polikliniku), ali nema državnu bolnicu. Dostupna je samo ambulantna nega. Najbliže operacione sale su u bolnicama u Kotoru i Risnu.",
		"TipPediatricUlcinj": "Ulcinj nema državnu bolnicu. U slučaju noćne hitne situacije sa detetom, bolje je odmah ići u bolnicu u Baru, koja ima dečije odeljenje.",
		"TipSurgeryUlcinj": "Ulcinj ima Dom Zdravlja (polikliniku), ali nema državnu bolnicu. Dostupna je samo ambulantna nega. Najbliža operaciona sala je u bolnici u Baru.",
		"TipHercegNovi": "Herceg Novi nema svoju bolnicu. Najbliže su u",
		"TipPediatricHercegNovi": "Herceg Novi nema državnu bolnicu. U slučaju noćne hitne situacije sa detetom, bolje je odmah ići u bolnice u Kotoru ili Risnu.",
		"TipSurgeryHercegNovi": "Herceg Novi ima Dom Zdravlja (polikliniku), ali nema državnu bolnicu. Dostupna je samo ambulantna nega. Najbliže operacione sale su u bolnicama u Kotoru i Risnu."
	},
	"sr-cyrl": {
		"TipBudva1": "Будва нема своју болницу, само",
		"TipDomZdravlja": "Дом Здравља (поликлиника)",
		"TipBudva2": "Најближе болнице су у",
		"TipBar": "Бару",
		"TipCetinje": "Цетињу",
		"TipKotor": "Котору",
		"TipTivat": "Тиват нема своју болницу. Најближе су у",
		"TipRisan": "Рисну",
		"TipUlcinj": "Улцињ нема своју болницу. Најближа је у",
		"TipBarCity": "Бар има Болницу са одељењима за одрасле и децу и Дом Здравља (поликлиника).",
		"TipEmergency": "У случају хитности, позовите хитну помоћ на 📞 124.",
		"TipClinicalCenter1": "Највећи и најсавременији медицински центар је",
		"TipClinicalCenter2": "Клинички центар Црне Горе у Подгорици",
		"TipClinicalCenter3": "(261 лекар!).",
		"And": "и",
		"TipPediatricBudva": "Будва има Дом Здравља са дечијим одељењем, али нема државну болницу. У случају ноћне хитне ситуације са дететом, боље је одмах ићи у болницу у Котору или Бару.",
		"TipSurgeryBudva": "Будва има Дом Здравља (поликлинику), али нема државну болницу. Доступна је само амбулантна нега. Најближа операциона сала је у болници у Котору.",
		"TipPediatricTivat": "Тиват нема државну болницу. У случају ноћне хитне ситуације са дететом, боље је одмах ићи у болнице у Котору или Рисну.",
		"TipSurgeryTivat": "Тиват има Дом Здравља (поликлинику), али нема државну болницу. Доступна је само амбулантна нега. Најближе операционе сале су у болницама у Котору и Рисну.",
		"TipPediatricUlcinj": "Улцињ нема државну болницу. У случају ноћне хитне ситуације са дететом, боље је одмах ићи у болницу у Бару, која има дечије одељење.",
		"TipSurgeryUlcinj": "Улцињ има Дом Здравља (поликлинику), али нема државну болницу. Доступна је само амбулантна нега. Најближа операциона сала је у болници у Бару.",
		"TipHercegNovi": "Херцег Нови нема своју болницу. Најближе су у",
		"TipPediatricHercegNovi": "Херцег Нови нема државну болницу. У случају ноћне хитне ситуације са дететом, боље је одмах ићи у болнице у Котору или Рисну.",
		"TipSurgeryHercegNovi": "Херцег Нови има Дом Здравља (поликлинику), али нема државну болницу. Доступна је само амбулантна нега. Најближе операционе сале су у болницама у Котору и Рисну."
	},
	"de": {
		"TipBudva1": "Budva hat kein eigenes Krankenhaus, nur",
		"TipDomZdravlja": "Dom Zdravlja (Poliklinik)",
		"TipBudva2": "Die nächsten Krankenhäuser sind in",
		"TipBar": "Bar",
		"TipCetinje": "Cetinje",
		"TipKotor": "Kotor",
		"TipTivat": "Tivat hat kein eigenes Krankenhaus. Die nächsten sind in",
		"TipRisan": "Risan",
		"TipUlcinj": "Ulcinj hat kein eigenes Krankenhaus. Das nächste ist in",
		"TipBarCity": "Bar hat ein Krankenhaus mit Erwachsenen- und Kinderabteilungen und Dom Zdravlja (Poliklinik).",
		"TipEmergency": "Im Notfall rufen Sie den Krankenwagen unter 📞 124.",
		"TipClinicalCenter1": "Das größte und modernste medizinische Zentrum ist das",
		"TipClinicalCenter2": "Klinische Zentrum Montenegros in Podgorica",
		"TipClinicalCenter3": "(261 Ärzte!).",
		"And": "und",
		"TipPediatricBudva": "Budva hat ein Dom Zdravlja mit Kinderabteilung, aber kein öffentliches Krankenhaus. Bei einem nächtlichen Notfall mit einem Kind ist es besser, direkt ins Krankenhaus nach Kotor oder Bar zu fahren.",
		"TipSurgeryBudva": "Budva hat ein Dom Zdravlja (Poliklinik), aber kein öffentliches Krankenhaus. Nur ambulante Versorgung ist verfügbar. Der nächste Operationssaal befindet sich im Krankenhaus Kotor.",
		"TipPediatricTivat": "Tivat hat kein öffentliches Krankenhaus. Bei einem nächtlichen Notfall mit einem Kind ist es besser, direkt zu den Krankenhäusern in Kotor oder Risan zu fahren.",
		"TipSurgeryTivat": "Tivat hat ein Dom Zdravlja (Poliklinik), aber kein öffentliches Krankenhaus. Nur ambulante Versorgung ist verfügbar. Die nächsten Operationssäle befinden sich in den Krankenhäusern Kotor und Risan.",
		"TipPediatricUlcinj": "Ulcinj hat kein öffentliches Krankenhaus. Bei einem nächtlichen Notfall mit einem Kind ist es besser, direkt ins Krankenhaus Bar zu fahren, das eine Kinderabteilung hat.",
		"TipSurgeryUlcinj": "Ulcinj hat ein Dom Zdravlja (Poliklinik), aber kein öffentliches Krankenhaus. Nur ambulante Versorgung ist verfügbar. Der nächste Operationssaal befindet sich im Krankenhaus Bar.",
		"TipHercegNovi": "Herceg Novi hat kein eigenes Krankenhaus. Die nächsten sind in",
		"TipPediatricHercegNovi": "Herceg Novi hat kein öffentliches Krankenhaus. Bei einem nächtlichen Notfall mit einem Kind ist es besser, direkt zu den Krankenhäusern in Kotor oder Risan zu fahren.",
		"TipSurgeryHercegNovi": "Herceg Novi hat ein Dom Zdravlja (Poliklinik), aber kein öffentliches Krankenhaus. Nur ambulante Versorgung ist verfügbar. Die nächsten Operationssäle befinden sich in den Krankenhäusern Kotor und Risan."
	},
	"tr": {
		"TipBudva1": "Budva'nın kendi hastanesi yok, sadece",
		"TipDomZdravlja": "Dom Zdravlja (poliklinik)",
		"TipBudva2": "En yakın hastaneler",
		"TipBar": "Bar",
		"TipCetinje": "Cetinje",
		"TipKotor": "Kotor",
		"TipTivat": "Tivat'ın kendi hastanesi yok. En yakınları",
		"TipRisan": "Risan",
		"TipUlcinj": "Ulcinj'in kendi hastanesi yok. En yakını",
		"TipBarCity": "Bar'da yetişkin ve çocuk bölümlerinden oluşan bir Hastane ve Dom Zdravlja (poliklinik) var.",
		"TipEmergency": "Acil durumda 📞 124 numaralı telefonu arayın.",
		"TipClinicalCenter1": "En büyük ve en modern tıp merkezi",
		"TipClinicalCenter2": "Podgorica'daki Karadağ Klinik Merkezi",
		"TipClinicalCenter3": "(261 doktor!).",
		"And": "ve",
		"TipPediatricBudva": "Budva'da çocuk bölümü olan bir Dom Zdravlja var, ancak devlet hastanesi yok. Gece çocukla acil bir durumda Kotor veya Bar'daki hastaneye doğrudan gitmek daha iyidir.",
		"TipSurgeryBudva": "Budva'da Dom Zdravlja (poliklinik) var, ancak devlet hastanesi yok. Sadece ayakta tedavi mümkündür. En yakın ameliyathane Kotor hastanesindedir.",
		"TipPediatricTivat": "Tivat'ta devlet hastanesi yok. Gece çocukla acil bir durumda Kotor veya Risan hastanelerine doğrudan gitmek daha iyidir.",
		"TipSurgeryTivat": "Tivat'ta Dom Zdravlja (poliklinik) var, ancak devlet hastanesi yok. Sadece ayakta tedavi mümkündür. En yakın ameliyathaneler Kotor ve Risan hastanelerindedir.",
		"TipPediatricUlcinj": "Ulcinj'de devlet hastanesi yok. Gece çocukla acil bir durumda çocuk bölümü olan Bar hastanesine doğrudan gitmek daha iyidir.",
		"TipSurgeryUlcinj": "Ulcinj'de Dom Zdravlja (poliklinik) var, ancak devlet hastanesi yok. Sadece ayakta tedavi mümkündür. En yakın ameliyathane Bar hastanesindedir.",
		"TipHercegNovi": "Herceg Novi'nin kendi hastanesi yok. En yakınları",
		"TipPediatricHercegNovi": "Herceg Novi'de devlet hastanesi yok. Gece çocukla acil bir durumda Kotor veya Risan hastanelerine doğrudan gitmek daha iyidir.",
		"TipSurgeryHercegNovi": "Herceg Novi'de Dom Zdravlja (poliklinik) var, ancak devlet hastanesi yok. Sadece ayakta tedavi mümkündür. En yakın ameliyathaneler Kotor ve Risan hastanelerindedir."
	}
}
</i18n>
