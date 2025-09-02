<template>
	<div class="contact-item phone-item">
		<span class="contact-link">
			<IconPhone :size="20" class="phone-icon" />
			<span>{{ phoneNumber }}</span>
		</span>

		<ContactsCopyButton :phoneNumber="phoneNumber" />
	</div>
</template>

<script setup lang="ts">
import { formatPhoneNumber } from './utils';

const props = defineProps<{
	phoneNumber: string;
}>();

const phoneNumber = computed(() => formatPhoneNumber(props.phoneNumber));
</script>

<style scoped src="./style.css" />
