import { ref } from 'vue';

interface ConfirmState {
	visible: boolean;
	title: string;
	message: string;
	confirmText: string;
	cancelText: string;
	confirmType: 'primary' | 'danger';
	resolve: ((value: boolean) => void) | null;
}

const state = ref<ConfirmState>({
	visible: false,
	title: '',
	message: '',
	confirmText: 'OK',
	cancelText: 'Cancel',
	confirmType: 'primary',
	resolve: null,
});

export interface ConfirmOptions {
	title?: string;
	message: string;
	confirmText?: string;
	cancelText?: string;
	confirmType?: 'primary' | 'danger';
}

export function useConfirm() {
	const confirm = (options: ConfirmOptions): Promise<boolean> => {
		return new Promise((resolve) => {
			state.value = {
				visible: true,
				title: options.title || '',
				message: options.message,
				confirmText: options.confirmText || 'OK',
				cancelText: options.cancelText || 'Cancel',
				confirmType: options.confirmType || 'primary',
				resolve,
			};
		});
	};

	const handleConfirm = () => {
		state.value.resolve?.(true);
		state.value.visible = false;
	};

	const handleCancel = () => {
		state.value.resolve?.(false);
		state.value.visible = false;
	};

	return {
		state,
		confirm,
		handleConfirm,
		handleCancel,
	};
}
