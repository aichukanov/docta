# Entity Page Refactor — Plan & Progress

## Overview
Переход от двухколоночного layout (контент + sticky карта) к одноколоночной структуре с секциями и sticky tab navigation.

## Architecture

```
┌─────────────────────────────────────┐
│  Hero (compact): name, photo,       │
│  rating, contacts, CTA buttons      │
├─────────────────────────────────────┤
│  Sticky Tab Bar                     │
│  [Услуги] [Отзывы] [На карте]      │
├─────────────────────────────────────┤
│  § Services / Doctors / Clinics     │
│  § Reviews                          │
│  § Q&A (future)                     │
│  § Map (inline)                     │
└─────────────────────────────────────┘
```

## New Components
- `components/entity-page/index.vue` — main wrapper (replaces `details-page.vue`)
- `components/entity-page/section.vue` — universal section wrapper (id, h2, count badge)
- `components/entity-page/tab-bar.vue` — sticky horizontal nav, IntersectionObserver
- `components/clinic/hero.vue` — compact clinic header
- `components/doctor/hero.vue` — compact doctor header

## Implementation Steps

### Phase 1: Core Components
- [x] 1.1 Create `components/entity-page/section.vue` (EntitySection)
- [x] 1.2 Create `components/entity-page/tab-bar.vue` (SectionTabBar)
- [x] 1.3 Create `components/entity-page/index.vue` (EntityPage — main wrapper)

### Phase 2: Hero Components
- [x] 2.1 Create `components/clinic/hero.vue` (ClinicHero)
- [x] 2.2 Create `components/doctor/hero.vue` (DoctorHero)

### Phase 3: Migrate Pages
- [x] 3.1 Migrate `pages/clinics/[clinicId]/index.vue` to EntityPage
- [x] 3.2 Migrate `pages/doctors/[doctorId]/index.vue` to EntityPage
- [x] 3.3 Migrate `pages/services/[serviceId]/index.vue` to EntityPage
- [x] 3.4 Migrate `pages/labtests/[labTestId]/index.vue` to EntityPage
- [x] 3.5 Migrate `pages/medications/[medicationId]/index.vue` to EntityPage

### Phase 4: Cleanup & Polish
- [ ] 4.1 Delete old `details-page.vue` when ready
- [ ] 4.2 Delete old `components/clinic/header.vue` (replaced by hero.vue)
- [ ] 4.3 Remove gradient styles from `ClinicCategorizedSection` headers
- [ ] 4.4 Verify SEO: heading hierarchy, schema.org, anchor links
- [ ] 4.5 Visual QA on mobile + desktop

### Phase 5: Future
- [ ] 5.1 Add Q&A section
- [ ] 5.2 Add reviews section for services/labtests/medications (when data available)

## Design Tokens
- Page max-width: 900px (single column, content-focused)
- Section gap: `--spacing-2xl` (32-48px)
- Hero: white bg, no gradient, no card border
- Sections separated by gap
- h1: 1.75rem / 700, h2: `--font-size-xl` / 600
- Accent color only for interactive elements
- Map: inline, 400px height, border-radius, lazy-loaded

## i18n Keys Added
All pages got `TabClinics`, `TabReviews`, `TabMap`, `TabServices` keys in 6 locales:
en, ru, de, tr, sr, sr-cyrl
