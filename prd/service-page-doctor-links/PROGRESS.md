# Прогресс

**Статус:** ✅ Закрыт. Реализовано 2026-07-23 (коммит `8039957 absent medicines`), проверено по коду и typecheck; **проверено на проде 2026-07-26**.

Реализация сдана другим агентом, проверена вручную по diff: обе таблицы-источники (точная + фолбэк по специальности) задействованы именно в приоритете, описанном в `index.md`, кэп 2 на клинику, `rank_score DESC` для фолбэка, лейбл «Врачи»/«Specialists» (нейтральный, не утверждает личное выполнение — AC-5). `server/common/services.ts:getDoctorsForServiceByClinic` — единая точка сборки, вызывается из `services/details.ts`.

## Чеклист реализации

- [x] `server/api/services/details.ts` — запросы точной связи + фолбэка по специальности, сборка `clinicDoctors`
- [x] `interfaces/clinic.ts` — `ClinicDoctorsByClinicId`, поле в `ClinicServiceWithPrices`
- [x] `pages/services/[serviceSlug]/index.vue` — проводка пропа
- [x] `components/entity-page/clinics-section.vue` — проводка пропа, `getDoctorsInfo`
- [x] `components/clinic/summary.vue` — новый `el-collapse-item` «Врачи», реюз `DoctorInfo` c `short`
- [x] i18n-строки заголовка блока (нейтральная формулировка, см. AC-5 в `index.md`) на всех 6 локалях
- [x] Живая проверка (AC-7 в `index.md`) — сделана 2026-07-26 **на проде**, а не на dev. В HTML `https://docta.me/services/ecg?lang=ru` в карточках клиник присутствуют блоки `Врачи (2)` со ссылками вида `/doctors/<slug>?lang=ru`; кэп 2 на клинику соблюдается
- [x] `npm run typecheck` — зелёный (проверено 2026-07-23)

## Проверка на проде (2026-07-26)

`curl https://docta.me/services/ecg?lang=ru` — блок отдаётся в SSR-разметке, а не рисуется
на клиенте. Ссылки на врачей присутствуют в HTML как обычные `<a href>` даже при свёрнутом
`el-collapse-item`, то есть цель пункта (входящие ссылки на карточки врачей для краулера)
достигнута независимо от того, раскроет ли пользователь блок.

Осторожно с проверками: локаль на проде задаётся `?lang=ru`, а не префиксом пути —
`/ru/services/...` отдаёт 200 с пустой оболочкой и сбивает с толку. Ссылки внутри страницы
несут `?lang=ru`, поэтому grep по `href="/doctors/<slug>"` без query ничего не находит.
