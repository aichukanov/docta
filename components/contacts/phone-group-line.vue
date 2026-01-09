<script setup lang="ts">
import { formatPhoneNumber } from './utils';

const props = defineProps<{
	phoneNumber: string;
	hasPhone?: boolean;
	hasWhatsapp?: boolean;
	hasViber?: boolean;
	hasTelegram?: boolean;
}>();

const { t } = useI18n();

const formattedNumber = computed(() => formatPhoneNumber(props.phoneNumber));

const cleanNumber = computed(() => props.phoneNumber.replace(/[^+\d]/g, ''));

const waUrl = computed(() => `https://wa.me/${cleanNumber.value}`);
const viberUrl = computed(() => `viber://chat?number=${cleanNumber.value}`);
const telegramUrl = computed(() => `https://t.me/${cleanNumber.value}`);
</script>

<template>
	<div class="phone-group-item">
		<div class="phone-header">
			<span class="phone-number">{{ formattedNumber }}</span>
			<ContactsCopyButton :value="phoneNumber" />
		</div>

		<div class="channel-buttons">
			<a v-if="hasPhone" :href="`tel:${phoneNumber}`" class="channel-btn">
				<IconPhone :size="20" />
				<span>{{ t('Call') }}</span>
			</a>

			<a
				v-if="hasTelegram"
				:href="telegramUrl"
				target="_blank"
				class="channel-btn channel-telegram"
			>
				<IconTelegram :size="20" />
				<span>Telegram</span>
			</a>

			<a
				v-if="hasWhatsapp"
				:href="waUrl"
				target="_blank"
				class="channel-btn channel-whatsapp"
			>
				<IconWhatsapp :size="20" />
				<span>WhatsApp</span>
			</a>

			<a
				v-if="hasViber"
				:href="viberUrl"
				target="_blank"
				class="channel-btn channel-viber"
			>
				<IconViber :size="20" />
				<span>Viber</span>
			</a>
		</div>
	</div>
</template>

<style scoped>
.phone-group-item {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-sm);
}

.phone-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-sm);
}

.phone-number {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
}

.channel-buttons {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

.channel-btn {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	padding: var(--spacing-sm) var(--spacing-md);
	border: none;
	border-radius: var(--border-radius-sm);
	background: var(--color-bg-secondary);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
	text-decoration: none;
	cursor: pointer;
	transition: all var(--transition-base);
}

.channel-btn:hover {
	background: var(--color-primary-light);
	color: var(--color-primary);
}

.channel-whatsapp:hover {
	background: rgba(37, 211, 102, 0.1);
	color: #25d366;
}

.channel-viber:hover {
	background: rgba(115, 96, 242, 0.1);
	color: #7360f2;
}

.channel-telegram:hover {
	background: rgba(0, 136, 204, 0.1);
	color: #0088cc;
}

@media (max-width: 480px) {
	.channel-buttons {
		flex-direction: column;
	}

	.channel-btn {
		justify-content: center;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"Call": "Call"
	},
	"ru": {
		"Call": "Позвонить"
	},
	"sr": {
		"Call": "Pozovi"
	},
	"sr-cyrl": {
		"Call": "Позови"
	},
	"de": {
		"Call": "Anrufen"
	},
	"tr": {
		"Call": "Ara"
	}
}
</i18n>
