SET FOREIGN_KEY_CHECKS = 0;

UPDATE `config` SET `value`='2.2.0-alpha1' WHERE `name`='thelia_version';
UPDATE `config` SET `value`='2' WHERE `name`='thelia_major_version';
UPDATE `config` SET `value`='2' WHERE `name`='thelia_minus_version';
UPDATE `config` SET `value`='0' WHERE `name`='thelia_release_version';
UPDATE `config` SET `value`='alpha1' WHERE `name`='thelia_extra_version';

-- admin hooks

SELECT @max_id := IFNULL(MAX(`id`),0) FROM `hook`;

INSERT INTO `hook` (`id`, `code`, `type`, `by_module`, `block`, `native`, `activate`, `position`, `created_at`, `updated_at`) VALUES
  (@max_id + 1, 'order.tab', 2, 0, 1, 1, 1, 1, NOW(), NOW())
;

INSERT INTO  `hook_i18n` (`id`, `locale`, `title`, `description`, `chapo`) VALUES
  (@max_id + 1, 'fr_FR', 'Commande - Onglet', '', ''),
  (@max_id + 1, 'en_US', 'Order - Tab', '', '')
;

SELECT @max_id := MAX(`id`) FROM `order_status`;

INSERT INTO `order_status` VALUES
  (@max_id + 1, "refunded", NOW(), NOW())
;

INSERT INTO  `order_status_i18n` VALUES
  (@max_id + 1, "en_US", "Refunded", "", "", ""),
  (@max_id + 1, "fr_FR", "Remboursée", "", "", "")
;

-- new column in admin_log

ALTER TABLE `admin_log` ADD `resource_id` INTEGER AFTER `resource` ;

-- new config

SELECT @max_id := IFNULL(MAX(`id`),0) FROM `config`;

INSERT INTO `config` (`id`, `name`, `value`, `secured`, `hidden`, `created_at`, `updated_at`) VALUES
(@max_id + 1, 'customer_change_email', '0', 0, 0, NOW(), NOW()),
(@max_id + 2, 'customer_confirm_email', '0', 0, 0, NOW(), NOW())
;

INSERT INTO `config_i18n` (`id`, `locale`, `title`, `description`, `chapo`, `postscriptum`) VALUES
(@max_id + 1, 'en_US', 'Allow customers to change their email. 1 for yes, 0 for no', NULL, NULL, NULL),
(@max_id + 1, 'fr_FR', 'Permettre aux clients de changer leur email. 1 pour oui, 0 pour non', NULL, NULL, NULL),
(@max_id + 2, 'en_US', 'Ask the customers to confirm their email, 1 for yes, 0 for no', NULL, NULL, NULL),
(@max_id + 2, 'fr_FR', 'Demander aux clients de confirmer leur email. 1 pour oui, 0 pour non', NULL, NULL, NULL)
;

-- country area table

create table `country_area`
(
    `country_id` INTEGER NOT NULL,
    `area_id` INTEGER NOT NULL,
    `created_at` DATETIME,
    `updated_at` DATETIME,
    INDEX `country_area_area_id_idx` (`area_id`),
    INDEX `fk_country_area_country_id_idx` (`country_id`),
    CONSTRAINT `fk_country_area_area_id`
        FOREIGN KEY (`area_id`)
        REFERENCES `area` (`id`)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,
    CONSTRAINT `fk_country_area_country_id`
        FOREIGN KEY (`country_id`)
        REFERENCES `country` (`id`)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET='utf8';

-- Initialize the table with existing data
INSERT INTO `country_area` (`country_id`, `area_id`, `created_at`, `updated_at`) select `id`, `area_id`, NOW(), NOW() FROM `country` WHERE `area_id` IS NOT NULL;

-- Remove area_id column from country table
ALTER TABLE `country` DROP `area_id`;

-- new hook --
SELECT @max_id := IFNULL(MAX(`id`),0) FROM `hook`;

INSERT INTO `hook` (`id`, `code`, `type`, `by_module`, `block`, `native`, `activate`, `position`, `created_at`, `updated_at`) VALUES
(@max_id + 1, 'profile.table-header', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 2, 'profile.table-row', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 3, 'import.table-header', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 4, 'import.table-row', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 5, 'export.table-header', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 6, 'export.table-row', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 7, 'category-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 8, 'category-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 9, 'brand-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 10, 'brand-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 11, 'attribute-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 12, 'attribute-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 13, 'currency-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 14, 'currency-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 15, 'country-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 16, 'country-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 17, 'content-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 18, 'content-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 19, 'feature-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 20, 'feature-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 21, 'document-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 22, 'document-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 23, 'customer-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 24, 'customer-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 25, 'image-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 26, 'image-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 27, 'hook-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 28, 'hook-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 29, 'folder-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 30, 'folder-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 31, 'module-hook-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 32, 'module-hook-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 33, 'module-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 34, 'module-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 35, 'message-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 36, 'message-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 37, 'profile-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 38, 'profile-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 39, 'product-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 40, 'product-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 41, 'order-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 42, 'order-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 43, 'shipping-zones-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 44, 'shipping-zones-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 45, 'shipping-configuration-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 46, 'shipping-configuration-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 47, 'sale-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 48, 'sale-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 49, 'variables-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 50, 'variables-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 51, 'template-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 52, 'template-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 53, 'tax-rule-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 54, 'tax-rule-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 55, 'tax-edit.top', 2, 0, 0, 1, 1, 1, NOW(), NOW()),
(@max_id + 56, 'tax-edit.bottom', 2, 0, 0, 1, 1, 1, NOW(), NOW())
;


INSERT INTO  `hook_i18n` (`id`, `locale`, `title`, `description`, `chapo`) VALUES
(@max_id + 1, 'fr_FR', 'Profil - colonne tableau', '', ''),
(@max_id + 1, 'en_US', 'Profile - table header', '', ''),
(@max_id + 2, 'fr_FR', 'Profil - ligne du tableau', '', ''),
(@max_id + 2, 'en_US', 'Profile - table row', '', ''),
(@max_id + 3, 'fr_FR', 'Import - colonne tableau', '', ''),
(@max_id + 3, 'en_US', 'Import - table header', '', ''),
(@max_id + 4, 'fr_FR', 'Import - ligne du tableau', '', ''),
(@max_id + 4, 'en_US', 'Import - table row', '', ''),
(@max_id + 5, 'fr_FR', 'Export - colonne tableau', '', ''),
(@max_id + 5, 'en_US', 'Export - table header', '', ''),
(@max_id + 6, 'fr_FR', 'Export - ligne du tableau', '', ''),
(@max_id + 6, 'en_US', 'Export - table row', '', ''),
(@max_id + 7, 'fr_FR', 'Edition d\'une categorie - en haut', '', ''),
(@max_id + 7, 'en_US', 'Category edit - top', '', ''),
(@max_id + 8, 'fr_FR', 'Edition d\'une categorie - en bas', '', ''),
(@max_id + 8, 'en_US', 'Category edit - bottom', '', ''),
(@max_id + 9, 'fr_FR', 'Edition d\'une marque - en haut', '', ''),
(@max_id + 9, 'en_US', 'Brand edit - top', '', ''),
(@max_id + 10, 'fr_FR', 'Edition d\'une marque - en bas', '', ''),
(@max_id + 10, 'en_US', 'Brand edit - bottom', '', ''),
(@max_id + 11, 'fr_FR', 'Edition d\'une déclinaison - en haut', '', ''),
(@max_id + 11, 'en_US', 'Attribute edit - top', '', ''),
(@max_id + 12, 'fr_FR', 'Edition d\'une déclinaison - en bas', '', ''),
(@max_id + 12, 'en_US', 'Attribute edit - bottom', '', ''),
(@max_id + 13, 'fr_FR', 'Edition d\'une devise - en haut', '', ''),
(@max_id + 13, 'en_US', 'Currency edit - top', '', ''),
(@max_id + 14, 'fr_FR', 'Edition d\'une devise - en bas', '', ''),
(@max_id + 14, 'en_US', 'Currency edit - bottom', '', ''),
(@max_id + 15, 'fr_FR', 'Edition d\'un pays - en haut', '', ''),
(@max_id + 15, 'en_US', 'Country edit - top', '', ''),
(@max_id + 16, 'fr_FR', 'Edition d\'un pays - en bas', '', ''),
(@max_id + 16, 'en_US', 'Country edit - bottom', '', ''),
(@max_id + 17, 'fr_FR', 'Edition d\'un contenu - en haut', '', ''),
(@max_id + 17, 'en_US', 'Content edit - top', '', ''),
(@max_id + 18, 'fr_FR', 'Edition d\'un contenu - en bas', '', ''),
(@max_id + 18, 'en_US', 'Content edit - bottom', '', ''),
(@max_id + 19, 'fr_FR', 'Edition d\'une caractéristique - en haut', '', ''),
(@max_id + 19, 'en_US', 'Feature edit - top', '', ''),
(@max_id + 20, 'fr_FR', 'Edition d\'une caractéristique - en bas', '', ''),
(@max_id + 20, 'en_US', 'Feature edit - bottom', '', ''),
(@max_id + 21, 'fr_FR', 'Edition d\'un document - en haut', '', ''),
(@max_id + 21, 'en_US', 'Document edit - top', '', ''),
(@max_id + 22, 'fr_FR', 'Edition d\'un document - en bas', '', ''),
(@max_id + 22, 'en_US', 'Document edit - bottom', '', ''),
(@max_id + 23, 'fr_FR', 'Edition d\'un client - en haut', '', ''),
(@max_id + 23, 'en_US', 'Client edit - top', '', ''),
(@max_id + 24, 'fr_FR', 'Edition d\'un client - en bas', '', ''),
(@max_id + 24, 'en_US', 'Client edit - bottom', '', ''),
(@max_id + 25, 'fr_FR', 'Edition d\'image - en haut', '', ''),
(@max_id + 25, 'en_US', 'Image edit - top', '', ''),
(@max_id + 26, 'fr_FR', 'Edition d\'image - en bas', '', ''),
(@max_id + 26, 'en_US', 'Image edit - bottom', '', ''),
(@max_id + 27, 'fr_FR', 'Edition d\'hook - en haut', '', ''),
(@max_id + 27, 'en_US', 'Hook edit - top', '', ''),
(@max_id + 28, 'fr_FR', 'Edition d\'hook - en bas', '', ''),
(@max_id + 28, 'en_US', 'Hook edit - bottom', '', ''),
(@max_id + 29, 'fr_FR', 'Edition d\'un dossier - en haut', '', ''),
(@max_id + 29, 'en_US', 'Folder edit - top', '', ''),
(@max_id + 30, 'fr_FR', 'Edition d\'un dossier - en bas', '', ''),
(@max_id + 30, 'en_US', 'Folder edit - bottom', '', ''),
(@max_id + 31, 'fr_FR', 'Edition d\'un hook de module - en haut', '', ''),
(@max_id + 31, 'en_US', 'Module hook edit - top', '', ''),
(@max_id + 32, 'fr_FR', 'Edition d\'un hook de module - en bas', '', ''),
(@max_id + 32, 'en_US', 'Module hook edit - bottom', '', ''),
(@max_id + 33, 'fr_FR', 'Edition d\'un module - en haut', '', ''),
(@max_id + 33, 'en_US', 'Module edit - top', '', ''),
(@max_id + 34, 'fr_FR', 'Edition d\'un module - en bas', '', ''),
(@max_id + 34, 'en_US', 'Module edit - bottom', '', ''),
(@max_id + 35, 'fr_FR', 'Edition d\'un message - en haut', '', ''),
(@max_id + 35, 'en_US', 'Message edit - top', '', ''),
(@max_id + 36, 'fr_FR', 'Edition d\'un message - en bas', '', ''),
(@max_id + 36, 'en_US', 'Message edit - bottom', '', ''),
(@max_id + 37, 'fr_FR', 'Edition d\'un profil - en haut', '', ''),
(@max_id + 37, 'en_US', 'Profile edit - top', '', ''),
(@max_id + 38, 'fr_FR', 'Edition d\'un profil - en bas', '', ''),
(@max_id + 38, 'en_US', 'Profile edit - bottom', '', ''),
(@max_id + 39, 'fr_FR', 'Edition d\'un produit - en haut', '', ''),
(@max_id + 39, 'en_US', 'Product edit - top', '', ''),
(@max_id + 40, 'fr_FR', 'Edition d\'un produit - en bas', '', ''),
(@max_id + 40, 'en_US', 'Product edit - bottom', '', ''),
(@max_id + 41, 'fr_FR', 'Edition d\'une commande - en haut', '', ''),
(@max_id + 41, 'en_US', 'Order edit - top', '', ''),
(@max_id + 42, 'fr_FR', 'Edition d\'une commande - en bas', '', ''),
(@max_id + 42, 'en_US', 'Order edit - bottom', '', ''),
(@max_id + 43, 'fr_FR', 'Edition des zones de livraison d\'un transporteur - en haut', '', ''),
(@max_id + 43, 'en_US', 'Shipping zones edit - top', '', ''),
(@max_id + 44, 'fr_FR', 'Edition des zones de livraison d\'un transporteur - en bas', '', ''),
(@max_id + 44, 'en_US', 'Shipping zones edit - bottom', '', ''),
(@max_id + 45, 'fr_FR', 'Edition d\'une zone de livraison - en haut', '', ''),
(@max_id + 45, 'en_US', 'Shipping configuration edit - top', '', ''),
(@max_id + 46, 'fr_FR', 'Edition d\'une zone de livraiso - en bas', '', ''),
(@max_id + 46, 'en_US', 'Shipping configuration edit - bottom', '', ''),
(@max_id + 47, 'fr_FR', 'Edition d\'une promotion - en haut', '', ''),
(@max_id + 47, 'en_US', 'Sale edit - top', '', ''),
(@max_id + 48, 'fr_FR', 'Edition d\'une promotion - en bas', '', ''),
(@max_id + 48, 'en_US', 'Sale edit - bottom', '', ''),
(@max_id + 49, 'fr_FR', 'Edition d\'une variable - en haut', '', ''),
(@max_id + 49, 'en_US', 'Variable edit - top', '', ''),
(@max_id + 50, 'fr_FR', 'Edition d\'une variable - en bas', '', ''),
(@max_id + 50, 'en_US', 'Variable edit - bottom', '', ''),
(@max_id + 51, 'fr_FR', 'Edition d\'un gabarit - en haut', '', ''),
(@max_id + 51, 'en_US', 'Template edit - top', '', ''),
(@max_id + 52, 'fr_FR', 'Edition d\'un gabarit - en bas', '', ''),
(@max_id + 52, 'en_US', 'Template edit - bottom', '', ''),
(@max_id + 53, 'fr_FR', 'Edition d\'une règle de tax - en haut', '', ''),
(@max_id + 53, 'en_US', 'Tax rule edit - top', '', ''),
(@max_id + 54, 'fr_FR', 'Edition d\'une règle de tax - en bas', '', ''),
(@max_id + 54, 'en_US', 'Tax rule edit - bottom', '', ''),
(@max_id + 55, 'fr_FR', 'Edition d\'une tax - en haut', '', ''),
(@max_id + 55, 'en_US', 'Tax edit - top', '', ''),
(@max_id + 56, 'fr_FR', 'Edition d\'une tax - en bas', '', ''),
(@max_id + 56, 'en_US', 'Tax edit - bottom', '', '')
;

SET FOREIGN_KEY_CHECKS = 1;