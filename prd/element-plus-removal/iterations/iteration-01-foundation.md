# Итерация 1: Фундамент UI-кита

[← Все итерации](README.md) | [← Навигация](../index.md)

**Статус:** 🔴 Not Started
**Зависимости:** нет

---

## Цель

Создать ядро кита (простые компоненты без сложного поведения), снять скрытую
зависимость иконок, заменить `ElMessage` на свой тост-сервис и зафиксировать
baseline бандла. Обкатать кит на тривиальных заменах, не трогая сложные страницы.

## Задачи

### Baseline

- [ ] `npm run build` + анализ бандла (`nuxt build --analyze` или `npx nuxi analyze`): зафиксировать в PROGRESS.md JS/CSS first-load для `/clinics` и `/doctors/[slug]`, размер EP-чанков.

### Инфраструктура

- [ ] Конфиг автоимпорта: `components: [{ path: '~/components/ui', pathPrefix: false }, '~/components']` в nuxt.config.ts.
- [ ] (Опционально, Q-3) dev-страница `/dev/ui` со всеми компонентами кита для визуальной проверки (исключить из прода/индексации).

### Иконки (снимает риск R-7)

- [ ] Выписать все импорты из `@element-plus/icons-vue` (27 файлов, ~25 иконок).
- [ ] Создать `components/ui/icons/icon-*.vue` — локальные копии SVG (MIT) + обёртка `AppIcon`.
- [ ] Заменить все импорты `@element-plus/icons-vue` и `<el-icon>` на локальные.

### Тосты

- [ ] `composables/use-toast.ts` + `components/ui/app-toaster.vue` (Teleport, `--z-tooltip`, `aria-live="polite"`, автозакрытие, очередь).
- [ ] Подключить `AppToaster` в `app.vue`.
- [ ] Механическая замена ~35 вызовов `ElMessage.*` → `useToast().*` по всему проекту (включая админку — это безопасная текстовая замена).

### Простые компоненты + тривиальные замены (обкатка)

- [ ] `AppButton` (type: primary/default/danger/text; size; loading; disabled; icon-слот). Фикс контраста danger переносится из design-tokens.css внутрь компонента (глобальный CSS пока НЕ удалять — им ещё пользуется EP в немигрированных зонах).
- [ ] `AppTag`, `AppAlert`, `AppSkeleton`, `AppEmpty`, `AppLoadingOverlay`.
- [ ] Заменить внутренности обёрток без изменения их API: `ApiErrorAlert.vue` (el-alert), `skeleton-card.vue` (el-skeleton), `view-all-link.vue` (el-icon).
- [ ] Заменить `v-loading` в `clinic/items-page.vue` на `AppLoadingOverlay`.

## Критерии приёмки

- **AC-1.** Grep `@element-plus/icons-vue` по репозиторию → 0 вхождений.
- **AC-2.** Grep `ElMessage` → 0 вхождений; тосты работают (success/error) минимум в 3 проверенных потоках (сохранение профиля, ошибка API, модерация).
- **AC-3.** `ApiErrorAlert`, `skeleton-card`, `view-all-link` не содержат `el-*`; их потребители не изменены.
- **AC-4.** Все компоненты кита стилизованы только токенами (ревью стилей).
- **AC-5.** Baseline бандла зафиксирован в PROGRESS.md.
- **AC-6.** `npm run typecheck` и e2e зелёные.

## Проверка

1. `npm run dev` → пройти страницы со скелетонами/алертами (каталоги при медленной сети, ошибка API).
2. Вызвать тосты из профиля (сохранение имени) и убедиться в автозакрытии и стеке из нескольких тостов.
3. `npm run build && npm run preview` → консоль без SSR-ворнингов гидрации.
