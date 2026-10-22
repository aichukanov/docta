<script setup lang="ts">
import {
	CLINIC_COMPLAINT_TYPES,
	ClinicComplaintType,
} from '~/enums/clinic-complaint-type';
import type { ClinicComplaintAdmin } from '~/interfaces/clinic-reputation';

/**
 * Редактор жалоб раздела «Репутация» (prd/clinic-reputation/). Одна строка на
 * пару (клиника, тип): сохранение по существующему типу обновляет строку.
 * Подтверждённые активные жалобы дают клинике бейдж «Осторожно» во всей выдаче.
 */
const props = defineProps<{ clinicId: number }>();

const { uiText } = useUiText();

// Служебные ярлыки для админа; публичные формулировки — i18n/clinic-reputation.ts
const TYPE_LABELS: Record<ClinicComplaintType, string> = {
	[ClinicComplaintType.IMPOSED_SERVICES]: 'Навязанные услуги',
	[ClinicComplaintType.PRICE_DISCREPANCY]:
		'Итоговая стоимость выше озвученной',
	[ClinicComplaintType.NO_WRITTEN_TERMS]: 'Нет договора и плана лечения',
	[ClinicComplaintType.NO_RECEIPT]: 'Чек не на всю сумму',
	[ClinicComplaintType.REFUND_REFUSED]: 'Невозврат предоплаты',
	[ClinicComplaintType.QUALITY_COMPLAINTS]: 'Качество лечения',
};

const typeOptions = CLINIC_COMPLAINT_TYPES.map((type) => ({
	label: `${type}. ${TYPE_LABELS[type]}`,
	value: type,
}));

const statusOptions = [
	{ label: 'Подтверждено редакцией (даёт бейдж)', value: 'confirmed' },
	{ label: 'Не подтверждено (только в разделе)', value: 'unconfirmed' },
];

const complaints = ref<ClinicComplaintAdmin[]>([]);
const isLoading = ref(false);

const emptyModel = () => ({
	complaintType: null as ClinicComplaintType | null,
	status: 'unconfirmed' as 'confirmed' | 'unconfirmed',
	isActive: true,
	reviewId: '' as string | number,
	articleSlug: '',
	incidentDate: '',
	sourceNote: '',
	clinicResponse: '',
});
const model = ref(emptyModel());

const loadComplaints = async () => {
	isLoading.value = true;
	try {
		const data = await $fetch<{ complaints: ClinicComplaintAdmin[] }>(
			'/api/admin/clinics/complaints',
			{ query: { clinicId: props.clinicId } },
		);
		complaints.value = data?.complaints || [];
	} catch (e) {
		console.error('Failed to load clinic complaints:', e);
	} finally {
		isLoading.value = false;
	}
};

const editComplaint = (complaint: ClinicComplaintAdmin) => {
	model.value = {
		complaintType: complaint.type,
		status: complaint.status,
		isActive: complaint.isActive,
		reviewId: complaint.reviewId ?? '',
		articleSlug: complaint.articleSlug ?? '',
		incidentDate: complaint.incidentDate ?? '',
		sourceNote: complaint.sourceNote ?? '',
		clinicResponse: complaint.clinicResponse ?? '',
	};
};

const saveComplaint = async () => {
	if (!model.value.complaintType) {
		alert('Выберите тип жалобы');
		return;
	}
	if (
		model.value.status === 'confirmed' &&
		!model.value.sourceNote.trim() &&
		!confirm(
			'Подтверждённая жалоба без заметки об источнике — сохранить? ' +
				'Лучше записать, какие документы видела редакция.',
		)
	) {
		return;
	}
	try {
		await $fetch('/api/admin/clinics/complaints', {
			method: 'POST',
			body: {
				clinicId: props.clinicId,
				complaintType: model.value.complaintType,
				status: model.value.status,
				isActive: model.value.isActive,
				reviewId: model.value.reviewId || null,
				articleSlug: model.value.articleSlug || null,
				incidentDate: model.value.incidentDate || null,
				sourceNote: model.value.sourceNote || null,
				clinicResponse: model.value.clinicResponse || null,
			},
		});
		model.value = emptyModel();
		await loadComplaints();
	} catch (e) {
		console.error('Failed to save clinic complaint:', e);
		alert('Не удалось сохранить жалобу');
	}
};

const toggleActive = async (complaint: ClinicComplaintAdmin) => {
	const next = !complaint.isActive;
	if (
		!confirm(
			next
				? 'Активировать жалобу?'
				: 'Деактивировать жалобу? Она пропадёт из раздела и перестанет давать бейдж.',
		)
	) {
		return;
	}
	try {
		await $fetch('/api/admin/clinics/complaints', {
			method: 'POST',
			body: {
				clinicId: props.clinicId,
				complaintType: complaint.type,
				status: complaint.status,
				isActive: next,
				reviewId: complaint.reviewId ?? null,
				articleSlug: complaint.articleSlug ?? null,
				incidentDate: complaint.incidentDate ?? null,
				sourceNote: complaint.sourceNote ?? null,
				clinicResponse: complaint.clinicResponse ?? null,
			},
		});
		await loadComplaints();
	} catch (e) {
		console.error('Failed to toggle clinic complaint:', e);
		alert('Не удалось изменить жалобу');
	}
};

watch(() => props.clinicId, loadComplaints, { immediate: true });
</script>

<template>
	<div class="complaints-section">
		<div class="section-header">
			<h4>Репутация: жалобы</h4>
		</div>

		<div class="complaints-form">
			<KitSelect
				v-model="model.complaintType"
				:options="typeOptions"
				placeholder="Тип жалобы"
				:no-data-text="uiText('NothingFound')"
				class="complaints-select"
			/>
			<KitSelect
				v-model="model.status"
				:options="statusOptions"
				placeholder="Статус"
				:no-data-text="uiText('NothingFound')"
				class="complaints-select"
			/>
			<el-input
				v-model="model.reviewId"
				placeholder="ID закреплённого отзыва"
				type="number"
			/>
			<el-input v-model="model.articleSlug" placeholder="Слаг статьи-разбора" />
			<el-input
				v-model="model.incidentDate"
				placeholder="Дата инцидента"
				type="date"
			/>
			<el-input
				v-model="model.sourceNote"
				type="textarea"
				:rows="2"
				placeholder="Внутренняя заметка об источнике (наружу не отдаётся)"
				class="complaints-wide"
			/>
			<el-input
				v-model="model.clinicResponse"
				type="textarea"
				:rows="2"
				placeholder="Официальный ответ клиники (публичный)"
				class="complaints-wide"
			/>
			<div class="complaints-actions">
				<el-checkbox v-model="model.isActive">Активна</el-checkbox>
				<el-button type="primary" @click="saveComplaint">Сохранить</el-button>
			</div>
		</div>

		<div v-if="isLoading" class="complaints-loading">Загрузка...</div>
		<div v-else class="complaints-list">
			<div
				v-for="complaint in complaints"
				:key="complaint.id"
				class="complaint-item"
				:class="{ inactive: !complaint.isActive }"
			>
				<div class="complaint-item-title">
					<span>
						{{ complaint.type }}. {{ TYPE_LABELS[complaint.type] }}
					</span>
					<span
						class="complaint-item-status"
						:class="{ confirmed: complaint.status === 'confirmed' }"
					>
						{{
							complaint.status === 'confirmed'
								? 'подтверждено'
								: 'не подтверждено'
						}}{{ complaint.isActive ? '' : ' · неактивна' }}
					</span>
				</div>
				<div class="complaint-item-meta">
					<span v-if="complaint.incidentDate">
						инцидент: {{ complaint.incidentDate }}
					</span>
					<span v-if="complaint.reviewId">
						отзыв #{{ complaint.reviewId }}
					</span>
					<span v-if="complaint.articleSlug">
						статья: {{ complaint.articleSlug }}
					</span>
				</div>
				<div v-if="complaint.sourceNote" class="complaint-item-note">
					{{ complaint.sourceNote }}
				</div>
				<div class="complaint-item-buttons">
					<el-button size="small" @click="editComplaint(complaint)">
						Редактировать
					</el-button>
					<el-button
						size="small"
						:type="complaint.isActive ? 'danger' : 'primary'"
						@click="toggleActive(complaint)"
					>
						{{ complaint.isActive ? 'Деактивировать' : 'Активировать' }}
					</el-button>
				</div>
			</div>
			<div v-if="!complaints.length" class="complaints-empty">
				Жалоб нет — бейджа «Осторожно» у клиники нет
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.complaints-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md);
	background: var(--kit-color-surface-secondary);
	border-radius: var(--kit-border-radius-md);
	border: 1px solid var(--kit-color-border-primary);
}

.section-header {
	h4 {
		margin: 0;
		color: var(--kit-color-text-primary);
	}
}

.complaints-form {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: var(--kit-spacing-sm);
	align-items: center;

	.complaints-wide {
		grid-column: 1 / -1;
	}
}

.complaints-select {
	width: 100%;
}

.complaints-actions {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
}

.complaints-list {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

.complaint-item {
	background: var(--kit-color-warning-bg);
	border: 1px solid var(--kit-color-warning-border);
	border-radius: var(--kit-border-radius-md);
	padding: var(--kit-spacing-sm);
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);

	&.inactive {
		background: var(--kit-color-surface-primary);
		border-color: var(--kit-color-border-primary);
		opacity: 0.75;
	}
}

.complaint-item-title {
	display: flex;
	justify-content: space-between;
	gap: var(--kit-spacing-sm);
	font-weight: 600;
}

.complaint-item-status {
	font-weight: 400;
	font-size: 13px;
	color: var(--kit-color-text-secondary);

	&.confirmed {
		color: var(--kit-color-warning-dark);
		font-weight: 600;
	}
}

.complaint-item-meta {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-md);
	color: var(--kit-color-text-secondary);
	font-size: 13px;
}

.complaint-item-note {
	font-size: 13px;
	color: var(--kit-color-text-secondary);
	white-space: pre-line;
}

.complaint-item-buttons {
	display: flex;
	gap: var(--kit-spacing-sm);
}

.complaints-empty,
.complaints-loading {
	color: var(--kit-color-text-secondary);
	font-style: italic;
	padding: var(--kit-spacing-xs) 0;
}
</style>
