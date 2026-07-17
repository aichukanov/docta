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
				:rel="nofollow ? 'nofollow noopener noreferrer' : 'noopener noreferrer'"
				class="contact-link messenger-link"
				target="_blank"
				@click="trackContactClick"
			>
				<slot />
			</a>
			<span v-else class="contact-link">
				<slot />
			</span>
		</el-tooltip>

		<ContactsCopyButton :value="value" :contactType="contactType" />
	</div>
</template>

<script setup lang="ts">
import type { AnalyticsContactType } from '~/types/analytics';

const props = withDefaults(
	defineProps<{
		value: string;
		tooltip: string;
		contactType: AnalyticsContactType;
		link?: boolean;
		nofollow?: boolean;
	}>(),
	{
		nofollow: false,
	},
);

const { trackEvent } = useAnalytics();
const analyticsEntity = useAnalyticsEntity();

const trackContactClick = () => {
	trackEvent('contact_clicked', {
		...analyticsEntity.value,
		contact_type: props.contactType,
	});
};
</script>

<style scoped src="./style.css" />
