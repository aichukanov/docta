<script setup lang="ts">
export type OAuthProvider = 'google' | 'facebook' | 'telegram';

interface Props {
	provider: OAuthProvider;
	disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
	disabled: false,
});

const emit = defineEmits<{
	click: [];
}>();
</script>

<template>
	<button
		class="oauth-icon-btn"
		:class="`oauth-icon-btn--${provider}`"
		:disabled="disabled"
		:title="provider.charAt(0).toUpperCase() + provider.slice(1)"
		@click="emit('click')"
	>
		<slot />
	</button>
</template>

<style scoped>
.oauth-icon-btn {
	width: 48px;
	height: 48px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: all 0.2s ease;
	padding: 0;
	outline: none;
	border: 1px solid transparent;
}

.oauth-icon-btn:hover {
	transform: scale(1.08);
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.oauth-icon-btn:active {
	transform: scale(0.96);
}

.oauth-icon-btn:disabled {
	opacity: 0.6;
	cursor: not-allowed;
	transform: none;
}

/* Google */
.oauth-icon-btn--google {
	background: #fff;
	border-color: #dadce0;
}

.oauth-icon-btn--google:hover {
	background: #f8f9fa;
	border-color: #c6c6c6;
}

/* Facebook */
.oauth-icon-btn--facebook {
	background: #1877f2;
	border-color: #1877f2;
}

.oauth-icon-btn--facebook:hover {
	background: #166fe5;
	border-color: #166fe5;
}

/* Telegram */
.oauth-icon-btn--telegram {
	background: #54a9eb;
	border-color: #54a9eb;
}

.oauth-icon-btn--telegram:hover {
	background: #4a96d1;
	border-color: #4a96d1;
}
</style>
