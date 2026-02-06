<script setup lang="ts">
const loading = ref(false);

const config = useRuntimeConfig();
const botUsername = config.public.telegramBotUsername || 'doctame_login_bot';

function signInWithTelegram() {
	loading.value = true;
	const origin = encodeURIComponent(window.location.origin);
	const callbackUrl = encodeURIComponent(`${window.location.origin}/api/auth/callback/telegram`);
	const authUrl = `https://oauth.telegram.org/auth?bot_id=${botUsername}&origin=${origin}&embed=0&request_access=write&return_to=${callbackUrl}`;
	window.location.href = authUrl;
}
</script>

<template>
	<OAuthIconButton provider="telegram" :disabled="loading" @click="signInWithTelegram">
		<IconTelegram :size="20" color="white" />
	</OAuthIconButton>
</template>
