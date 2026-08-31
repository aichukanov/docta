<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { combineI18nMessages } from '~/i18n/utils';
import { PROJECT_CONTACTS } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';

// Непубличный профиль страница показывает только владельцу и админу — баннер
// объясняет, почему пациенты его не видят. Причина скрытия админом написана
// на сербском, как лежит в БД (doctors.hidden_by_admin_reason).
const props = defineProps<{
	// Строка «это ваш профиль» со ссылкой в кабинет — только владельцу;
	// админу достаётся одна плашка-предупреждение
	isOwner?: boolean;
	isDraft?: boolean;
	hidden?: boolean;
	hiddenByAdmin?: boolean;
	hiddenReason?: string;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([doctorProfileI18n]),
});

const { locale } = useI18n({ useScope: 'global' });

const profileLink = computed(() => ({
	name: 'profile-doctor',
	query: getRegionalQuery(locale.value),
}));

const notice = computed(() => {
	if (props.hiddenByAdmin) return t('bannerHiddenByAdmin');
	if (props.isDraft) return t('bannerDraft');
	if (props.hidden) return t('bannerHidden');
	return '';
});
</script>

<template>
	<div class="owner-banner">
		<div v-if="isOwner" class="owner-banner__row">
			<div class="owner-banner__content">
				<IconEdit :size="18" />
				<span class="owner-banner__text">{{ t('ownerBanner') }}</span>
			</div>
			<NuxtLink :to="profileLink" class="owner-banner__link">
				{{ t('ownerBannerManage') }}
			</NuxtLink>
		</div>

		<div v-if="notice" class="owner-banner__notice">
			<p class="owner-banner__notice-text">{{ notice }}</p>
			<template v-if="hiddenByAdmin">
				<p v-if="hiddenReason" class="owner-banner__reason">
					<span class="owner-banner__reason-label">{{
						t('hiddenReason')
					}}</span>
					<!-- сама причина всегда на сербском, помечаем именно её -->
					<span lang="sr">{{ hiddenReason }}</span>
				</p>
				<p class="owner-banner__notice-text">
					{{ t('hiddenReasonAction') }}
					<a :href="`mailto:${PROJECT_CONTACTS.email}`">
						{{ PROJECT_CONTACTS.email }}
					</a>
				</p>
			</template>
		</div>
	</div>
</template>

<style scoped lang="less">
.owner-banner {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md) var(--kit-spacing-xl);
	background: var(--kit-color-primary-bg);
	border: 1px solid var(--kit-color-border-accent);
	border-radius: var(--kit-border-radius-lg);
}

.owner-banner__row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);
}

.owner-banner__notice {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
	padding: var(--kit-spacing-xs) var(--kit-spacing-md);
	background: var(--kit-color-warning-bg);
	border: 1px solid var(--kit-color-warning-border);
	border-radius: var(--kit-border-radius-md);
}

.owner-banner__notice-text {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-warning-dark);
	line-height: 1.5;
}

.owner-banner__reason {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-primary);
	line-height: 1.5;
}

.owner-banner__reason-label {
	font-weight: var(--kit-font-weight-semibold);
	margin-right: var(--kit-spacing-xs);
}

.owner-banner__content {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
	color: var(--kit-color-primary);
}

.owner-banner__text {
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-medium);
}

.owner-banner__link {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-primary);
	text-decoration: none;
	white-space: nowrap;
	transition: color var(--kit-transition-fast);

	&:hover {
		color: var(--kit-color-primary-dark);
	}
}
</style>
