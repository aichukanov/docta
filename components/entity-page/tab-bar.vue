<script setup lang="ts">
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

const scrollToSection = (id: string) => {
	const el = document.getElementById(id);
	if (!el) return;

	const targetY = el.getBoundingClientRect().top + window.scrollY - 120;
	const startY = window.scrollY;
	const diff = targetY - startY;
	const duration = Math.min(300, Math.abs(diff) * 0.3);
	const startTime = performance.now();

	const step = (now: number) => {
		const elapsed = now - startTime;
		const t = Math.min(elapsed / duration, 1);
		const ease = t * (2 - t);
		window.scrollTo(0, startY + diff * ease);
		if (t < 1) requestAnimationFrame(step);
	};

	requestAnimationFrame(step);
};

const updateQueryParam = (id: string) => {
	const url = new URL(window.location.href);
	url.searchParams.set('tab', id);
	window.history.replaceState(window.history.state, '', url.toString());
};

const onTabClick = (id: string) => {
	scrollToSection(id);
	updateQueryParam(id);
};

const updateActiveTab = () => {
	const scrollBottom = window.scrollY + window.innerHeight;
	const docHeight = document.documentElement.scrollHeight;

	if (docHeight - scrollBottom < 50) {
		activeTabId.value = props.tabs[props.tabs.length - 1]?.id || '';
		return;
	}

	let closest = props.tabs[0]?.id || '';
	let minDist = Infinity;

	for (const tab of props.tabs) {
		const el = document.getElementById(tab.id);
		if (!el) continue;
		const top = el.getBoundingClientRect().top - 130;
		if (top <= 0 && Math.abs(top) < minDist) {
			minDist = Math.abs(top);
			closest = tab.id;
		}
	}

	activeTabId.value = closest;
};

onMounted(() => {
	const tab = route.query.tab as string | undefined;
	if (tab && tabIds.value.has(tab)) {
		nextTick(() => scrollToSection(tab));
	}

	window.addEventListener('scroll', updateActiveTab, { passive: true });
	updateActiveTab();

	onUnmounted(() => {
		window.removeEventListener('scroll', updateActiveTab);
	});
});
</script>

<template>
	<nav class="section-tab-bar" aria-label="Page sections">
		<div class="section-tab-bar__inner">
			<button
				v-for="tab in tabs"
				:key="tab.id"
				class="section-tab"
				:class="{ 'section-tab--active': activeTabId === tab.id }"
				@click="onTabClick(tab.id)"
			>
				{{ tab.label }}
			</button>
		</div>
	</nav>
</template>

<style lang="less" scoped>
.section-tab-bar {
	position: sticky;
	top: 60px;
	z-index: 10;
	background: var(--color-surface-primary, #fff);
	border-bottom: 1px solid var(--color-border-light);
}

.section-tab-bar__inner {
	max-width: 900px;
	margin: 0 auto;
	padding: 0 var(--spacing-md);
	display: flex;
	gap: var(--spacing-xs);
	overflow-x: auto;
	-webkit-overflow-scrolling: touch;

	&::-webkit-scrollbar {
		display: none;
	}
}

.section-tab {
	flex-shrink: 0;
	padding: var(--spacing-sm) var(--spacing-md);
	border: none;
	background: none;
	font-size: var(--font-size-sm);
	font-family: inherit;
	color: var(--color-text-secondary);
	cursor: pointer;
	border-bottom: 2px solid transparent;
	transition: color 0.15s ease;

	&:hover {
		color: var(--color-text-primary);
	}

	&--active {
		color: var(--color-primary);
		border-bottom-color: var(--color-primary);
	}
}
</style>
