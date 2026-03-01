<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { locale } = useI18n({ useScope: 'global' });

await navigateTo(
	{
		name: 'profile-basic',
		query: getRegionalQuery(locale.value),
	},
	{ redirectCode: 301, replace: true },
);
</script>
