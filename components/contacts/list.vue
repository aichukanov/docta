<template>
	<div class="contacts-list">
		<!-- Прямая связь -->
		<div v-if="hasDirectContacts" class="contacts-group">
			<!-- Сгруппированные номера телефонов с каналами -->
			<ContactsPhoneGroupLine
				v-for="group in phoneGroups"
				:key="group.phoneNumber"
				:phoneNumber="group.phoneNumber"
				:hasPhone="group.hasPhone"
				:hasWhatsapp="group.hasWhatsapp"
				:hasViber="group.hasViber"
				:hasTelegram="group.hasTelegram"
			/>

			<!-- Telegram-контакты которые не являются номерами (юзернеймы) -->
			<ContactsTelegramLine
				v-for="contact in telegramUsernames"
				:key="contact"
				:contact="contact"
			/>

			<ContactsEmailLine
				v-for="emailAddress in emailAddresses"
				:key="emailAddress"
				:emailAddress="emailAddress"
			/>
		</div>
		<!-- Онлайн-присутствие -->
		<div v-if="hasOnlinePresence" class="contacts-group">
			<ContactsWebsiteLine
				v-for="websiteUrl in websiteUrls"
				:key="websiteUrl"
				:websiteUrl="websiteUrl"
				:nofollow="websiteNofollow"
			/>

			<ContactsFacebookLine
				v-for="facebookProfile in facebookProfiles"
				:key="facebookProfile"
				:profile="facebookProfile"
			/>

			<ContactsInstagramLine
				v-for="instagramProfile in instagramProfiles"
				:key="instagramProfile"
				:profile="instagramProfile"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import { splitContacts, isPhoneNumber } from './utils';
import type { ContactList } from '~/interfaces/contacts';
import { BillingService } from '~/enums/billing-service';

interface PhoneGroup {
	phoneNumber: string;
	hasPhone: boolean;
	hasWhatsapp: boolean;
	hasViber: boolean;
	hasTelegram: boolean;
}

const props = defineProps<{
	list: ContactList;
}>();

const phoneNumbers = computed(() => splitContacts(props.list.phone));
const emailAddresses = computed(() => splitContacts(props.list.email));
const whatsappContacts = computed(() => splitContacts(props.list.whatsapp));
const telegramContacts = computed(() => splitContacts(props.list.telegram));
const viberContacts = computed(() => splitContacts(props.list.viber));
const facebookProfiles = computed(() => splitContacts(props.list.facebook));
const instagramProfiles = computed(() => splitContacts(props.list.instagram));
const websiteUrls = computed(() => splitContacts(props.list.website));
const hasDofollow = computed(() =>
	props.list.features?.includes(BillingService.DOFOLLOW),
);
const websiteNofollow = computed(() => !hasDofollow.value);

// Группировка номеров телефонов с их каналами
const phoneGroups = computed<PhoneGroup[]>(() => {
	const phoneSet = new Set(phoneNumbers.value);
	const whatsappSet = new Set(whatsappContacts.value.filter(isPhoneNumber));
	const viberSet = new Set(viberContacts.value.filter(isPhoneNumber));
	const telegramSet = new Set(telegramContacts.value.filter(isPhoneNumber));

	// Собираем все уникальные номера
	const allNumbers = new Set([
		...phoneSet,
		...whatsappSet,
		...viberSet,
		...telegramSet,
	]);

	return [...allNumbers].map((phoneNumber) => ({
		phoneNumber,
		hasPhone: phoneSet.has(phoneNumber),
		hasWhatsapp: whatsappSet.has(phoneNumber),
		hasViber: viberSet.has(phoneNumber),
		hasTelegram: telegramSet.has(phoneNumber),
	}));
});

// Telegram-контакты которые НЕ являются номерами телефона (юзернеймы)
const telegramUsernames = computed(() =>
	telegramContacts.value.filter((c) => !isPhoneNumber(c)),
);

const hasOnlinePresence = computed(
	() =>
		websiteUrls.value.length > 0 ||
		facebookProfiles.value.length > 0 ||
		instagramProfiles.value.length > 0,
);

const hasDirectContacts = computed(
	() =>
		phoneGroups.value.length > 0 ||
		emailAddresses.value.length > 0 ||
		telegramUsernames.value.length > 0,
);
</script>

<style scoped src="./style.css" />
