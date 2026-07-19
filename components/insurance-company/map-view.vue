<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { InsuranceCompanyBranchWithCompany } from '~/interfaces/insurance-company';

const props = defineProps<{
	branches: InsuranceCompanyBranchWithCompany[];
}>();

const emit = defineEmits<{
	(e: 'ready'): void;
}>();

const { t, locale } = useI18n();

const {
	isLoading,
	isInitialized,
	initializeMap,
	addMarker,
	removeMarker,
	markers,
	openPopup,
	centerOnLocations,
} = useLeaflet();

const mapContainer = ref<HTMLElement | null>(null);
const isTeleportReady = ref(false);
const selectedBranch = ref<InsuranceCompanyBranchWithCompany | null>(null);

const branchesWithCoords = computed(() =>
	props.branches.filter((branch) => branch.latitude && branch.longitude),
);

const getBranchMarkerId = (branchId: number) =>
	`insurance-catalog-marker-${branchId}`;

const companyLink = (branch: InsuranceCompanyBranchWithCompany) => ({
	name: 'insurance-companies-companySlug',
	params: { companySlug: branch.companySlug },
	query: getRegionalQuery(locale.value),
});

const waitForInit = () => {
	if (isInitialized.value) return Promise.resolve();
	return new Promise<void>((resolve) => {
		const stop = watch(isInitialized, (v) => {
			if (v) {
				stop();
				resolve();
			}
		});
	});
};

const openBranchPopup = async (branch: InsuranceCompanyBranchWithCompany) => {
	await waitForInit();

	selectedBranch.value = null;
	await nextTick();

	openPopup(branch.latitude, branch.longitude);
	selectedBranch.value = branch;
};

const fitToMarkers = () => {
	centerOnLocations(
		branchesWithCoords.value.map((branch) => [branch.latitude, branch.longitude]),
	);
};

const syncMarkers = () => {
	const currentMarkerIds = new Set(markers.keys());
	const newBranchIds = new Set(
		branchesWithCoords.value.map((branch) => getBranchMarkerId(branch.id)),
	);

	currentMarkerIds.forEach((markerId) => {
		if (!newBranchIds.has(markerId)) {
			removeMarker(markerId);
		}
	});

	branchesWithCoords.value.forEach((branch) => {
		const markerId = getBranchMarkerId(branch.id);
		if (!currentMarkerIds.has(markerId)) {
			addMarker(markerId, branch.latitude, branch.longitude, {
				onClick: () => openBranchPopup(branch),
			});
		}
	});

	fitToMarkers();
};

// Регистрируем watcher синхронно в setup(), а не внутри onMounted после
// await — иначе Vue не привязывает его к инстансу компонента и не
// останавливает при unmount. Такой "утёкший" watcher продолжает вызывать
// syncMarkers() (а значит и добавлять/удалять Leaflet-маркеры) уже после
// того, как страница со списком размонтирована — например, при переходе
// на страницу компании — и ловит Vue на попытке запатчить Teleport, чья
// цель (div маркера) уже удалена из DOM вместе с контейнером карты.
watch(
	() => props.branches,
	() => {
		if (isTeleportReady.value) syncMarkers();
	},
	{ deep: true },
);

onMounted(async () => {
	if (!mapContainer.value) return;

	await initializeMap(mapContainer.value);
	syncMarkers();

	isTeleportReady.value = true;
	emit('ready');
});

defineExpose({
	openBranchPopup,
	fitToMarkers,
});
</script>

<template>
	<div class="insurance-catalog-map-container">
		<div ref="mapContainer" class="insurance-catalog-map">
			<div v-if="isLoading" class="map-loading">
				<p>{{ t('MapLoading') }}</p>
			</div>
		</div>

		<template v-if="isTeleportReady">
			<Teleport
				v-for="branch in branchesWithCoords"
				:key="branch.id"
				:to="`#${getBranchMarkerId(branch.id)}`"
			>
				<InsuranceCompanyBranchMarker />
			</Teleport>

			<Teleport v-if="selectedBranch" to="#popup-container">
				<div class="insurance-catalog-popup">
					<NuxtLink
						:to="companyLink(selectedBranch)"
						class="insurance-catalog-popup__company"
					>
						{{ selectedBranch.companyName }}
					</NuxtLink>
					<ClinicLocationAddress :clinic="selectedBranch" />
					<ClinicRouteButton :clinic="selectedBranch" />
					<div
						v-if="selectedBranch.phone || selectedBranch.companyPhone"
						class="insurance-catalog-popup__phone"
					>
						<IconPhone :size="16" />
						<span>{{ selectedBranch.phone || selectedBranch.companyPhone }}</span>
					</div>
				</div>
			</Teleport>
		</template>
	</div>
</template>

<i18n lang="json">
{
	"en": { "MapLoading": "Loading map" },
	"ru": { "MapLoading": "Загрузка карты" },
	"de": { "MapLoading": "Karte wird geladen" },
	"tr": { "MapLoading": "Harita yükleniyor" },
	"sr": { "MapLoading": "Učitava mapu" },
	"sr-cyrl": { "MapLoading": "Учитава мапу" }
}
</i18n>

<style>
.insurance-catalog-map-container {
	width: 100%;
	height: 100%;
	min-height: inherit;
	position: relative;
}

.insurance-catalog-map {
	width: 100%;
	height: 100%;
	position: relative;
}
</style>

<style scoped lang="less">
.map-loading {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	z-index: var(--z-raised);
	background: var(--color-bg-primary);
	padding: var(--spacing-lg) var(--spacing-2xl);
	border-radius: var(--border-radius-md);
	box-shadow: var(--shadow-md);
}

.insurance-catalog-popup {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-sm);
}

.insurance-catalog-popup__company {
	font-size: var(--font-size-base);
	font-weight: 600;
	color: var(--color-primary);
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}

.insurance-catalog-popup__phone {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
}
</style>
