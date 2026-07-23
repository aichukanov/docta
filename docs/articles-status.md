# Статус статей /articles

Отслеживаем, какие статьи прошли ручную проверку (факты, формулировки, ссылки), а какие только сгенерированы и ждут вычитки. Обновлять статус на «проверено» только после того, как контент реально прочитан и поправлен человеком — не автоматически при правке отдельных мест.

## Проверено

| Статья | i18n-файл | Дата проверки |
|---|---|---|
| [healthcare-system-in-montenegro](../pages/articles/healthcare-system-in-montenegro.vue) | `i18n/article-healthcare-system.ts` | 2026-07-18 |
| [birth-in-montenegro](../pages/articles/birth-in-montenegro.vue) | `i18n/article-birth-in-montenegro.ts` | 2026-07-18 |
| [health-insurance-for-residence-permit](../pages/articles/health-insurance-for-residence-permit.vue) | `i18n/article-residence-insurance.ts` | 2026-07-18 |
| [mental-health-in-montenegro](../pages/articles/mental-health-in-montenegro.vue) | `i18n/article-mental-health.ts` | 2026-07-19 |
| [tourist-healthcare-in-montenegro](../pages/articles/tourist-healthcare-in-montenegro.vue) | `i18n/article-tourist-healthcare.ts` | 2026-07-19 |
| [dentistry-in-montenegro](../pages/articles/dentistry-in-montenegro.vue) | `i18n/article-dentistry.ts` | 2026-07-19 |
| [pharmacies-and-medications](../pages/articles/pharmacies-and-medications.vue) | `i18n/article-pharmacies.ts` | 2026-07-19 |
| [weekend-medical-help-in-montenegro](../pages/articles/weekend-medical-help-in-montenegro.vue) | `i18n/article-weekend-medical-help.ts` | 2026-07-19 |
| [lab-tests-and-checkups](../pages/articles/lab-tests-and-checkups.vue) | `i18n/article-labtests.ts` | 2026-07-19 |
| [child-healthcare-in-montenegro](../pages/articles/child-healthcare-in-montenegro.vue) | `i18n/article-child-healthcare.ts` | 2026-07-19 |
| [healthcare-in-budva](../pages/articles/healthcare-in-budva.vue) | `i18n/article-city-healthcare.ts` (общий компонент `components/article/city-healthcare.vue`) | 2026-07-19 |
| [healthcare-in-podgorica](../pages/articles/healthcare-in-podgorica.vue) | `i18n/article-city-healthcare.ts` | 2026-07-19 |
| [healthcare-in-kotor](../pages/articles/healthcare-in-kotor.vue) | `i18n/article-city-healthcare.ts` | 2026-07-19 |
| [healthcare-in-bar](../pages/articles/healthcare-in-bar.vue) | `i18n/article-city-healthcare.ts` | 2026-07-19 |

## Сгенерировано, ждёт проверки

| Статья | i18n-файл |
|---|---|
| [russian-speaking-doctors-in-montenegro](../pages/articles/russian-speaking-doctors-in-montenegro.vue) | — |
| [clinics-with-language-support](../pages/articles/clinics-with-language-support.vue) | — |
| [medications-not-available-in-montenegro](../pages/articles/medications-not-available-in-montenegro.vue) | `i18n/article-medications-unavailable.ts` |

> `medications-not-available-in-montenegro` — YMYL: наличие препаратов взято из чатов (`data/chat-exports/_analysis/whats-not-available.md`), не сверено по каждой позиции с реестром CInMED/остатками аптек; нужна вычитка носителем sr/sr-cyrl/de/tr и hero-картинка `public/img/articles/medications-not-available-in-montenegro.webp`.
> Факты сверены по БД (`med_substances` / `med_medicines`, только active) — чат-источник несколько раз ошибался, проверять по реестру обязательно. Доступные вещества вынесены ссылками по substanceIds: активированный уголь 523, повидон-йод 670, октенидин 611, хлоропирамин 357, диметинден 190, лоратадин 498, дезлоратадин 178, фексофенадин 259, парацетамол 635, ибупрофен 364; плюс ссылки на конкретные препараты Synopen (`synopen-20mg2ml`) и Flenty (`flenty`). Исправлено против чата: (1) хлоропирамин (супрастин) ЕСТЬ как Synopen; (2) tobramycin/Tobrex зарегистрирован — убран из «не найти»; (3) диметинден (фенистил) ЕСТЬ, но только как гель Flenty — оральных капель нет; (4) повидон-йод (Betadine) и октенидин (Octenisept) есть — заменили расплывчатое «спросите у фармацевта». НЕ в реестре (поданы как отсутствующие): цетиризин (зиртек), левоцетиризин (Xyzal — «везут из Сербии»), клемастин (тавегил), осельтамивир (Тамифлю — только общемед. пример), сибутрамин, доктор МОМ, каметон; регидрон/ORS как препарат тоже не нашёлся. Хлоргексидин/мирамистин/диоксидин как substance-строки не нашлись — формулировки смягчены. **Комбо-анальгетики:** привычных безрецептурных комбо-таблеток типа пенталгина нет; многокомпонентное — простудные средства (аналоги колдрекса): Caffetin Cold (`caffetin-cold`) и Tylol Hot (`tylol-hot-500mg-60mg-4mg-2684`), оба — ссылки. (В реестре есть и Caffetin-таблетки с кодеином — рецептурные, в статью не выносил.)
> **Правило именования (важно, задано юзером):** действующие вещества — на языке локали (в RU по-русски, как localized `name_ru` в каталоге; латиница для аптекаря — дело каталога, не статьи). Названия ЛЕКАРСТВ не переводим: локальные препараты ЧГ остаются как в реестре/на упаковке (Synopen, Flenty, Betadine, Octenisept, Caffetin Cold, Tylol Hot, Xyzal, Ozempic, Wegovy, Forxiga, Jardiance); российские бренды воспроизводим по-русски (Тамифлю, Энтеросгель, Супрастин, Зиртек, Корвалол…) — так и будут искать. Список статей в `pages/articles/index.vue` сортируется по `date` (новые сверху).
>
> **Блок «Диабет и уколы для похудения» (GLP-1 + инсулин):** семаглутид ЕСТЬ (Ozempic — диабет, Wegovy — вес; оба инъекции, Rx); тирзепатид (Mounjaro) и Rybelsus (оральный семаглутид) НЕ зарегистрированы. Диабет в целом закрыт: инсулины (аналоги, 12 активных препаратов), метформин, дапаглифлозин (Forxiga), эмпаглифлозин (Jardiance), глиптины — всё есть (юзерская догадка, что «форсиги нет», оказалась неверной). YMYL: подано как Rx по показаниям, без поощрения самокола ради похудения.
>
> **Рецепты — исправлено СКВОЗНО (было неверно «только электронный»):** в реальности рецепт бывает бумажным (частные клиники — с печатью и подписью врача, аптеки принимают при оплате из кармана) ИЛИ электронным (eRecept — в основном путь Фонда/льготного отпуска). Правка внесена в `article-medications-unavailable`, `article-pharmacies` (заголовок TOC + PhaPrescriptions3), `article-healthcare-system` (убрано «бумажные выведены из оборота» + reframe), `article-mental-health`, `article-tourist-healthcare`. Все 6 локалей в каждой. Источник — личный опыт юзера (получал бумажные рецепты много раз, электронных не видел).

Связано: [[project-articles-from-chats]], [[project-seo-audit-2026-07]].
