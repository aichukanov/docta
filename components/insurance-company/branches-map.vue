<script setup lang="ts">
import type { InsuranceBranchData } from '~/interfaces/insurance-company';

const props = defineProps<{
	branches: InsuranceBranchData[];
	companyPhone?: string;
}>();

const emit = defineEmits<{
	(e: 'ready'): void;
}>();

const { t } = useI18n();

const {
	isLoading,
	isInitialized,
	initializeMap,
	addMarker,
	openPopup,
	centerOnLocations,
} = useLeaflet();

const mapContainer = ref<HTMLElement | null>(null);
const isTeleportReady = ref(false);
const selectedBranch = ref<InsuranceBranchData | null>(null);

const branchesWithCoords = computed(() =>
	props.branches.filter((branch) => branch.latitude && branch.longitude),
);

const getBranchMarkerId = (branchId: number) => `insurance-branch-marker-${branchId}`;

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

const openBranchPopup = async (branch: InsuranceBranchData) => {
	await waitForInit();

	selectedBranch.value = null;
	await nextTick();

	openPopup(branch.latitude, branch.longitude);
	selectedBranch.value = branch;
};

const centerOnBranches = async () => {
	await waitForInit();
	centerOnLocations(
		branchesWithCoords.value.map((branch) => [branch.latitude, branch.longitude]),
	);
};

onMounted(async () => {
	if (!mapContainer.value) return;

	await initializeMap(mapContainer.value);

	branchesWithCoords.value.forEach((branch) => {
		addMarker(getBranchMarkerId(branch.id), branch.latitude, branch.longitude, {
			onClick: () => openBranchPopup(branch),
		});
	});

	centerOnBranches();

	isTeleportReady.value = true;
	emit('ready');
});

defineExpose({
	openBranchPopup,
	centerOnBranches,
});
</script>

<template>
	<div class="insurance-branches-map-container">
		<div ref="mapContainer" class="insurance-branches-map">
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
				<div class="insurance-branch-popup">
					<ClinicLocationAddress :clinic="selectedBranch" />
					<ClinicRouteButton :clinic="selectedBranch" />
					<div v-if="selectedBranch.phone || companyPhone" class="insurance-branch-popup__phone">
						<IconPhone :size="16" />
						<span>{{ selectedBranch.phone || companyPhone }}</span>
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
.insurance-branches-map-container {
	width: 100%;
	min-width: min(400px, 100%);
	height: 100%;
	min-height: inherit;
	position: relative;
}

.insurance-branches-map {
	width: 100%;
	height: 100%;
	position: relative;
}

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
</style>

<style scoped lang="less">
.insurance-branch-popup {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-sm);
}

.insurance-branch-popup__phone {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
}
</style>
