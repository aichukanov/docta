<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';

import articlesI18n from '~/i18n/articles';
import articleBloodDonationI18n from '~/i18n/article-blood-donation';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		articleBloodDonationI18n,
		breadcrumbI18n,
	]),
});

const ARTICLE_SLUG = 'blood-donation-in-montenegro';

const getClinicLink = (clinicSlug: string) => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug },
	query: getRegionalQuery(locale.value),
});

const getLabTestLink = (labTestSlug: string) => ({
	name: 'labtests-labTestSlug',
	params: { labTestSlug },
	query: getRegionalQuery(locale.value),
});

/**
 * Больницы, в корпусах которых работают пункты Завода трансфузии. Сам Завод
 * в каталоге не заведён (это не клиника, приём пациентов он не ведёт),
 * поэтому в Подгорице ссылки на пункт нет — вместо неё ссылка на Клинический
 * центр, в круге которого стоит здание Завода.
 *
 * Адреса и телефоны в тексте — из карточек Завода, а не из наших карточек
 * клиник: у части больниц улица в каталоге записана иначе (Никшич, Беране,
 * Плевля). Правим только вместе, сверившись с transfuzija.me/kontakt.
 */
const kccgLink = computed(() =>
	getClinicLink('klinicki-centar-crne-gore-podgorica'),
);
const barHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-blazo-orlandic'),
);
const kotorHospitalLink = computed(() => getClinicLink('opsta-bolnica-kotor'));
const beraneHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-berane'),
);
const cetinjeHospitalLink = computed(() =>
	getClinicLink('bolnica-danilo-i-cetinje'),
);
const niksicHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-niksic'),
);
const bijeloPoljeHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-bijelo-polje'),
);
const pljevljaHospitalLink = computed(() =>
	getClinicLink('opsta-bolnica-pljevlja'),
);
const risanHospitalLink = computed(() =>
	getClinicLink(
		'specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan',
	),
);

// Показатели, из-за которых чаще всего разворачивают донора, — ведут
// на карточки анализов с ценами лабораторий.
const hemoglobinLink = computed(() => getLabTestLink('hemoglobin'));
const ferritinLink = computed(() => getLabTestLink('ferritin'));
const bloodGroupLink = computed(() =>
	getLabTestLink('blood-group-and-rh-factor'),
);
const cbcLink = computed(() => getLabTestLink('complete-blood-count'));

const healthcareSystemArticleLink = computed(() => ({
	path: '/articles/healthcare-system-in-montenegro',
	query: getRegionalQuery(locale.value),
}));

const labTestsArticleLink = computed(() => ({
	path: '/articles/lab-tests-and-checkups',
	query: getRegionalQuery(locale.value),
}));

/**
 * Полный текст анкеты донора — 23 общих вопроса и 3 для женщин, переведённые
 * с ЧЕРНОГОРСКОГО бланка (стр. 2 Karton davaoca): именно его дают на месте.
 * Английский PDF на сайте Завода с ним вопрос в вопрос не совпадает, об этом
 * сказано в тексте под списком.
 *
 * Список живёт отдельной последней секцией и НЕ сворачивается: решение юзера.
 * В секции «Кому можно сдавать» от него остаётся только упоминание с отсылкой
 * в конец статьи (BldWho6).
 */
const QUESTION_KEYS = Array.from({ length: 23 }, (_, i) => `BldQ${i + 1}`);
const WOMEN_QUESTION_KEYS = ['BldQWomen1', 'BldQWomen2', 'BldQWomen3'];

const QUESTIONNAIRE_ME_URL =
	'https://transfuzija.me/api/media/file/Upitnik.pdf';
const QUESTIONNAIRE_EN_URL =
	'https://transfuzija.me/api/media/file/Questionnaire.pdf';

const SECTION_IDS = [
	'who',
	'often',
	'docs',
	'where',
	'app',
	'drives',
	'prepare',
	'how',
	'target',
	'perks',
	'questionnaire',
	'sources',
] as const;

const articleToc = computed(() =>
	SECTION_IDS.map((id) => ({
		id: `section-${id}`,
		label: t(`BldToc_${id}`),
	})),
);

const articleCta = computed(() => ({
	title: t('BldCtaTitle'),
	text: t('BldCtaText'),
	button: t('BldCtaButton'),
	link: cbcLink.value,
}));

const { breadcrumbItems } = useArticlePageSeo({
	slug: ARTICLE_SLUG,
	title: computed(() => t('BldTitle')),
	description: computed(() => t('BldDescription')),
	image: `/img/articles/${ARTICLE_SLUG}.webp`,
	datePublished: '2026-09-16',
	t,
	locale,
});
</script>

<template>
	<ArticlePage
		:breadcrumbs="breadcrumbItems"
		:title="t('BldTitle')"
		:description="t('BldDescription')"
		:image="`/img/articles/${ARTICLE_SLUG}.webp`"
		:toc="articleToc"
		:cta="articleCta"
	>
		<ArticleSection id="section-who" :title="t('BldToc_who')">
			<p
				>{{ t('BldWho1a')
				}}<NuxtLink :to="kccgLink">{{ t('BldWho1Link') }}</NuxtLink
				>{{ t('BldWho1End') }}</p
			>
			<p>{{ t('BldWho2') }}</p>
			<ul>
				<li>{{ t('BldWhoReqWeight') }}</li>
				<li>{{ t('BldWhoReqTemp') }}</li>
				<li>{{ t('BldWhoReqPulse') }}</li>
				<li>{{ t('BldWhoReqPressure') }}</li>
				<li
					><NuxtLink :to="hemoglobinLink">{{ t('BldWhoReqHbLink') }}</NuxtLink
					>{{ t('BldWhoReqHbEnd') }}</li
				>
				<li>{{ t('BldWhoReqHealth') }}</li>
			</ul>
			<p>{{ t('BldWho3') }}</p>
			<p
				>{{ t('BldWho4a')
				}}<NuxtLink :to="ferritinLink">{{ t('BldWho4Link') }}</NuxtLink
				>{{ t('BldWho4End') }}</p
			>
			<p
				>{{ t('BldWho5a')
				}}<NuxtLink :to="bloodGroupLink">{{ t('BldWho5Link') }}</NuxtLink
				>{{ t('BldWho5End') }}</p
			>
			<p>{{ t('BldWho6') }}</p>
			<p>{{ t('BldWho8') }}</p>
			<p>{{ t('BldWho7') }}</p>
		</ArticleSection>

		<ArticleSection id="section-often" :title="t('BldToc_often')">
			<p>{{ t('BldOften1') }}</p>
			<p>{{ t('BldOften2') }}</p>
			<p>{{ t('BldOften3') }}</p>
		</ArticleSection>

		<ArticleSection id="section-docs" :title="t('BldToc_docs')">
			<p>{{ t('BldDocs1') }}</p>
			<p>{{ t('BldDocs2') }}</p>
			<p>{{ t('BldDocs3') }}</p>
			<p>{{ t('BldDocs4') }}</p>
			<p>{{ t('BldDocs5') }}</p>
		</ArticleSection>

		<ArticleSection id="section-where" :title="t('BldToc_where')">
			<p>{{ t('BldWhere1') }}</p>
			<ul>
				<li>{{ t('BldWherePodgorica') }}</li>
				<li
					><NuxtLink :to="barHospitalLink">{{ t('BldWhereBarLink') }}</NuxtLink
					>{{ t('BldWhereBarEnd') }}</li
				>
				<li
					><NuxtLink :to="kotorHospitalLink">{{
						t('BldWhereKotorLink')
					}}</NuxtLink
					>{{ t('BldWhereKotorEnd') }}</li
				>
				<li
					><NuxtLink :to="beraneHospitalLink">{{
						t('BldWhereBeraneLink')
					}}</NuxtLink
					>{{ t('BldWhereBeraneEnd') }}</li
				>
				<li
					><NuxtLink :to="cetinjeHospitalLink">{{
						t('BldWhereCetinjeLink')
					}}</NuxtLink
					>{{ t('BldWhereCetinjeEnd') }}</li
				>
				<li
					><NuxtLink :to="niksicHospitalLink">{{
						t('BldWhereNiksicLink')
					}}</NuxtLink
					>{{ t('BldWhereNiksicEnd') }}</li
				>
				<li
					><NuxtLink :to="bijeloPoljeHospitalLink">{{
						t('BldWhereBpLink')
					}}</NuxtLink
					>{{ t('BldWhereBpEnd') }}</li
				>
				<li
					><NuxtLink :to="pljevljaHospitalLink">{{
						t('BldWherePljevljaLink')
					}}</NuxtLink
					>{{ t('BldWherePljevljaEnd') }}</li
				>
				<li
					><NuxtLink :to="risanHospitalLink">{{
						t('BldWhereRisanLink')
					}}</NuxtLink
					>{{ t('BldWhereRisanEnd') }}</li
				>
			</ul>
			<p>{{ t('BldWhere2') }}</p>
			<p>{{ t('BldWhere3') }}</p>
			<p>{{ t('BldWhere4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-app" :title="t('BldToc_app')">
			<p
				>{{ t('BldApp1a')
				}}<a
					href="https://darujkrv.me/"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('BldApp1Link') }}</a
				>{{ t('BldApp1End') }}</p
			>
			<p>{{ t('BldApp2') }}</p>
			<p>{{ t('BldApp3') }}</p>
			<p>{{ t('BldApp4') }}</p>
			<p>{{ t('BldApp5') }}</p>
		</ArticleSection>

		<ArticleSection id="section-drives" :title="t('BldToc_drives')">
			<p>{{ t('BldDrives1') }}</p>
			<p>{{ t('BldDrives2') }}</p>
			<p>{{ t('BldDrives3') }}</p>
			<ul>
				<li>{{ t('BldDrivesHn') }}</li>
				<li>{{ t('BldDrivesBudva') }}</li>
				<li>{{ t('BldDrivesBar') }}</li>
				<li>{{ t('BldDrivesTivat') }}</li>
				<li>{{ t('BldDrivesOther') }}</li>
			</ul>
			<p>{{ t('BldDrives4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-prepare" :title="t('BldToc_prepare')">
			<p>{{ t('BldPrep1') }}</p>
			<p>{{ t('BldPrep2') }}</p>
			<p>{{ t('BldPrep3') }}</p>
			<p>{{ t('BldPrep4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-how" :title="t('BldToc_how')">
			<p>{{ t('BldHow1') }}</p>
			<p>{{ t('BldHow2') }}</p>
			<p>{{ t('BldHow3') }}</p>
			<p>{{ t('BldHow4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-target" :title="t('BldToc_target')">
			<p>{{ t('BldTarget1') }}</p>
			<p>{{ t('BldTarget2') }}</p>
			<p>{{ t('BldTarget3') }}</p>
			<p>{{ t('BldTarget4') }}</p>
		</ArticleSection>

		<ArticleSection id="section-perks" :title="t('BldToc_perks')">
			<p>{{ t('BldPerks1') }}</p>
			<p>{{ t('BldPerksAnon') }}</p>
			<p>{{ t('BldPerksPart') }}</p>
			<p>{{ t('BldPerksFund') }}</p>
			<p>{{ t('BldPerks2') }}</p>
			<p>{{ t('BldPerks3') }}</p>
			<p>{{ t('BldPerks4') }}</p>
		</ArticleSection>

		<ArticleSection
			id="section-questionnaire"
			:title="t('BldToc_questionnaire')"
		>
			<p>{{ t('BldQIntro') }}</p>
			<ul>
				<li v-for="key in QUESTION_KEYS" :key="key">{{ t(key) }}</li>
			</ul>
			<p>{{ t('BldQWomenIntro') }}</p>
			<ul>
				<li v-for="key in WOMEN_QUESTION_KEYS" :key="key">{{ t(key) }}</li>
			</ul>
			<p>{{ t('BldQConfirm') }}</p>
			<p
				>{{ t('BldQSourceA')
				}}<a
					:href="QUESTIONNAIRE_ME_URL"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('BldQSourceMeLink') }}</a
				>{{ t('BldQSourceMid')
				}}<a
					:href="QUESTIONNAIRE_EN_URL"
					target="_blank"
					rel="noopener nofollow"
					>{{ t('BldQSourceEnLink') }}</a
				>{{ t('BldQSourceEnd') }}</p
			>
		</ArticleSection>

		<ArticleSection id="section-sources" :title="t('BldToc_sources')">
			<p>{{ t('BldSources1') }}</p>
			<ul>
				<li>
					<a
						href="https://transfuzija.me/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('BldSourcesSite') }}</a
					>
				</li>
				<li>
					<a
						href="https://darujkrv.me/"
						target="_blank"
						rel="noopener nofollow"
						>{{ t('BldSourcesApp') }}</a
					>
				</li>
				<li>
					<a href="https://ckcg.me/" target="_blank" rel="noopener nofollow">{{
						t('BldSourcesRedCross')
					}}</a>
				</li>
			</ul>
			<p>{{ t('BldSources2') }}</p>
			<p
				>{{ t('BldSourcesRelatedA')
				}}<NuxtLink :to="healthcareSystemArticleLink">{{
					t('BldSourcesRelatedLink1')
				}}</NuxtLink
				>{{ t('BldSourcesRelatedMid')
				}}<NuxtLink :to="labTestsArticleLink">{{
					t('BldSourcesRelatedLink2')
				}}</NuxtLink
				>{{ t('BldSourcesRelatedEnd') }}</p
			>
		</ArticleSection>
	</ArticlePage>
</template>
