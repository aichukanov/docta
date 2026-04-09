<script setup lang="ts">
import { useConfirm } from '~/composables/use-confirm';

const { state, handleConfirm, handleCancel } = useConfirm();
</script>

<template>
	<ConfirmDialog
		v-model="state.visible"
		:title="state.title"
		:confirmText="state.confirmText"
		:cancelText="state.cancelText"
		:confirmType="state.confirmType"
		@confirm="handleConfirm"
		@cancel="handleCancel"
	>
		{{ state.message }}
	</ConfirmDialog>
</template>
