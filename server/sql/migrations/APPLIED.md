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
