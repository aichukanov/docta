<template>
	<FilterWrapper :label="t('Specialty')">
		<el-select
			v-model="specialtyIds"
			:placeholder="t('AnySpecialty')"
			:no-data-text="t('NotFound')"
			size="large"
			multiple
			@visible-change="focusSearchInput($event)"
		>
			<template #header>
				<el-input
					ref="searchInput"
					v-model="search"
					:placeholder="t('SearchSpecialty')"
				/>
			</template>
			<el-option
				v-for="{ text, value } in specialties"
				:key="value"
				:label="text"
				:value="value"
			/>
		</el-select>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';

const { t } = useI18n(specialtyI18n);

const { specialtyIds } = useFilters();

const search = ref('');
const searchInput = ref<HTMLInputElement | null>(null);

const specialties = computed(() =>
	Object.values(DoctorSpecialty)
		.filter(Number)
		.map((key) => ({
			text: t(key),
			value: key,
		}))
		.filter((specialty) =>
			specialty.text.toLowerCase().includes(search.value.toLowerCase()),
		)
		.sort((a, b) => a.text.localeCompare(b.text)),
);

const focusSearchInput = async (visible: boolean) => {
	if (visible && searchInput.value) {
		await nextTick();
		searchInput.value.focus();
	}
};
</script>
