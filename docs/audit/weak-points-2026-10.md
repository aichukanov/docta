# Аудит слабых мест — октябрь 2026

Дата: 2026-10-09. Пять направлений: серверный код/безопасность, SEO, данные БД, фронтенд, инфраструктура/тесты/зависимости. Локальная БД на момент аудита = прод-срез 2026-10-08, прод проверялся curl'ом. Закрытое прошлыми аудитами (docs/audit/*) не дублируется — только новое и статусы старых открытых пунктов.

## Сводный топ-10 (риск × усилия)

1. **Нет автоматических бэкапов MySQL и пользовательских загрузок** при одном VPS — RPO до недели (недельный снапшот хостера + ручные дампы). Потеря диска = потеря отзывов, клиник, биллинга за неделю. Фикс дешёвый: cron mysqldump + выгрузка наружу + rsync uploads/storage.
2. **Stored XSS** — ✅ ИСПРАВЛЕНО 2026-10-09: `marked.parse()` + `v-html` (`components/marked-content.vue`) рендерил описания, которые пишут не-админы — кабинет клиники (`server/api/clinics/my-create.ts`, `my-update.ts`) и профиль врача (`server/api/doctors/update-my-profile.ts:79`). Усугублялось п.6 ниже (самопубликация). Фикс на рендере: raw-HTML экранируется, ссылки/картинки только со схемами https/http/mailto/tel или относительные (с вычисткой управляющих символов из схемы и экранированием атрибутов против `&colon;`-обхода). Остаточный хвост: превью md-editor-v3 в кабинете рендерит markdown своим движком без санитайзера — self-XSS для владельца, но срабатывает и у админа, открывшего чужую клинику в форме редактирования; закрыть при бампе md-editor-v3 (п.7, проп `sanitize`).
3. **95+ применённых к проду SQL-файлов не в git** (`server/sql/`, 4 — в migrations/), часть миграций (015/016/017) существует только в БД — прод невоспроизводим из репозитория.
4. **`server/api/reviews/recent-from-real-users.ts` не фильтрует `status`** — pending/rejected утекут в публичный блок «последние отзывы» (сейчас данные чистые, но это мина). Попутно зафиксировать решение: во всех агрегатах pending учитывается в рейтинг (`status != 'rejected'`).
5. **Правка отзыва не сбрасывает модерацию**: `server/api/reviews/edit.post.ts:54-59` меняет текст, не трогая `status`/`is_verified`, и не обнуляет переводы `text_*` (в других локалях остаётся старый текст). Одобренный отзыв публикуется с непроверенным новым текстом.
6. **Самопубликация клиник без модерации**: `my-create.ts` + `my-set-status.ts` — любой аккаунт публикует «клинику» (фейки, SEO-спам); `hidden` работает только постфактум. Нужна очередь одобрения по образцу модерации отзывов.
7. **Security-бампы зависимостей не сделаны**: sharp 0.34.5 (CVE libvips при реальной поверхности — парсинг недоверенных картинок в верификации отзывов) → 0.35.5 отдельным апгрейдом; vue → 3.5.43 (SSR-XSS), nuxt → 3.21.11, form-data → 4.0.6, mysql2 → 3.24.x, md-editor-v3 → 6.5.6 — закрываются `npm audit fix` без force. Остальные 43 уязвимости — dev-цепочка и транзитивный шум.
8. ~~**Rate limiting отсутствует полностью**: перебор паролей на `auth/login`, неограниченная отправка писем через Mailgun (`register`, `forgot-password`, `resend-verification`, `request-email-change`), POST отзывов. Минимум — лимитер по CF-Connecting-IP на auth-* и email-эндпоинты.~~ **Сделано 2026-10-09**: `server/utils/rate-limit.ts` — in-memory лимитер по CF-Connecting-IP (login 5/15 мин, email-эндпоинты 5/час общим bucket'ом; лимиты на воркер, в pm2-кластере фактически ×4), код `TOO_MANY_REQUESTS` + переводы, тест `tests/unit/rate-limit.spec.ts`. POST отзывов не лимитирован осознанно: требует логин + есть защита от дублей (`REVIEW_DUPLICATE`).
9. **Справки снова отстали от каталога**: после импорта 38 клиник в тир ≥3 клиник попали **949 услуг и 630 анализов без карточек** (топ: мед. справки — firearms 19 клиник, adoption 18; Double/Triple Test 23, наркопанели, Lipoprotein A). «Тир закрыт» из июля больше не верен.
10. **Мониторинга, CI и healthcheck в деплое нет**: о падении узнают пользователи; 693 теста и typecheck запускаются только руками; `docta_build` = pull+build+`pm2 restart` (не `reload`) без гейтов и отката.

## Безопасность сервера (детали)

Проверено ~130 эндпоинтов. **Чисто**: requireAdmin на всех админских write; IDOR не найден (getOwnedClinic/getOwnedOrder, verification/sessions проверяют владельца); Stripe-вебхук с подписью и идемпотентностью; SQL параметризован, в т.ч. весь новый код; секреты не текут (runtimeConfig.public — только публичные токены); ошибки — только коды api-codes; maxPreparedStatements:200 на месте.

Находки сверх топ-10:

- **[Важно] Upload без привязки**: `server/api/upload/image.post.ts:79-104` — для категорий `clinics`/`insurance-companies`/`coupons` файл сохраняется и URL отдаётся любому залогиненному → файлохостинг под доменом + файлы-сироты. Оставить в публичном эндпоинте только `avatars`/`doctors`.
- **[Важно] HTML-инъекция имени в письма** — ✅ ИСПРАВЛЕНО 2026-10-09: `server/utils/email-templates.ts` — `greeting(userName)` шёл в HTML без экранирования, имя при регистрации не ограничивалось, письмо уходит на произвольный адрес. Экранированы все внешние значения в HTML-письмах: userName (3 шаблона), userAgent/ip/location в уведомлении о входе, old/newEmail в смене почты, clinicName в биллинговом письме (`billing-email.ts`); общий хелпер `common/escape-html.ts` (его же использует safe-markdown). В `register.post.ts` добавлен лимит 255 (NAME_TOO_LONG, как в update-name).
- **[Минор] LIKE без экранирования `%`/`_` и лимита длины** в 8 листингах (`clinics/list.ts:324`, `doctors/list.ts:148`, `services/list.ts:103`, `labtests/list.ts:109`, `insurance-companies/list.ts:44`, `medicines/list.ts:166,235`, `users/list.ts:24`, `common/medicines/name-match.ts:52`) — бэктрекинг MySQL на мусорных паттернах. Общий `escapeLikePattern` + max длина в validateName.
- **[Минор] Нет лимита длины текста отзыва** (`reviews/create.post.ts:37`, `edit.post.ts:27`) — мегабайтные тексты в БД и очередь модерации.
- **[Минор] SSRF в админских download-URL**: `server/utils/image-processing.ts:81-91` — fetch произвольного URL из админских форм, статус/URL отражаются в ошибке. Разрешать только публичные http(s)-адреса.
- **[Минор] `resolveUploadPath` без нормализации `..`** (`image-processing.ts:71-75`) — значение из БД; кривой импорт → unlink за пределами uploads. Проверять `resolve().startsWith(uploadsRoot)`.
- **[Минор] Сессия 365 дней без ротации** (`server/utils/session.ts:5,33-43`), просроченные строки `auth_sessions` не чистятся.

## SEO

**Регрессий нет**, новые разделы (статьи — включая донорство, оно на проде; страховые + их отзывы с 301 ниже порога; аналоги лекарств в SSR; фасеты с уникальными title; справки с lastmod по updated_at; купоны; 410/301 скрытых) сделаны чисто. Edge-кэш для ботов безопасен (локаль только из URL, Vary корректный).

- **[Средняя] Страницы отзывов — пропущенный паттерн 7e**: `components/reviews-page.vue` (useSeoMeta ~строка 145) без robots-логики `hasRedundantQuery` — `?sort=<мусор>`, `?page=1` отдают 200 с self-canonical на мусорный URL (прод подтверждён). Все три типа отзывов, 151 страница в sitemap. Фикс по образцу `components/list-page.vue:177`.
- **[Средняя] lastmod core-секции sitemap застрял на 2026-07-20** (`server/common/sitemap/sitemap.ts`, buildCoreSection): у статей нет источника даты — новая статья не поднимает lastmod части, Google вправе не перечитывать core-1.xml. Фикс: datePublished/dateModified уже есть у статей — вынести в реестр рядом с ARTICLE_SLUGS (`common/articles.ts`).
- **[Низкая] ATC-код в canonical не нормализован по регистру**: `/medicines?atcClassCodes=r06` и `=R06` — два self-canonical на одинаковый контент (`stores/filters.ts:203-216` валидирует case-insensitive, `common/url-utils.ts` сохраняет сырое значение).
- **[Низкая, E-E-A-T] Контакт на /about — `contact@svad.net`** — ЗАКРЫТ 2026-10-19: заведён ящик contact@docta.me, заменён в `PROJECT_CONTACTS` и в строках локалей privacy.vue, доставка проверена тестовым письмом.
- **[Инфо]** У /medicines нет хаба related-filters (у 4 других разделов есть); глубина пагинации компенсируется sitemap+rank_score.
- Статусы старых пунктов: lastmod сущностей — сделан полностью (миграция 026, 100% покрытие); крошки на detail — закрыт (AppBreadcrumbs в EntityPage); contact@ — закрыт 2026-10-19 (см. выше).

## Данные

**Чисто**: дубли клиник (place_id/slug/имя+город) — 0; дубли clinic_languages вычищены (203/203); тёзки-врачи под контролем (суффиксы slug); FK-целостность связей — 0 сирот; rejected-отзывов 0; обоих флагов obsolete+outdated — 0; каталоги и справки локализованы на 100%; миграции по 057 включительно применены (018/019/020 тоже — записи памяти устарели); FZOCG X/J/M-блоки ХН/Мойковац исправлены 056-й.

- **Справки**: 949 услуг + 630 анализов тира ≥3 без карточек (см. топ-10 п.9).
- **Локализация профилей**: 143/192 клиник без name_ru (74%), 113+ без описаний; 1254/1956 врачей без name_ru (64%), 1692 без description_sr (86%). Самый массовый контентный пробел при 6-язычном позиционировании.
- **Застрявшие outdated-прайсы**: Novi Standard — 1046 позиций (весь прайс) помечены outdated с декабря 2025, и это легитимно: БД сходится с самым свежим доступным первоисточником (PDF «08.04.2025.Cenovnik», в шапке «Od 01.10.2024»), новее ничего нет — сайт прайс не публикует вовсе, только акции в новостях (сверка map.json 2026-10-02). Снять флаги нечем, нужен новый документ от клиники. A3 Medical 348/472 с января; Konzilijum 215/238; Optimal 65. У Novi Standard одновременно 15/15 врачей исчезли с их сайта — кандидат на разбор «что с клиникой».
- **Мусор**: 53 нулевые цены стационара ОБ Никшич (0.00 вместо NULL, Y-коды); 3 подологические услуги-сироты (8237–8239, остатки iPodo) + typhoid-vaccination (7440, сознательно); 13 строк medical_services_specialties с NULL specialty_id; 2 сироты clinic_languages (clinic_id=21); clinic_languages без UNIQUE/FK — дубли вернутся при первом INSERT IGNORE.
- **65 публичных врачей без клиники** (в BACKLOG было ~54 — растёт).
- **Dev-среда**: 627 врачей ссылаются на /uploads/doctors/*.webp, локальная папка пуста — все фото биты в разработке. Внешние photo_url выборочно проверены — 200 OK.
- **data/**: журнал прайсов — ритм ок (2026-10-07), 1 ошибка доступа (ДЗ Бело-Поле, PDF не отдаётся curl); висит выгрузка отзывов для 27 импортированных клиник (Mićunović 74, Lopičić 61, Ana Medica 49); 4 спорных профиля волны 2e ждут решения; ежемесячная сверка составов клиник не налажена как регулярный процесс.
- 4 тарифа fzocg-medicinsko-pomagala (DA1101–DA1104) со scheme='single' и price_eur=NULL.

## Фронтенд

**Чисто**: публичные компоненты без захардкоженных строк и без «|» в переводах; mobile-overflow в публичной части не найден; правила FRONTEND_PERFORMANCE соблюдаются новым кодом; el-select/el-breadcrumb/тосты/иконки/пагинация действительно мигрированы.

- **[M] Утечка Leaflet**: `composables/use-leaflet.ts` — нет `map.remove()`/onBeforeUnmount вообще; 4 потребителя (clinic-services-map, clinics-map-view, branches-map, ClinicMapPicker), копится за SPA-сессию. Проверять на билде.
- **[M] A11y отзывов**: `components/review/rating-input.vue:9-21` — звёзды без aria-label/radiogroup (и это самодельные кнопки — нарушение конвенции EP-контролов); `review/form.vue:167-212` — label без for/id. Свежая фича непроходима скринридером.
- **[M] Гонка debounce**: `components/clinic/items-page.vue:76-88` — таймер поиска не чистится, pushQuery может переписать query следующей страницы. Мелочь того же класса: `filter/name.vue:27-33` (debounce без cancel), поллинг в `billing/success.vue:27-51` без прерывания.
- **Дублирование ~1500–2000 строк**: 6 каталожных страниц с одинаковым boilerplate (route-sync, useSeoMeta, schema.org, каскады заголовков — в medicines каскад 155 строк) → композабл `useCatalogListPage`; подстраницы клиники services/labtests идентичны на 90%; парные related-filters и tips. Каждое SEO-правило сейчас правится в 6 местах.
- **Мёртвый код ~900 строк**: details-page.vue (279), clinic/header.vue (151), review/own-item.vue (183), contacts/phone-line|viber-line|whatsapp-line (сверить с планами показа контактов), doctor/description.vue, icon/chevron.vue, use-api-messages.ts, query-parser.ts + мёртвые экспорты.
- **Остаток EP на горячем пути** (по убыванию выгоды): el-collapse ×4 в clinic/summary (20 карточек на листинг); el-tooltip в прайсовых бейджах (price-outdated, obsolete, approved, coupon, contacts/line, copy-button); el-input фильтра имени; el-button — 161 вхождение при готовом KitButton; el-dropdown в entity-page/tab-bar. Админский хвост (el-table/el-form) — в route-чанке, в последнюю очередь.
- **Тёмная тема**: отсутствует полностью; предусловие — ~70 захардкоженных hex в публичных компонентах заменить на kit-токены (pages/index.vue 11, medicine-страница 7, services/index.vue:287,308).
- **Хвост Lighthouse**: спрайт иконок — не сделан; фото врачей — сырые внешние URL без вариантов; Mixpanel — idle-загрузка сделана, тонкий клиент не решён.
- **Админка**: целиком по-русски без i18n + native alert/confirm (clinic-add.vue:75,116 и др.); grid ломается <750px (clinic-find.vue:991) — desktop-only, низкий приоритет. nowrap проверить: coupon-banner.vue:99, substance-badges.vue:51.

## Инфраструктура, тесты, зависимости

- **Typecheck — 0 ошибок** (базлайн удержан). `.env` в git нет, секретов в репо нет.
- **Бэкапы/мониторинг/CI** — см. топ-10 (п.1, 10). `.github/` нет вовсе; минимальный workflow (typecheck + unit-проект) стоил бы минуты.
- **Деплой**: `docta_build` — build in-place рядом с живыми воркерами (окно 404 на чанки; OOM-риск при 4ГБ куче на 8ГБ RAM), `pm2 restart` вместо `reload` (cluster ×4 дал бы нулевой даунтайм бесплатно). В ecosystem.config.cjs нет wait_ready/kill_timeout и ротации логов (pm2-logrotate не стоит — логи растут бесконечно).
- **Тесты**: 693 теста / 46 файлов (chromium e2e + unit на Playwright + scripts). Дыры: флоу отправки/верификации/модерации отзывов — 0 тестов; кабинет клиники + биллинг — 0; купоны — только юнит; специфика лекарств (аналоги) — нет.
- **ROOT в scripts/ не починен** — 15 скриптов с `ROOT = resolve(__dirname, '..')` (= scripts/): clinics/build-working-hours-sql, clinic-doctor-table, fetch-clinic-working-hours; doctors/find-duplicate-doctors; kb/kb-compile-qa, kb-generate-sql, kb-parse-channel, kb-translate; medicines/build-med-sql, generate-med-translations, generate-substance-translations, normalize-medicines-json, rebuild-substance-batches, scrape-medicines; reviews/generate-telegram-reviews-sql. Чинить по образцу остальных ~30 (`'../..'`).
- **storage/ не в .gitignore** — на сервере там фото верификации отзывов; один `git add -A` на машине с файлами — чувствительные изображения в репо.
- **182 незакоммиченных пути** на рабочей машине, из них 95 SQL в server/sql/ (см. топ-10 п.3).
- **Зависимости**: security-бампы — топ-10 п.7. Стратегически: Nuxt 3 → 4 назревает (i18n 10 и pinia 4 уже целятся в Nuxt 4), nuxt-гарантированного фикса island-уязвимостей нет даже в 4.5.2 — но админка держится не только на route middleware (requireAdmin на API), так что риск ограничен.

## Что оказалось лучше, чем в памяти проекта

- Миграции 018/019 (скрытие) и 020 (купоны) — применены.
- Дубли clinic_languages — вычищены (но UNIQUE/FK так и нет).
- FZOCG X/J/M-блоки ДЗ Херцег-Нови/Мойковац — исправлены миграцией 056.
- Статья о донорстве крови — на проде, во всех локалях и sitemap.
- lastmod сущностей в sitemap — полностью сделан (кроме статей/статики — см. SEO п.2).
