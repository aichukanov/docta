# Database Schema (Technical Reference for Agents)

This file provides a structured reference of the MySQL database for the docta.me project.

## Tables Summary

| Table                           | Description                                                    |
| :------------------------------ | :------------------------------------------------------------- |
| `cities`                        | List of cities in Montenegro with coordinates.                 |
| `clinics`                       | Core clinic data, contacts, and multi-language descriptions.   |
| `doctors`                       | Medical specialists, personal info, and professional titles.   |
| `lab_tests`                     | Catalog of laboratory tests with localized names.              |
| `medical_services`              | Catalog of general medical services (localized via i18n keys). |
| `medications`                   | Catalog of medications (localized via i18n keys).              |
| `specialties`                   | Medical specialties (localized via i18n keys).                 |
| `languages`                     | Supported languages (codes and names).                         |
| `clinic_lab_tests`              | Junction table: Clinic <-> Lab Test (includes pricing).        |
| `clinic_medical_services`       | Junction table: Clinic <-> Medical Service (includes pricing). |
| `clinic_medications`            | Junction table: Clinic <-> Medication (includes pricing).      |
| `doctor_clinics`                | Junction table: Doctor <-> Clinic (includes position).         |
| `doctor_specialties`            | Junction table: Doctor <-> Specialty.                          |
| `doctor_languages`              | Junction table: Doctor <-> Languages spoken.                   |
| `clinic_languages`              | Junction table: Clinic <-> Languages supported.                |
| `lab_test_categories`           | Categories for lab tests.                                      |
| `lab_test_categories_relations` | Junction table: Lab Test <-> Category.                         |
| `lab_test_synonyms`             | Alternative names for lab tests for search optimization.       |
| `doctor_redirects`              | Redirect map for merged doctor profiles.                       |
| `lab_test_redirects`            | Redirect map for merged lab test records.                      |

## Detailed Table Definitions

### `cities`

- `id` (int, PK, AI)
- `name` (varchar(100), Unique): City name (English/Key).
- `latitude` (decimal(10,8))
- `longitude` (decimal(11,8))
- `created_at` (timestamp)

### `clinics`

- `id` (int, PK, AI)
- `name` (varchar(255))
- `city_id` (int, FK -> cities.id)
- `address` (text)
- `latitude` (decimal(10,8))
- `longitude` (decimal(11,8))
- `phone` (varchar(255))
- `email` (varchar(255))
- `website` (varchar(255))
- `instagram`, `facebook`, `whatsapp`, `telegram`, `viber` (varchar(255))
- `town` (varchar(255))
- `postal_code` (varchar(10))
- `description_sr`, `description_ru`, `description_en`, `description_de`, `description_tr` (text): Localized descriptions.
- `created_at`, `updated_at` (timestamp)

### `doctors`

- `id` (int, PK, AI)
- `name` (varchar(255)): Name (usually in Montenegrin/Serbian).
- `name_ru` (varchar(255)): Name in Russian.
- `photo_url` (varchar(255))
- `phone` (varchar(20))
- `email`, `website`, `instagram`, `facebook`, `whatsapp`, `telegram`, `viber` (varchar(255))
- `professional_title` (varchar(255))
- `created_at`, `updated_at` (timestamp)

### `lab_tests`

- `id` (int, PK, AI)
- `name` (varchar(100), Unique): Test name in English (Key).
- `name_sr`, `name_ru`, `name_de`, `name_tr` (varchar(255)): Localized names.
- `created_at` (timestamp)

### `clinic_lab_tests`

- `id` (int, PK, AI)
- `lab_test_id` (int, FK -> lab_tests.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50)): Clinic-specific test code.
- `price` (decimal(10,2))
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `lab_test_id`)

### `clinic_medical_services`

- `id` (int, PK, AI)
- `medical_service_id` (int, FK -> medical_services.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50))
- `price` (decimal(10,2))
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medical_service_id`)

### `clinic_medications`

- `id` (int, PK, AI)
- `medication_id` (int, FK -> medications.id)
- `clinic_id` (int, FK -> clinics.id)
- `code` (varchar(50))
- `price` (decimal(10,2))
- `created_at` (timestamp)
- _Unique constraint_: (`clinic_id`, `medication_id`)

### `doctor_clinics`

- `id` (int, PK, AI)
- `doctor_id` (int, FK -> doctors.id)
- `clinic_id` (int, FK -> clinics.id)
- `position` (varchar(255)): Job title/position in the clinic.
- `created_at` (timestamp)

### `doctor_specialties`

- `id` (int, PK, AI)
- `doctor_id` (int, FK -> doctors.id)
- `specialty_id` (int, FK -> specialties.id)
- `created_at` (timestamp)

### `lab_test_synonyms`

- `id` (int, PK, AI)
- `lab_test_id` (int, FK -> lab_tests.id)
- `another_name` (varchar(255))
- `language` (varchar(10))

## Core Implementation Logic

1. **I18n Strategy**:
   - Explicit columns (e.g., `description_ru`) are used for large text blocks in `clinics` and `lab_tests`.
   - The `name` column in `medical_services`, `medications`, `specialties`, and `cities` acts as a unique key for lookup in `i18n/*.ts` files.
2. **Pricing**: Prices are stored as `decimal(10,2)` in junction tables between clinics and services/tests/meds.
3. **Geo**: Latitude/Longitude use standard `decimal` types for high precision.
4. **Referential Integrity**: Most foreign keys use `ON DELETE CASCADE`.
5. **Search**: Search should consider `lab_test_synonyms` and localized `name_*` columns.
