<script setup lang="ts">
import { CityId } from '~/enums/cities';
import { createEmptyBranch, type AdminBranchRow } from '~/common/insurance-company-admin';

// Админка не переведена на другие языки (см. остальные components/admin/*) —
// названия городов здесь просто латиница, без привязки к i18n/city.ts
const CITY_NAMES: Record<number, string> = {
	[CityId.PODGORICA]: 'Podgorica',
	[CityId.NIKSIC]: 'Nikšić',
	[CityId.BUDVA]: 'Budva',
	[CityId.TIVAT]: 'Tivat',
	[CityId.ULCINJ]: 'Ulcinj',
	[CityId.KOTOR]: 'Kotor',
	[CityId.BAR]: 'Bar',
	[CityId.HERCEG_NOVI]: 'Herceg Novi',
	[CityId.BERANE]: 'Berane',
	[CityId.CETINJE]: 'Cetinje',
	[CityId.DANILOVGRAD]: 'Danilovgrad',
	[CityId.BELO_POLJE]: 'Bijelo Polje',
	[CityId.KOLASIN]: 'Kolašin',
	[CityId.MOJKOVAC]: 'Mojkovac',
	[CityId.ANDRIJEVICA]: 'Andrijevica',
	[CityId.PLJEVLJA]: 'Pljevlja',
	[CityId.ROZAJE]: 'Rožaje',
};

const cityOptions = Object.values(CityId)
	.filter((v): v is number => typeof v === 'number')
	.map((id) => ({ value: id, label: CITY_NAMES[id] || `#${id}` }));

const props = defineProps<{
	modelValue: AdminBranchRow[];
}>();

const emit = defineEmits<{
	(e: 'update:modelValue', value: AdminBranchRow[]): void;
}>();

const addBranch = () => {
	emit('update:modelValue', [...props.modelValue, createEmptyBranch()]);
};

const removeBranch = (index: number) => {
	const next = [...props.modelValue];
	next.splice(index, 1);
	emit('update:modelValue', next);
};
</script>

<template>
	<div class="branches-section">
		<div class="section-header">
			<h4>Филиалы</h4>
			<el-button size="small" @click="addBranch">+ Добавить филиал</el-button>
		</div>

		<div
			v-for="(branch, index) in modelValue"
			:key="branch.id ?? `new-${index}`"
			class="branch-row"
		>
			<div class="branch-row__header">
				<span>Филиал #{{ index + 1 }}{{ branch.id ? ` (id ${branch.id})` : '' }}</span>
				<el-button type="danger" size="small" @click="removeBranch(index)">
					×
				</el-button>
			</div>

			<div class="branch-row__grid">
				<el-select v-model="branch.cityId" filterable placeholder="Город">
					<el-option
						v-for="city in cityOptions"
						:key="city.value"
						:label="city.label"
						:value="city.value"
					/>
				</el-select>
				<el-input v-model="branch.postalCode" placeholder="Postal code" />

				<el-input v-model="branch.address_sr" placeholder="Адрес (SR)" />
				<el-input
					v-model="branch.address_sr_cyrl"
					placeholder="Адрес (SR-CYRL)"
				/>

				<el-input v-model="branch.town_sr" placeholder="Town (SR)" />
				<el-input v-model="branch.town_sr_cyrl" placeholder="Town (SR-CYRL)" />

				<el-input v-model="branch.latitude" placeholder="Широта" />
				<el-input v-model="branch.longitude" placeholder="Долгота" />

				<el-input v-model="branch.phone" placeholder="Телефон филиала" />
				<el-input v-model="branch.email" placeholder="Email филиала" />

				<el-input
					v-model="branch.workingHours"
					placeholder="Часы работы"
					class="branch-row__working-hours"
				/>
			</div>
		</div>

		<div v-if="!modelValue.length" class="no-branches">Филиалов пока нет</div>
	</div>
</template>

<style scoped lang="less">
.branches-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;

	h4 {
		margin: 0;
		color: var(--color-text-primary);
	}
}

.branch-row {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	padding: var(--spacing-sm);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-md);
}

.branch-row__header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.branch-row__grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(160px, 1fr));
	gap: var(--spacing-xs) var(--spacing-sm);
}

.branch-row__working-hours {
	grid-column: 1 / -1;
}

.no-branches {
	color: var(--color-text-secondary);
	font-style: italic;
}
</style>
