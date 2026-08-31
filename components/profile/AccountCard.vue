<script setup lang="ts">
import accountCardMessages from '~/i18n/account-card';

const { t } = useI18n({
	useScope: 'local',
	messages: accountCardMessages.messages,
});

withDefaults(
	defineProps<{
		provider: string;
		isConnected?: boolean;
		isPrimary?: boolean;
		details?: { label: string; value: string }[];
		verifiedEmail?: boolean;
		isLoading?: boolean;
	}>(),
	{
		isConnected: false,
		isPrimary: false,
		details: () => [],
		verifiedEmail: false,
		isLoading: false,
	},
);

const emit = defineEmits<{
	'unlink': [];
	'set-primary': [];
	'link': [];
}>();
</script>

<template>
	<div class="account-card" :class="{ 'account-card--connected': isConnected }">
		<div class="account-card__header">
			<div class="account-card__provider">
				<span class="account-card__provider-icon"><slot name="icon" /></span>
				<span class="account-card__provider-name">{{ provider }}</span>
			</div>
			<span
				v-if="isConnected"
				class="account-card__status account-card__status--on"
			>
				<span class="account-card__status-dot"></span>
				{{ t('connected') }}
			</span>
			<span v-else class="account-card__status account-card__status--off">
				{{ t('notConnected') }}
			</span>
		</div>

		<div v-if="details?.length" class="account-card__details">
			<div
				v-for="detail in details"
				:key="detail.label"
				class="account-card__detail"
			>
				<span class="account-card__detail-label">{{ detail.label }}</span>
				<span class="account-card__detail-value">{{ detail.value }}</span>
			</div>
			<div v-if="verifiedEmail" class="account-card__detail">
				<span class="account-card__verified-badge">
					{{ t('emailVerified') }}
				</span>
			</div>
		</div>

		<el-tooltip v-if="isPrimary" :content="t('primaryHint')" placement="top">
			<div class="account-card__primary-badge">
				{{ t('primary') }}
			</div>
		</el-tooltip>

		<div class="account-card__actions">
			<template v-if="isConnected">
				<el-tooltip
					v-if="!isPrimary"
					:content="t('setPrimaryHint')"
					placement="top"
				>
					<el-button
						size="small"
						:loading="isLoading"
						@click="emit('set-primary')"
					>
						{{ t('setPrimary') }}
					</el-button>
				</el-tooltip>
				<el-button
					size="small"
					type="danger"
					plain
					:loading="isLoading"
					@click="emit('unlink')"
				>
					{{ t('unlink') }}
				</el-button>
			</template>
			<slot v-else name="link-action">
				<el-button
					size="small"
					type="primary"
					:loading="isLoading"
					@click="emit('link')"
				>
					{{ t('link') }}
				</el-button>
			</slot>
		</div>
	</div>
</template>

<style scoped>
.account-card {
	position: relative;
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-lg);
	padding: var(--kit-spacing-xl);
	transition: all var(--kit-transition-base);
	background: var(--kit-color-bg-primary);
}

.account-card:hover {
	border-color: var(--kit-color-border-accent);
	box-shadow: var(--kit-shadow-hover);
}

.account-card--connected {
	border-color: var(--kit-color-success-border);
	background: linear-gradient(
		135deg,
		var(--kit-color-success-bg-soft) 0%,
		var(--kit-color-bg-primary) 100%
	);
}

.account-card__header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: var(--kit-spacing-md);
}

.account-card__provider {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
}

.account-card__provider-icon {
	flex-shrink: 0;
	display: flex;
}

.account-card__provider-name {
	font-size: var(--kit-font-size-lg);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-heading);
}

.account-card__status {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
}

.account-card__status--on {
	color: var(--kit-color-primary-green);
}

.account-card__status--off {
	color: var(--kit-color-text-muted);
}

.account-card__status-dot {
	width: 8px;
	height: 8px;
	border-radius: var(--kit-border-radius-full);
	background: var(--kit-color-success);
	box-shadow: var(--kit-shadow-success-glow);
}

.account-card__details {
	display: flex;
	flex-direction: column;
	gap: 6px;
	padding: var(--kit-spacing-md);
	border-radius: var(--kit-border-radius-md);
	margin-bottom: var(--kit-spacing-md);
}

.account-card__detail {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-sm);
}

.account-card__detail-label {
	font-size: var(--kit-font-size-xs);
	color: var(--kit-color-text-muted);
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.account-card__detail-value {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-primary);
	font-weight: var(--kit-font-weight-medium);
}

.account-card__verified-badge {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	font-size: var(--kit-font-size-xs);
	color: var(--kit-color-primary-green);
	background: var(--kit-color-success-bg);
	padding: 2px 8px;
	border-radius: 12px;
	font-weight: var(--kit-font-weight-medium);
}

.account-card__primary-badge {
	display: inline-flex;
	font-size: 11px;
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-primary);
	background: var(--kit-color-primary-bg);
	padding: 3px 10px;
	border-radius: 12px;
	margin-bottom: var(--kit-spacing-md);
	text-transform: uppercase;
	letter-spacing: 0.3px;
}

.account-card__actions {
	display: flex;
	gap: var(--kit-spacing-sm);
	flex-wrap: wrap;
}
</style>
