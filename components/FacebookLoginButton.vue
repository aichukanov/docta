<script setup lang="ts">
const loading = ref(false);

function signInWithFacebook() {
	loading.value = true;
	window.location.href = '/api/auth/facebook';
}
</script>

<template>
	<OAuthIconButton provider="facebook" :disabled="loading" @click="signInWithFacebook">
		<IconFacebook :size="20" color="white" />
	</OAuthIconButton>
</template>
