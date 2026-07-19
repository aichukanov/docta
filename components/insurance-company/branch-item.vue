<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { formatPhoneNumber, splitContacts } from '~/components/contacts/utils';
import type { InsuranceBranchData } from '~/interfaces/insurance-company';

const props = defineProps<{
	branch: InsuranceBranchData;
	companyPhone?: string;
	companyEmail?: string;
}>();

defineEmits<{ showOnMap: [] }>();

// companyPhone/companyEmail — fallback-поля компании, у них может быть
// несколько значений через ";" (несколько офисных линий/адресов) — на
// филиал без своего контакта берём только первое, а не всю строку целиком
const phone = computed(() => {
	const raw = props.branch.phone || splitContacts(props.companyPhone)[0];
	return raw ? formatPhoneNumber(raw) : undefined;
});
const email = computed(
	() => props.branch.email || splitContacts(props.companyEmail)[0],
);
// Постоянная ссылка на конкретный офис (со временем сюда будут вести и отзывы
// по офису — id филиала как якорь стабилен, в отличие от порядкового номера).
const anchorId = computed(() => `branch-${props.branch.id}`);
</script>

<template>
	<div :id="anchorId" class="insurance-branch-item">
		<address class="insurance-branch-item__address">
			<LocationFilled aria-hidden="true" />
			<ClinicLocationAddress :clinic="branch" />
		</address>

		<div v-if="phone" class="insurance-branch-item__meta-row">
			<IconPhone :size="16" aria-hidden="true" />
			<span>{{ phone }}</span>
		</div>

		<div v-if="email" class="insurance-branch-item__meta-row">
			<IconEmail :size="16" aria-hidden="true" />
			<span>{{ email }}</span>
		</div>

		<div v-if="branch.workingHours" class="insurance-branch-item__meta-row">
			<IconClock :size="16" aria-hidden="true" />
			<span>{{ branch.workingHours }}</span>
		</div>

		<div class="insurance-branch-item__actions">
			<ClinicShowOnMapButton @click="$emit('showOnMap')" />
			<ClinicRouteButton :clinic="branch" />
		</div>
	</div>
</template>

<style scoped lang="less">
.insurance-branch-item {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	// Учитываем sticky EntityPageTabBar при переходе по #branch-{id}
	scroll-margin-top: 120px;
	transition: border-color 0.2s ease;

	// Подсветка при переходе по прямой ссылке на офис (#branch-{id})
	&:target {
		border-color: var(--color-primary);
	}
}

.insurance-branch-item__address {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-xs);
	font-style: normal;
	color: var(--color-text-primary);

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
		margin-top: 2px;
		color: var(--color-text-secondary);
	}
}

.insurance-branch-item__meta-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
}

.insurance-branch-item__actions {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-sm);
}
</style>
