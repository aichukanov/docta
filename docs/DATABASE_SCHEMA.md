# Database Schema (Technical Reference for Agents)

This file provides a structured reference of the MySQL database for the docta.me project.

## Tables Summary

| Table                                   | Description                                                                                   |
| :-------------------------------------- | :-------------------------------------------------------------------------------------------- |
| `auth_users`                            | User accounts (admins with email/password, OAuth users).                                      |
| `auth_oauth_accounts`                   | OAuth provider accounts linked to users.                                                      |
| `auth_oauth_profiles_google`            | Google OAuth profile data (email, name, locale, avatar).                                      |
| `auth_oauth_profiles_telegram`          | Telegram OAuth profile data (name, username, avatar).                                         |
| `auth_oauth_profiles_facebook`          | Facebook OAuth profile data (name, email, avatar).                                            |
| `auth_sessions`                         | User sessions with expiration tracking.                                                       |
| `auth_login_history`                    | Login attempt history (IP, user agent, method, success).                                      |
| `auth_email_verification_tokens`        | Tokens for email verification flow.                                                           |
| `auth_password_reset_tokens`            | Tokens for password reset flow.                                                               |
| `auth_email_log`                        | Log of all sent email messages.                                                               |
| `cities`                                | List of cities with coordinates.                                                              |
| `clinics`                               | Core clinic data, contacts, and multi-language descriptions.                                  |
| `doctors`                               | Medical specialists, personal info, and professional titles.                                  |
| `lab_tests`                             | Catalog of laboratory tests with localized names.                                             |
| `medical_services`                      | Catalog of general medical services (localized).                                              |
| `medications`                           | Catalog of medications (localized).                                                           |
| `specialties`                           | Medical specialties.                                                                          |
| `languages`                             | Supported languages (codes and names).                                                        |
| `clinic_lab_tests`                      | Junction table: Clinic <-> Lab Test (includes pricing).                                       |
| `clinic_medical_services`               | Junction table: Clinic <-> Medical Service (includes pricing).                                |
| `clinic_medications`                    | Junction table: Clinic <-> Medication (includes pricing).                                     |
| `clinic_languages`                      | Junction table: Clinic <-> Languages supported.                                               |
| `clinic_medical_service_doctors`        | Junction table: Clinic <-> Medical Service <-> Doctor.                                        |
| `clinic_types`                          | Reference table of clinic types (e.g. hospital, lab, pharmacy).                               |
| `clinic_clinic_types`                   | Junction table: Clinic <-> Clinic Type.                                                       |
| `clinic_admins`                         | Junction table: Clinic <-> managing users (cabinet access). _(migration 022)_                  |
| `clinic_working_hours`                  | Working hours per clinic (JSON per weekday).                                                  |
| `clinic_coupons`                        | Discount coupons per clinic (percent + item types). _(migration 020)_                         |
| `insurance_companies`                   | Directory of private insurers operating in Montenegro. _(migrations 010-012)_                 |
| `insurance_company_branches`            | Branch offices of an insurer (1:N), with address, coordinates and hours.                      |
| `doctor_clinics`                        | Junction table: Doctor <-> Clinic (includes position).                                        |
| `doctor_specialties`                    | Junction table: Doctor <-> Specialty.                                                         |
| `doctor_languages`                      | Junction table: Doctor <-> Languages spoken.                                                  |
| `medical_services_specialties`          | Junction table: Medical Service <-> Specialty.                                                |
| `medical_service_categories`            | Categories for medical services.                                                              |
| `medical_service_categories_relations`  | Junction table: Medical Service <-> Category.                                                 |
| `lab_test_categories`                   | Categories for lab tests.                                                                     |
| `lab_test_categories_relations`         | Junction table: Lab Test <-> Category.                                                        |
| `lab_test_synonyms`                     | Alternative names for lab tests for search optimization.                                      |
| `lab_test_reference_info`               | Editorial reference card for a lab test, 5 fields x 6 languages.                              |
| `medical_service_reference_info`        | Editorial reference card for a service, same shape as the lab test one.                       |
| `medical_service_synonyms`              | Alternative names for medical services (search + names kept from merges).                     |
| `medical_service_tariffs`               | State-insurance (FZOCG) reference pricelists, linked to either catalog. NOT clinic prices.    |
| `medical_service_duplicate_candidates`  | Review queue of suspected duplicate service pairs.                                            |
| `lab_test_duplicate_candidates`         | Review queue of suspected duplicate lab test pairs.                                           |
| `medical_service_redirects`             | Redirect map for merged medical service records.                                              |
| `doctor_redirects`                      | Redirect map for merged doctor profiles.                                                      |
| `lab_test_redirects`                    | Redirect map for merged lab test records.                                                     |
| `slug_redirects`                        | Redirect map for renamed slugs (old slug → entity id).                                        |
| `reviews`                               | Polymorphic reviews for clinics, doctors, services, and insurance companies.                  |
| `review_replies`                        | Replies to reviews (one from clinic, one from doctor).                                        |
| `review_likes`                          | Likes on reviews by registered users.                                                         |
| `review_reply_likes`                    | Likes on review replies by registered users.                                                  |
| `review_verification_files`             | Visit-confirmation files for reviews (private storage). _(migration 005, applied 2026-06-12)_ |
| `review_moderation_logs`                | Audit log of review moderation actions. _(migration 005, applied 2026-06-12)_                 |
| `review_ai_summaries`                   | Cached AI summaries of reviews per entity per locale. _(migration 005, applied 2026-06-12)_   |
| `billing_paid_services`                 | Catalog of paid services available for clinics.                                               |
| `billing_service_prices`                | Price per paid service per period, with deactivated rows kept for history.                    |
| `billing_clinic_service_purchases`      | Purchase records of paid services by clinics.                                                 |
| `billing_clinic_service_purchase_items` | Junction table: Purchase <-> Paid Service.                                                    |
| `billing_orders`                        | Checkout orders for paid services (Stripe flow, not yet in use).                              |
| `billing_order_items`                   | Junction table: Order <-> Paid Service, with the price frozen at order time.                  |
| `billing_payment_transactions`          | Payment attempts against an order (Stripe session, status, error).                            |
| `countries`                             | Shared country table with 6-language translations.                                            |
| `med_dispensing_modes`                  | Medicine dispensing modes (prescription/OTC) with translations.                               |
| `med_pharma_forms`                      | Pharmaceutical dosage forms with translations.                                                |
| `med_substances`                        | INN / active substances with translations.                                                    |
| `med_atc_groups`                        | ATC level-1 therapeutic categories with translations.                                         |
| `med_auth_holders`                      | Marketing authorization holders (legal entities in MNE).                                      |
| `med_manufacturers`                     | Drug manufacturers with full addresses and country FK.                                        |
| `med_medicines`                         | CInMED medicine register (3553 medicines).                                                    |
| `med_medicine_substances`               | Junction table: Medicine <-> Substance (M:N).                                                 |
| `med_substance_reference_info`          | Editorial reference card for a substance, 3 fields x 6 languages. _(migration 024)_           |
| `med_foreign_products`                  | Brand names of the same substances on foreign markets (RU/UA/TR/DE/PL/US). _(migration 017)_  |
| `med_foreign_product_substances`        | Junction table: Foreign product <-> Substance (M:N).                                          |

## Detailed Table Definitions

### `auth_users`

- `id` (int, PK, AI)
- `email` (varchar(255), Unique, NULL): User email address. NULL for phantom users from Google Maps (no email available).
- `name` (varchar(255)): User's full name.
- `photo_url` (varchar(500)): URL to user's profile photo.
- `profile_url` (varchar(500), NULL): External profile link (Google Maps contributor URL, Facebook profile, etc.).
- `password_hash` (varchar(255), NULL): Bcrypt password hash (for admins with email/password login). NULL for OAuth users.
- `is_admin` (boolean, default FALSE): Flag indicating administrator privileges.
- `email_verified` (boolean, default FALSE): Whether the user's email is verified.
- `is_phantom` (boolean, default FALSE): Auto-created user from external review import. Flips to FALSE on first OAuth login.
- `is_profile_public` (boolean, NOT NULL, default FALSE): Profile privacy. TRUE — author name shown next to own reviews (masked email `u*****@g****.*om` if no name); FALSE — reviews displayed anonymously. Default is private for real users; phantom users are backfilled TRUE and always treated as public in display logic (imported review names come from public sources).
- `primary_oauth_provider` (varchar(50), NULL): Primary OAuth provider for display (google, telegram, NULL for email).
- `preferred_locale` (varchar(10), NULL): Preferred language: sr, sr-cyrl, en, ru, de, tr.
- `preferred_city_id` (int, FK -> cities.id, NULL, ON DELETE SET NULL): User's city for distance sorting of clinics.
- `created_at` (timestamp)
- `updated_at` (timestamp)
- _Indexes_: `idx_email`, `idx_is_admin`, `idx_email_verified`, `idx_is_phantom`, `idx_primary_provider`, `idx_preferred_locale`
- _Comment_: Stores admin users (with password_hash), OAuth users (without password_hash), and phantom users (auto-created from review imports, is_phantom=TRUE).

### `auth_oauth_accounts`

- `id` (int, PK, AI)
- `user_id` (int, FK -> auth_users.id, NOT NULL): Reference to user account.
- `provider` (varchar(50), NOT NULL): OAuth provider name (google, telegram).
- `provider_account_id` (varchar(255), NOT NULL): User ID from OAuth provider.
- `access_token` (text): OAuth access token (optional, encrypted).
- `refresh_token` (text): OAuth refresh token (optional).
- `expires_at` (bigint): Token expiration timestamp (UNIX).
- `created_at` (timestamp)
- `updated_at` (timestamp)
- _Unique constraint_: (`provider`, `provider_account_id`)
- _Indexes_: `idx_user_id` (user_id), `idx_provider` (provider, provider_account_id)
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE CASCADE)
- _Comment_: Supports multiple OAuth providers per user (e.g., one user can login via both Google and Telegram).

### `auth_oauth_profiles_google`

- `id` (int, PK, AI)
- `oauth_account_id` (int, FK -> auth_oauth_accounts.id, NOT NULL, Unique)
- `google_id` (varchar(255), NOT NULL): Google User ID.
- `email` (varchar(255), NOT NULL): Email from Google.
- `verified_email` (boolean, default FALSE): Whether Google verified the email.
- `name` (varchar(255)): Full name.
- `given_name` (varchar(255)): First name.
- `family_name` (varchar(255)): Last name.
- `picture` (text): Avatar URL.
- `locale` (varchar(10)): Locale (ru, en, etc.).
- `raw_data` (json): Full Google response.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_google_id`, `idx_email`
- _Foreign Keys_: `oauth_account_id` -> `auth_oauth_accounts.id` (ON DELETE CASCADE)

### `auth_oauth_profiles_telegram`

- `id` (int, PK, AI)
- `oauth_account_id` (int, FK -> auth_oauth_accounts.id, NOT NULL, Unique)
- `telegram_id` (bigint, NOT NULL): Telegram User ID.
- `first_name` (varchar(255), NOT NULL)
- `last_name` (varchar(255))
- `username` (varchar(255)): Username without @.
- `photo_url` (text): Avatar URL.
- `auth_date` (bigint): Authorization date (UNIX timestamp).
- `raw_data` (json): Full Telegram response.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_telegram_id`, `idx_username`
- _Foreign Keys_: `oauth_account_id` -> `auth_oauth_accounts.id` (ON DELETE CASCADE)

### `auth_oauth_profiles_facebook`

- `id` (int, PK, AI)
- `oauth_account_id` (int, FK -> auth_oauth_accounts.id, NOT NULL, Unique)
- `facebook_id` (varchar(255), NOT NULL, Unique)
- `name` (varchar(255), NOT NULL)
- `email` (varchar(255))
- `picture_url` (text): Avatar URL.
- `raw_data` (json): Full Facebook response.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_email`
- _Foreign Keys_: `oauth_account_id` -> `auth_oauth_accounts.id` (ON DELETE CASCADE)

### `auth_sessions`

- `id` (varchar(255), PK): Session ID (UUID).
- `user_id` (int, FK -> auth_users.id, NOT NULL): Reference to user account.
- `expires_at` (bigint, NOT NULL): Session expiration timestamp (UNIX).
- `created_at` (timestamp)
- _Indexes_: `idx_user_id` (user_id), `idx_expires_at` (expires_at)
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE CASCADE)
- _Comment_: Database-based session storage. HTTPOnly cookies store session_id, actual session data is in DB.

### `auth_login_history`

- `id` (int, PK, AI)
- `user_id` (int, FK -> auth_users.id, NOT NULL)
- `ip_address` (varchar(45)): IP address (IPv4 or IPv6).
- `user_agent` (text)
- `location` (varchar(255)): Geolocation (city, country).
- `login_method` (varchar(50)): Login method: email, google, telegram.
- `success` (boolean, default TRUE)
- `failure_reason` (varchar(255)): Reason for failure (if success=false).
- `created_at` (timestamp)
- _Indexes_: `idx_user_id`, `idx_created_at`, `idx_success`, `idx_user_recent` (user_id, created_at DESC)
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE CASCADE)

### `auth_email_verification_tokens`

- `id` (int, PK, AI)
- `user_id` (int, FK -> auth_users.id, NOT NULL)
- `token` (varchar(255), Unique, NOT NULL): UUID token for email verification.
- `email` (varchar(255), NOT NULL): Email to verify.
- `expires_at` (bigint, NOT NULL): Token expiration (UNIX timestamp).
- `verified` (boolean, default FALSE)
- `created_at` (timestamp)
- _Indexes_: `idx_token`, `idx_user_id`, `idx_expires_at`
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE CASCADE)

### `auth_password_reset_tokens`

- `id` (int, PK, AI)
- `user_id` (int, FK -> auth_users.id, NOT NULL)
- `token` (varchar(255), Unique, NOT NULL): UUID token for password reset.
- `expires_at` (bigint, NOT NULL): Token expiration (UNIX timestamp).
- `used` (boolean, default FALSE)
- `created_at` (timestamp)
- _Indexes_: `idx_token`, `idx_user_id`, `idx_expires_at`
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE CASCADE)

### `auth_email_log`

- `id` (int, PK, AI)
- `to_email` (varchar(255), NOT NULL): Recipient address.
- `subject` (varchar(500), NOT NULL): Email subject.
- `html` (mediumtext, NOT NULL): HTML body.
- `text_body` (text): Plain text body.
- `status` (enum: 'sent', 'failed', 'dev', default 'sent')
- `error` (text): Error message when status=failed.
- `created_at` (timestamp)
- _Indexes_: `idx_to_email`, `idx_status`, `idx_created_at`

### `cities`

- `id` (int, PK, AI)
- `name` (varchar(100), Unique): City name.
- `latitude` (decimal(10,8))
- `longitude` (decimal(11,8))
- `created_at` (timestamp)

### `clinics`

- `id` (int, PK, AI)
- `slug` (varchar(280), Unique, NOT NULL): URL-safe slug generated from name_sr. Used for human-readable URLs.
- `google_place_id` (varchar(255), NULL, Unique): Google Places ID for deduplication.
- `city_id` (int, FK -> cities.id)
- `name_sr` (varchar(255)): Name in Serbian (Latin).
- `name_sr_cyrl` (varchar(255)): Name in Serbian (Cyrillic).
- `name_ru` (varchar(255)): Name in Russian.
- `address_sr` (text): Address in Serbian (Latin).
- `address_sr_cyrl` (varchar(255)): Address in Serbian (Cyrillic).
- `town_sr` (varchar(255)): Town/district in Serbian (Latin).
- `town_sr_cyrl` (varchar(255)): Town/district in Serbian (Cyrillic).
- `postal_code` (varchar(10))
- `latitude` (decimal(10,8))
- `longitude` (decimal(11,8))
- `phone` (varchar(255))
- `email` (varchar(255))
- `website` (varchar(255))
- `instagram`, `facebook`, `whatsapp`, `telegram`, `viber` (varchar(255))
- `description_sr`, `description_sr_cyrl`, `description_ru`, `description_en`, `description_de`, `description_tr` (text): Localized descriptions.
- `logo_url` (varchar(500)): URL to clinic logo image.
- `rank_score` (decimal(5,4), NOT NULL, default 0.0000): Computed ranking score for sort ordering.
- `created_by` (int, NULL, FK -> auth_users.id, ON DELETE SET NULL): **Provenance only — who created the record.** NULL for clinics created via admin panel or import. Access to the clinic cabinet is NOT derived from this column: it lives in `clinic_admins` _(migration 022)_. Never authorize against `created_by`.
- `status` (enum: 'draft', 'pending_verification', 'published', 'rejected', NOT NULL, default 'published'): Owner-driven lifecycle. Public flow is draft <-> published; non-published clinics are excluded from public listings and their page is visible only to the owner and admins. 'pending_verification'/'rejected' are reserved for future moderation.
- `hidden` (boolean, NOT NULL, default FALSE): When TRUE, the clinic is excluded from every public query (listings, service/labtest/medication cards, global search, sitemap) and its page returns **410 Gone** for everyone except the owner and admins, who still see it rendered as non-public with an explanation banner (drafts stay 404 — they are reversible, an admin hiding is not).
- `hidden_reason` (text, NULL): Why the clinic was hidden, written by an admin **in Serbian (Latin)**. Shown to the owner in the cabinet and in the page banner; never public. _(migration 021)_ Admin-only flag, orthogonal to `status` (the owner's status is preserved and cannot be used to bypass it). Mirrors `doctors.hidden`. The predicate lives in `server/common/clinic-visibility.ts` — never inline `status = 'published'`.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_clinics_slug` (slug, UNIQUE), `uq_clinics_google_place_id` (google_place_id, UNIQUE), `idx_city`, `idx_location` (latitude, longitude), `idx_name` (name_sr), `idx_clinics_rank_score` (rank_score DESC), `idx_clinics_status`, `idx_clinics_created_by`, `idx_clinics_hidden`

### `doctors`

- `id` (int, PK, AI)
- `slug` (varchar(280), Unique, NOT NULL): URL-safe slug generated from name_sr. Used for human-readable URLs.
- `user_id` (int, Unique, NULL, FK -> auth_users.id): Owner user account. NULL for doctors created via admin panel.
- `name_sr` (varchar(255)): Name in Serbian (Latin).
- `name_sr_cyrl` (varchar(255)): Name in Serbian (Cyrillic).
- `name_ru` (varchar(255)): Name in Russian.
- `name_en` (varchar(255)): Name in English.
- `photo_url` (varchar(255))
- `phone` (varchar(20))
- `email`, `website`, `instagram`, `facebook`, `whatsapp`, `telegram`, `viber` (varchar(255))
- `description_sr`, `description_sr_cyrl`, `description_ru`, `description_en`, `description_de`, `description_tr` (text): Localized descriptions.
- `professional_title` (varchar(255))
- `hidden` (boolean, default FALSE): Self-hiding. When TRUE, the doctor is excluded from all public listings and their profile page returns 404. The doctor toggles it from their own cabinet (`POST /api/doctors/toggle-visibility`), so it is reversible by them.
- `hidden_by_admin` (boolean, NOT NULL, default FALSE): Moderation hiding, admin-only. Same exclusion from every public query, but the page returns **410 Gone** (intentional, permanent removal) and the doctor cannot lift it from their cabinet. Kept separate from `hidden` precisely so a doctor cannot undo an admin decision.
- `is_draft` (boolean, default FALSE): When TRUE, the profile is pending review and not yet published. Only admins can change this.
- Public visibility is `hidden = 0 AND hidden_by_admin = 0 AND is_draft = 0` — build the predicate with `doctorIsPublicSql()` from `server/common/doctor-visibility.ts`, never inline it.
- `rank_score` (decimal(5,4), NOT NULL, default 0.0000): Computed ranking score for sort ordering.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_doctors_user_id` (user_id, UNIQUE), `idx_hidden`, `idx_doctors_hidden_by_admin`, `idx_doctors_is_draft`, `idx_doctors_rank_score` (rank_score DESC)
- _Foreign Keys_: `user_id` -> `auth_users.id` (ON DELETE SET NULL)

### `specialties`

- `id` (int, PK, AI)
- `name` (varchar(100), Unique): Specialty name (key for i18n lookup).
- `created_at` (timestamp)

### `languages`

- `id` (int, PK, AI)
- `code` (varchar(5), Unique): Language code (e.g., "en", "ru").
- `name` (varchar(100), Unique): Language name.
- `created_at` (timestamp)

### `lab_tests`

- `id` (int, PK, AI)
- `slug` (varchar(280), Unique, NOT NULL): URL-safe slug generated from name_en. Used for human-readable URLs.
- `name_en` (varchar(255), Unique): Test name in English (Key).
- `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `rank_score` (decimal(5,4), NOT NULL, default 0.0000): Computed ranking score for sort ordering.
- `created_at` (timestamp)
- _Indexes_: `idx_lab_tests_slug` (slug, UNIQUE), `idx_lab_tests_rank_score` (rank_score DESC)

### `lab_test_categories`

- `id` (int, PK, AI)
- `name` (varchar(255)): Category name.

### `lab_test_categories_relations`

- `id` (int, PK, AI)
- `lab_test_id` (int, FK -> lab_tests.id, CASCADE): Lab Test ID.
- `category_id` (int): Category ID.
- _Unique constraint_: (`lab_test_id`, `category_id`)
- _Comment_: FK added by migration 032 — see `medical_service_categories_relations`.

### `lab_test_synonyms`

- `id` (int, PK, AI)
- `lab_test_id` (int, FK -> lab_tests.id, CASCADE): Lab Test ID. _(FK added by migration 032)_
- `another_name` (varchar(255), Indexed): Alternative name.
- `language` (varchar(10)): Language code.
- _Unique constraint_: (`another_name`, `language`) — globally unique, unlike `medical_service_synonyms` which scopes uniqueness per record.
- _Comment_: Merging lab tests writes the losing record's names here (all six languages), so a clinic's own phrasing keeps resolving after the merge. A merge also moves the losing record's existing synonyms across, and one of those can end up equal to the surviving record's own name — the cleanup query for that lives in `duplicate-synonyms-fix.txt` and ran as migration 031.
- _Collation_: `utf8mb4_unicode_ci`, like the rest of the schema. It was `utf8mb4_0900_ai_ci` until migration 044 (2026-10-02), so older migrations compare `another_name` with an explicit `COLLATE utf8mb4_unicode_ci` — now a no-op, harmless. See `docs/rules/SQL_COLLATIONS.md`.

### `lab_test_reference_info`

- `id` (int, PK, AI)
- `lab_test_id` (int, NOT NULL, FK -> lab_tests.id, CASCADE)
- `what_*`, `how_*`, `indications_*`, `prep_*`, `abnormal_*` (text): Five content fields, each with `_en`, `_sr`, `_sr_cyrl`, `_ru`, `_de`, `_tr` variants.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`lab_test_id`) — one card per lab test.
- _Comment_: Editorial content written for the catalogue, not imported from any clinic. Five fields, each in six languages, and the set is fixed by an approved format: `what` (what it is), `how` (how it is done), `indications` (when it is ordered), `prep` (how to prepare), `abnormal` (what a deviation can mean). The generic medical disclaimer is NOT stored here — it lives in the page footer, so a card only carries its own specifics.
- _Merge behaviour_: `UNIQUE` on the entity id means a merge can only carry the card over if the surviving record has none; the merge endpoints therefore use `UPDATE IGNORE`, and a losing record's card is dropped with it.

### `lab_test_duplicate_candidates`

- `id` (int, PK, AI)
- `lab_test_id_a` (int, FK -> lab_tests.id, CASCADE): Always the smaller id.
- `lab_test_id_b` (int, FK -> lab_tests.id, CASCADE): Always the larger id.
- `tier` (enum('A','B','C')): A — ≥2 language columns agree, or a synonym match plus one language; B — 1 language, or a synonym match alone; C — fuzzy English only.
- `score` (decimal(6,2)): Ranking score, higher = more confident.
- `signals` (varchar(500)): Comma-separated evidence codes, e.g. `lang:name_sr,synonym-match,same-clinic:2`.
- `status` (enum('pending','merged','dismissed'), default 'pending')
- `detected_at` (timestamp), `decided_at` (datetime, NULL)
- _Unique constraint_: (`lab_test_id_a`, `lab_test_id_b`)
- _Comment_: Filled by `scripts/labtests/find-duplicate-labtests.mjs`, reviewed in the admin "Дубликаты" tab. Same contract as `medical_service_duplicate_candidates`: a dismissed pair must never resurface on the next detector run, and rows disappear on their own when one side is merged away.

### `lab_test_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Lab Test ID.
- `new_id` (int): New Lab Test ID (target).

### `medical_service_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Medical Service ID.
- `new_id` (int): New Medical Service ID (target).

### `slug_redirects`

- `id` (int, PK, AI)
- `entity_type` (varchar(50), NOT NULL): Entity type the OLD url belonged to: clinics, doctors, services, labtests, medications.
- `old_slug` (varchar(280), NOT NULL): Previous slug value.
- `entity_id` (int, NOT NULL): ID of the entity the old slug should redirect to.
- `target_entity_type` (varchar(50), NULL): Catalog the target lives in. `NULL` means the same as `entity_type` — the ordinary case, a renamed slug. Set only when a record moved between catalogs, e.g. lab tests that price imports had filed under `medical_services` (migration 029): the row then reads `services` → `labtests`, and `/services/<old_slug>` 301s to `/labtests/<new_slug>`.
- `created_at` (timestamp)
- _Unique constraint_: (`entity_type`, `old_slug`)
- _Comment_: Read by `checkSlugRedirect` (`server/common/redirect/slug-redirects.ts`), which caches the whole table in memory for a minute. A cross-catalog row redirects even when the slug is unchanged — slugs are unique per table, so the same slug legitimately exists in both catalogs.

### `medical_services`

- `id` (int, PK, AI)
- `slug` (varchar(280), Unique, NOT NULL): URL-safe slug generated from name_en. Used for human-readable URLs.
- `name_en` (varchar(255), Unique): Service name in English (Key).
- `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `sort_order` (int): Display order.
- `rank_score` (decimal(5,4), NOT NULL, default 0.0000): Computed ranking score for sort ordering.
- `created_at` (timestamp)
- _Indexes_: `idx_medical_services_slug` (slug, UNIQUE), `idx_medical_services_rank_score` (rank_score DESC), `idx_ms_sort_order` (sort_order, rank_score DESC)

### `medical_service_synonyms`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id, CASCADE)
- `another_name` (varchar(255), NOT NULL): Alternative name.
- `language` (varchar(10), NOT NULL): Locale code — `en`, `sr`, `sr-cyrl`, `ru`, `de`, `tr`.
- `created_at` (timestamp)
- _Unique constraint_: (`medical_service_id`, `another_name`, `language`)
- _Comment_: Mirrors `lab_test_synonyms`, but scoped per service rather than globally unique on name — the same wording may legitimately point at more than one service. Merging services writes the losing record's names here, so a clinic's own phrasing keeps resolving after the merge.
- _Coverage_: until migrations 036/037 only 83 of 4991 services had any row here, nearly all as merge fallout rather than editorial work — the import prompt documented synonyms for lab tests only, so no import ever wrote one for a service. 036/037 add 3854 rows for 927 services (every service in ≥3 clinics was reviewed). Batches, pipeline and rules: `data/service-names/README.md`; audit: `docs/audit/service-names-2026-09.md`; the convention for new imports: `docs/import/CLINIC_SERVICES_IMPORT.md` §1.6.
- _Language codes_: `sr-cyrl` with a hyphen, as in `lab_test_synonyms`. The `sr_cyrl` spelling in the table comment in `server/sql/create-medical-service-synonyms.sql` is wrong — no row uses it.
- _Collation_: `utf8mb4_unicode_ci`, same as `medical_services` and (since migration 044) `lab_test_synonyms`, so comparing `another_name` against a `name_*` column or the other synonym table needs no explicit `COLLATE`.

### `medical_service_duplicate_candidates`

- `id` (int, PK, AI)
- `service_id_a` (int, FK -> medical_services.id, CASCADE): Always the smaller id.
- `service_id_b` (int, FK -> medical_services.id, CASCADE): Always the larger id.
- `tier` (enum('A','B','C')): A — ≥2 language columns agree; B — 1 agrees; C — fuzzy English only.
- `score` (decimal(6,2)): Ranking score, higher = more confident.
- `signals` (varchar(500)): Comma-separated evidence codes, e.g. `lang:name_sr,lang:name_ru,same-clinic:3`.
- `status` (enum('pending','merged','dismissed'), default 'pending')
- `detected_at` (timestamp), `decided_at` (datetime, NULL)
- _Unique constraint_: (`service_id_a`, `service_id_b`)
- _Comment_: Filled by `scripts/services/find-duplicate-services.mjs`, reviewed in the admin "Дубликаты" tab. `status` is why the queue is persisted — a dismissed pair must never resurface on the next detector run. Rows disappear on their own when one side is merged away (FK CASCADE).

### `medical_service_categories`

- `id` (int, PK, AI)
- `name` (varchar(255)): Category name.
- `created_at` (datetime)

### `medical_service_categories_relations`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id, CASCADE): Medical Service ID.
- `medical_service_category_id` (int): Medical Service Category ID.
- _Unique constraint_: (`medical_service_id`, `medical_service_category_id`)
- _Comment_: The FK dates from migration 032. Until then this table had none and `server/api/services/remove.ts` did not clean it, so every deleted service left rows pointing at nothing — invisible on the site but skewing counts (services per category). The same migration added FKs to `medical_services_specialties`, `clinic_medical_service_doctors`, `lab_test_categories_relations` and `lab_test_synonyms` for the same reason.

### `medical_services_specialties`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id, CASCADE): Medical Service ID.
- `specialty_id` (int): Specialty ID.
- _Comment_: FK added by migration 032 — see `medical_service_categories_relations`.

### `medical_service_tariffs`

Reference tariffs from the state insurer (FZOCG) pricelists. **Not** clinic prices: a row is what FZOCG pays or charges for a position, shown on detail pages as context next to the clinics' own prices.

- `id` (int, PK, AI)
- `tariff_source` (enum, NOT NULL): Which pricelist the row came from — `fzocg-pzz` (primary care), `fzocg-sekundarna` (secondary/tertiary), `fzocg-drg`, `fzocg-transfuziologija`, `fzocg-apotekarska`, `fzocg-medicinsko-pomagala`, `fzocg-van-mreze`.
- `code` (varchar(50), NOT NULL, Indexed): Service code as printed in the source PDF (e.g. `J09001`, `A05Z`, `AA1101`).
- `medical_service_id` (int, NULL, FK -> medical_services.id, SET NULL): Link into the services catalog.
- `lab_test_id` (int, NULL, FK -> lab_tests.id, SET NULL): Link into the lab test catalog. Laboratory sections of the pricelist (`K01`/`K02` microbiology, `L01` histopathology, `Z01` biochemistry and haematology) belong to lab tests, not services. _(migration 028)_
- `scheme` (enum('single','dual','operacija','coefficient'), NOT NULL): Which of the price columns below are populated.
- `price_eur` (decimal(10,2)): `scheme=single` — the only price. `scheme=coefficient` — the computed final price.
- `price_odjeljenje_eur`, `price_ambulanta_eur` (decimal(10,2)): `scheme=dual` — inpatient (department) and outpatient price.
- `price_operacija_eur`, `price_anestezija_eur`, `price_ukupno_eur` (decimal(10,2)): `scheme=operacija` — operation portion, anesthesia portion, and their total.
- `coefficient` (decimal(8,4)), `base_coefficient_eur` (decimal(10,2)): `scheme=coefficient` — DRG coefficient and base rate; their product is `price_eur`.
- `name_sr_latin` (varchar(500)): Position name exactly as printed in the source PDF (Serbian Latin).
- `section`, `subsection` (varchar): Section headings of the source document — the only thing that disambiguates codes reused across pricelists.
- `amended_from`, `effective_from` (date): Effective date of the latest amendment and of the base document.
- `source_signed_number` (varchar(50)), `source_pdf` (varchar(500)), `notes` (text): Provenance.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`tariff_source`, `code`) — `code` alone is NOT unique, and this is not an edge case: 246 codes occur in more than one pricelist, usually meaning something entirely different. `L01008` is `Patronažna posjeta kod babinjara` in `fzocg-pzz` but `Pregled endoskopske resekcije polipa kolona` in `fzocg-sekundarna`. Every lookup must scope by `tariff_source`.
- _Indexes_: `idx_medical_service_id`, `idx_lab_test_id`, `idx_code`
- _Comment_: 5822 rows; 2809 linked to services, 23 to lab tests, 2990 linked to neither — a code without a catalog counterpart is normal and stays searchable. **At most one of the two catalog links is set.** That is a convention, not a DB constraint: MySQL 8 refuses a `CHECK` on a column used by a FK with `ON DELETE SET NULL` (ERROR 3823), and both columns are such. It holds because migration 029 assigns one link and nulls the other in a single `UPDATE`, and because `server/common/tariffs.ts` queries strictly one column per request. Read by `server/api/services/details.ts` and `server/api/labtests/details.ts`, rendered by `components/medical-service/fzocg-tariff-section.vue` on both detail pages, and searchable by code in `/services`.
- _Name shift (fixed by 038)_: `name_sr_latin` came from `FINAL.json`, where the OCR+LLM merge had shifted names onto neighbouring codes — sometimes together with the price, when that too came from the LLM. The catalog links were right (they follow clinic codes); the displayed tariff name, and for 22 rows the price, belonged to the next line of the pricelist. 038 corrects 140 secondary-care rows and the same rows in `FINAL.json`. Method and evidence: `docs/audit/service-names-2026-09.md` § 038, `data/fzocg/README.md`. Independent checks worth reusing: clinics 88/137 charge exactly 2.5 × `price_odjeljenje_eur` (1.17 × `price_ambulanta_eur`), and the Danilo hospital pricelist in `data/clinic-services-import/bolnica-danilo-cetinje/_full.json` has 2790 codes with names at 3 × `price_ambulanta_eur`.
- _PZZ vs secondary codes collide_: the same code means different things in the two pricelists (X01025 is IUD insertion in PZZ, lymph-node biopsy in secondary care). Linking by bare code attached PZZ rows to hospital services; 038 re-points 16 and unlinks 1. Do not re-run `update-medical-service-tariffs-linkage.sql` unrestricted: PZZ rows belong to services held by primary-care clinics (codes `HN_`, `MO_`, `_KO`, or DZ 80/85 bare), secondary rows to hospitals 88/131/137.

### `medical_service_reference_info`

- `id` (int, PK, AI)
- `medical_service_id` (int, NOT NULL, FK -> medical_services.id, CASCADE)
- `what_*`, `how_*`, `indications_*`, `prep_*`, `abnormal_*` (text): Same five fields x six languages as `lab_test_reference_info`.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`medical_service_id`) — one card per service.
- _Comment_: Editorial content written for the catalogue, not imported from any clinic. Five fields, each in six languages, and the set is fixed by an approved format: `what` (what it is), `how` (how it is done), `indications` (when it is ordered), `prep` (how to prepare), `abnormal` (what a deviation can mean). The generic medical disclaimer is NOT stored here — it lives in the page footer, so a card only carries its own specifics.
- _Merge behaviour_: `UNIQUE` on the entity id means a merge can only carry the card over if the surviving record has none; the merge endpoints therefore use `UPDATE IGNORE`, and a losing record's card is dropped with it.

### `medications`

- `id` (int, PK, AI)
- `slug` (varchar(280), Unique, NOT NULL): URL-safe slug generated from name_en. Used for human-readable URLs.
- `name_en` (varchar(255), Unique): Medication name in English (Key).
- `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `created_at` (timestamp)

### `clinic_lab_tests`

- `id` (int, PK, AI)
- `lab_test_id` (int, FK -> lab_tests.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific test code.
- `price` (decimal(10,2))
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `is_price_outdated` (tinyint(1), NOT NULL, default 0): Price is old; shown as "+X%".
- `is_obsolete` (tinyint(1), NOT NULL, default 0): The clinic no longer lists this item (migration 045). Same meaning and handling as in `clinic_medical_services`.
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `lab_test_id`)

### `clinic_medical_services`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific service code.
- `price` (decimal(10,2))
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `price_min` (decimal(10,2)): Minimum price (for price ranges).
- `is_price_outdated` (tinyint(1), NOT NULL, default 0): Price is old; shown as "+X%".
- `is_obsolete` (tinyint(1), NOT NULL, default 0): The clinic no longer lists this item in its pricelist (migration 045). The row is kept, not deleted, so code, price and history survive. Search, listings, filters, clinic/doctor pages, counts, ranking, sitemap and JSON-LD skip it. The service/lab test detail page (direct link) still shows the clinic, last in the list, with the note "the clinic may no longer offer this service". The predicate is built only by `priceRowIsActiveSql()` (`server/common/price-row-visibility.ts`); `tests/unit/price-row-visibility.spec.ts` makes every file that reads these tables declare whether it is public.
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medical_service_id`)

### `clinic_medical_service_doctors`

- `id` (int, PK, AI)
- `clinic_id` (int, FK -> clinics.id, CASCADE): Clinic ID.
- `medical_service_id` (int, FK -> medical_services.id, CASCADE): Medical Service ID.
- `doctor_id` (int, FK -> doctors.id, CASCADE): Doctor ID.
- `price` (decimal(10,2)): Price of the service for this doctor.
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `created_at` (datetime)
- _Unique constraint_: (`doctor_id`, `clinic_id`, `medical_service_id`)
- _Comment_: Links doctors to specific medical services within a clinic, with individual pricing. Feeds the "Doctors" block inside the clinic card on a service page (see `prd/service-page-doctor-links`). All three FKs date from migration 032: none of `services/remove.ts`, `doctors/remove.ts` or `clinics/remove.ts` cleaned this table, so deletions on any of the three sides left orphans behind. Those endpoints now delete explicitly as well.

### `clinic_medications`

- `id` (int, PK, AI)
- `medication_id` (int, FK -> medications.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific medication code.
- `price` (decimal(10,2))
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medication_id`)

### `clinic_types`

- `id` (tinyint unsigned, PK): Not auto-increment — values set manually.
- `name` (varchar(100), NOT NULL): English canonical name (e.g. "hospital", "laboratory", "pharmacy").

### `clinic_clinic_types`

- `clinic_id` (int, PK, FK -> clinics.id ON DELETE CASCADE)
- `clinic_type_id` (tinyint unsigned, PK, FK -> clinic_types.id ON DELETE CASCADE)
- _Comment_: Junction table linking clinics to their types. A clinic can have multiple types.

### `clinic_admins`

Users who manage a clinic (migration 022). Replaces the single-owner
`clinics.created_by` check: a real clinic has several managing accounts (owner,
reception admin, marketer), and handing over access used to mean overwriting
ownership.

- `id` (int, PK, AI)
- `clinic_id` (int, FK -> clinics.id ON DELETE CASCADE)
- `user_id` (int, FK -> auth_users.id ON DELETE CASCADE)
- `created_at` (timestamp): When access was granted.
- _Unique constraint_: (`clinic_id`, `user_id`) — required: without it a repeated
  import or a double click in the admin panel silently duplicates rows (as happened
  with `clinic_languages`).
- _Indexes_: `idx_clinic_admins_user` (user_id)

**The only source of truth for clinic cabinet rights.** Checked via
`isClinicAdmin` / `getOwnedClinic` in `server/common/clinic-admins.ts` and
`server/common/clinic-cabinet.ts`; site admins (`auth_users.is_admin`) bypass it.
The list is edited in the admin panel only (`/api/clinics/admins/*`) — clinic
managers cannot grant access to each other.

### `clinic_working_hours`

- `id` (int, PK, AI)
- `clinic_id` (int, Unique, FK -> clinics.id ON DELETE CASCADE): One record per clinic.
- `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday`, `sunday` (json, NOT NULL): Working hours per day.
- `created_at`, `updated_at` (timestamp)

### `clinic_coupons`

Discount coupons offered at a clinic (migration 020). Unlike `is_price_outdated`,
which flags a single price row, a coupon is a clinic-level offer covering a whole
item type — hence a separate table.

- `id` (int, PK, AI)
- `clinic_id` (int, FK -> clinics.id ON DELETE CASCADE)
- `discount_percent` (tinyint unsigned, NOT NULL): 1..100.
- `applies_to` (set('services','labtests','medications'), NOT NULL): Item types the discount covers. Drives where the coupon may be shown — a services-only coupon must not appear on lab test pages.
- `source_name` (varchar(100), NULL): Partner whose promo we relay (e.g. 'Montenegro Experte'); NULL — docta.me's own coupon.
- `image_url` (varchar(500), NULL): Coupon visual to show at the reception; NULL — the site renders its own localized coupon.
- `code` (varchar(50), NULL): Code word, if the clinic asks for one; NULL — showing the coupon is enough.
- `payment_method` (enum: 'any', 'cash', 'card', NOT NULL, default 'any'): Payment method the discount requires. Surfaced in the coupon's terms — finding out at the till that only cash counts is the worst case. Unknown values are read as 'any': inventing a restriction is worse than omitting one.
- `valid_from`, `valid_until` (date, NULL): NULL means "already active" / "open-ended, cancel manually".
- `is_active` (boolean, NOT NULL, default TRUE)
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_clinic_coupons_clinic` (clinic_id, is_active)

Read only via `server/common/clinic-coupons.ts` — it applies the three activity
conditions (flag + both dates) and returns the best coupon per clinic. Exposed on
`ClinicData.coupon` by `clinics/list`, `clinics/details` and
`clinics/items-summary`.

Managed from the admin clinic panel (`AdminClinicCouponsEditor`) via
`clinics/coupons/{list,save,delete}` — all admin-only. The coupon image is
uploaded like every other image (`/api/upload/admin-image`, category `coupons`);
an external URL passed to `save` is downloaded into `/uploads/coupons/` instead of
being hotlinked. Withdrawing an offer means `is_active = 0`, not deletion — the
history matters, patients may already have come with that coupon.

### `clinic_languages`

- `id` (int, PK, AI)
- `clinic_id` (int): Clinic ID.
- `language_id` (int): Language ID.
- `create_time` (datetime)

### `insurance_companies`

- `id` (int, PK, AI)
- `slug` (varchar(100), Unique, NOT NULL)
- `name_sr` (varchar(255), NOT NULL), `name_sr_cyrl`, `name_ru` (varchar(255)): Name. Columns mirror the `clinics` convention — no `name_en`/`name_de`/`name_tr`, an insurer's legal name is not translated.
- `website`, `phone`, `email` (varchar(255)): Contacts. `phone` holds digits-only `+382...` values, several separated by `;`.
- `facebook`, `instagram`, `telegram`, `whatsapp`, `viber` (varchar(255)) _(migration 011)_
- `logo_url` (varchar(500))
- `created_at`, `updated_at` (timestamp)
- _Comment_: Private insurers operating in Montenegro (Sava, Lovcen, Uniqa, Generali, Grawe), collected from the insurers' own sites. Used by `server/api/insurance-companies/*` and `pages/insurance-companies/*`. Unrelated to FZOCG, the state insurer, whose pricelists live in `medical_service_tariffs`.

### `insurance_company_branches`

- `id` (int, PK, AI)
- `insurance_company_id` (int, NOT NULL, FK -> insurance_companies.id, CASCADE)
- `city_id` (int, NOT NULL, FK -> cities.id)
- `address_sr`, `address_sr_cyrl` (text), `town_sr`, `town_sr_cyrl` (varchar(255)), `postal_code` (varchar(20))
- `latitude` (decimal(10,8)), `longitude` (decimal(11,8))
- `phone`, `email` (varchar(255)): Branch contacts; override the company's when set.
- `working_hours` (varchar(255)) _(migration 012)_
- `created_at` (timestamp)
- _Comment_: 1:N, unlike `clinics` where one row is one address — an insurer usually has several offices.

### `doctor_clinics`

- `id` (int, PK, AI)
- `doctor_id` (int, FK -> doctors.id)
- `clinic_id` (int, FK -> clinics.id)
- `position` (varchar(255)): Job title/position in the clinic.
- `created_at` (timestamp)
- _Unique constraint_: (`doctor_id`, `clinic_id`)

### `doctor_specialties`

- `id` (int, PK, AI)
- `doctor_id` (int, FK -> doctors.id)
- `specialty_id` (int, FK -> specialties.id)
- `created_at` (timestamp)
- _Unique constraint_: (`doctor_id`, `specialty_id`)

### `doctor_languages`

- `id` (int, PK, AI)
- `doctor_id` (int, FK -> doctors.id)
- `language_id` (int, FK -> languages.id)
- `created_at` (timestamp)
- _Unique constraint_: (`doctor_id`, `language_id`)

### `doctor_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Doctor ID.
- `new_id` (int): New Doctor ID (target).

### `billing_paid_services`

- `id` (int, PK, AI)
- `name` (varchar(50), Unique, NOT NULL): Service name (e.g., "dofollow", "highlight", "approved").

### `billing_service_prices`

- `id` (int, PK, AI)
- `service_id` (int, NOT NULL): Paid service this price belongs to.
- `months` (int, NOT NULL): Period the price covers — 1, 3, 6 or 12.
- `price_cents` (int, NOT NULL), `currency` (varchar(3), NOT NULL, default 'EUR')
- `active` (tinyint(1), NOT NULL, default 1): Whether the price is on sale.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`service_id`, `months`, `active`) — `active` is deliberately part of the key, so a withdrawn price can stay in the table next to the one that replaced it instead of being deleted.
- _Indexes_: `idx_service_active` (service_id, active)
- _Comment_: Current state after migration 008 — HIGHLIGHT at 10 EUR/month (27/48/84 for 3/6/12), APPROVED at 1 EUR/month and 10 EUR/year with the 3- and 6-month rows deactivated, and every DOFOLLOW row deactivated. See `billing_paid_services` for why DOFOLLOW was withdrawn.

### `billing_clinic_service_purchases`

- `id` (int, PK, AI)
- `clinic_id` (int, FK -> clinics.id): Clinic that purchased services.
- `price` (decimal(10,2)): Total price paid.
- `purchased_at` (datetime): Purchase date.
- `valid_until` (datetime): Expiration date of services.
- `deleted` (boolean, default FALSE): Soft delete flag.
- `created_at` (timestamp)

### `billing_clinic_service_purchase_items`

- `id` (int, PK, AI)
- `purchase_id` (int, FK -> billing_clinic_service_purchases.id)
- `service_id` (int, FK -> billing_paid_services.id)
- _Unique constraint_: (`purchase_id`, `service_id`)
- _Relationship_: Links specific paid services to a purchase.

### `billing_orders`

- `id` (varchar(36), PK): Order UUID.
- `clinic_id` (int, NOT NULL, FK -> clinics.id)
- `created_by` (int, FK -> auth_users.id, SET NULL): Who placed the order.
- `status` (enum('pending_payment','processing','completed','failed','cancelled'), NOT NULL, default 'pending_payment')
- `total_amount_cents` (int, NOT NULL), `currency` (varchar(3), NOT NULL, default 'EUR')
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_clinic_status` (clinic_id, status), `idx_created` (created_at)
- _Comment_: The Stripe checkout flow. Empty in production: keys were never wired up, and the alert on a placed order falls back to a `mailto:`. Distinct from `billing_clinic_service_purchases`, which records placements granted manually through the admin panel and is the path actually in use.

### `billing_order_items`

- `id` (int, PK, AI)
- `order_id` (varchar(36), NOT NULL, FK -> billing_orders.id, CASCADE)
- `service_id` (int, NOT NULL, FK -> billing_paid_services.id): A paid placement (HIGHLIGHT, APPROVED), NOT a medical service.
- `months` (int, NOT NULL): Period — 1, 3, 6 or 12.
- `price_cents` (int, NOT NULL): Price frozen at order time, so later price changes do not rewrite history.
- `created_at` (timestamp)

### `billing_payment_transactions`

- `id` (int, PK, AI)
- `order_id` (varchar(36), NOT NULL, FK -> billing_orders.id)
- `transaction_id` (varchar(255), Unique, NOT NULL): Stripe Checkout Session id (`cs_...`).
- `payment_provider` (varchar(50), NOT NULL): `stripe`.
- `amount_cents` (int, NOT NULL), `currency` (varchar(3), NOT NULL, default 'EUR')
- `status` (enum('pending','success','failed','refunded'), NOT NULL, default 'pending')
- `payment_url` (text), `session_id` (varchar(255)), `metadata` (json), `error_message` (text)
- `created_at`, `updated_at` (timestamp)
- _Comment_: One row per payment attempt, so a retried order keeps its history.

### `reviews`

- `id` (int, PK, AI)
- `user_id` (int, NULL, FK -> auth_users.id): Review author. Links to real or phantom user. ON DELETE SET NULL.
- `clinic_id` (int, NULL, FK -> clinics.id): Review target: clinic.
- `doctor_id` (int, NULL, FK -> doctors.id): Review target: doctor.
- `medical_service_id` (int, NULL, FK -> medical_services.id): Review target: service.
- `insurance_company_id` (int, NULL, FK -> insurance_companies.id): Review target: insurance company. _(migration 035)_
- `provider` (enum: 'google_maps', 'facebook', 'telegram', 'docta_me', NOT NULL): Source of the review.
- `provider_review_id` (varchar(255), NULL): External ID for deduplication.
- `rating` (tinyint unsigned, NULL): Rating 1-5.
- `original_language` (varchar(10), NOT NULL, default 'sr'): Language code of the original review text (may be outside project languages, e.g., 'bs', 'me').
- `original_text` (text, NULL): Original review text as written by the author (may be in any language).
- `text_sr`, `text_sr_cyrl`, `text_en`, `text_ru`, `text_de`, `text_tr` (text, NULL): Localized/translated review texts.
- `published_at` (datetime, NULL): When review was published on the platform.
- `likes_count` (int unsigned, NOT NULL, default 0): Denormalized like counter for sorting.
- `status` (enum: 'pending', 'approved', 'rejected', NOT NULL, default 'approved'): POST-moderation status. New user reviews are inserted as 'pending' (publicly visible); 'rejected' reviews are hidden from public lists, ratings, and ranking, but the author still sees their own review with the rejection reason. Imported/external reviews stay 'approved' via the column default.- `is_verified` (boolean, NOT NULL, default FALSE): Visit confirmed by a moderator-approved verification file.- `moderated_by` (int, NULL, FK -> auth_users.id, SET NULL): Admin who moderated.- `moderated_at` (datetime, NULL): When moderated.- `rejection_reason` (text, NULL): Shown to the author when status='rejected'.- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`provider`, `provider_review_id`)
- _Indexes_: `idx_reviews_user_id`, `idx_reviews_clinic_rating` (clinic_id, rating), `idx_reviews_doctor_rating` (doctor_id, rating), `idx_reviews_clinic_user` (clinic_id, user_id), `idx_reviews_doctor_user` (doctor_id, user_id), `idx_reviews_insurance_rating` (insurance_company_id, rating), `idx_reviews_insurance_user` (insurance_company_id, user_id), `idx_medical_service_id`, `idx_provider`, `idx_rating`, `idx_reviews_likes_count` (likes_count DESC)
- _Foreign Keys_: `user_id` -> `auth_users.id` (SET NULL), `clinic_id` -> `clinics.id` (CASCADE), `doctor_id` -> `doctors.id` (CASCADE), `medical_service_id` -> `medical_services.id` (CASCADE), `insurance_company_id` -> `insurance_companies.id` (CASCADE)
- _Comment_: Polymorphic reviews — exactly one of clinic_id/doctor_id/medical_service_id/insurance_company_id must be NOT NULL (clinic_id + doctor_id may be set together when a review names both). Author info (name, photo, profile link) is stored in `auth_users` — use JOIN by `user_id`.

### `review_replies`

- `id` (int, PK, AI)
- `review_id` (int, FK -> reviews.id, NOT NULL): Parent review.
- `responder_type` (enum: 'clinic', 'doctor', 'insurance_company', NOT NULL): Who is replying.
- `clinic_id` (int, NULL, FK -> clinics.id): Clinic that replied (when responder_type='clinic').
- `doctor_id` (int, NULL, FK -> doctors.id): Doctor that replied (when responder_type='doctor').
- `insurance_company_id` (int, NULL, FK -> insurance_companies.id): Insurer that replied (when responder_type='insurance_company'). _(migration 035)_
- `user_id` (int, NULL, FK -> auth_users.id): User who posted the reply (clinic manager or doctor). ON DELETE SET NULL.
- `original_text` (text, NOT NULL): Reply text as written.
- `original_language` (varchar(10), NOT NULL, default 'sr'): Language code of the original reply.
- `text_sr`, `text_sr_cyrl`, `text_en`, `text_ru`, `text_de`, `text_tr` (text, NULL): Localized/translated reply texts.
- `provider` (enum: 'google_maps', 'facebook', 'telegram', 'docta_me', NOT NULL, default 'docta_me'): Source of the reply (imported or native).
- `likes_count` (int unsigned, NOT NULL, default 0): Denormalized like counter.
- `published_at` (datetime, NULL): When reply was published.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`review_id`, `responder_type`) — at most one reply per responder type per review.
- _Indexes_: `idx_review_replies_review_id`, `idx_review_replies_clinic_id`, `idx_review_replies_doctor_id`
- _Foreign Keys_: `review_id` -> `reviews.id` (CASCADE), `clinic_id` -> `clinics.id` (CASCADE), `doctor_id` -> `doctors.id` (CASCADE), `insurance_company_id` -> `insurance_companies.id` (CASCADE), `user_id` -> `auth_users.id` (SET NULL)
- _Comment_: At most one reply per responder type. No threading. Exactly one of clinic_id/doctor_id/insurance_company_id must be NOT NULL (matches responder_type).

### `review_likes`

- `id` (int, PK, AI)
- `review_id` (int, FK -> reviews.id, NOT NULL): Liked review.
- `user_id` (int, FK -> auth_users.id, NOT NULL): User who liked.
- `created_at` (timestamp)
- _Unique constraint_: (`review_id`, `user_id`) — one like per user per review.
- _Indexes_: `idx_review_likes_user_id`
- _Foreign Keys_: `review_id` -> `reviews.id` (CASCADE), `user_id` -> `auth_users.id` (CASCADE)
- _Comment_: Only authenticated (non-phantom) users can like. `reviews.likes_count` is updated via application logic on insert/delete.

### `review_reply_likes`

- `id` (int, PK, AI)
- `reply_id` (int, FK -> review_replies.id, NOT NULL): Liked reply.
- `user_id` (int, FK -> auth_users.id, NOT NULL): User who liked.
- `created_at` (timestamp)
- _Unique constraint_: (`reply_id`, `user_id`) — one like per user per reply.
- _Indexes_: `idx_review_reply_likes_user_id`
- _Foreign Keys_: `reply_id` -> `review_replies.id` (CASCADE), `user_id` -> `auth_users.id` (CASCADE)
- _Comment_: Only authenticated (non-phantom) users can like. `review_replies.likes_count` is updated via application logic on insert/delete.

### `review_verification_files`

- `id` (int, PK, AI)
- `review_id` (int, FK -> reviews.id, NOT NULL): Review being verified. One file per review.
- `stored_name` (varchar(255), NOT NULL): On-disk file name (UUID.webp) inside `VERIFICATIONS_DIR` (default `storage/verifications`, **outside** `public/`).
- `file_name` (varchar(255), NULL): Original client file name.
- `file_type` (varchar(100), NOT NULL): MIME type after processing (image/webp).
- `file_size` (int unsigned, NOT NULL): Size in bytes after processing.
- `status` (enum: 'pending', 'approved', 'rejected', NOT NULL, default 'pending')
- `rejection_reason` (text, NULL)
- `uploaded_at` (datetime, default CURRENT_TIMESTAMP), `reviewed_at` (datetime, NULL), `reviewed_by` (int, NULL, FK -> auth_users.id, SET NULL)
- _Unique constraint_: (`review_id`)
- _Foreign Keys_: `review_id` -> `reviews.id` (CASCADE), `reviewed_by` -> `auth_users.id` (SET NULL)
- _Comment_: Personal data (receipts, referrals). Files are served only to the review author and admins via `/api/reviews/verification-file?reviewId=`. Approving sets `reviews.is_verified = TRUE`.

### `review_moderation_logs`

- `id` (int, PK, AI)
- `review_id` (int, FK -> reviews.id, NOT NULL)
- `action` (enum: 'approved', 'rejected', 'verification_uploaded', 'verification_approved', 'verification_rejected', NOT NULL)
- `moderator_id` (int, NULL, FK -> auth_users.id, SET NULL): NULL = action by the review author (e.g. verification upload).
- `comment` (text, NULL): Rejection reason etc.
- `created_at` (datetime, default CURRENT_TIMESTAMP)
- _Indexes_: `idx_moderation_logs_review` (review_id)

### `review_ai_summaries`

- `id` (int, PK, AI)
- `entity_type` (enum: 'doctor', 'clinic', 'insurance_company', NOT NULL)
- `entity_id` (int, NOT NULL)
- `language` (varchar(10), NOT NULL): One of the 6 site locales.
- `sentiment` (enum: 'positive', 'neutral', 'negative', NOT NULL): Shared across locales of one entity.
- `positives`, `negatives` (JSON, NOT NULL): Arrays of short strings.
- `recommendations` (text, NULL): 2-3 sentences for potential patients.
- `reviews_count` (int, NOT NULL): Number of reviews the summary was generated from (staleness check: regenerate when current count differs by >= 5).
- `generated_at` (datetime, default CURRENT_TIMESTAMP), `regenerated_at` (datetime, NULL)
- _Unique constraint_: (`entity_type`, `entity_id`, `language`)
- _Comment_: Cache for AI review summaries, one row per entity per locale. `GET /api/reviews/ai-summary` **only reads this cache** — it never generates anything and needs no API key (verified 2026-07-26). Summaries are produced manually in a Claude Code session and loaded as SQL; the workflow is `docs/import/AI_SUMMARY_WORKFLOW.md`. Earlier plans for background generation via `ANTHROPIC_API_KEY` were dropped 2026-06-12 (see `prd/reviews/PROGRESS.md`) — treat any mention of that key for this feature as stale.

## Core Implementation Logic

1. **Authentication Strategy**:
   - **Admin users**: Use email + password authentication. `password_hash` is filled with bcrypt hash (cost=10), `is_admin=TRUE`.
   - **Regular users**: Use OAuth (Google, Telegram). `password_hash=NULL`, `is_admin=FALSE`.
   - **Session management**: Database-based sessions stored in `auth_sessions` table with expiration tracking.
   - **Security**: HTTPOnly cookies store `session_id`, actual session data (user_id, expires_at) is in DB.
   - **Email verification**: Tokens stored in `auth_email_verification_tokens`, email log in `auth_email_log`.
   - **Password reset**: Tokens stored in `auth_password_reset_tokens`.
   - **Login history**: All login attempts tracked in `auth_login_history`.

2. **User Account Types**:
   - Admin accounts are created manually in the database (no public registration).
   - OAuth users can self-register through OAuth providers.
   - One user can have multiple OAuth providers linked via `auth_oauth_accounts`.
   - OAuth profile data is stored in provider-specific tables (`auth_oauth_profiles_google`, `auth_oauth_profiles_telegram`, `auth_oauth_profiles_facebook`), linked via `oauth_account_id`.
   - **Phantom users** (`is_phantom=TRUE`): auto-created during external review imports (Facebook, Telegram, Google Maps). When a phantom user authenticates via OAuth, `is_phantom` flips to `FALSE` and all their reviews are already linked via `user_id`. Google Maps phantom users cannot be auto-claimed (contributor ID ≠ OAuth ID).

3. **I18n Strategy**:
   - Explicit columns with language suffixes (e.g., `name_sr`, `name_ru`, `description_en`) are used for localized content.
   - The `_sr` suffix denotes Serbian (Latin script), `_sr_cyrl` denotes Serbian (Cyrillic script).
   - For `specialties`, `languages`, and some reference tables, the `name` column acts as a key for lookup in `i18n/*.ts` files.

4. **Pricing**:
   - Prices are stored as `decimal(10,2)` in junction tables between clinics and services/tests/meds.
   - `price_max` field supports price ranges (e.g., "100-150 EUR").
   - `clinic_medical_services` also has `price_min` for three-tier price ranges.

5. **Ranking**:
   - `clinics`, `doctors`, `lab_tests`, and `medical_services` all have a `rank_score` column (decimal(5,4), default 0) used for default sort ordering.
   - Each table has a DESC index on `rank_score` for efficient sorted queries.

6. **Geo**:
   - Latitude uses `decimal(10,8)`, Longitude uses `decimal(11,8)` for high precision.

7. **Referential Integrity**:
   - Most foreign keys use `ON DELETE CASCADE`.

8. **Search**:
   - Search should consider `lab_test_synonyms`, `medical_service_synonyms` and localized `name_*` columns.

9. **Redirects**:
   - `doctor_redirects`, `lab_test_redirects` and `medical_service_redirects` tables handle merged records for 301 redirects.

10. **Service-Specialty Mapping**:
    - `medical_services_specialties` links medical services to relevant specialties for filtering.

11. **Service-Category Mapping**:
    - `medical_service_categories` and `medical_service_categories_relations` allow grouping medical services by categories.
    - `lab_test_categories` and `lab_test_categories_relations` allow grouping lab tests by categories.

12. **Doctor-Service Assignment**:
    - `clinic_medical_service_doctors` enables assigning specific doctors to medical services within a clinic context.

13. **Reviews, Replies & Likes**:
    - Each review can have up to **2 replies**: one from the clinic (`responder_type='clinic'`) and one from the doctor (`responder_type='doctor'`). No threading — flat structure only.
    - Replies are stored in `review_replies` with a unique constraint on (`review_id`, `responder_type`).
    - Both reviews and replies can be liked by authenticated (non-phantom) users. One like per user per entity.
    - `likes_count` is a denormalized counter on `reviews` and `review_replies` — updated by app logic on like/unlike (INSERT/DELETE into `review_likes` / `review_reply_likes`).
    - Reviews are sorted by `likes_count DESC` by default (index `idx_reviews_likes_count`).
    - Imported replies (from Google Maps, Facebook) use the `provider` field; native replies default to `docta_me`.

14. **Paid Services (Billing)**:
    - `billing_paid_services` contains paid services (dofollow, highlight, approved/verified).
    - `billing_clinic_service_purchases` tracks purchases made by clinics.
    - `billing_clinic_service_purchase_items` links purchases to specific services.
    - Prices are stored as `decimal(10,2)`.
    - `deleted` flag supports soft deletes for purchases.
    - Services sold via the catalog: HIGHLIGHT (featured in lists), APPROVED (verified badge). DOFOLLOW (id 1) is no longer sold — its `billing_service_prices` rows are deactivated (migration 008), the service row remains for legacy purchases. Selling dofollow links violates Google's link spam policy.

15. **Clinic Types & Working Hours**:
    - `clinic_types` is a reference table of clinic types (hospital, laboratory, pharmacy, etc.).
    - `clinic_clinic_types` links clinics to one or more types.
    - `clinic_working_hours` stores working hours per weekday as JSON (one row per clinic).

16. **Medicine Register (CInMED)**:

- Source: [cinmed.me](https://cinmed.me/en/register-of-medicines-for-human-use/) — Montenegro Ministry of Health.
- Scraped via `scripts/scrape-medicines.mjs`, raw data in `data/medicines.json`.
- Translations in `data/med-translations/` (JSON batches), SQL generated by `node scripts/build-med-sql.mjs`.
- Deploy to production: `mysql ... < server/sql/migrations/deploy-medicines.sql` (single file, schema + data).

### `countries`

- `id` (smallint unsigned, PK, AI)
- `name` (varchar(100), Unique): Montenegrin/Serbian name from source.
- `name_en`, `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(100)): Translations.
- Shared table — not prefixed with `med_`, can be used by other features.

### `med_dispensing_modes`

- `id` (tinyint unsigned, PK, AI)
- `name` (varchar(255), Unique): Montenegrin name (e.g. "Lijek se izdaje samo na ljekarski recept").
- `name_en`, `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Translations.
- 9 entries: prescription-only, OTC, hospital-only, restricted, special, renewable/non-renewable.

### `med_pharma_forms`

- `id` (smallint unsigned, PK, AI)
- `name` (varchar(255), Unique): Montenegrin name (e.g. "Film tableta", "Rastvor za injekciju").
- `name_en`, `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Translations.
- 147 dosage forms.

### `med_substances`

- `id` (smallint unsigned, PK, AI)
- `name` (varchar(500), Unique(400)): INN name in Montenegrin/Serbian (e.g. "paracetamol", "acetilsalicilna kiselina").
- `name_en`, `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(500)): Translations.
- 904 substances. Includes individual INN, vaccine descriptions (stored whole), and biologic products.
- Vaccines/biologics INN not split by comma — stored as single entry (e.g. "vakcina protiv hepatitisa b, rekombinantna").

### `med_atc_groups`

- `id` (tinyint unsigned, PK, AI)
- `code` (char(1), Unique): ATC level-1 code (A through V).
- `name` (varchar(100)): English name (used as default).
- `name_en`, `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(100)): Translations.
- 14 therapeutic categories. Filter by `atc_group_id` instead of `LIKE` on `atc_code`.

### `med_auth_holders`

- `id` (smallint unsigned, PK, AI)
- `name` (varchar(500), Unique(400)): Legal entity name in Montenegro (e.g. `"EVROPA LEK PHARMA" DOO PODGORICA`).
- 46 entries. No translations — company legal names.

### `med_manufacturers`

- `id` (smallint unsigned, PK, AI)
- `name` (varchar(500), Unique(400)): Short manufacturer name (e.g. "Hemofarm a.d.").
- `full_address` (varchar(1000)): Full address from detail page. Multiple sites separated by `; `.
- `country_id` (smallint unsigned, FK → `countries.id`): Country of origin.
- 421 entries.

### `med_medicines`

- `id` (int unsigned, PK, AI)
- `cinmed_id` (int unsigned, Unique): id from the CInMED list page (`a.dataset.id` at scrape time).
  **NOT stable** — verified 2026-08-28: all 8 sampled ids from the April 2026 scrape now open
  different medicines on cinmed.me. Fine as an internal dedup key for re-applying our own
  generated SQL, but never treat it as the register's permanent identifier, and never build
  outgoing links from it (see `detail_url`).
- `name` (varchar(500)): Brand name (e.g. "ASPIRIN® PROTECT").
- `slug` (varchar(600), Unique(400), NOT NULL): URL-safe slug for human-readable URLs.
- `pharmaceutical_form_id` (smallint unsigned, FK → `med_pharma_forms.id`)
- `strength` (varchar(500)): Dosage strength (e.g. "100mg", "500mg+25mg"). Can be long for vaccines.
- `packaging` (varchar(500)): Short packaging from list (e.g. "Blister, 30 tbl").
- `detail_packaging` (varchar(1000)): Full packaging from detail page.
- `manufacturer_id` (smallint unsigned, FK → `med_manufacturers.id`)
- `authorization_holder_id` (smallint unsigned, FK → `med_auth_holders.id`)
- `authorization_number` (varchar(100)): Approval decision number.
- `authorization_date` (date): Approval date.
- `dispensing_mode_id` (tinyint unsigned, FK → `med_dispensing_modes.id`)
- `atc_code` (varchar(10)): Full ATC code (e.g. "N02BE01"). Indexed.
- `atc_group_id` (tinyint unsigned, FK → `med_atc_groups.id`): Level-1 ATC group for fast filtering.
- `is_active` (tinyint(1), default 1): 1 = active license, 0 = expired. Indexed.
- `detail_url` (varchar(500)): cinmed.me detail link captured at scrape time. **Stale by now** —
  cinmed.me reuses `?id=` values, so these URLs point at other medicines. Not rendered anywhere
  and deliberately not emitted as schema.org `sameAs` (see `common/schema-org-builders.ts`);
  the UI links to the cinmed.me root instead.
- `scraped_at`, `updated_at` (datetime): Timestamps.
- 3553 total, 2523 with active license.

### `med_medicine_substances`

- `medicine_id` (int unsigned, PK, FK → `med_medicines.id`, CASCADE)
- `substance_id` (smallint unsigned, PK, FK → `med_substances.id`, CASCADE)
- 4404 links. Most medicines have 1 substance; combo drugs and vaccines have multiple.

### `med_substance_reference_info`

- `id` (int, PK, AI)
- `substance_id` (smallint unsigned, NOT NULL, Unique, FK → `med_substances.id`, CASCADE)
- `what_*`, `used_for_*`, `caution_*` (text): Three content fields, each with `_en`, `_sr`, `_sr_cyrl`, `_ru`, `_de`, `_tr` variants.
- `created_at`, `updated_at` (timestamp)
- 209 substances covered.
- _Comment_: The substance-level counterpart of `lab_test_reference_info`, but three fields instead of five — what the substance is, what it is used for, what to be careful about. Written for the catalogue, not scraped. _(migration 024)_

### `med_foreign_products`

- `id` (int unsigned, PK, AI)
- `market_code` (varchar(4), NOT NULL, Indexed): Market the brand is sold on — `RU`, `UA`, `TR`, `DE`, `PL`, `US`.
- `brand_name` (varchar(255), NOT NULL): Brand as sold on that market.
- `pharma_form_id` (smallint unsigned, FK → `med_pharma_forms.id`, SET NULL): Dosage form.
- `strength` (varchar(160)): Strength as printed on the package.
- `note` (varchar(500)), `sort_order` (int unsigned)
- `created_at` (timestamp)
- _Unique constraint_: (`market_code`, `brand_name`, `pharma_form_id`) — one row per market × brand × form, so the same brand sold as tablets and as syrup is two rows.
- 3059 products.
- _Comment_: Feeds the "Analogues in other countries" tab on a medicine page. A local medicine is matched to these by set-matching its substances plus dose and form, top 5 per market; see `prd/drug-cross-country-reference/IMPLEMENTATION.md`. _(migration 017)_

### `med_foreign_product_substances`

- `product_id` (int unsigned, PK, FK → `med_foreign_products.id`, CASCADE)
- `substance_id` (smallint unsigned, PK, FK → `med_substances.id`, CASCADE)
- 3358 links.
- _Comment_: A foreign brand resolves only through substances that already exist in `med_substances`, i.e. that are registered in Montenegro. A brand whose substance has no local registration cannot be stored, and such a question is answered by an article rather than by the catalogue.
