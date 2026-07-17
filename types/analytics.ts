/**
 * Каталог типизированных событий аналитики (Mixpanel).
 *
 * Конвенции:
 * - имена событий и свойств — snake_case;
 * - у событий, привязанных к сущности каталога, всегда есть entity_type /
 *   entity_id / entity_slug — на этих свойствах строятся воронки
 *   (см. prd/analytics/events-catalog.md);
 * - PII (телефоны, email, адреса) в свойства класть нельзя — только тип
 *   контакта и ссылку на сущность.
 *
 * page_type и locale добавляются к событиям автоматически
 * (см. composables/use-analytics.ts).
 */

export type AnalyticsEntityType =
	| 'clinic'
	| 'doctor'
	| 'service'
	| 'labtest'
	// medicine — регистр лекарств (med_medicines), medication — аптечные
	// позиции клиник (medications): разные таблицы, id пересекаются
	| 'medicine'
	| 'medication'
	| 'article';

export type AnalyticsContactType =
	| 'phone'
	| 'email'
	| 'address'
	| 'website'
	| 'whatsapp'
	| 'viber'
	| 'telegram'
	| 'facebook'
	| 'instagram';

export type AnalyticsAuthProvider =
	| 'google'
	| 'telegram'
	| 'facebook'
	| 'password';

/** Ссылка на сущность каталога в свойствах события */
export interface AnalyticsEntityRef {
	entity_type: AnalyticsEntityType;
	/** id из БД; у статических статей — slug */
	entity_id: number | string;
	entity_slug: string;
}

/** Просмотр детальной страницы сущности */
export interface EntityViewedProperties extends AnalyticsEntityRef {
	/** Каноническое (нелокализованное) название сущности */
	entity_name?: string;
	/** Сколько клиник предлагают услугу/анализ/лекарство */
	clinics_count?: number;
}

/** Клик по ссылке/карточке сущности (переход между сущностями) */
export interface EntityLinkClickedProperties extends AnalyticsEntityRef {
	entity_name?: string;
	/** Позиция карточки в списке, начиная с 1 */
	position?: number;
}

/**
 * Клик/копирование контакта. Сущность-владелец контакта приходит из
 * provide/inject-контекста (см. provideAnalyticsEntity) и может отсутствовать.
 */
export interface ContactInteractionProperties
	extends Partial<AnalyticsEntityRef> {
	contact_type: AnalyticsContactType;
}

/** Поиск по названию на листинге (debounced, не каждый кейстрок) */
export interface SearchPerformedProperties {
	query: string;
	results_count?: number;
}

/** Применение фильтра на листинге */
export interface FilterAppliedProperties {
	filter_name: string;
	filter_value: string | number | boolean | Array<string | number>;
	results_count?: number;
}

/** Сброс фильтров на листинге */
export interface FilterClearedProperties {
	filters_count?: number;
}

/** Открытие карты (ленивая загрузка/кнопка «показать на карте») */
export interface MapOpenedProperties {
	markers_count?: number;
}

/** Клик по маркеру/попапу клиники на карте */
export interface MapMarkerClickedProperties
	extends Partial<AnalyticsEntityRef> {}

/** Имя события → интерфейс его свойств. Источник истины для trackEvent. */
export interface AnalyticsEvents {
	entity_viewed: EntityViewedProperties;
	entity_link_clicked: EntityLinkClickedProperties;
	contact_clicked: ContactInteractionProperties;
	contact_copied: ContactInteractionProperties;
	search_performed: SearchPerformedProperties;
	filter_applied: FilterAppliedProperties;
	filter_cleared: FilterClearedProperties;
	map_opened: MapOpenedProperties;
	map_marker_clicked: MapMarkerClickedProperties;
}

export type AnalyticsEventName = keyof AnalyticsEvents;
