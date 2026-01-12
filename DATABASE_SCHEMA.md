# Database Schema (Technical Reference for Agents)

This file provides a structured reference of the MySQL database for the docta.me project.

## Tables Summary

| Table                                  | Description                                                    |
| :------------------------------------- | :------------------------------------------------------------- |
| `cities`                               | List of cities with coordinates.                               |
| `clinics`                              | Core clinic data, contacts, and multi-language descriptions.   |
| `doctors`                              | Medical specialists, personal info, and professional titles.   |
| `lab_tests`                            | Catalog of laboratory tests with localized names.              |
| `medical_services`                     | Catalog of general medical services (localized).               |
| `medications`                          | Catalog of medications (localized).                            |
| `specialties`                          | Medical specialties.                                           |
| `languages`                            | Supported languages (codes and names).                         |
| `clinic_lab_tests`                     | Junction table: Clinic <-> Lab Test (includes pricing).        |
| `clinic_medical_services`              | Junction table: Clinic <-> Medical Service (includes pricing). |
| `clinic_medications`                   | Junction table: Clinic <-> Medication (includes pricing).      |
| `clinic_languages`                     | Junction table: Clinic <-> Languages supported.                |
| `clinic_medical_service_doctors`       | Junction table: Clinic <-> Medical Service <-> Doctor.         |
| `doctor_clinics`                       | Junction table: Doctor <-> Clinic (includes position).         |
| `doctor_specialties`                   | Junction table: Doctor <-> Specialty.                          |
| `doctor_languages`                     | Junction table: Doctor <-> Languages spoken.                   |
| `medical_services_specialties`         | Junction table: Medical Service <-> Specialty.                 |
| `medical_service_categories`           | Categories for medical services.                               |
| `medical_service_categories_relations` | Junction table: Medical Service <-> Category.                  |
| `lab_test_categories`                  | Categories for lab tests.                                      |
| `lab_test_categories_relations`        | Junction table: Lab Test <-> Category.                         |
| `lab_test_synonyms`                    | Alternative names for lab tests for search optimization.       |
| `doctor_redirects`                     | Redirect map for merged doctor profiles.                       |
| `lab_test_redirects`                   | Redirect map for merged lab test records.                      |

## Detailed Table Definitions

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

### `lab_test_synonyms`

- `id` (int, PK, AI)
- `lab_test_id` (int): Lab Test ID.
- `another_name` (varchar(255), Indexed): Alternative name.
- `language` (varchar(10)): Language code.

### `lab_test_redirects`

- `id` (int, PK, AI)
- `old_id` (int): Old Lab Test ID.
- `new_id` (int): New Lab Test ID (target).

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

## Core Implementation Logic

1. **I18n Strategy**:

   - Explicit columns with language suffixes (e.g., `name_sr`, `name_ru`, `description_en`) are used for localized content.
   - The `_sr` suffix denotes Serbian (Latin script), `_sr_cyrl` denotes Serbian (Cyrillic script).
   - For `specialties`, `languages`, and some reference tables, the `name` column acts as a key for lookup in `i18n/*.ts` files.

2. **Pricing**:

   - Prices are stored as `decimal(10,2)` in junction tables between clinics and services/tests/meds.
   - `price_max` field supports price ranges (e.g., "100-150 EUR").

3. **Geo**:

   - Latitude uses `decimal(10,8)`, Longitude uses `decimal(11,8)` for high precision.

4. **Referential Integrity**:

   - Most foreign keys use `ON DELETE CASCADE`.

5. **Search**:

   - Search should consider `lab_test_synonyms` and localized `name_*` columns.

6. **Redirects**:

   - `doctor_redirects` and `lab_test_redirects` tables handle merged records for 301 redirects.

7. **Service-Specialty Mapping**:

   - `medical_services_specialties` links medical services to relevant specialties for filtering.

8. **Service-Category Mapping**:

   - `medical_service_categories` and `medical_service_categories_relations` allow grouping medical services by categories.
   - `lab_test_categories` and `lab_test_categories_relations` allow grouping lab tests by categories.

9. **Doctor-Service Assignment**:
   - `clinic_medical_service_doctors` enables assigning specific doctors to medical services within a clinic context.
