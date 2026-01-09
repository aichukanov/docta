<template>
	<div class="contacts-list">
		<!-- Онлайн-присутствие -->
		<div v-if="hasOnlinePresence" class="contacts-group">
			<ContactsWebsiteLine
				v-for="websiteUrl in websiteUrls"
				:key="websiteUrl"
				:websiteUrl="websiteUrl"
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

		<!-- Прямая связь -->
		<div v-if="hasDirectContacts" class="contacts-group">
			<ContactsEmailLine
				v-for="emailAddress in emailAddresses"
				:key="emailAddress"
				:emailAddress="emailAddress"
			/>

			<ContactsPhoneLine
				v-for="phoneNumber in phoneNumbers"
				:key="phoneNumber"
				:phoneNumber="phoneNumber"
			/>
			<ContactsWhatsappLine
				v-for="contact in whatsappContacts"
				:key="contact"
				:contact="contact"
			/>

			<ContactsTelegramLine
				v-for="contact in telegramContacts"
				:key="contact"
				:contact="contact"
			/>

			<ContactsViberLine
				v-for="contact in viberContacts"
				:key="contact"
				:contact="contact"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import { splitContacts } from './utils';
import type { ContactList } from '~/interfaces/contacts';

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

const hasOnlinePresence = computed(
	() =>
		websiteUrls.value.length > 0 ||
		facebookProfiles.value.length > 0 ||
		instagramProfiles.value.length > 0,
);

const hasDirectContacts = computed(
	() =>
		phoneNumbers.value.length > 0 ||
		emailAddresses.value.length > 0 ||
		whatsappContacts.value.length > 0 ||
		telegramContacts.value.length > 0 ||
		viberContacts.value.length > 0,
);
</script>

<style scoped src="./style.css" />
