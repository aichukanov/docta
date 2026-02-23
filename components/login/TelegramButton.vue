<script setup lang="ts">
const loading = ref(false);

function signInWithTelegram() {
	loading.value = true;
	window.location.href = '/api/auth/telegram';
}
</script>

<template>
	<OAuthIconButton provider="telegram" :disabled="loading" @click="signInWithTelegram">
		<IconTelegram :size="20" color="white" />
	</OAuthIconButton>
</template>
