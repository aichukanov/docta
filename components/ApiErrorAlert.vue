<script setup lang="ts">
import type { ERROR_CODES } from '~/server/utils/api-codes';
import apiErrorMessages from '~/i18n/api-errors';

defineOptions({ inheritAttrs: false });

const { t } = useI18n({
	useScope: 'local',
	messages: apiErrorMessages.messages,
});

const props = withDefaults(
	defineProps<{
		error: ERROR_CODES | null;
		closable?: boolean;
	}>(),
	{ closable: false },
);

const emit = defineEmits<{
	close: [];
}>();

const message = computed(() => {
	if (!props.error) return null;
	return t(`error_${props.error}`);
});
</script>

<template>
	<template v-if="message">
		<slot :message="message">
			<el-alert
				v-bind="$attrs"
				:title="message"
				type="error"
				:closable="closable"
				@close="emit('close')"
			/>
		</slot>
	</template>
</template>
