<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

const props = defineProps<{
	isLoading: boolean;
	isFound: boolean;
	backRouteName: string;
	loadingText: string;
	notFoundText: string;
	clinics: ClinicData[];
	clinicPrices?: ClinicPrice[];
}>();

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

const { t, locale } = useI18n({ useScope: 'local' });
const router = useRouter();
const { getRouteParams } = useFilters();

const mapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();

const showClinicOnMap = (clinic: ClinicData) => {
	mapRef.value?.centerOnClinics([clinic]);
};

const backToSearch = () => {
	router.push({
		name: props.backRouteName,
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	if (props.clinics.length > 0) {
		mapRef.value?.centerOnClinics(props.clinics);
	}
};
</script>

<template>
	<div class="details-page">
		<div class="details-page-header">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</div>
		<div class="details-page-content">
			<div v-if="isLoading" class="loading">
				<div class="loading-spinner"></div>
				<p>{{ loadingText }}</p>
			</div>
			<div v-else-if="isFound" class="details-info-container">
				<div class="details-info-wrapper">
					<slot name="info" :showClinicOnMap="showClinicOnMap" />
					<slot name="clinics" :showClinicOnMap="showClinicOnMap">
						<div class="clinics-list">
							<ClinicSummary
								v-for="clinic in clinics"
								:key="clinic.id"
								:clinic="clinic"
								:priceInfo="getPriceInfo(clinic.id)"
								linkable
								@show-on-map="showClinicOnMap(clinic)"
							/>
						</div>
					</slot>
				</div>
				<ClinicServicesMap
					ref="mapRef"
					:services="[]"
					:clinics="clinics"
					:showAllClinics="true"
					@ready="onMapReady"
				/>
			</div>
			<div v-else class="details-info-container">
				<p>{{ notFoundText }}</p>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.details-page {
	padding: var(--spacing-md);

	.details-page-header {
		margin-bottom: var(--spacing-md);
	}

	.details-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.details-info-container {
			display: flex;
			flex-direction: row;
			align-items: flex-start;
			gap: var(--spacing-2xl);
			width: 100%;
			max-width: 1600px;

			.details-info-wrapper {
				flex: 1;
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);
				min-width: 0;
			}

			:deep(.clinic-services-map-container) {
				flex: 1;
				position: sticky;
				top: calc(60px + var(--spacing-lg));
				height: calc(100vh - 60px - var(--spacing-lg) - var(--spacing-md));
				min-height: 400px;
				max-height: 700px;
			}
		}
	}
}

.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	color: #6b7280;
}

.loading-spinner {
	width: 40px;
	height: 40px;
	border: 3px solid #e5e7eb;
	border-top: 3px solid #4f46e5;
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin-bottom: 16px;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}

@media (max-width: 650px) {
	.details-page {
		.details-page-content {
			.details-info-container {
				flex-direction: column;
			}
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"ToSearchPage": "Back to search"
	},
	"ru": {
		"ToSearchPage": "К поиску"
	},
	"de": {
		"ToSearchPage": "Zurück zur Suche"
	},
	"tr": {
		"ToSearchPage": "Aramaya geri dön"
	},
	"sr": {
		"ToSearchPage": "Nazad na pretragu"
	},
	"ba": {
		"ToSearchPage": "Nazad na pretragu"
	},
	"me": {
		"ToSearchPage": "Nazad na pretragu"
	}
}
</i18n>
