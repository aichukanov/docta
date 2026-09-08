<script setup lang="ts">
import { hasContacts } from '../contacts/utils';
import clinicSummaryI18n from '~/i18n/clinic-summary';
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

const { t } = useI18n({
	useScope: 'local',
	messages: clinicSummaryI18n.messages,
});

const hasServices = computed(() => props.services && props.services.length > 0);
const hasDoctors = computed(() => props.doctors && props.doctors.length > 0);
const hasClinicContacts = computed(() => hasContacts(props.clinic));
const hasFooterContent = computed(
	() => hasServices.value || hasDoctors.value || hasClinicContacts.value,
);

// Услуги открыты по умолчанию
const activeCollapse = ref<string[]>(hasServices.value ? ['services'] : []);

// Контакты рендерятся только после первого раскрытия. el-collapse-item
// прячет содержимое через v-show, и на листинге из 20 карточек в HTML уезжало
// ~100 КБ скрытых копи-кнопок, тултипов и иконок мессенджеров, а гидрация
// заводила сотни экземпляров ElTooltip — треть документа ради того, что никто
// не видит (docs/audit/lighthouse-perf-2026-09.md, этап 3). SEO-ценности у
// контактов в свёрнутой карточке нет: они есть на странице клиники.
// Секции «Услуги» и «Врачи» так не трогать — их ссылки нужны в SSR-HTML
// (перелинковка врачей на страницах услуг).
const contactsRendered = ref(false);
watch(
	activeCollapse,
	(names) => {
		if (names.includes('contacts')) contactsRendered.value = true;
	},
	{ immediate: true },
);
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
					<!-- hydrate-on-visible: HTML со ссылками на услуги остаётся в SSR,
					     а JS-гидрация карточек под фолдом откладывается до скролла -->
					<LazyClinicServiceSectionContent
						hydrate-on-visible
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
					</LazyClinicServiceSectionContent>
				</el-collapse-item>

				<el-collapse-item v-if="hasDoctors" name="doctors">
					<template #title>
						<span class="collapse-title">
							{{ t('Doctors') }}
							<span class="collapse-count">({{ doctors?.length }})</span>
						</span>
					</template>
					<!-- Секция свёрнута (v-show), IntersectionObserver сработает при
					     раскрытии — ссылки на врачей в SSR-HTML при этом остаются -->
					<div class="clinic-doctors">
						<LazyDoctorInfo
							v-for="doctor in doctors"
							:key="doctor.id"
							hydrate-on-visible
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
					<ContactsList v-if="contactsRendered" :list="clinic" />
				</el-collapse-item>
			</el-collapse>
		</footer>
	</div>
</template>

<style scoped lang="less">
.clinic-summary {
	display: flex;
	flex-direction: column;
	background: var(--kit-color-surface-primary);
	border: 1px solid var(--kit-color-border-light);
	border-radius: var(--kit-border-radius-lg);
	overflow: hidden;
}

.clinic-footer {
	border-top: 1px solid var(--kit-color-border-light);
	padding: 0 var(--kit-spacing-xl);
}

.clinic-doctors {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
	padding-bottom: var(--kit-spacing-sm);
}

.collapse-title {
	font-weight: var(--kit-font-weight-medium);

	.collapse-count {
		color: var(--kit-color-text-muted);
		font-weight: var(--kit-font-weight-normal);
		margin-left: var(--kit-spacing-xs);
	}
}

@media (max-width: 600px) {
	.clinic-footer {
		padding: 0 var(--kit-spacing-md);
	}
}
</style>
