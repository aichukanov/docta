# Прогресс

**Статус:** 🔴 Not Started

PRD написан 2026-07-23, все запросы и покрытие проверены на живой БД (см. `index.md`). Готов к реализации другим агентом.

## Чеклист реализации

- [ ] `server/api/services/details.ts` — запросы точной связи + фолбэка по специальности, сборка `clinicDoctors`
- [ ] `interfaces/clinic.ts` — `ClinicDoctorsByClinicId`, поле в `ClinicServiceWithPrices`
- [ ] `pages/services/[serviceSlug]/index.vue` — проводка пропа
- [ ] `components/entity-page/clinics-section.vue` — проводка пропа, `getDoctorsInfo`
- [ ] `components/clinic/summary.vue` — новый `el-collapse-item` «Врачи», реюз `DoctorInfo` c `short`
- [ ] i18n-строки заголовка блока (нейтральная формулировка, см. AC-5 в `index.md`) на всех 6 локалях
- [ ] Ручная проверка на dev-сервере (AC-7 в `index.md`)
- [ ] `npm run typecheck`
