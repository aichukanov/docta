<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';
import specialtyI18n from '~/i18n/specialty';

const props = defineProps<{
	doctor: DoctorData;
}>();

const { t } = useI18n(specialtyI18n);

const specialtiesText = computed(() => {
	return props.doctor.specialtyIds
		?.split(',')
		.map((specialty) => t(specialty) || specialty)
		.join(', ');
});
</script>

<template>
	<div class="doctor-specialty">
		{{ specialtiesText }}
	</div>
</template>

<style scoped lang="less">
.doctor-specialty {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-primary-green);
	line-height: 1.3;
}

@media (max-width: 768px) {
	.doctor-specialty {
		font-size: var(--font-size-md);
	}
}
</style>
