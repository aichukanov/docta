<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import clinicReputationI18n from '~/i18n/clinic-reputation';
import type { ClinicComplaint } from '~/interfaces/clinic-reputation';

/**
 * Раздел «Репутация» на странице клиники (prd/clinic-reputation/).
 * Только стандартные формулировки из словаря + чип статуса; свободный текст —
 * лишь официальный ответ клиники. Пустой список — секция не рендерится вовсе
 * (решает родитель по complaints.length).
 */
const props = defineProps<{
	complaints: ClinicComplaint[];
	clinicId: number;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicReputationI18n.messages,
});

const articleLink = (slug: string) => ({
	path: `/articles/${slug}`,
	query: getRegionalQuery(locale.value),
});

// Ответ клиники может быть продублирован в несколько строк — показываем
// каждый уникальный текст один раз, под списком
const clinicResponses = computed(() => {
	const texts = props.complaints
		.map((c) => c.clinicResponse)
		.filter((text): text is string => Boolean(text));
	return [...new Set(texts)];
});

// Раздел читают? — одно событие на просмотр (паттерн entity_viewed)
const { trackEvent } = useAnalytics();
const { target: sectionTarget, hasBeenVisible } = useInViewport();
watch(hasBeenVisible, (visible) => {
	if (visible) {
		trackEvent('reputation_viewed', { clinic_id: props.clinicId });
	}
});
</script>

<template>
	<div ref="sectionTarget" class="reputation-section">
		<ul class="reputation-list">
			<li
				v-for="complaint in complaints"
				:key="complaint.type"
				class="reputation-item"
			>
				<div class="reputation-item__row">
					<span class="reputation-item__text">{{
						t(`Complaint${complaint.type}`)
					}}</span>
					<el-tooltip
						:content="
							complaint.status === 'confirmed'
								? t('ConfirmedByEditorsHint')
								: t('UnconfirmedHint')
						"
						placement="top"
						effect="light"
					>
						<KitTag
							:variant="
								complaint.status === 'confirmed' ? 'warning' : 'default'
							"
							appearance="light"
							size="small"
							class="reputation-item__status"
						>
							{{
								complaint.status === 'confirmed'
									? t('ConfirmedByEditors')
									: t('Unconfirmed')
							}}
						</KitTag>
					</el-tooltip>
				</div>
				<div
					v-if="complaint.reviewId || complaint.articleSlug"
					class="reputation-item__links"
				>
					<a v-if="complaint.reviewId" href="#reviews">{{
						t('SeePinnedReview')
					}}</a>
					<NuxtLink
						v-if="complaint.articleSlug"
						:to="articleLink(complaint.articleSlug)"
					>
						{{ t('SeeArticle') }}
					</NuxtLink>
				</div>
			</li>
		</ul>

		<div v-if="clinicResponses.length" class="reputation-response">
			<div class="reputation-response__title">
				{{ t('ClinicResponseTitle') }}
			</div>
			<p
				v-for="(response, index) in clinicResponses"
				:key="index"
				class="reputation-response__text"
			>
				{{ response }}
			</p>
		</div>

		<p class="reputation-footer">{{ t('ReputationFooter') }}</p>
	</div>
</template>

<style scoped lang="less">
.reputation-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.reputation-list {
	list-style: none;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
}

.reputation-item {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
	padding: var(--kit-spacing-md);
	background: var(--kit-color-warning-bg);
	border: 1px solid var(--kit-color-warning-border);
	border-radius: var(--kit-border-radius-md);

	&__row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--kit-spacing-md);
		flex-wrap: wrap;
	}

	// warning-dark на warning-bg — паттерн owner-banner, контраст достаточный
	&__text {
		color: var(--kit-color-warning-dark);
		font-weight: var(--kit-font-weight-medium);
	}

	&__status {
		cursor: help;
		flex-shrink: 0;
	}

	&__links {
		display: flex;
		gap: var(--kit-spacing-md);
		font-size: var(--kit-font-size-sm);
	}
}

.reputation-response {
	padding: var(--kit-spacing-md);
	background: var(--kit-color-surface-secondary);
	border-radius: var(--kit-border-radius-md);

	&__title {
		font-weight: var(--kit-font-weight-semibold);
		margin-bottom: var(--kit-spacing-xs);
	}

	&__text {
		margin: 0;
		color: var(--kit-color-text-secondary);
		white-space: pre-line;
	}
}

.reputation-footer {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-secondary);
}
</style>
