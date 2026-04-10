# Applied Migrations Log

## 2026-03-20: deploy-reviews.sql

Deployed reviews system to production. Applied by docta_admin on 89.116.111.68.

Schema changes:
- `clinics`: added `google_place_id` (VARCHAR(255), UNIQUE)
- `auth_users`: added `is_phantom`, `profile_url`, made `email` nullable
- Created tables: `reviews`, `review_replies`, `review_likes`, `review_reply_likes`
- `reviews`: added `likes_count` column + index

## 2026-03-20: Google Maps reviews import

Data collected: 2026-03-18 — 2026-03-19. Applied by docta_admin on 89.116.111.68.

Imported reviews for 7 clinics:
- a3-medical-sutomore
- buntic (Bar)
- dental-esthetic-studio (Bar)
- dr-zejnilovic (Bar)
- just-dental (Bar)
- medical-vranes-bar (Bar)
- pavlin (Bar)

SQL files removed after successful import (regenerable via `generate-reviews-sql.mjs` from configs in `data/review-import-configs/`).

## 2026-04-10: deploy-medicines.sql

Medicine register from CInMED (cinmed.me) — Montenegro Ministry of Health.

Single deploy file: `server/sql/migrations/deploy-medicines.sql`

```bash
mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/deploy-medicines.sql
```

Created tables:
- `countries` (39) — shared country table with 6-language translations
- `med_dispensing_modes` (9) — prescription modes with translations
- `med_pharma_forms` (147) — pharmaceutical forms with translations
- `med_substances` (904) — INN/active substances with translations
- `med_atc_groups` (14) — ATC therapeutic categories with translations
- `med_auth_holders` (46) — marketing authorization holders (legal entities in MNE)
- `med_manufacturers` (421) — manufacturers with full addresses and country FK
- `med_medicines` (3553) — main medicines table, 2523 with active license
- `med_medicine_substances` (4404) — M:N medicine ↔ substance links

Data source: `data/medicines.json` (scraped via `scripts/scrape-medicines.mjs`).
Translations: `data/med-translations/` (JSON batches).
Regenerate SQL from JSON: `node scripts/build-med-sql.mjs`.
