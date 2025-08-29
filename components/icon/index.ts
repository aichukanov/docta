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
export { default as RouteIcon } from './route.vue';
export { default as MapPinIcon } from './map-pin.vue';
export { default as LanguageIcon } from './language.vue';

// Type definitions for icon props
export interface IconProps {
	size?: string | number;
	color?: string;
}

