<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorProfileStatus } from '~/interfaces/doctor';

const props = defineProps<{
	status: DoctorProfileStatus;
	doctorId: number;
	isToggling: boolean;
}>();

const emit = defineEmits<{
	(e: 'toggle-visibility'): void;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: doctorProfileI18n.messages,
});

const statusLabel = computed(() => {
	const map: Record<DoctorProfileStatus, string> = {
		draft: t('statusDraft'),
		public: t('statusPublic'),
		hidden: t('statusHidden'),
	};
	return map[props.status];
});

const statusDesc = computed(() => {
	const map: Record<DoctorProfileStatus, string> = {
		draft: t('statusDraftDesc'),
		public: t('statusPublicDesc'),
		hidden: t('statusHiddenDesc'),
	};
	return map[props.status];
});

const doctorLink = computed(() => ({
	name: 'doctors-doctorId',
	params: { doctorId: props.doctorId },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="status-block" :class="`status-block--${status}`">
		<div class="status-block__header">
			<span class="status-block__badge">
				<IconLock v-if="status === 'draft' || status === 'hidden'" :size="14" />
				<IconCheck v-else :size="14" />
				{{ statusLabel }}
			</span>
		</div>
		<p class="status-block__desc">{{ statusDesc }}</p>

		<div v-if="status !== 'draft'" class="status-block__actions">
			<NuxtLink :to="doctorLink" target="_blank">
				<el-button size="small" type="primary">
					{{ t('viewProfile') }}
				</el-button>
			</NuxtLink>
			<el-button
				v-if="status === 'public'"
				size="small"
				type="warning"
				:loading="isToggling"
				@click="emit('toggle-visibility')"
			>
				{{ t('hideProfile') }}
			</el-button>
			<el-button
				v-else
				size="small"
				type="success"
				:loading="isToggling"
				@click="emit('toggle-visibility')"
			>
				{{ t('showProfile') }}
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

.status-block--draft {
	background: var(--color-warning-bg);
	border-color: var(--color-warning-border);
}

.status-block--public {
	background: var(--color-success-bg);
	border-color: var(--color-success-border);
}

.status-block--hidden {
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

.status-block--draft .status-block__badge {
	background: var(--color-warning-border);
	color: var(--color-warning-dark);
}

.status-block--public .status-block__badge {
	background: var(--color-success-border);
	color: var(--color-success-dark);
}

.status-block--hidden .status-block__badge {
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
