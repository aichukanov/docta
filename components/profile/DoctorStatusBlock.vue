<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { PROJECT_CONTACTS } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorProfileStatus } from '~/interfaces/doctor';

const props = defineProps<{
	status: DoctorProfileStatus;
	doctorId: number;
	doctorSlug: string;
	isToggling: boolean;
	// Причина скрытия админом — как есть, на сербском (см. doctors
	// .hidden_by_admin_reason). Может быть пустой: тогда плашка обходится
	// общим описанием статуса.
	hiddenReason?: string;
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
		hidden_by_admin: t('statusHiddenByAdmin'),
	};
	return map[props.status];
});

const statusDesc = computed(() => {
	const map: Record<DoctorProfileStatus, string> = {
		draft: t('statusDraftDesc'),
		public: t('statusPublicDesc'),
		hidden: t('statusHiddenDesc'),
		hidden_by_admin: t('statusHiddenByAdminDesc'),
	};
	return map[props.status];
});

const doctorLink = computed(() => ({
	name: 'doctors-doctorSlug',
	params: { doctorSlug: props.doctorSlug },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="status-block" :class="`status-block--${status}`">
		<div class="status-block__header">
			<span class="status-block__badge">
				<IconLock v-if="status !== 'public'" :size="14" />
				<IconCheck v-else :size="14" />
				{{ statusLabel }}
			</span>
		</div>
		<p class="status-block__desc">{{ statusDesc }}</p>

		<!-- Почему скрыли и что сделать, чтобы вернуться. Причина написана
		     администратором на сербском, поэтому помечена lang="sr". -->
		<div v-if="status === 'hidden_by_admin'" class="status-block__reason">
			<template v-if="hiddenReason">
				<span class="status-block__reason-label">{{ t('hiddenReason') }}</span>
				<p class="status-block__reason-text" lang="sr">{{ hiddenReason }}</p>
			</template>
			<p class="status-block__reason-action">
				{{ t('hiddenReasonAction') }}
				<a :href="`mailto:${PROJECT_CONTACTS.email}`">
					{{ PROJECT_CONTACTS.email }}
				</a>
			</p>
		</div>

		<!-- Страница непубличного профиля открывается владельцу (с баннером
		     наверху), поэтому ссылка есть при любом статусе. Переключать
		     видимость можно только там, где это решение врача. -->
		<div class="status-block__actions">
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
				v-else-if="status === 'hidden'"
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

.status-block--hidden,
.status-block--hidden_by_admin {
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
	color: var(--color-primary-green);
}

.status-block--hidden .status-block__badge,
.status-block--hidden_by_admin .status-block__badge {
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

.status-block__reason {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	padding: var(--spacing-md);
	background: var(--color-bg-primary);
	border: 1px solid var(--color-danger-border);
	border-radius: var(--border-radius-md);
}

.status-block__reason-label {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-semibold);
	color: var(--color-danger-dark);
}

.status-block__reason-text,
.status-block__reason-action {
	margin: 0;
	font-size: var(--font-size-sm);
	color: var(--color-text-primary);
	line-height: 1.5;
}

.status-block__reason-action {
	color: var(--color-text-secondary);
}
</style>
