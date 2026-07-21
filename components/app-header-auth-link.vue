<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import IconUser from '~/components/icon/user.vue';

withDefaults(
	defineProps<{
		avatarSize?: number;
		drawer?: boolean;
	}>(),
	{
		avatarSize: 32,
		drawer: false,
	},
);

const { t, locale } = useI18n();
const userStore = useUserStore();
const { user, isUserLoading } = storeToRefs(userStore);

const profilePageLink = computed(() => ({
	name: 'profile-basic',
	query: getRegionalQuery(locale.value),
}));

const loginPageLink = computed(() => ({
	path: '/login',
	query: getRegionalQuery(locale.value),
}));

const userDisplayName = computed(() => {
	if (!user.value) return '';
	if (user.value.name) return user.value.name;
	if (user.value.email) return user.value.email.split('@')[0];
	return '';
});
</script>

<template>
	<ClientOnly>
		<template v-if="!isUserLoading">
			<NuxtLink
				v-if="user"
				class="app-header-auth-link app-header-auth-link--user"
				:class="{ 'app-header-auth-link--drawer': drawer }"
				:to="profilePageLink"
				:aria-label="t('GoToProfile')"
			>
				<DoctorAvatar
					:name="userDisplayName"
					:photo-url="user?.photo_url"
					:size="avatarSize"
				/>
				<span class="app-header-auth-link__name">{{ userDisplayName }}</span>
			</NuxtLink>

			<NuxtLink
				v-else
				class="app-header-auth-link app-header-auth-link--login"
				:class="{ 'app-header-auth-link--drawer': drawer }"
				:to="loginPageLink"
			>
				<IconUser class="app-header-auth-link__icon" :size="16" />
				<span>{{ t('Login') }}</span>
			</NuxtLink>
		</template>
	</ClientOnly>
</template>

<i18n lang="json">
{
	"en": { "GoToProfile": "Go to profile", "Login": "Log in" },
	"ru": { "GoToProfile": "Перейти в профиль", "Login": "Войти" },
	"sr": { "GoToProfile": "Idite na profil", "Login": "Prijavite se" },
	"sr-cyrl": { "GoToProfile": "Идите на профил", "Login": "Пријавите се" },
	"de": { "GoToProfile": "Zum Profil gehen", "Login": "Anmelden" },
	"tr": { "GoToProfile": "Profile git", "Login": "Giriş yap" }
}
</i18n>

<style lang="less" scoped>
.app-header-auth-link {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	min-width: 0;
	text-decoration: none;
	white-space: nowrap;

	&--user {
		color: var(--color-text-primary);
		padding: 4px 10px 4px 4px;
		border-radius: var(--border-radius-xl);
		transition: all var(--transition-base);

		&:hover {
			background: rgba(79, 70, 229, 0.06);
			color: var(--color-primary);
		}
	}

	&--login {
		box-sizing: border-box;
		/* 40px — вровень с переключателем языка */
		height: 40px;
		font-weight: var(--font-weight-medium);
		/* line-box = иконке (16px), иначе текст с наследуемым line-height
		   оптически уезжает ниже центра */
		line-height: 1;
		color: white;
		background: var(--color-primary);
		padding: 0 var(--spacing-lg);
		border-radius: var(--border-radius-lg);
		transition: all var(--transition-base);

		&:hover {
			background: var(--color-primary-dark);
			box-shadow: var(--shadow-hover);
		}
	}

	&--drawer {
		flex: 1;
	}

	&__name {
		font-weight: var(--font-weight-medium);
		overflow: hidden;
		text-overflow: ellipsis;
	}

	&__icon {
		width: 16px;
		height: 16px;
		flex-shrink: 0;
	}
}
</style>
