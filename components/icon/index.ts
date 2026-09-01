// Tree-shakable icon exports
// Each icon can be imported individually: import { PhoneIcon } from '@/icons'
// Or bulk import: import * as Icons from '@/icons'

export { default as PhoneIcon } from './phone.vue';
export { default as EmailIcon } from './email.vue';
export { default as WhatsAppIcon } from './whatsapp.vue';
export { default as TelegramIcon } from './telegram.vue';
export { default as ViberIcon } from './viber.vue';
export { default as FacebookIcon } from './facebook.vue';
export { default as InstagramIcon } from './instagram.vue';
export { default as CopyIcon } from './copy.vue';
export { default as CheckIcon } from './check.vue';
export { default as ChevronIcon } from './chevron.vue';
export { default as DoctorIcon } from './doctor.vue';
export { default as BackIcon } from './back.vue';
export { default as ArrowDownIcon } from './arrow-down.vue';
export { default as SearchIcon } from './search.vue';
export { default as LabTestIcon } from './lab-test.vue';
export { default as MedicationIcon } from './medication.vue';
export { default as MedicalServiceIcon } from './medical-service.vue';
export { default as RouteIcon } from './route.vue';
export { default as MapPinIcon } from './map-pin.vue';
export { default as LanguageIcon } from './language.vue';
export { default as LightbulbIcon } from './lightbulb.vue';
export { default as AlertCircleIcon } from './alert-circle.vue';
export { default as GoogleIcon } from './google.vue';

// Иконки, заменившие набор Element Plus (миграция prd/element-plus-removal)
export { default as IconPlus } from './plus.vue';
export { default as IconRefreshLeft } from './refresh-left.vue';
export { default as IconList } from './list.vue';
export { default as IconMapLocation } from './map-location.vue';
export { default as IconUpload } from './upload.vue';
export { default as IconShare } from './share.vue';
export { default as IconOfficeBuilding } from './office-building.vue';
export { default as IconFilter } from './filter.vue';
export { default as IconQuestionCircle } from './question-circle.vue';
export { default as IconCreditCard } from './credit-card.vue';
export { default as IconDiscount } from './discount.vue';
export { default as IconBriefcase } from './briefcase.vue';
export { default as IconArrowRight } from './arrow-right.vue';

// Type definitions for icon props
export interface IconProps {
	size?: string | number;
	color?: string;
}
