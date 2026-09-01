<script setup lang="ts">
import IconArrowDown from '~/components/icon/arrow-down.vue';

export interface TabItem {
	id: string;
	label: string;
}

const props = defineProps<{
	tabs: TabItem[];
}>();

const route = useRoute();

const tabIds = computed(() => new Set(props.tabs.map((t) => t.id)));
const activeTabId = ref(props.tabs[0]?.id || '');
const activeLabel = computed(
	() =>
		props.tabs.find((t) => t.id === activeTabId.value)?.label ||
		props.tabs[0]?.label ||
		'',
);

// Высота залипающей шапки приложения (app-header: sticky, min-height 60px).
const HEADER_OFFSET = 60;
// Ссылка на мобильную залипающую полосу. На десктопе она display:none →
// offsetHeight 0, поэтому смещение сводится к высоте шапки (рельс сбоку не
// перекрывает контент по вертикали).
const mobileBarRef = ref<HTMLElement | null>(null);
const stickyHeight = () =>
	HEADER_OFFSET + (mobileBarRef.value?.offsetHeight ?? 0);

// «Линия активации» — насколько ниже залипающего блока должен подняться
// заголовок секции, чтобы она стала активной. Берём ~28% высоты области под
// баром, чтобы подсветка переключалась заранее, с заметным отступом от верха,
// а не когда заголовок упрётся в самый верх экрана.
const activationLine = () => {
	const base = stickyHeight();
	return base + Math.round((window.innerHeight - base) * 0.28);
};

// На время программного скролла (клик по вкладке) блокируем scroll-spy, чтобы
// он не переключил подсветку на соседнюю секцию: у коротких секций заголовок
// после клика оказывается выше линии активации.
const spyLocked = ref(false);

const scrollToSection = (id: string, onDone?: () => void) => {
	const el = document.getElementById(id);
	if (!el) {
		onDone?.();
		return;
	}

	const targetY =
		el.getBoundingClientRect().top + window.scrollY - stickyHeight() - 8;
	const startY = window.scrollY;
	const diff = targetY - startY;
	const duration = Math.min(300, Math.abs(diff) * 0.3);
	const startTime = performance.now();

	const step = (now: number) => {
		const elapsed = now - startTime;
		const t = duration > 0 ? Math.min(elapsed / duration, 1) : 1;
		const ease = t * (2 - t);
		window.scrollTo(0, startY + diff * ease);
		if (t < 1) requestAnimationFrame(step);
		else onDone?.();
	};

	requestAnimationFrame(step);
};

const updateQueryParam = (id: string) => {
	const url = new URL(window.location.href);
	url.searchParams.set('tab', id);
	window.history.replaceState(window.history.state, '', url.toString());
};

const onTabClick = (id: string) => {
	activeTabId.value = id; // подсвечиваем сразу, не дожидаясь scroll-spy
	spyLocked.value = true;
	scrollToSection(id, () => {
		spyLocked.value = false;
	});
	updateQueryParam(id);
};

const updateActiveTab = () => {
	if (spyLocked.value) return;

	const scrollBottom = window.scrollY + window.innerHeight;
	const docHeight = document.documentElement.scrollHeight;

	if (docHeight - scrollBottom < 50) {
		activeTabId.value = props.tabs[props.tabs.length - 1]?.id || '';
		return;
	}

	// Активна секция, чей заголовок последним поднялся выше линии активации.
	const line = activationLine();
	let closest = props.tabs[0]?.id || '';
	let minDist = Infinity;

	for (const tab of props.tabs) {
		const el = document.getElementById(tab.id);
		if (!el) continue;
		const top = el.getBoundingClientRect().top - line;
		if (top <= 0 && Math.abs(top) < minDist) {
			minDist = Math.abs(top);
			closest = tab.id;
		}
	}

	activeTabId.value = closest;
};

// Скролл сыплет десятками событий в секунду, а updateActiveTab читает
// scrollHeight и getBoundingClientRect по каждой вкладке — это принудительный
// пересчёт layout на каждый тик. Схлопываем в один пересчёт на кадр:
// чаще подсветка всё равно не обновляется — браузер не рисует.
let scrollFrame: number | null = null;

const onScroll = () => {
	if (scrollFrame !== null) return;
	scrollFrame = requestAnimationFrame(() => {
		scrollFrame = null;
		updateActiveTab();
	});
};

onMounted(() => {
	const tab = route.query.tab as string | undefined;
	if (tab && tabIds.value.has(tab)) {
		nextTick(() => onTabClick(tab));
	}

	window.addEventListener('scroll', onScroll, { passive: true });
	updateActiveTab();

	onUnmounted(() => {
		window.removeEventListener('scroll', onScroll);
		if (scrollFrame !== null) cancelAnimationFrame(scrollFrame);
	});
});
</script>

<template>
	<div class="section-nav">
		<!-- Десктоп: вертикальный рельс слева от контента -->
		<nav class="section-nav__rail" aria-label="Page sections">
			<button
				v-for="tab in tabs"
				:key="tab.id"
				class="rail-item"
				:class="{ 'rail-item--active': activeTabId === tab.id }"
				@click="onTabClick(tab.id)"
			>
				{{ tab.label }}
			</button>
		</nav>

		<!-- Мобильные: залипающая полоса с текущим разделом и выпадающим списком -->
		<div class="section-nav__mobile" ref="mobileBarRef">
			<el-dropdown
				trigger="click"
				placement="bottom-start"
				popper-class="section-nav-menu"
				@command="onTabClick"
			>
				<button class="mobile-trigger" type="button">
					<span class="mobile-trigger__label">{{ activeLabel }}</span>
					<IconArrowDown class="mobile-trigger__chev" size="1em" />
				</button>
				<template #dropdown>
					<el-dropdown-menu>
						<el-dropdown-item
							v-for="tab in tabs"
							:key="tab.id"
							:command="tab.id"
							:class="{ 'is-active': activeTabId === tab.id }"
						>
							{{ tab.label }}
						</el-dropdown-item>
					</el-dropdown-menu>
				</template>
			</el-dropdown>
		</div>
	</div>
</template>

<style lang="less" scoped>
/* --- Мобильная полоса (по умолчанию); рельс скрыт --- */
.section-nav__rail {
	display: none;
}

.section-nav__mobile {
	position: sticky;
	top: 60px;
	z-index: var(--kit-z-raised);
	background: var(--kit-color-surface-primary, #fff);
	border-bottom: 1px solid var(--kit-color-border-light);
	padding: var(--kit-spacing-sm) 0;
}

.mobile-trigger {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-sm);
	width: 100%;
	padding: var(--kit-spacing-sm) var(--kit-spacing-md);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-md);
	background: var(--kit-color-bg-primary, #fff);
	font-family: inherit;
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-primary);
	cursor: pointer;
}

.mobile-trigger__chev {
	flex-shrink: 0;
	color: var(--kit-color-text-muted);
	font-size: 12px;
}

/* --- Десктоп: рельс вместо полосы --- */
@media (min-width: 1024px) {
	.section-nav__mobile {
		display: none;
	}

	.section-nav__rail {
		display: flex;
		flex-direction: column;
		gap: 2px;
		position: sticky;
		top: 76px;
		border-left: 1px solid var(--kit-color-border-light);
	}

	.rail-item {
		text-align: left;
		padding: var(--kit-spacing-sm) var(--kit-spacing-md);
		border: none;
		border-left: 2px solid transparent;
		margin-left: -1px;
		border-radius: 0 var(--kit-border-radius-md) var(--kit-border-radius-md) 0;
		background: none;
		font-family: inherit;
		font-size: var(--kit-font-size-sm);
		color: var(--kit-color-text-secondary);
		cursor: pointer;
		transition:
			color 0.15s ease,
			background-color 0.15s ease;

		&:hover {
			color: var(--kit-color-text-primary);
			background: var(--kit-color-bg-secondary);
		}

		&--active {
			color: var(--kit-color-primary);
			border-left-color: var(--kit-color-primary);
			font-weight: var(--kit-font-weight-semibold);
			background: var(--kit-color-primary-bg);
		}
	}
}
</style>

<style lang="less">
/* Выпадающее меню телепортируется из scoped-области — стилизуем глобально */
.section-nav-menu .el-dropdown-menu__item.is-active {
	color: var(--kit-color-primary);
	font-weight: var(--kit-font-weight-semibold);
}
</style>
