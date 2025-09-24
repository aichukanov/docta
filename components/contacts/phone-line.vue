<template>
	<ContactsLine :value="phoneNumber">
		<IconPhone :size="20" class="phone-icon" />
		<span>{{ formatPhoneNumber(phoneNumber) }}</span>
	</ContactsLine>
</template>

<script setup lang="ts">
import { formatPhoneNumber } from './utils';

defineProps<{
	phoneNumber: string;
}>();
</script>

<style scoped src="./style.css" />
