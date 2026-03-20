-- Knowledge Base tables for docta.me
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/create-kb-tables.sql

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- kb_sources — channel/group registry
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_sources` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `provider` VARCHAR(50) NOT NULL COMMENT 'telegram, whatsapp, viber, etc.',
  `provider_source_id` VARCHAR(255) NOT NULL COMMENT 'Channel/group ID from provider',
  `name` VARCHAR(255) DEFAULT NULL,
  `url` VARCHAR(500) DEFAULT NULL,
  `metadata` JSON DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_sources_provider` (`provider`, `provider_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_messages — imported messages from channels
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_messages` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `source_id` INT NOT NULL,
  `user_id` INT DEFAULT NULL COMMENT 'FK to auth_users (phantom or real)',
  `provider_message_id` VARCHAR(255) NOT NULL COMMENT 'Message ID from provider export',
  `reply_to_id` INT DEFAULT NULL COMMENT 'Self-ref to parent message',
  `message_type` ENUM('question','answer','recommendation','info','other') NOT NULL DEFAULT 'other',
  `original_text` TEXT DEFAULT NULL,
  `original_language` VARCHAR(10) NOT NULL DEFAULT 'ru',
  `text_sr` TEXT DEFAULT NULL,
  `text_sr_cyrl` TEXT DEFAULT NULL,
  `text_en` TEXT DEFAULT NULL,
  `text_ru` TEXT DEFAULT NULL,
  `text_de` TEXT DEFAULT NULL,
  `text_tr` TEXT DEFAULT NULL,
  `has_media` TINYINT(1) NOT NULL DEFAULT 0,
  `media_type` VARCHAR(50) DEFAULT NULL,
  `published_at` DATETIME DEFAULT NULL,
  `raw_data` JSON DEFAULT NULL,
  `is_duplicate` TINYINT(1) NOT NULL DEFAULT 0,
  `duplicate_of_id` INT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_msg_provider` (`source_id`, `provider_message_id`),
  KEY `idx_kb_msg_user` (`user_id`),
  KEY `idx_kb_msg_reply` (`reply_to_id`),
  KEY `idx_kb_msg_type` (`message_type`),
  KEY `idx_kb_msg_published` (`published_at`),
  KEY `idx_kb_msg_duplicate` (`is_duplicate`),
  CONSTRAINT `fk_kb_msg_source` FOREIGN KEY (`source_id`) REFERENCES `kb_sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_msg_user` FOREIGN KEY (`user_id`) REFERENCES `auth_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_kb_msg_reply` FOREIGN KEY (`reply_to_id`) REFERENCES `kb_messages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_kb_msg_dup` FOREIGN KEY (`duplicate_of_id`) REFERENCES `kb_messages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_tags — hierarchical tags/categories
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(100) NOT NULL COMMENT 'URL-friendly key, also i18n lookup key',
  `parent_id` INT DEFAULT NULL COMMENT 'Parent tag for hierarchy',
  `sort_order` INT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_tags_slug` (`slug`),
  KEY `idx_kb_tags_parent` (`parent_id`),
  CONSTRAINT `fk_kb_tags_parent` FOREIGN KEY (`parent_id`) REFERENCES `kb_tags` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_message_tags
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_message_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `message_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_msg_tag` (`message_id`, `tag_id`),
  KEY `idx_kb_msg_tag_tag` (`tag_id`),
  CONSTRAINT `fk_kb_msg_tag_msg` FOREIGN KEY (`message_id`) REFERENCES `kb_messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_msg_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `kb_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_threads — compiled Q&A entries
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_threads` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `root_message_id` INT DEFAULT NULL COMMENT 'Root message this Q&A was compiled from (NULL for fully curated)',
  `slug` VARCHAR(255) DEFAULT NULL,
  `status` ENUM('draft','published','faq') NOT NULL DEFAULT 'draft',
  `title_sr` VARCHAR(500) DEFAULT NULL,
  `title_sr_cyrl` VARCHAR(500) DEFAULT NULL,
  `title_en` VARCHAR(500) DEFAULT NULL,
  `title_ru` VARCHAR(500) DEFAULT NULL,
  `title_de` VARCHAR(500) DEFAULT NULL,
  `title_tr` VARCHAR(500) DEFAULT NULL,
  `answer_sr` TEXT DEFAULT NULL,
  `answer_sr_cyrl` TEXT DEFAULT NULL,
  `answer_en` TEXT DEFAULT NULL,
  `answer_ru` TEXT DEFAULT NULL,
  `answer_de` TEXT DEFAULT NULL,
  `answer_tr` TEXT DEFAULT NULL,
  `views_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `published_at` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_thread_root` (`root_message_id`),
  UNIQUE KEY `uq_kb_thread_slug` (`slug`),
  KEY `idx_kb_thread_status` (`status`),
  KEY `idx_kb_thread_published` (`published_at`),
  CONSTRAINT `fk_kb_thread_root` FOREIGN KEY (`root_message_id`) REFERENCES `kb_messages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_thread_tags
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_thread_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thread_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_thread_tag` (`thread_id`, `tag_id`),
  KEY `idx_kb_thread_tag_tag` (`tag_id`),
  CONSTRAINT `fk_kb_thread_tag_thread` FOREIGN KEY (`thread_id`) REFERENCES `kb_threads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_thread_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `kb_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_thread_sources — which messages were compiled into this Q&A
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_thread_sources` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thread_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_thread_src` (`thread_id`, `message_id`),
  KEY `idx_kb_thread_src_msg` (`message_id`),
  CONSTRAINT `fk_kb_thread_src_thread` FOREIGN KEY (`thread_id`) REFERENCES `kb_threads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_thread_src_msg` FOREIGN KEY (`message_id`) REFERENCES `kb_messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_articles — curated articles
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_articles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(255) NOT NULL,
  `author_user_id` INT DEFAULT NULL,
  `status` ENUM('draft','published') NOT NULL DEFAULT 'draft',
  `title_sr` VARCHAR(500) DEFAULT NULL,
  `title_sr_cyrl` VARCHAR(500) DEFAULT NULL,
  `title_en` VARCHAR(500) DEFAULT NULL,
  `title_ru` VARCHAR(500) DEFAULT NULL,
  `title_de` VARCHAR(500) DEFAULT NULL,
  `title_tr` VARCHAR(500) DEFAULT NULL,
  `content_sr` MEDIUMTEXT DEFAULT NULL,
  `content_sr_cyrl` MEDIUMTEXT DEFAULT NULL,
  `content_en` MEDIUMTEXT DEFAULT NULL,
  `content_ru` MEDIUMTEXT DEFAULT NULL,
  `content_de` MEDIUMTEXT DEFAULT NULL,
  `content_tr` MEDIUMTEXT DEFAULT NULL,
  `views_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `published_at` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_article_slug` (`slug`),
  KEY `idx_kb_article_status` (`status`),
  CONSTRAINT `fk_kb_article_author` FOREIGN KEY (`author_user_id`) REFERENCES `auth_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_article_tags
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_article_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_article_tag` (`article_id`, `tag_id`),
  KEY `idx_kb_article_tag_tag` (`tag_id`),
  CONSTRAINT `fk_kb_article_tag_article` FOREIGN KEY (`article_id`) REFERENCES `kb_articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_article_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `kb_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_article_sources — which messages informed this article
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_article_sources` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_article_src` (`article_id`, `message_id`),
  KEY `idx_kb_article_src_msg` (`message_id`),
  CONSTRAINT `fk_kb_article_src_article` FOREIGN KEY (`article_id`) REFERENCES `kb_articles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_kb_article_src_msg` FOREIGN KEY (`message_id`) REFERENCES `kb_messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- kb_entity_links — generic polymorphic links to domain entities
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kb_entity_links` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `linkable_type` ENUM('message','thread','article') NOT NULL,
  `linkable_id` INT NOT NULL,
  `entity_type` VARCHAR(50) NOT NULL COMMENT 'doctor, clinic, specialty, medical_service',
  `entity_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_kb_entity_link` (`linkable_type`, `linkable_id`, `entity_type`, `entity_id`),
  KEY `idx_kb_entity_lookup` (`entity_type`, `entity_id`),
  KEY `idx_kb_entity_linkable` (`linkable_type`, `linkable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
