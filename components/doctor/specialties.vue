<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorCardData } from '~/interfaces/doctor';
import specialtyI18n from '~/i18n/specialty';

const props = defineProps<{
	doctor: DoctorCardData;
}>();

const { t, locale } = useI18n(specialtyI18n);

const specialtyIdList = computed(
	() => props.doctor.specialtyIds?.split(',').filter(Boolean) ?? [],
);

const specialtyLink = (specialtyId: string) => ({
	name: 'doctors',
	query: { ...getRegionalQuery(locale.value), specialtyIds: specialtyId },
});
</script>

<template>
	<div class="doctor-specialty">
		<template v-for="(specialtyId, index) in specialtyIdList" :key="specialtyId">
			<NuxtLink class="doctor-specialty__link" :to="specialtyLink(specialtyId)">{{
				t(`specialty_${specialtyId}`)
			}}</NuxtLink
			><span v-if="index < specialtyIdList.length - 1">, </span>
		</template>
	</div>
</template>

<style scoped lang="less">
.doctor-specialty {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-medium);
	line-height: 1.3;
	word-break: break-word;
}

.doctor-specialty__link {
	color: var(--color-primary-green);
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}
</style>
