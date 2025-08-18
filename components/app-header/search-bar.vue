<template>
	<div class="search-bar search-bar--compact search-bar--flat">
		<div class="search-bar__container">
			<div class="search-bar__filters">
				<div class="search-bar__filter" @click="showSpecialtyFilter = true">
					<div class="search-bar__filter-label">{{ t('Specialty') }}</div>
					<div class="search-bar__filter-value">{{ selectedSpecialties }}</div>
				</div>

				<div class="search-bar__separator"></div>

				<div class="search-bar__filter" @click="showCityFilter = true">
					<div class="search-bar__filter-label">{{ t('City') }}</div>
					<div class="search-bar__filter-value">{{ selectedCity }}</div>
				</div>

				<div class="search-bar__separator"></div>

				<div class="search-bar__filter" @click="showLanguageFilter = true">
					<div class="search-bar__filter-label">{{ t('Language') }}</div>
					<div class="search-bar__filter-value">{{ selectedLanguage }}</div>
				</div>

				<button
					class="search-bar__search-button"
					:aria-label="t('Search')"
					@click="handleSearch"
				>
					<svg class="search-bar__search-icon" viewBox="0 0 24 24" fill="none">
						<path
							d="M21 21L16.514 16.506M19 10.5A8.5 8.5 0 1 1 10.5 2A8.5 8.5 0 0 1 19 10.5Z"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
						/>
					</svg>
				</button>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { useFiltersStore } from '~/stores/filters';

const emit = defineEmits<{
	search: [];
}>();

const { t } = useI18n();

const filtersStore = useFiltersStore();

// Filter states
const showSpecialtyFilter = ref(false);
const showCityFilter = ref(false);
const showLanguageFilter = ref(false);

const selectedSpecialties = computed(() => {
	if (filtersStore.specialties.length === 0) return t('AnySpecialty');
	if (filtersStore.specialties.length === 1) return filtersStore.specialties[0];
	return t('SpecialtiesCount', { count: filtersStore.specialties.length });
});

const selectedCity = computed(() => filtersStore.city || t('AnyCity'));
const selectedLanguage = computed(
	() => filtersStore.language || t('AnyLanguage'),
);

const handleSearch = () => {
	emit('search');
};
</script>

<i18n lang="json">
{
	"en": {
		"Specialty": "Specialty",
		"City": "City",
		"Language": "Language",
		"Search": "Search",
		"Doctors": "Doctors",
		"Pharmacies": "Pharmacies",
		"AnySpecialty": "Any specialty",
		"AnyCity": "Any city",
		"AnyLanguage": "Any language",
		"SpecialtiesCount": "{count} specialties"
	},
	"ru": {
		"Specialty": "Специализация",
		"City": "Город",
		"Language": "Язык",
		"Search": "Поиск",
		"Doctors": "Доктора",
		"Pharmacies": "Аптеки",
		"AnySpecialty": "Любая специализация",
		"AnyCity": "Любой город",
		"AnyLanguage": "Любой язык",
		"SpecialtiesCount": "{count} специализаций"
	},
	"sr": {
		"Specialty": "Specijalizacija",
		"City": "Grad",
		"Language": "Jezik",
		"Search": "Pretraga",
		"Doctors": "Lekari",
		"Pharmacies": "Apoteke",
		"AnySpecialty": "Bilo koja specijalizacija",
		"AnyCity": "Bilo koji grad",
		"AnyLanguage": "Bilo koji jezik",
		"SpecialtiesCount": "{count} specijalizacija"
	},
	"ba": {
		"Specialty": "Specijalizacija",
		"City": "Grad",
		"Language": "Jezik",
		"Search": "Pretraga",
		"Doctors": "Lekari",
		"Pharmacies": "Apoteke",
		"AnySpecialty": "Bilo koja specijalizacija",
		"AnyCity": "Bilo koji grad",
		"AnyLanguage": "Bilo koji jezik",
		"SpecialtiesCount": "{count} specijalizacija"
	},
	"me": {
		"Specialty": "Specijalizacija",
		"City": "Grad",
		"Language": "Jezik",
		"Search": "Pretraga",
		"Doctors": "Ljekari",
		"Pharmacies": "Apoteke",
		"AnySpecialty": "Bilo koja specijalizacija",
		"AnyCity": "Bilo koji grad",
		"AnyLanguage": "Bilo koji jezik",
		"SpecialtiesCount": "{count} specijalizacija"
	},
	"de": {
		"Specialty": "Fachrichtung",
		"City": "Stadt",
		"Language": "Sprache",
		"Search": "Suchen",
		"Doctors": "Ärzte",
		"Pharmacies": "Apotheken",
		"AnySpecialty": "Jede Fachrichtung",
		"AnyCity": "Jede Stadt",
		"AnyLanguage": "Jede Sprache",
		"SpecialtiesCount": "{count} Fachrichtungen"
	},
	"tr": {
		"Specialty": "Uzmanlık",
		"City": "Şehir",
		"Language": "Dil",
		"Search": "Ara",
		"Doctors": "Doktorlar",
		"Pharmacies": "Eczaneler",
		"AnySpecialty": "Herhangi bir uzmanlık",
		"AnyCity": "Herhangi bir şehir",
		"AnyLanguage": "Herhangi bir dil",
		"SpecialtiesCount": "{count} uzmanlık"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.search-bar {
	width: 100%;
	display: flex;
	justify-content: center;
	padding: @base-padding 0 0 0;
	box-sizing: border-box;

	&--compact {
		padding: @base-offset 0 0 0;
	}

	&--flat {
		.search-bar__filters {
			border: none;
			box-shadow: none;
			background: transparent;
			border-radius: 0;

			&:hover {
				box-shadow: none;
			}
		}
	}

	&__container {
		width: 100%;
		max-width: 850px;
		padding: 0 @base-padding;
		box-sizing: border-box;
	}

	&__filters {
		display: flex;
		align-items: center;
		background: white;
		border: 1px solid @light-gray-color;
		border-radius: 32px;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
		overflow: hidden;
		transition: box-shadow 0.2s ease;

		&:hover {
			box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
		}
	}

	&__filter {
		flex: 1;
		padding: 14px 16px;
		cursor: pointer;
		transition: background-color 0.2s ease;
		min-width: 0;

		&:hover {
			background: rgba(75, 70, 229, 0.04);
		}
	}

	&__filter-label {
		font-size: 12px;
		font-weight: 600;
		color: @dark-gray-color;
		margin-bottom: 2px;
	}

	&__filter-value {
		font-size: 14px;
		font-weight: 400;
		color: #222;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	&__separator {
		width: 1px;
		height: 32px;
		background: @light-gray-color;
		flex-shrink: 0;
	}

	&__search-button {
		background: @primary-color;
		border: none;
		width: 48px;
		height: 48px;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition: background-color 0.2s ease;
		margin: 8px;
		flex-shrink: 0;

		&:hover {
			background: @primary-hover-color;
		}
	}

	&__search-icon {
		width: 16px;
		height: 16px;
		color: white;
	}
}

@media only screen and (max-width: 800px) {
	.search-bar {
		&__filters {
			border-radius: 24px;
		}

		&__filter {
			padding: 12px 12px;
		}

		&__filter-label {
			font-size: 11px;
		}

		&__filter-value {
			font-size: 13px;
		}

		&__search-button {
			width: 40px;
			height: 40px;
			margin: 6px;
		}

		&__search-icon {
			width: 14px;
			height: 14px;
		}
	}
}

@media only screen and (max-width: 600px) {
	.search-bar {
		&__container {
			padding: 0 @base-offset;
		}

		&__filter {
			padding: 10px 8px;
		}

		&__search-button {
			width: 36px;
			height: 36px;
			margin: 4px;
		}
	}
}
</style>
