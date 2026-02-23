<script setup lang="ts">
const loading = ref(false);

function signInWithGoogle() {
	loading.value = true;
	window.location.href = '/api/auth/google';
}
</script>

<template>
	<OAuthIconButton provider="google" :disabled="loading" @click="signInWithGoogle">
		<IconGoogle :size="20" />
	</OAuthIconButton>
</template>
