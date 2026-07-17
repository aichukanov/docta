# Задача: кабинет клиники (создание и управление клиникой пользователем)

Реализуй итерации 2–6 PRD `prd/clinic-profile/` полностью: создание клиники,
редактирование, управление контентом, markdown, draft/published.

## Перед началом прочитай

- `prd/clinic-profile/PROGRESS.md`, `02-requirements.md`, `03-architecture.md`, `04-database.md`
- Все файлы `prd/clinic-profile/iterations/iteration-02..06-*.md` (какие существуют)
- `docs/DATABASE_SCHEMA.md`, `docs/rules/*.md`
- **Эталон — профиль врача, он уже полностью реализован по той же схеме:**
  `components/profile/tab/doctor.vue`, `components/profile/DoctorEditForm.vue`,
  `DoctorCard.vue`, `DoctorStatusBlock.vue`, `DoctorEmptyState.vue`,
  `server/api/doctors/my-profile.ts`, `toggle-visibility`, статусы
  draft/hidden/public. Копируй этот UX и архитектуру, не изобретай новую.

## Важные поправки к PRD (документация устарела)

- Auth и user-profile полностью реализованы — блокеры из PROGRESS.md неактуальны.
- Таб «Мои клиники» (`components/profile/tab/clinics.vue`) — заглушка
  «раздел в разработке», её и заменяешь.
- Markdown-инфраструктура уже есть: `components/markdown-editor.client.vue`
  (редактор с превью) и `components/marked-content.vue` (рендер) — итерация 5
  сводится к их переиспользованию, см. как это сделано в DoctorEditForm.
- Публичная страница клиники готова (итерация 1) — не ломай её; черновики
  не должны попадать в публичные списки и sitemap.

## Что сделать

1. **Миграция БД** (итерация 2): полям таблицы `clinics` добавить `created_by`
   (FK users), `status` ENUM('draft','pending_verification','published','rejected'),
   `logo_url`. Сверь с `04-database.md` и реальной схемой.
2. **API** по образцу doctors: `server/api/clinics/my-list`, `create`, `update`,
   `toggle-visibility`/смена статуса. Права: редактировать может только создатель
   (или админ). Валидация на сервере.
3. **Таб «Мои клиники»**: список клиник пользователя (одной может быть несколько,
   в отличие от врача), статус-бейджи, создание новой, редактирование.
4. **Форма клиники** (итерации 3–4): название (+ локализации по схеме существующих
   полей name_*), тип, город, адрес, координаты (выбор точки — в проекте есть
   Leaflet, `composables/use-leaflet.ts`), контакты (телефон, email, viber,
   whatsapp, telegram), языки, график работы, описание с markdown-редактором,
   логотип (загрузка через `composables/use-image-upload.ts` — пользовательская
   загрузка в /uploads допустима, это admin-upload сценарий).
5. **Draft/Published** (итерация 6): новая клиника создаётся draft, публикация
   переводит в pending_verification или published — реши по спеке итерации 6;
   на публичной странице draft-клиника видна только владельцу/админу (404 остальным).

## Конвенции проекта (обязательно)

- SQL-миграции НЕ применять: файл в `server/sql/migrations/`, выдай команду mysql,
  после подтверждения пользователя отметь в `server/sql/migrations/APPLIED.md`.
- i18n: 6 локалей (en, ru, sr, sr-cyrl, de, tr), иекавица; локальные сообщения
  по образцу `i18n/doctor-profile.ts` — сделай `i18n/clinic-profile.ts`.
- Только дизайн-токены; переиспользуй общие компоненты (AppBreadcrumbs и т.д.).
- `npm run typecheck` зелёный. НЕ запускай `nuxt build` при работающем dev-сервере.
- НЕ коммить — пользователь коммитит сам.
- Зона: `components/profile/**` (кроме tab/basic.vue), `server/api/clinics/my-*` и
  новые endpoint'ы, `i18n/clinic-profile.ts`. Чужие зоны (листинг /clinics,
  use-analytics) не трогать.

## Definition of Done

- Полный цикл: создать клинику → заполнить → опубликовать → увидеть на публичной
  странице → скрыть. Черновики не светятся в списках/sitemap.
- typecheck зелёный, тексты на 6 локалях.
- `prd/clinic-profile/PROGRESS.md` и итерации обновлены.
- Сводка: файлы, миграции на применение, сценарий ручной проверки.

**После завершения этой задачи** в этом же окне выполни `prd/prompts/04-clinic-billing.md` —
он зависит от связи user→clinic, которую ты только что создал.
