<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicStatus } from '~/interfaces/clinic';

const props = defineProps<{
	status: ClinicStatus;
	clinicSlug: string;
	isToggling: boolean;
}>();

const emit = defineEmits<{
	(e: 'publish'): void;
	(e: 'hide'): void;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});

const statusLabel = computed(() => {
	const map: Record<ClinicStatus, string> = {
		draft: t('StatusDraft'),
		published: t('StatusPublished'),
		pending_verification: t('StatusPendingVerification'),
		rejected: t('StatusRejected'),
	};
	return map[props.status];
});

const statusDesc = computed(() => {
	const map: Record<ClinicStatus, string> = {
		draft: t('StatusDraftDesc'),
		published: t('StatusPublishedDesc'),
		pending_verification: t('StatusPendingVerificationDesc'),
		rejected: t('StatusRejectedDesc'),
	};
	return map[props.status];
});

const canPublish = computed(
	() => props.status === 'draft' || props.status === 'rejected',
);
const canHide = computed(
	() => props.status === 'published' || props.status === 'pending_verification',
);

const clinicLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: props.clinicSlug },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="status-block" :class="`status-block--${status}`">
		<div class="status-block__header">
			<span class="status-block__badge">
				<IconCheck v-if="status === 'published'" :size="14" />
				<IconLock v-else :size="14" />
				{{ statusLabel }}
			</span>
		</div>
		<p class="status-block__desc">{{ statusDesc }}</p>

		<div class="status-block__actions">
			<NuxtLink :to="clinicLink" target="_blank">
				<el-button size="small" type="primary">
					{{ t('BtnView') }}
				</el-button>
			</NuxtLink>
			<el-button
				v-if="canPublish"
				size="small"
				type="success"
				:loading="isToggling"
				@click="emit('publish')"
			>
				{{ t('BtnPublish') }}
			</el-button>
			<el-button
				v-else-if="canHide"
				size="small"
				type="warning"
				:loading="isToggling"
				@click="emit('hide')"
			>
				{{ t('BtnHide') }}
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.status-block {
	padding: var(--spacing-lg);
	border-radius: var(--border-radius-lg);
	border: 1px solid var(--color-border-primary);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.status-block--draft,
.status-block--pending_verification {
	background: var(--color-warning-bg);
	border-color: var(--color-warning-border);
}

.status-block--published {
	background: var(--color-success-bg);
	border-color: var(--color-success-border);
}

.status-block--rejected {
	background: var(--color-danger-bg);
	border-color: var(--color-danger-border);
}

.status-block__header {
	display: flex;
	align-items: center;
}

.status-block__badge {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-semibold);
	padding: 4px 12px;
	border-radius: 20px;
	text-transform: uppercase;
	letter-spacing: 0.3px;
}

.status-block--draft .status-block__badge,
.status-block--pending_verification .status-block__badge {
	background: var(--color-warning-border);
	color: var(--color-warning-dark);
}

.status-block--published .status-block__badge {
	background: var(--color-success-border);
	color: var(--color-primary-green);
}

.status-block--rejected .status-block__badge {
	background: var(--color-danger-border);
	color: var(--color-danger-dark);
}

.status-block__desc {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	margin: 0;
	line-height: 1.5;
}

.status-block__actions {
	display: flex;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}
</style>
