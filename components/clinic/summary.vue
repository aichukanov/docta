<script setup lang="ts">
import { hasContacts } from '../contacts/utils';
import type {
	ClinicPrice,
	ClinicData,
	ClinicSummaryService,
} from '~/interfaces/clinic';
import type { DoctorCardData } from '~/interfaces/doctor';

const props = withDefaults(
	defineProps<{
		clinic: ClinicData;
		priceInfo?: ClinicPrice;
		services?: ClinicSummaryService[];
		// Врачи этой клиники по профилю услуги (страница услуги, см. PRD).
		doctors?: DoctorCardData[];
		serviceLimit?: number;
		showPrice?: boolean;
		// Расстояние до пользователя в км; null/undefined — локация неизвестна
		distance?: number | null;
	}>(),
	{
		serviceLimit: 2,
		showPrice: true,
	},
);

defineEmits<{
	(e: 'show-on-map'): void;
}>();

// Контакты внутри карточки атрибуцируются к этой клинике
provideAnalyticsEntity(
	computed(() => ({
		entity_type: 'clinic' as const,
		entity_id: props.clinic.id,
		entity_slug: props.clinic.slug,
	})),
);

const summaryI18n = {
	'en': {
		Contacts: 'Contacts',
		AvailableServices: 'Specialty services',
		Doctors: 'Specialists',
	},
	'ru': {
		Contacts: 'Контакты',
		AvailableServices: 'Профильные услуги',
		Doctors: 'Врачи',
	},
	'de': {
		Contacts: 'Kontakte',
		AvailableServices: 'Fachleistungen',
		Doctors: 'Ärzte',
	},
	'tr': {
		Contacts: 'İletişim',
		AvailableServices: 'Uzmanlık hizmetleri',
		Doctors: 'Doktorlar',
	},
	'sr': {
		Contacts: 'Kontakti',
		AvailableServices: 'Profilne usluge',
		Doctors: 'Lekari',
	},
	'sr-cyrl': {
		Contacts: 'Контакти',
		AvailableServices: 'Профилне услуге',
		Doctors: 'Лекари',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: summaryI18n,
});

const hasServices = computed(() => props.services && props.services.length > 0);
const hasDoctors = computed(() => props.doctors && props.doctors.length > 0);
const hasClinicContacts = computed(() => hasContacts(props.clinic));
const hasFooterContent = computed(
	() => hasServices.value || hasDoctors.value || hasClinicContacts.value,
);

// Услуги открыты по умолчанию
const activeCollapse = ref<string[]>(hasServices.value ? ['services'] : []);
</script>

<template>
	<div class="clinic-summary">
		<ClinicSummaryHeader
			:clinic="clinic"
			:price="priceInfo?.price"
			:priceMin="priceInfo?.priceMin"
			:priceMax="priceInfo?.priceMax"
			:isOutdated="priceInfo?.isOutdated"
			:showPrice="showPrice"
			:distance="distance"
			@show-on-map="$emit('show-on-map')"
		/>

		<footer v-if="hasFooterContent" class="clinic-footer">
			<el-collapse v-model="activeCollapse" expand-icon-position="left">
				<el-collapse-item v-if="hasServices" name="services">
					<template #title>
						<span class="collapse-title">
							{{ t('AvailableServices') }}
							<span class="collapse-count">({{ services?.length }})</span>
						</span>
					</template>
					<ClinicServiceSectionContent
						:items="services || []"
						:initialLimit="serviceLimit"
					>
						<template #default="{ item }">
							<PricedItemCard
								:id="item.id"
								:slug="item.slug"
								:name="item.name"
								:localName="item.localName"
								:price="item.price"
								:priceMin="item.priceMin"
								:priceMax="item.priceMax"
								:isOutdated="item.isOutdated"
								routeName="services-serviceSlug"
								routeParamName="serviceSlug"
							/>
						</template>
					</ClinicServiceSectionContent>
				</el-collapse-item>

				<el-collapse-item v-if="hasDoctors" name="doctors">
					<template #title>
						<span class="collapse-title">
							{{ t('Doctors') }}
							<span class="collapse-count">({{ doctors?.length }})</span>
						</span>
					</template>
					<div class="clinic-doctors">
						<DoctorInfo
							v-for="doctor in doctors"
							:key="doctor.id"
							:service="doctor"
							short
						/>
					</div>
				</el-collapse-item>

				<el-collapse-item
					v-if="hasClinicContacts"
					name="contacts"
					:title="t('Contacts')"
				>
					<ContactsList :list="clinic" />
				</el-collapse-item>
			</el-collapse>
		</footer>
	</div>
</template>

<style scoped lang="less">
.clinic-summary {
	display: flex;
	flex-direction: column;
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-lg);
	overflow: hidden;
}

.clinic-footer {
	border-top: 1px solid var(--color-border-light);
	padding: 0 var(--spacing-xl);
}

.clinic-doctors {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding-bottom: var(--spacing-sm);
}

.collapse-title {
	font-weight: var(--font-weight-medium);

	.collapse-count {
		color: var(--color-text-muted);
		font-weight: var(--font-weight-normal);
		margin-left: var(--spacing-xs);
	}
}

@media (max-width: 600px) {
	.clinic-footer {
		padding: 0 var(--spacing-md);
	}
}
</style>
