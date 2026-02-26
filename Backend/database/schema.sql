-- Schema for project: create database and Food-Menu table
-- Note: table name contains a hyphen so identifiers are escaped with backticks

CREATE DATABASE IF NOT EXISTS `database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `database`;

-- Orders table for storing placed orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `items` JSON NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  `delivery` DECIMAL(10,2) DEFAULT 50.00,
  `tax` DECIMAL(10,2) NOT NULL,
  `grand_total` DECIMAL(10,2) NOT NULL,
  `status` VARCHAR(20) DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Food_Menu` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(50) DEFAULT NULL,
  `price` DECIMAL(8,2) DEFAULT 0.00,
  `discount` INT DEFAULT 0,
  `description` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert sample menu items (matches frontend categories and price range)
INSERT INTO `Food_Menu` (`name`, `category`, `price`, `discount`, `description`) VALUES
-- INDIAN
('Biryani Special 1', 'Indian', 250.00, 15, 'Fragrant rice with spices and tender meat'),
('Biryani Special 2', 'Indian', 240.00, 18, 'Hyderabadi style biryani with vegetables'),
('Biryani Special 3', 'Indian', 260.00, 12, 'Mughlai biryani with premium ingredients'),
('Biryani Special 4', 'Indian', 225.00, 20, 'Kolkata style biryani with egg'),
('Butter Chicken Special 1', 'Indian', 280.00, 10, 'Creamy tomato-based chicken curry'),
('Butter Chicken Special 2', 'Indian', 290.00, 15, 'Rich butter and cream sauce chicken'),
('Butter Chicken Special 3', 'Indian', 275.00, 12, 'Restaurant style butter chicken'),
('Butter Chicken Special 4', 'Indian', 285.00, 18, 'Special blend with cashew cream'),
('Paneer Tikka Special 1', 'Indian', 180.00, 25, 'Grilled paneer in tandoori spices'),
('Paneer Tikka Special 2', 'Indian', 190.00, 20, 'Marinated paneer with Indian herbs'),
('Paneer Tikka Special 3', 'Indian', 200.00, 15, 'Cottage cheese tikka with yogurt'),
('Paneer Tikka Special 4', 'Indian', 185.00, 22, 'Tandoori paneer with mint chutney'),

-- CHINESE
('Noodles Special 1', 'Chinese', 150.00, 20, 'Stir-fried noodles with vegetables'),
('Noodles Special 2', 'Chinese', 160.00, 15, 'Glass noodles with soy sauce'),
('Noodles Special 3', 'Chinese', 170.00, 18, 'Crispy noodles with gravy'),
('Noodles Special 4', 'Chinese', 155.00, 22, 'Hakka style egg noodles'),
('Fried Rice Special 1', 'Chinese', 140.00, 25, 'Chinese rice with mixed vegetables'),
('Fried Rice Special 2', 'Chinese', 150.00, 20, 'Egg fried rice with soy sauce'),
('Fried Rice Special 3', 'Chinese', 160.00, 15, 'Vegetable fried rice with spices'),
('Fried Rice Special 4', 'Chinese', 145.00, 18, 'Schezwan fried rice'),

-- ITALIAN
('Pizza Special 1', 'Italian', 220.00, 12, 'Margherita pizza with fresh basil'),
('Pizza Special 2', 'Italian', 250.00, 15, 'Pepperoni pizza with melted cheese'),
('Pizza Special 3', 'Italian', 240.00, 10, 'Veggie pizza with assorted vegetables'),
('Pizza Special 4', 'Italian', 280.00, 20, 'BBQ chicken pizza with bacon'),
('Pasta Special 1', 'Italian', 180.00, 18, 'Spaghetti Carbonara with cream sauce'),
('Pasta Special 2', 'Italian', 190.00, 15, 'Penne Arrabbiata with red sauce'),
('Pasta Special 3', 'Italian', 200.00, 12, 'Fettuccine Alfredo with garlic'),
('Pasta Special 4', 'Italian', 210.00, 20, 'Lasagna with layered meat sauce'),

-- FAST FOOD
('Burger Special 1', 'FastFood', 130.00, 25, 'Cheese burger with fresh lettuce'),
('Burger Special 2', 'FastFood', 140.00, 20, 'Double patty burger with sauce'),
('Burger Special 3', 'FastFood', 150.00, 18, 'Spicy chicken burger'),
('Burger Special 4', 'FastFood', 135.00, 22, 'Classic hamburger with condiments'),
('Fries Special 1', 'FastFood', 80.00, 30, 'Crispy french fries with salt'),
('Fries Special 2', 'FastFood', 100.00, 25, 'Cajun spiced fries'),
('Fries Special 3', 'FastFood', 110.00, 20, 'Cheese and bacon fries'),
('Fries Special 4', 'FastFood', 90.00, 28, 'Garlic herb fries'),

-- DESSERT
('Ice Cream Special 1', 'Dessert', 120.00, 20, 'Vanilla ice cream with chocolate'),
('Ice Cream Special 2', 'Dessert', 130.00, 15, 'Strawberry ice cream with toppings'),
('Ice Cream Special 3', 'Dessert', 140.00, 18, 'Mango ice cream sundae'),
('Ice Cream Special 4', 'Dessert', 125.00, 22, 'Butterscotch ice cream with nuts'),
('Cake Special 1', 'Dessert', 200.00, 12, 'Chocolate cake with frosting'),
('Cake Special 2', 'Dessert', 220.00, 15, 'Red velvet cake slice'),
('Cake Special 3', 'Dessert', 210.00, 18, 'Cheesecake with berries'),
('Cake Special 4', 'Dessert', 190.00, 20, 'Vanilla sponge cake'),

-- BEVERAGE
('Milkshake Special 1', 'Beverage', 110.00, 15, 'Chocolate milkshake with cream'),
('Milkshake Special 2', 'Beverage', 120.00, 18, 'Strawberry milkshake blend'),
('Milkshake Special 3', 'Beverage', 115.00, 12, 'Vanilla milkshake with nuts'),
('Milkshake Special 4', 'Beverage', 125.00, 20, 'Mango milkshake special'),
('Cold Coffee Special 1', 'Beverage', 100.00, 20, 'Iced coffee with whipped cream'),
('Cold Coffee Special 2', 'Beverage', 110.00, 15, 'Mocha cold coffee'),
('Cold Coffee Special 3', 'Beverage', 105.00, 18, 'Caramel cold coffee'),
('Cold Coffee Special 4', 'Beverage', 115.00, 25, 'Espresso cold coffee');