<script setup lang="ts">
import type {
	DuplicateCandidateItem,
	DuplicateCandidateSide,
	DuplicateQueueStats,
} from '~/server/api/services/duplicates/queue.get';

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const { confirm } = useConfirm();

const tier = ref<'A' | 'B' | 'C'>('A');
const page = ref(1);
const isLoading = ref(false);
const items = ref<DuplicateCandidateItem[]>([]);
const stats = ref<DuplicateQueueStats>({
	pendingA: 0,
	pendingB: 0,
	pendingC: 0,
	dismissed: 0,
});
const total = ref(0);
const pageSize = ref(25);

const TIER_HINTS: Record<'A' | 'B' | 'C', string> = {
	A: 'Совпали названия в двух и более языках. Почти всегда настоящий дубликат, но глазами смотреть всё равно надо.',
	B: 'Совпало название в одном языке. Смотреть внимательнее.',
	C: 'Только нечёткое совпадение по английскому. Здесь много осмысленно разных услуг — тир для последней вычитки.',
};

const load = async () => {
	isLoading.value = true;
	try {
		const data = await $fetch('/api/services/duplicates/queue', {
			query: { tier: tier.value, page: page.value },
		});
		items.value = data.items;
		stats.value = data.stats;
		total.value = data.pagination.total;
		pageSize.value = data.pagination.pageSize;
	} finally {
		isLoading.value = false;
	}
};

watch([tier, page], load);
onMounted(load);

const changeTier = (value: 'A' | 'B' | 'C') => {
	tier.value = value;
	page.value = 1;
};

const sideLabel = (side: DuplicateCandidateSide) =>
	`${side.nameEn || side.nameSr || side.id} (ID: ${side.id})`;

const priceLabel = (side: DuplicateCandidateSide) => {
	if (side.priceFrom == null) return 'без цены';
	if (side.priceTo == null || side.priceFrom === side.priceTo) {
		return `${side.priceFrom} €`;
	}
	return `${side.priceFrom}–${side.priceTo} €`;
};

const merge = async (
	item: DuplicateCandidateItem,
	keep: DuplicateCandidateSide,
	drop: DuplicateCandidateSide,
) => {
	const ok = await confirm({
		title: 'Объединить услуги?',
		message:
			`ОСТАВИТЬ: ${sideLabel(keep)}\n` +
			`УДАЛИТЬ: ${sideLabel(drop)}\n\n` +
			'Клиники, цены, справка, тарифы и отзывы перейдут на оставленную услугу. ' +
			'Названия удаляемой сохранятся как синонимы, со старого адреса встанет 301.',
		confirmText: 'Объединить',
		cancelText: 'Отмена',
		confirmType: 'danger',
	});
	if (!ok) return;

	await $fetch('/api/services/merge', {
		method: 'POST',
		body: {
			primaryServiceId: keep.id,
			secondaryServiceId: drop.id,
		},
	});

	// Строка кандидата уходит вместе с удалённой услугой (FK ON DELETE CASCADE),
	// поэтому её отдельно закрывать не нужно — только перечитать очередь.
	await load();
	emit('updated');
};

const dismiss = async (item: DuplicateCandidateItem) => {
	await $fetch('/api/services/duplicates/dismiss', {
		method: 'POST',
		body: { candidateId: item.id },
	});
	await load();
};
</script>

<template>
	<div class="service-duplicates">
		<div class="queue-info">
			<p>
				<strong>Очередь дубликатов.</strong> Заполняется скриптом
				<code>scripts/services/find-duplicate-services.mjs</code>. Отклонённые
				пары больше не возвращаются в очередь.
			</p>
			<p class="tier-hint">{{ TIER_HINTS[tier] }}</p>
		</div>

		<div class="queue-controls">
			<el-radio-group
				:model-value="tier"
				@update:model-value="changeTier($event as 'A' | 'B' | 'C')"
			>
				<el-radio-button value="A">
					Тир A ({{ stats.pendingA }})
				</el-radio-button>
				<el-radio-button value="B">
					Тир B ({{ stats.pendingB }})
				</el-radio-button>
				<el-radio-button value="C">
					Тир C ({{ stats.pendingC }})
				</el-radio-button>
			</el-radio-group>

			<span class="dismissed-count">
				отклонено ранее: {{ stats.dismissed }}
			</span>
		</div>

		<div v-if="isLoading" class="queue-empty">Загрузка…</div>

		<div v-else-if="!items.length" class="queue-empty">
			В этом тире пусто — всё разобрано.
		</div>

		<div v-else class="pair-list">
			<div v-for="item in items" :key="item.id" class="pair">
				<div class="pair-signals">
					<el-tag
						v-for="signal in item.signals"
						:key="signal"
						size="small"
						type="info"
					>
						{{ signal }}
					</el-tag>
				</div>

				<div class="pair-sides">
					<div
						v-for="side in [item.a, item.b]"
						:key="side.id"
						class="pair-side"
					>
						<div class="side-name">{{ side.nameEn }}</div>
						<div class="side-sub">{{ side.nameSr }}</div>
						<div class="side-sub">{{ side.nameRu }}</div>
						<div class="side-meta">
							<span>ID {{ side.id }}</span>
							<span>{{ side.clinicCount }} клиник</span>
							<span>{{ priceLabel(side) }}</span>
							<span v-if="side.categoryIds"> кат. {{ side.categoryIds }} </span>
							<el-tag v-if="side.hasReferenceInfo" size="small" type="success">
								справка
							</el-tag>
							<el-tag v-if="side.tariffCount" size="small" type="warning">
								тарифов: {{ side.tariffCount }}
							</el-tag>
						</div>
						<el-button
							type="warning"
							size="small"
							@click="
								merge(item, side, side.id === item.a.id ? item.b : item.a)
							"
						>
							Оставить эту
						</el-button>
					</div>
				</div>

				<div class="pair-actions">
					<el-button size="small" @click="dismiss(item)">
						Не дубликат
					</el-button>
				</div>
			</div>
		</div>

		<el-pagination
			v-if="total > pageSize"
			class="queue-pagination"
			layout="prev, pager, next"
			:current-page="page"
			:page-size="pageSize"
			:total="total"
			@current-change="page = $event"
		/>
	</div>
</template>

<style scoped lang="less">
.service-duplicates {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.queue-info {
	padding: var(--spacing-md);
	background: rgba(245, 158, 11, 0.1);
	border: 1px solid rgba(245, 158, 11, 0.3);
	border-radius: var(--border-radius-md);

	p {
		margin: 0;
	}

	.tier-hint {
		margin-top: var(--spacing-xs);
		color: var(--color-text-secondary);
	}
}

.queue-controls {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: var(--spacing-md);

	.dismissed-count {
		color: var(--color-text-secondary);
	}
}

.queue-empty {
	padding: var(--spacing-lg);
	color: var(--color-text-secondary);
	text-align: center;
}

.pair-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.pair {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-md);
}

.pair-signals {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

.pair-sides {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-md);
}

.pair-side {
	display: flex;
	flex: 1 1 50%;
	max-width: 50%;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-xs);
	padding: var(--spacing-sm);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-md);

	.side-name {
		font-weight: 600;
	}

	.side-sub {
		color: var(--color-text-secondary);
	}

	.side-meta {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: var(--spacing-xs);
		color: var(--color-text-secondary);
	}
}

.pair-actions {
	display: flex;
	justify-content: flex-end;
}

.queue-pagination {
	justify-content: center;
}

@media (max-width: 768px) {
	.pair-sides {
		flex-direction: column;
	}

	.pair-side {
		max-width: 100%;
	}
}
</style>
