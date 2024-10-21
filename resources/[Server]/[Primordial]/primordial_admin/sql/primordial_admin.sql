-- SQLBook: Code
CREATE TABLE IF NOT EXISTS `primordial_warns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `author` VARCHAR(40) DEFAULT NULL,
  `player` VARCHAR(40) DEFAULT NULL,
  `license` VARCHAR(50) DEFAULT NULL,
  `ip` VARCHAR(25) DEFAULT NULL,
  `discord` VARCHAR(40) DEFAULT NULL,
  `reason` VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `primordial_bans` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `author` VARCHAR(40) DEFAULT NULL,
  `player` VARCHAR(40) DEFAULT NULL,
  `license` VARCHAR(50) DEFAULT NULL,
  `ip` VARCHAR(25) DEFAULT NULL,
  `discord` VARCHAR(40) DEFAULT NULL,
  `reason` VARCHAR(100) DEFAULT NULL,
  `ban_time` INT(50) NOT NULL,
  `expiration_time` VARCHAR(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `primordial_reports` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `author` VARCHAR(40) NOT NULL,
    `author_discord` VARCHAR(40) NOT NULL,
    `author_license` VARCHAR(50) NOT NULL,
    `reportType` ENUM('player', 'staff') NOT NULL,
    `reason_title` VARCHAR(50) NOT NULL,
    `reason_message` VARCHAR(255) NOT NULL,
    `report_time` TIME NOT NULL,
    `report_date` DATE NOT NULL,
    `is_claimed` BOOLEAN DEFAULT FALSE,
    `claim_admin_name` VARCHAR(40) DEFAULT NULL,
    `claim_time` TIME DEFAULT NULL,
    `claim_date` DATE DEFAULT NULL,
    `is_closed` BOOLEAN DEFAULT FALSE,
    `close_time` TIME DEFAULT NULL,
    `close_date` DATE DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;