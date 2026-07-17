# Итерация 5: Админка и финальное удаление

[← Все итерации](README.md) | [← Навигация](../index.md)

**Статус:** 🔴 Not Started
**Зависимости:** итерации 1–4
**Решение-предусловие:** Q-2 (мигрировать админку сейчас или заморозить EP в ней) — см. [риски](../05-risks-and-metrics.md)

---

## Цель

Мигрировать админку (самая тяжёлая по виджетам, но не критичная по качеству зона —
единственный пользователь — владелец) и демонтировать Element Plus полностью:
пакеты, модуль, мост токенов.

## Контур

`pages/admin/index.vue` + `components/admin/*` (~20 файлов): user-info (таблица),
review-moderation (диалог, пагинация, радио-фильтры), clinic-find,
*-info/*-add/*-merge формы, editable-field, slug-field, clinic-working-hours-editor,
а также `markdown-editor.client.vue` (только если есть EP-обвязка; сам md-editor-v3 не трогаем).

## Задачи

### Миграция админки

- [ ] `AppTabs`/`AppTab` (6 групп табов в admin/index.vue; aria-роли, стрелки, ленивые панели).
- [ ] `AppTable` — семантическая таблица под `admin/user-info.vue` (без сортировок/выделения; не строить универсальный datagrid).
- [ ] `AppInputNumber` (4 использования: цены) — input[inputmode=decimal] + кнопки ±.
- [ ] `admin/clinic-working-hours-editor.vue` → `AppTimeInput` (паттерн из итерации 4).
- [ ] `review-moderation.vue`: el-dialog → `AppDialog`, el-pagination → обёртка `pagination.vue`, радио-фильтры → `AppSegmented`.
- [ ] Остальные admin-формы: механическая пересадка input/select/button/checkbox на кит.

### Демонтаж (строго после grep-нуля по всему репо)

- [ ] Полный grep-гейт: `<el-`, `\bEl[A-Z]`, `v-loading`, `@element-plus` → 0 во всём репозитории.
- [ ] nuxt.config.ts: убрать `@element-plus/nuxt` из modules.
- [ ] package.json: удалить `element-plus`, `@element-plus/nuxt`; `npm install`; проверить, что lock не тянет EP.
- [ ] design-tokens.css: удалить мост `:root:root { --el-* }` (строки 130–167) и фикс `.el-button--danger` (169–178; к этому моменту логика уже внутри AppButton с итерации 1).
- [ ] Финальный замер: `nuxt build --analyze`, дельта против baseline → PROGRESS.md.
- [ ] Точечный WCAG-проход по компонентам кита (select, tabs, dialog, tooltip, switch, формы) — закрытие NFR-1; зафиксировать результат (память: re-audit планировался на новых компонентах).

## Критерии приёмки

- **AC-1.** Grep-гейт всего репозитория → 0; `package.json`/`package-lock.json` не содержат element-plus.
- **AC-2.** Все админ-операции работают: поиск клиники, добавление/правка врача/услуги/анализа, merge, модерация отзывов (approve/reject с комментарием), правка графика работы, таблица пользователей.
- **AC-3.** Сборка и preview без ошибок; ни одна страница не запрашивает EP-чанки.
- **AC-4.** Финальная дельта бандла зафиксирована; Lighthouse mobile на ключевых страницах не хуже baseline.
- **AC-5.** typecheck + полный e2e зелёные.
- **AC-6.** WCAG-проход по киту: 0 нарушений AA.

## Проверка

1. Ручной прогон всех вкладок админки (единственный пользователь — можно позволить себе чек-лист вместо e2e).
2. `npm run build && npm run preview` → полный клик-прогон публичного сайта + профиля.
3. `npm ls element-plus` → пусто.
