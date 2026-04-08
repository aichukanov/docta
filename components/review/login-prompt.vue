<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

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
	gap: var(--spacing-md);
}

.register-link {
	color: var(--color-text-muted);
	text-decoration: none;
	font-size: var(--font-size-base);
}

.register-link:hover {
	color: var(--color-primary);
	text-decoration: underline;
}
</style>
