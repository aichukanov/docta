<template>
	<span
		class="language-badge"
		:class="`language-badge--${size}`"
		:title="tooltipText"
	>
		<svg
			class="language-icon"
			xmlns="http://www.w3.org/2000/svg"
			viewBox="0 0 24 24"
			fill="none"
		>
			<path
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"
				d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
			/>
		</svg>
		<span class="language-name">{{ languageName }}</span>
	</span>
</template>

<script setup lang="ts">
import type { Locale } from '~/composables/use-locale';

interface Props {
	lang: string;
	locale?: Locale;
	size?: 'sm' | 'md';
	tooltip?: string;
}

const props = withDefaults(defineProps<Props>(), {
	size: 'md',
});

// Определяем названия языков
const languageNames: Record<string, string> = {
	sr: 'Srpski',
	ru: 'Русский',
	en: 'English',
	fr: 'Français',
	de: 'Deutsch',
	tr: 'Türkçe',
	ba: 'Bosanski',
	me: 'Crnogorski',
};

const languageName = languageNames[props.lang] || props.lang.toUpperCase();

// Локализованные подсказки
const tooltipTranslations: Record<Locale, Record<string, string>> = {
	sr: {
		sr: 'Lekar govori srpski',
		ru: 'Lekar govori ruski',
		en: 'Lekar govori engleski',
		fr: 'Lekar govori francuski',
		de: 'Lekar govori nemački',
		tr: 'Lekar govori turski',
		ba: 'Lekar govori bosanski',
		me: 'Lekar govori crnogorski',
	},
	ru: {
		sr: 'Врач говорит на сербском языке',
		ru: 'Врач говорит на русском языке',
		en: 'Врач говорит на английском языке',
		fr: 'Врач говорит на французском языке',
		de: 'Врач говорит на немецком языке',
		tr: 'Врач говорит на турецком языке',
		ba: 'Врач говорит на боснийском языке',
		me: 'Врач говорит на черногорском языке',
	},
	en: {
		sr: 'Doctor speaks Serbian',
		ru: 'Doctor speaks Russian',
		en: 'Doctor speaks English',
		fr: 'Doctor speaks French',
		de: 'Doctor speaks German',
		tr: 'Doctor speaks Turkish',
		ba: 'Doctor speaks Bosnian',
		me: 'Doctor speaks Montenegrin',
	},
	ba: {
		sr: 'Doktor govori srpski',
		ru: 'Doktor govori ruski',
		en: 'Doktor govori engleski',
		fr: 'Doktor govori francuski',
		de: 'Doktor govori njemački',
		tr: 'Doktor govori turski',
		ba: 'Doktor govori bosanski',
		me: 'Doktor govori crnogorski',
	},
	me: {
		sr: 'Doktor govori srpski',
		ru: 'Doktor govori ruski',
		en: 'Doktor govori engleski',
		fr: 'Doktor govori francuski',
		de: 'Doktor govori njemački',
		tr: 'Doktor govori turski',
		ba: 'Doktor govori bosanski',
		me: 'Doktor govori crnogorski',
	},
	de: {
		sr: 'Arzt spricht Serbisch',
		ru: 'Arzt spricht Russisch',
		en: 'Arzt spricht Englisch',
		fr: 'Arzt spricht Französisch',
		de: 'Arzt spricht Deutsch',
		tr: 'Arzt spricht Türkisch',
		ba: 'Arzt spricht Bosnisch',
		me: 'Arzt spricht Montenegrinisch',
	},
	tr: {
		sr: 'Doktor Sırpça konuşuyor',
		ru: 'Doktor Rusça konuşuyor',
		en: 'Doktor İngilizce konuşuyor',
		fr: 'Doktor Fransızca konuşuyor',
		de: 'Doktor Almanca konuşuyor',
		tr: 'Doktor Türkçe konuşuyor',
		ba: 'Doktor Boşnakça konuşuyor',
		me: 'Doktor Karadağca konuşuyor',
	},
};

// Формируем подсказку
const defaultTooltip =
	tooltipTranslations[props.locale]?.[props.lang] ||
	`Doctor speaks ${languageName}`;
const tooltipText = props.tooltip || defaultTooltip;
</script>

<style scoped>
.language-badge {
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-xs);
	padding: var(--spacing-xs) var(--spacing-sm);
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	font-weight: 500;
	white-space: nowrap;
	transition: all var(--transition-base);
}

.language-badge--sm {
	padding: var(--spacing-sm) var(--spacing-md);
	font-size: var(--font-size-md);
	gap: var(--spacing-xs);
}

.language-badge--md {
	padding: var(--spacing-md) var(--spacing-lg);
	font-size: var(--font-size-lg);
	gap: var(--spacing-sm);
}

.language-badge:hover {
	background: var(--color-surface-primary);
	border-color: var(--color-border-primary);
}

.language-icon {
	width: 1em;
	height: 1em;
	flex-shrink: 0;
	opacity: 0.7;
}

.language-name {
	color: var(--color-text-primary);
	font-weight: 500;
	line-height: 1;
}

/* Адаптивность */
@media (max-width: 768px) {
	.language-badge--sm {
		padding: var(--spacing-xs) var(--spacing-sm);
		font-size: var(--font-size-sm);
	}

	.language-badge--md {
		padding: var(--spacing-sm) var(--spacing-md);
		font-size: var(--font-size-md);
	}
}
</style>
