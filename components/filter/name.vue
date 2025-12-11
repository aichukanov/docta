<template>
	<FilterWrapper :label="label">
		<el-input v-model="localName" :placeholder="placeholder" size="large" />
	</FilterWrapper>
</template>

<script setup lang="ts">
import { debounce } from 'lodash-es';

defineProps<{
	label: string;
	placeholder: string;
}>();

const { name } = useFilters();

const localName = ref(name.value);

const updateName = debounce((value: string) => {
	name.value = value;
}, 300);

watch(localName, (value) => {
	updateName(value);
});

watch(name, (value) => {
	if (value !== localName.value) {
		localName.value = value;
	}
});
</script>
