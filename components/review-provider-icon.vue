<template>
	<span class="provider-icon">
		<component :is="iconComponent" class="icon-svg" :size="14" />
	</span>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import DoctaMeIcon from '~/components/icon/docta-me.vue';
import FacebookIcon from '~/components/icon/facebook.vue';
import GoogleMapsIcon from '~/components/icon/google-maps.vue';
import LinkIcon from '~/components/icon/link.vue';
import TelegramIcon from '~/components/icon/telegram.vue';

const props = defineProps<{ provider: string }>();

const iconComponent = computed(() => {
	switch (props.provider) {
		case 'google_maps':
			return GoogleMapsIcon;
		case 'facebook':
			return FacebookIcon;
		case 'telegram':
			return TelegramIcon;
		case 'docta_me':
			return DoctaMeIcon;
		default:
			return LinkIcon;
	}
});
</script>

<style scoped>
.provider-icon {
	display: inline-flex;
	align-items: center;
	margin-right: 4px;
}

.icon-svg {
	flex-shrink: 0;
}
</style>
