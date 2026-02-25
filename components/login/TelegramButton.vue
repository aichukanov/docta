<script setup lang="ts">
function signInWithTelegram() {
	window.location.href = '/api/auth/telegram';
}
</script>

<template>
	<OAuthIconButton provider="telegram" @click="signInWithTelegram">
		<IconTelegram :size="20" color="white" />
	</OAuthIconButton>
</template>
