<script setup lang="ts">
import type { ERROR_CODES } from '~/server/utils/api-codes';
import apiErrorMessages from '~/i18n/api-errors';

defineOptions({ inheritAttrs: false });

const { t } = useI18n({
	useScope: 'local',
	messages: apiErrorMessages.messages,
});

// Подпись кнопки закрытия живёт в глобальном словаре, а не среди кодов ошибок,
// поэтому за ней нужен отдельный t с глобальной областью.
const { t: tGlobal } = useI18n({ useScope: 'global' });

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
			<KitAlert
				v-bind="$attrs"
				variant="error"
				:title="message"
				:closable="closable"
				:close-label="tGlobal('Close')"
				@close="emit('close')"
			/>
		</slot>
	</template>
</template>
