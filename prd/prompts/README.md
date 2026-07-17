# Промпты для параллельной реализации оставшихся задач

Подготовлено 2026-06-11 по результатам сверки PRD с фактическим кодом.
Каждый файл — самодостаточный промпт для отдельного окна Claude Code:
скажи в окне «прочитай и выполни prd/prompts/NN-название.md».

## Окна и порядок запуска

| Окно | Промпт | Зависимости |
| ---- | ------ | ----------- |
| 1 | [01-clinic-catalog.md](01-clinic-catalog.md) — геолокация, фильтры, карта | нет |
| 2 | [02-analytics-events.md](02-analytics-events.md) — события взаимодействий | нет, но листинги делает последней фазой (конфликт-зона с окном 1) |
| 3 | [03-clinic-cabinet.md](03-clinic-cabinet.md) — кабинет клиники | нет |
| 3 (после 03) | [04-clinic-billing.md](04-clinic-billing.md) — self-service биллинг | требует завершённого 03 (нужна связь user→clinic) |
| 4 | [05-reviews-completion.md](05-reviews-completion.md) — верификация, модерация, AI summary | нет |
| 5 | [06-user-profile-privacy.md](06-user-profile-privacy.md) — приватность, маскировка email | нет |
| 6 | [07-distance-vs-price-sort.md](07-distance-vs-price-sort.md) — расстояние vs цена: модель сортировок и дефолты | после интеграции окон 1–5 (2026-06-12); начинается с согласования вариантов |

## Зоны файлов (чтобы окна не конфликтовали)

- **Окно 1:** `server/api/geo/**`, `server/api/clinics/list.ts`, `pages/clinics/index.vue`,
  `components/filter/**`, `components/clinic/**`, новые composables/компоненты гео и карты
- **Окно 2:** `composables/use-analytics.ts`, `types/**`, `components/contacts/**`,
  детальные страницы врача/клиники; `pages/clinics/index.vue` и карточки листингов — ТОЛЬКО последней фазой
- **Окно 3:** `components/profile/**` (кроме tab/basic.vue), `server/api/clinics/my-*`,
  затем `pages/profile/clinics/**`, `server/api/billing/**`
- **Окно 4:** `server/api/reviews/**`, `components/review/**`, `components/admin/review*`, `pages/admin/**`
- **Окно 5:** `components/profile/tab/basic.vue`, `server/api/auth/**`

Если все окна работают в одном чекауте: агентам НЕ коммитить (параллельные
коммиты перепутают staged-файлы) — коммитит пользователь по завершении окна.
Альтернатива: по git worktree на окно.

## Общие правила (продублированы в каждом промпте)

- PRD-статусы устарели — верить коду, не PROGRESS.md.
- SQL-миграции не применять самостоятельно: файл в `server/sql/migrations/` + готовая
  команда mysql пользователю; после подтверждения отметить в `APPLIED.md`.
- i18n: 6 локалей (en, ru, sr, sr-cyrl, de, tr), сербский — иекавица,
  правила в `docs/rules/i18n.md` и `docs/rules/LOCALE_ARCHITECTURE.md`.
- Дизайн: только токены из design-tokens.css; AppBreadcrumbs, не el-breadcrumb.
- `npm run typecheck` должен оставаться зелёным.
- Не запускать `nuxt build`, пока запущен dev-сервер (сносит .nuxt и роняет dev).
- В конце обновить PROGRESS.md и файлы итераций своего PRD под реальность.
