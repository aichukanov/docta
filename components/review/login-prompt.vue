<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t, locale } = useReviewsI18n();

const loginLink = computed(() => ({
	path: '/login',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="review-login-prompt">
		<NuxtLink :to="loginLink">
			<el-button type="primary">{{ t('LoginToReview') }}</el-button>
		</NuxtLink>
		<NuxtLink :to="loginLink" class="register-link">
			{{ t('RegisterToReview') }}
		</NuxtLink>
	</div>
</template>

<style scoped>
.review-login-prompt {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
}

.register-link {
	color: var(--kit-color-text-muted);
	text-decoration: none;
	font-size: var(--kit-font-size-base);
}

.register-link:hover {
	color: var(--kit-color-primary);
	text-decoration: underline;
}
</style>
