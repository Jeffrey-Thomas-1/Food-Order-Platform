-- Schema for project: create database and Food-Menu table
-- Note: table name contains a hyphen so identifiers are escaped with backticks

CREATE DATABASE IF NOT EXISTS `database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `database`;

CREATE TABLE IF NOT EXISTS `Food_Menu` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(50) DEFAULT NULL,
  `price` DECIMAL(8,2) DEFAULT 0.00,
  `description` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample menu items (matches detail cards in the frontend)
INSERT INTO `Food_Menu` (`name`, `category`, `price`, `description`) VALUES
('Cabbage', 'Vegetable', 1.50, 'Fresh cabbage, local produce'),
('Apple', 'Fruit', 0.99, 'Crisp and sweet apple'),
('Orange', 'Fruit', 1.20, 'Juicy orange'),
('Briyani', 'Main', 6.50, 'Spiced rice with choice of meat or vegetables'),
('Fried Rice', 'Main', 5.00, 'Stir-fried rice with vegetables and egg'),
('Ramen', 'Main', 6.00, 'Noodle soup with savory broth'),
('Cheese Burger', 'Main', 0.00, NULL),
('Veg Pizza', 'Main', 0.00, NULL),
('Cold Coffee', 'Drinks', 0.00, NULL);