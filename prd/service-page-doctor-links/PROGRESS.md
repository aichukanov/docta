# Прогресс

**Статус:** ✅ Реализовано 2026-07-23 (коммит `8039957 absent medicines`), проверено по коду и typecheck.

Реализация сдана другим агентом, проверена вручную по diff: обе таблицы-источники (точная + фолбэк по специальности) задействованы именно в приоритете, описанном в `index.md`, кэп 2 на клинику, `rank_score DESC` для фолбэка, лейбл «Врачи»/«Specialists» (нейтральный, не утверждает личное выполнение — AC-5). `server/common/services.ts:getDoctorsForServiceByClinic` — единая точка сборки, вызывается из `services/details.ts`.

## Чеклист реализации

- [x] `server/api/services/details.ts` — запросы точной связи + фолбэка по специальности, сборка `clinicDoctors`
- [x] `interfaces/clinic.ts` — `ClinicDoctorsByClinicId`, поле в `ClinicServiceWithPrices`
- [x] `pages/services/[serviceSlug]/index.vue` — проводка пропа
- [x] `components/entity-page/clinics-section.vue` — проводка пропа, `getDoctorsInfo`
- [x] `components/clinic/summary.vue` — новый `el-collapse-item` «Врачи», реюз `DoctorInfo` c `short`
- [x] i18n-строки заголовка блока (нейтральная формулировка, см. AC-5 в `index.md`) на всех 6 локалях
- [ ] Ручная проверка на dev-сервере (AC-7 в `index.md`) — **не выполнена мной**, код и запросы проверены статически (diff + typecheck), живой визуальный чек на 3 услугах (точная/фолбэк/без совпадений) ещё не сделан никем
- [x] `npm run typecheck` — зелёный (проверено 2026-07-23)
