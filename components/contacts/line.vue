<template>
	<div class="contact-item phone-item">
		<a
			v-if="link"
			:href="value"
			class="contact-link messenger-link"
			target="_blank"
		>
			<slot />
		</a>
		<span v-else class="contact-link">
			<slot />
		</span>

		<ContactsCopyButton :value="value" />
	</div>
</template>

<script setup lang="ts">
defineProps<{
	value: string;
	link?: boolean;
}>();
</script>

<style scoped src="./style.css" />
