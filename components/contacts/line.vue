<template>
	<div class="contact-item">
		<el-tooltip
			:content="tooltip"
			placement="bottom"
			effect="light"
			:showAfter="700"
		>
			<a
				v-if="link"
				:href="value"
				:rel="nofollow ? 'nofollow noopener' : 'noopener'"
				class="contact-link messenger-link"
				target="_blank"
			>
				<slot />
			</a>
			<span v-else class="contact-link">
				<slot />
			</span>
		</el-tooltip>

		<ContactsCopyButton :value="value" />
	</div>
</template>

<script setup lang="ts">
withDefaults(
	defineProps<{
		value: string;
		tooltip: string;
		link?: boolean;
		nofollow?: boolean;
	}>(),
	{
		nofollow: true,
	},
);
</script>

<style scoped src="./style.css" />
