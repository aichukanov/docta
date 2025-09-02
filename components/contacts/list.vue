<template>
	<div class="contacts-list">
		<ContactsWebsiteLine
			v-for="websiteUrl in websiteUrls"
			:key="websiteUrl"
			:websiteUrl="websiteUrl"
		/>

		<ContactsPhoneLine
			v-for="phoneNumber in phoneNumbers"
			:key="phoneNumber"
			:phoneNumber="phoneNumber"
		/>

		<ContactsEmailLine
			v-for="emailAddress in emailAddresses"
			:key="emailAddress"
			:emailAddress="emailAddress"
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
</script>

<style scoped src="./style.css" />
