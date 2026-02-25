<script setup lang="ts">
const { loading, openTelegramAuth } = useTelegramAuth();
</script>

<template>
	<OAuthIconButton
		provider="telegram"
		:disabled="loading"
		@click="openTelegramAuth()"
	>
		<IconTelegram :size="20" color="white" />
	</OAuthIconButton>
</template>
