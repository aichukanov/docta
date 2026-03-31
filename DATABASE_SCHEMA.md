# Database Schema (Technical Reference for Agents)

This file provides a structured reference of the MySQL database for the docta.me project.

## Tables Summary

| Table                                   | Description                                                    |
| :-------------------------------------- | :------------------------------------------------------------- |
| `auth_users`                            | User accounts (admins with email/password, OAuth users).       |
| `auth_oauth_accounts`                   | OAuth provider accounts linked to users.                       |
| `auth_oauth_profiles_google`            | Google OAuth profile data (email, name, locale, avatar).       |
| `auth_oauth_profiles_telegram`          | Telegram OAuth profile data (name, username, avatar).          |
| `auth_oauth_profiles_facebook`          | Facebook OAuth profile data (name, email, avatar).             |
| `auth_sessions`                         | User sessions with expiration tracking.                        |
| `auth_login_history`                    | Login attempt history (IP, user agent, method, success).       |
| `auth_email_verification_tokens`        | Tokens for email verification flow.                            |
| `auth_password_reset_tokens`            | Tokens for password reset flow.                                |
| `auth_email_log`                        | Log of all sent email messages.                                |
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
| `reviews`                               | Polymorphic reviews for clinics, doctors, and services.        |
| `review_replies`                        | Replies to reviews (one from clinic, one from doctor).         |
| `review_likes`                          | Likes on reviews by registered users.                         |
| `review_reply_likes`                    | Likes on review replies by registered users.                  |
| `billing_paid_services`                 | Catalog of paid services available for clinics.                |
| `billing_clinic_service_purchases`      | Purchase records of paid services by clinics.                  |
| `billing_clinic_service_purchase_items` | Junction table: Purchase <-> Paid Service.                     |
| `kb_sources`                            | Registry of imported channels/groups (Telegram, etc.).         |
| `kb_messages`                           | Imported messages from community channels.                     |
| `kb_tags`                               | Hierarchical tags/categories for KB content.                   |
| `kb_message_tags`                       | Junction table: Message <-> Tag.                               |
| `kb_threads`                            | Compiled Q&A entries (question + answer, 6 languages).         |
| `kb_thread_tags`                        | Junction table: Thread <-> Tag.                                |
| `kb_thread_sources`                     | Junction table: Thread <-> source Messages.                    |
| `kb_articles`                           | Curated articles with localized content.                       |
| `kb_article_tags`                       | Junction table: Article <-> Tag.                               |
| `kb_article_sources`                    | Junction table: Article <-> source Messages.                   |
| `kb_entity_links`                       | Generic polymorphic links to domain entities (doctor, clinic). |

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
- `primary_oauth_provider` (varchar(50), NULL): Primary OAuth provider for display (google, telegram, NULL for email).
- `preferred_locale` (varchar(10), NULL): Preferred language: sr, sr-cyrl, en, ru, de, tr.
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
- `created_at`, `updated_at` (timestamp)

### `doctors`

- `id` (int, PK, AI)
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
- `hidden` (boolean, default FALSE): When TRUE, the doctor is excluded from all public listings and their profile page returns 404.
- `is_draft` (boolean, default FALSE): When TRUE, the profile is pending review and not yet published. Only admins can change this.
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_doctors_user_id` (user_id, UNIQUE), `idx_hidden`, `idx_doctors_is_draft`
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

### `clinic_clinic_types`

- `clinic_id` (int, PK, FK -> clinics.id ON DELETE CASCADE)
- `clinic_type_id` (tinyint unsigned, PK): Clinic type. Values defined in `ClinicType` enum.

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
- `name` (varchar(50), Unique, NOT NULL): Service name (e.g., "dofollow", "highlight", "approved").

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

### `reviews`

- `id` (int, PK, AI)
- `user_id` (int, NULL, FK -> auth_users.id): Review author. Links to real or phantom user. ON DELETE SET NULL.
- `clinic_id` (int, NULL, FK -> clinics.id): Review target: clinic.
- `doctor_id` (int, NULL, FK -> doctors.id): Review target: doctor.
- `medical_service_id` (int, NULL, FK -> medical_services.id): Review target: service.
- `provider` (enum: 'google_maps', 'facebook', 'telegram', 'docta_me', NOT NULL): Source of the review.
- `provider_review_id` (varchar(255), NULL): External ID for deduplication.
- `rating` (tinyint unsigned, NULL): Rating 1-5.
- `original_language` (varchar(10), NOT NULL, default 'sr'): Language code of the original review text (may be outside project languages, e.g., 'bs', 'me').
- `original_text` (text, NULL): Original review text as written by the author (may be in any language).
- `text_sr`, `text_sr_cyrl`, `text_en`, `text_ru`, `text_de`, `text_tr` (text, NULL): Localized/translated review texts.
- `published_at` (datetime, NULL): When review was published on the platform.
- `likes_count` (int unsigned, NOT NULL, default 0): Denormalized like counter for sorting.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`provider`, `provider_review_id`)
- _Indexes_: `idx_reviews_user_id`, `idx_clinic_id`, `idx_doctor_id`, `idx_medical_service_id`, `idx_provider`, `idx_rating`, `idx_reviews_likes_count` (likes_count DESC)
- _Foreign Keys_: `user_id` -> `auth_users.id` (SET NULL), `clinic_id` -> `clinics.id` (CASCADE), `doctor_id` -> `doctors.id` (CASCADE), `medical_service_id` -> `medical_services.id` (CASCADE)
- _Comment_: Polymorphic reviews — exactly one of clinic_id/doctor_id/medical_service_id must be NOT NULL. Author info (name, photo, profile link) is stored in `auth_users` — use JOIN by `user_id`.

### `review_replies`

- `id` (int, PK, AI)
- `review_id` (int, FK -> reviews.id, NOT NULL): Parent review.
- `responder_type` (enum: 'clinic', 'doctor', NOT NULL): Who is replying.
- `clinic_id` (int, NULL, FK -> clinics.id): Clinic that replied (when responder_type='clinic').
- `doctor_id` (int, NULL, FK -> doctors.id): Doctor that replied (when responder_type='doctor').
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
- _Foreign Keys_: `review_id` -> `reviews.id` (CASCADE), `clinic_id` -> `clinics.id` (CASCADE), `doctor_id` -> `doctors.id` (CASCADE), `user_id` -> `auth_users.id` (SET NULL)
- _Comment_: Each review can have at most 2 replies: one from the clinic and one from the doctor. No threading. Exactly one of clinic_id/doctor_id must be NOT NULL (matches responder_type).

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

### `kb_sources`

- `id` (int, PK, AI)
- `provider` (varchar(50), NOT NULL): Source provider (telegram, whatsapp, viber).
- `provider_source_id` (varchar(255), NOT NULL): Channel/group ID from provider.
- `name` (varchar(255)): Channel name.
- `url` (varchar(500)): Link to channel.
- `metadata` (json): Additional data (type, member count, etc.).
- `created_at` (timestamp)
- _Unique constraint_: (`provider`, `provider_source_id`)

### `kb_messages`

- `id` (int, PK, AI)
- `source_id` (int, FK -> kb_sources.id, NOT NULL): Source channel.
- `user_id` (int, FK -> auth_users.id, NULL): Message author (phantom or real).
- `provider_message_id` (varchar(255), NOT NULL): Message ID from export (for dedup).
- `reply_to_id` (int, FK -> kb_messages.id, NULL): Self-reference for threading.
- `message_type` (enum: 'question','answer','recommendation','info','other', default 'other'): Classification.
- `original_text` (text): Plain text content.
- `original_language` (varchar(10), default 'ru'): Source language.
- `text_sr`, `text_sr_cyrl`, `text_en`, `text_ru`, `text_de`, `text_tr` (text, NULL): Localized texts.
- `has_media` (boolean, default FALSE): Whether message has attachments.
- `media_type` (varchar(50), NULL): Type of media (photo, video, document).
- `published_at` (datetime): When message was posted in channel.
- `raw_data` (json): Full original message object.
- `is_duplicate` (boolean, default FALSE): Cross-channel duplicate flag.
- `duplicate_of_id` (int, FK -> kb_messages.id, NULL): Reference to original.
- `created_at`, `updated_at` (timestamp)
- _Unique constraint_: (`source_id`, `provider_message_id`)
- _Indexes_: `idx_kb_msg_user`, `idx_kb_msg_reply`, `idx_kb_msg_type`, `idx_kb_msg_published`, `idx_kb_msg_duplicate`
- _Foreign Keys_: `source_id` -> `kb_sources.id` (CASCADE), `user_id` -> `auth_users.id` (SET NULL), `reply_to_id` -> `kb_messages.id` (SET NULL), `duplicate_of_id` -> `kb_messages.id` (SET NULL)

### `kb_tags`

- `id` (int, PK, AI)
- `slug` (varchar(100), UNIQUE, NOT NULL): URL-friendly key, also i18n lookup key.
- `parent_id` (int, FK -> kb_tags.id, NULL): Parent tag for hierarchy.
- `sort_order` (int, default 0): Display order.
- `created_at` (timestamp)
- _Indexes_: `idx_kb_tags_parent`
- _Foreign Keys_: `parent_id` -> `kb_tags.id` (SET NULL)
- _Comment_: Tag names resolved via i18n files using slug as key. Hierarchy: e.g., `city` (parent) → `city:budva` (child).

### `kb_message_tags`

- `id` (int, PK, AI)
- `message_id` (int, FK -> kb_messages.id, NOT NULL)
- `tag_id` (int, FK -> kb_tags.id, NOT NULL)
- _Unique constraint_: (`message_id`, `tag_id`)

### `kb_threads`

- `id` (int, PK, AI)
- `root_message_id` (int, FK -> kb_messages.id, UNIQUE, NULL): Root message this Q&A was compiled from. NULL for fully curated Q&A.
- `slug` (varchar(255), UNIQUE, NULL): URL slug for /qa/<slug>.
- `status` (enum: 'draft','published','faq', default 'draft'): Publication status.
- `title_sr`, `title_sr_cyrl`, `title_en`, `title_ru`, `title_de`, `title_tr` (varchar(500)): Localized question/title.
- `answer_sr`, `answer_sr_cyrl`, `answer_en`, `answer_ru`, `answer_de`, `answer_tr` (text): Localized compiled answer.
- `views_count` (int unsigned, default 0): View counter.
- `published_at` (datetime, NULL)
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_kb_thread_status`, `idx_kb_thread_published`
- _Foreign Keys_: `root_message_id` -> `kb_messages.id` (SET NULL)
- _Comment_: Compiled from one or more message threads. Similar questions merged into one Q&A. Status `faq` = shown on FAQ page.

### `kb_thread_tags`

- `id` (int, PK, AI)
- `thread_id` (int, FK -> kb_threads.id, NOT NULL)
- `tag_id` (int, FK -> kb_tags.id, NOT NULL)
- _Unique constraint_: (`thread_id`, `tag_id`)

### `kb_thread_sources`

- `id` (int, PK, AI)
- `thread_id` (int, FK -> kb_threads.id, NOT NULL)
- `message_id` (int, FK -> kb_messages.id, NOT NULL)
- _Unique constraint_: (`thread_id`, `message_id`)
- _Comment_: Links compiled Q&A back to the original messages it was derived from.

### `kb_articles`

- `id` (int, PK, AI)
- `slug` (varchar(255), UNIQUE, NOT NULL): URL slug for /articles/<slug>.
- `author_user_id` (int, FK -> auth_users.id, NULL): Article author.
- `status` (enum: 'draft','published', default 'draft')
- `title_sr`, `title_sr_cyrl`, `title_en`, `title_ru`, `title_de`, `title_tr` (varchar(500)): Localized titles.
- `content_sr`, `content_sr_cyrl`, `content_en`, `content_ru`, `content_de`, `content_tr` (mediumtext): Localized content.
- `views_count` (int unsigned, default 0)
- `published_at` (datetime, NULL)
- `created_at`, `updated_at` (timestamp)
- _Indexes_: `idx_kb_article_status`
- _Foreign Keys_: `author_user_id` -> `auth_users.id` (SET NULL)

### `kb_article_tags`

- `id` (int, PK, AI)
- `article_id` (int, FK -> kb_articles.id, NOT NULL)
- `tag_id` (int, FK -> kb_tags.id, NOT NULL)
- _Unique constraint_: (`article_id`, `tag_id`)

### `kb_article_sources`

- `id` (int, PK, AI)
- `article_id` (int, FK -> kb_articles.id, NOT NULL)
- `message_id` (int, FK -> kb_messages.id, NOT NULL)
- _Unique constraint_: (`article_id`, `message_id`)
- _Comment_: Links articles back to the original messages that informed them.

### `kb_entity_links`

- `id` (int, PK, AI)
- `linkable_type` (enum: 'message','thread','article', NOT NULL): Type of KB entity.
- `linkable_id` (int, NOT NULL): ID of the KB entity.
- `entity_type` (varchar(50), NOT NULL): Domain entity type (doctor, clinic, specialty, medical_service).
- `entity_id` (int, NOT NULL): ID of the domain entity.
- _Unique constraint_: (`linkable_type`, `linkable_id`, `entity_type`, `entity_id`)
- _Indexes_: `idx_kb_entity_lookup` (entity_type, entity_id), `idx_kb_entity_linkable` (linkable_type, linkable_id)
- _Comment_: Generic polymorphic table for linking KB content to domain entities. Designed for reuse across domains — `entity_type` can be any string (doctor, clinic, restaurant, hotel, etc.).

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

12. **Reviews, Replies & Likes**:

   - Each review can have up to **2 replies**: one from the clinic (`responder_type='clinic'`) and one from the doctor (`responder_type='doctor'`). No threading — flat structure only.
   - Replies are stored in `review_replies` with a unique constraint on (`review_id`, `responder_type`).
   - Both reviews and replies can be liked by authenticated (non-phantom) users. One like per user per entity.
   - `likes_count` is a denormalized counter on `reviews` and `review_replies` — updated by app logic on like/unlike (INSERT/DELETE into `review_likes` / `review_reply_likes`).
   - Reviews are sorted by `likes_count DESC` by default (index `idx_reviews_likes_count`).
   - Imported replies (from Google Maps, Facebook) use the `provider` field; native replies default to `docta_me`.

13. **Paid Services (Billing)**:

- `billing_paid_services` contains available paid services (dofollow, highlight, approved/verified).
- `billing_clinic_service_purchases` tracks purchases made by clinics.
- `billing_clinic_service_purchase_items` links purchases to specific services.
- Prices are stored as `decimal(10,2)`.
- `deleted` flag supports soft deletes for purchases.
- Current available services: DOFOLLOW (dofollow links), HIGHLIGHT (featured in lists), APPROVED (verified badge).

14. **Knowledge Base (KB)**:

- Imported from Telegram community channels via `kb_sources` → `kb_messages`.
- Messages are classified (`question`, `answer`, `recommendation`, `info`, `other`) and threaded via `reply_to_id`.
- **Phantom users**: message authors are auto-created as phantom users in `auth_users` with Telegram OAuth accounts, same pattern as review imports.
- **Tags**: hierarchical tag system in `kb_tags` (slug-based, i18n via slug lookup). Tags have optional `parent_id` for hierarchy (e.g., `city:budva` → parent `city`).
- **Q&A Threads** (`kb_threads`): compiled from message threads. Similar questions are merged into one Q&A with generalized question/answer in 6 languages. Status flow: `draft` → `published` / `faq`.
- **Articles** (`kb_articles`): curated long-form content with localized title/content in 6 languages.
- **Entity links** (`kb_entity_links`): generic polymorphic linking of KB content (messages, threads, articles) to domain entities (doctors, clinics, specialties, medical services). Reusable across domains.
- **Deduplication**: UNIQUE constraint `(source_id, provider_message_id)` per channel; cross-channel dedup via `is_duplicate` + `duplicate_of_id`.
- **Source tracing**: `kb_thread_sources` and `kb_article_sources` link compiled content back to original messages.
