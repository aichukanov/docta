# Database Schema (Technical Reference for Agents)

This file provides a structured reference of the MySQL database for the docta.me project.

## Tables Summary

| Table                                   | Description                                                    |
| :-------------------------------------- | :------------------------------------------------------------- |
| `users`                                 | User accounts (admins with email/password, OAuth users).       |
| `oauth_accounts`                        | OAuth provider accounts linked to users.                       |
| `sessions`                              | User sessions with expiration tracking.                        |
| `cities`                                | List of cities with coordinates.                               |
| `clinics`                               | Core clinic data, contacts, and multi-language descriptions.   |
| `doctors`                               | Medical specialists, personal info, and professional titles.   |
| `lab_tests`                             | Catalog of laboratory tests with localized names.              |
| `medical_services`                      | Catalog of general medical services (localized).               |
| `medications`                           | Catalog of medications (localized).                            |
| `specialties`                           | Medical specialties.                                           |
| `languages`                             | Supported languages (codes and names).                         |
| `clinic_lab_tests`                      | Junction table: Clinic <-> Lab Test (includes pricing).        |
| `clinic_medical_services`               | Junction table: Clinic <-> Medical Service (includes pricing). |
| `clinic_medications`                    | Junction table: Clinic <-> Medication (includes pricing).      |
| `clinic_languages`                      | Junction table: Clinic <-> Languages supported.                |
| `clinic_medical_service_doctors`        | Junction table: Clinic <-> Medical Service <-> Doctor.         |
| `doctor_clinics`                        | Junction table: Doctor <-> Clinic (includes position).         |
| `doctor_specialties`                    | Junction table: Doctor <-> Specialty.                          |
| `doctor_languages`                      | Junction table: Doctor <-> Languages spoken.                   |
| `medical_services_specialties`          | Junction table: Medical Service <-> Specialty.                 |
| `medical_service_categories`            | Categories for medical services.                               |
| `medical_service_categories_relations`  | Junction table: Medical Service <-> Category.                  |
| `lab_test_categories`                   | Categories for lab tests.                                      |
| `lab_test_categories_relations`         | Junction table: Lab Test <-> Category.                         |
| `lab_test_synonyms`                     | Alternative names for lab tests for search optimization.       |
| `medical_service_redirects`             | Redirect map for merged medical service records.               |
| `doctor_redirects`                      | Redirect map for merged doctor profiles.                       |
| `lab_test_redirects`                    | Redirect map for merged lab test records.                      |
| `billing_paid_services`                 | Catalog of paid services available for clinics.                |
| `billing_clinic_service_purchases`      | Purchase records of paid services by clinics.                  |
| `billing_clinic_service_purchase_items` | Junction table: Purchase <-> Paid Service.                     |

## Detailed Table Definitions

### `users`

- `id` (int, PK, AI)
- `email` (varchar(255), Unique, NOT NULL): User email address.
- `name` (varchar(255)): User's full name.
- `photo_url` (varchar(500)): URL to user's profile photo.
- `password_hash` (varchar(255), NULL): Bcrypt password hash (for admins with email/password login). NULL for OAuth users.
- `is_admin` (boolean, default FALSE): Flag indicating administrator privileges.
- `created_at` (timestamp)
- `updated_at` (timestamp)
- _Indexes_: `idx_email` (email), `idx_is_admin` (is_admin)
- _Comment_: Stores both admin users (with password_hash) and OAuth users (without password_hash).

### `oauth_accounts`

- `id` (int, PK, AI)
- `user_id` (int, FK -> users.id, NOT NULL): Reference to user account.
- `provider` (varchar(50), NOT NULL): OAuth provider name (google, telegram).
- `provider_account_id` (varchar(255), NOT NULL): User ID from OAuth provider.
- `access_token` (text): OAuth access token (optional, encrypted).
- `refresh_token` (text): OAuth refresh token (optional).
- `expires_at` (bigint): Token expiration timestamp (UNIX).
- `created_at` (timestamp)
- `updated_at` (timestamp)
- _Unique constraint_: (`provider`, `provider_account_id`)
- _Indexes_: `idx_user_id` (user_id), `idx_provider` (provider, provider_account_id)
- _Foreign Keys_: `user_id` -> `users.id` (ON DELETE CASCADE)
- _Comment_: Supports multiple OAuth providers per user (e.g., one user can login via both Google and Telegram).

### `sessions`

- `id` (varchar(255), PK): Session ID (UUID).
- `user_id` (int, FK -> users.id, NOT NULL): Reference to user account.
- `expires_at` (bigint, NOT NULL): Session expiration timestamp (UNIX).
- `created_at` (timestamp)
- _Indexes_: `idx_user_id` (user_id), `idx_expires_at` (expires_at)
- _Foreign Keys_: `user_id` -> `users.id` (ON DELETE CASCADE)
- _Comment_: Database-based session storage. HTTPOnly cookies store session_id, actual session data is in DB.

### `cities`

- `id` (int, PK, AI)
- `name` (varchar(100), Unique): City name.
- `latitude` (decimal(10,8))
- `longitude` (decimal(11,8))
- `created_at` (timestamp)

### `clinics`

- `id` (int, PK, AI)
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
- `created_at`, `updated_at` (timestamp)

### `doctors`

- `id` (int, PK, AI)
- `name_sr` (varchar(255)): Name in Serbian (Latin).
- `name_sr_cyrl` (varchar(255)): Name in Serbian (Cyrillic).
- `name_ru` (varchar(255)): Name in Russian.
- `name_en` (varchar(255)): Name in English.
- `photo_url` (varchar(255))
- `phone` (varchar(20))
- `email`, `website`, `instagram`, `facebook`, `whatsapp`, `telegram`, `viber` (varchar(255))
- `description_sr`, `description_sr_cyrl`, `description_ru`, `description_en`, `description_de`, `description_tr` (text): Localized descriptions.
- `professional_title` (varchar(255))
- `created_at`, `updated_at` (timestamp)

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
- `name_en` (varchar(255), Unique): Test name in English (Key).
- `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `created_at` (timestamp)

### `lab_test_categories`

- `id` (int, PK, AI)
- `name` (varchar(255)): Category name.

### `lab_test_categories_relations`

- `id` (int, PK, AI)
- `lab_test_id` (int): Lab Test ID.
- `category_id` (int): Category ID.
- _Unique constraint_: (`lab_test_id`, `category_id`)

### `lab_test_synonyms`

- `id` (int, PK, AI)
- `lab_test_id` (int): Lab Test ID.
- `another_name` (varchar(255), Indexed): Alternative name.
- `language` (varchar(10)): Language code.

### `lab_test_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Lab Test ID.
- `new_id` (int): New Lab Test ID (target).

### `medical_service_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Medical Service ID.
- `new_id` (int): New Medical Service ID (target).

### `medical_services`

- `id` (int, PK, AI)
- `name_en` (varchar(255), Unique): Service name in English (Key).
- `name_sr`, `name_sr_cyrl`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `sort_order` (int): Display order.
- `created_at` (timestamp)

### `medical_service_categories`

- `id` (int, PK, AI)
- `name` (varchar(255)): Category name.
- `created_at` (datetime)

### `medical_service_categories_relations`

- `id` (int, PK, AI)
- `medical_service_id` (int): Medical Service ID.
- `medical_service_category_id` (int): Medical Service Category ID.
- _Unique constraint_: (`medical_service_id`, `medical_service_category_id`)

### `medical_services_specialties`

- `id` (int, PK, AI)
- `medical_service_id` (int): Medical Service ID.
- `specialty_id` (int): Specialty ID.

### `medications`

- `id` (int, PK, AI)
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
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `lab_test_id`)

### `clinic_medical_services`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific service code.
- `price` (decimal(10,2))
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medical_service_id`)

### `clinic_medical_service_doctors`

- `id` (int, PK, AI)
- `clinic_id` (int): Clinic ID.
- `medical_service_id` (int): Medical Service ID.
- `doctor_id` (int): Doctor ID.
- `price` (decimal(10,2)): Price of the service for this doctor.
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `created_at` (datetime)
- _Comment_: Links doctors to specific medical services within a clinic, with individual pricing.

### `clinic_medications`

- `id` (int, PK, AI)
- `medication_id` (int, FK -> medications.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific medication code.
- `price` (decimal(10,2))
- `price_max` (decimal(10,2)): Maximum price (for price ranges).
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medication_id`)

### `clinic_languages`

- `id` (int, PK, AI)
- `clinic_id` (int): Clinic ID.
- `language_id` (int): Language ID.
- `create_time` (datetime)

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
- `name` (varchar(255), NOT NULL): Service name (e.g., "dofollow", "highlight", "approved").
- `description` (text): Service description.
- `created_at` (timestamp)

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
- `created_at` (timestamp)
- _Relationship_: Links specific paid services to a purchase.

## Core Implementation Logic

1. **Authentication Strategy**:

   - **Admin users**: Use email + password authentication. `password_hash` is filled with bcrypt hash (cost=10), `is_admin=TRUE`.
   - **Regular users**: Use OAuth (Google, Telegram). `password_hash=NULL`, `is_admin=FALSE`.
   - **Session management**: Database-based sessions stored in `sessions` table with expiration tracking.
   - **Security**: HTTPOnly cookies store `session_id`, actual session data (user_id, expires_at) is in DB.

2. **User Account Types**:

   - Admin accounts are created manually in the database (no public registration).
   - OAuth users can self-register through OAuth providers.
   - One user can have multiple OAuth providers linked via `oauth_accounts`.

3. **I18n Strategy**:

   - Explicit columns with language suffixes (e.g., `name_sr`, `name_ru`, `description_en`) are used for localized content.
   - The `_sr` suffix denotes Serbian (Latin script), `_sr_cyrl` denotes Serbian (Cyrillic script).
   - For `specialties`, `languages`, and some reference tables, the `name` column acts as a key for lookup in `i18n/*.ts` files.

4. **Pricing**:

   - Prices are stored as `decimal(10,2)` in junction tables between clinics and services/tests/meds.
   - `price_max` field supports price ranges (e.g., "100-150 EUR").

5. **Geo**:

   - Latitude uses `decimal(10,8)`, Longitude uses `decimal(11,8)` for high precision.

6. **Referential Integrity**:

   - Most foreign keys use `ON DELETE CASCADE`.

7. **Search**:

   - Search should consider `lab_test_synonyms` and localized `name_*` columns.

8. **Redirects**:

   - `doctor_redirects`, `lab_test_redirects` and `medical_service_redirects` tables handle merged records for 301 redirects.

9. **Service-Specialty Mapping**:

   - `medical_services_specialties` links medical services to relevant specialties for filtering.

10. **Service-Category Mapping**:

   - `medical_service_categories` and `medical_service_categories_relations` allow grouping medical services by categories.
   - `lab_test_categories` and `lab_test_categories_relations` allow grouping lab tests by categories.

11. **Doctor-Service Assignment**:

   - `clinic_medical_service_doctors` enables assigning specific doctors to medical services within a clinic context.

12. **Paid Services (Billing)**:

- `billing_paid_services` contains available paid services (dofollow, highlight, approved/verified).
- `billing_clinic_service_purchases` tracks purchases made by clinics.
- `billing_clinic_service_purchase_items` links purchases to specific services.
- Prices are stored as `decimal(10,2)`.
- `deleted` flag supports soft deletes for purchases.
- Current available services: DOFOLLOW (dofollow links), HIGHLIGHT (featured in lists), APPROVED (verified badge).
