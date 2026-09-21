-- ============================================================================
-- CommerceBase — Database Schema
-- White-Label, Enterprise-Grade E-Commerce Platform
-- ============================================================================
-- Run this script against your MySQL server to initialise the database.
--
--   mysql -u root -p < database/schema.sql
--
-- ============================================================================

-- Create the database (idempotent)
CREATE DATABASE IF NOT EXISTS commercebase
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE commercebase;

-- ============================================================================
-- 1. StoreConfig — White-label branding & configuration
-- ============================================================================
CREATE TABLE IF NOT EXISTS StoreConfig (
    config_id       INT             AUTO_INCREMENT PRIMARY KEY,
    store_name      VARCHAR(150)    NOT NULL,
    logo_url        VARCHAR(500)    DEFAULT '/assets/img/default-logo.png',
    theme_color     VARCHAR(7)      NOT NULL DEFAULT '#4F46E5'  COMMENT 'Hex colour code',
    tagline         VARCHAR(255)    DEFAULT '',
    contact_email   VARCHAR(255)    DEFAULT '',
    currency_code   CHAR(3)         NOT NULL DEFAULT 'INR',
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================================
-- 2. Users — Authentication & RBAC
-- ============================================================================
CREATE TABLE IF NOT EXISTS Users (
    user_id         INT             AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    password_hash   VARCHAR(255)    NOT NULL  COMMENT 'SHA-256 hashed password',
    phone           VARCHAR(20)     DEFAULT NULL,
    address         TEXT            DEFAULT NULL,
    role            ENUM('Admin', 'Customer') NOT NULL DEFAULT 'Customer',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================================
-- 3. Categories — Product categorisation
-- ============================================================================
CREATE TABLE IF NOT EXISTS Categories (
    category_id     INT             AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(100)    NOT NULL UNIQUE,
    description     TEXT            DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================================
-- 4. Products
-- ============================================================================
CREATE TABLE IF NOT EXISTS Products (
    product_id      INT             AUTO_INCREMENT PRIMARY KEY,
    category_id     INT             DEFAULT NULL,
    product_name    VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    price           DECIMAL(10,2)   NOT NULL CHECK (price >= 0),
    stock_quantity  INT             NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    image_url       VARCHAR(500)    DEFAULT '/assets/img/default-product.png',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES Categories(category_id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================================
-- 5. Orders
-- ============================================================================
CREATE TABLE IF NOT EXISTS Orders (
    order_id        INT             AUTO_INCREMENT PRIMARY KEY,
    user_id         INT             NOT NULL,
    total_amount    DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    status          ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')
                                    NOT NULL DEFAULT 'Pending',
    shipping_address TEXT           NOT NULL,
    payment_method  VARCHAR(50)     DEFAULT 'COD'  COMMENT 'COD | UPI | Card',
    ordered_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================================
-- 6. OrderItems — Maps the many-to-many between Orders and Products
-- ============================================================================
CREATE TABLE IF NOT EXISTS OrderItems (
    item_id         INT             AUTO_INCREMENT PRIMARY KEY,
    order_id        INT             NOT NULL,
    product_id      INT             NOT NULL,
    quantity        INT             NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price      DECIMAL(10,2)   NOT NULL  COMMENT 'Price at time of order',
    subtotal        DECIMAL(12,2)   GENERATED ALWAYS AS (quantity * unit_price) STORED,

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- 7. Seed Data
-- ============================================================================

-- Default store configuration
INSERT INTO StoreConfig (store_name, logo_url, theme_color, tagline, contact_email, currency_code)
VALUES
    ('CommerceBase Store', '/assets/img/default-logo.png', '#4F46E5',
     'Your One-Stop Online Shop', 'admin@commercebase.local', 'INR');

-- Default Admin user  (password: Admin@123  →  SHA-256 hash)
INSERT INTO Users (full_name, email, password_hash, phone, role)
VALUES
    ('System Admin', 'admin@commercebase.local',
     'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7',
     '9999999999', 'Admin');

-- Sample Customer
INSERT INTO Users (full_name, email, password_hash, phone, address, role)
VALUES
    ('Rahul Sharma', 'rahul@example.com',
     '98ec654a8df28f8f0f8f02220483d46916b85017de0b74d8ec755c28cb8539a8',
     '9876543210', '221B Baker Street, Mumbai, MH 400001', 'Customer');

-- Sample Categories
INSERT INTO Categories (category_name, description) VALUES
    ('Electronics', 'Gadgets, phones, laptops and accessories'),
    ('Clothing',    'Men & Women apparel'),
    ('Books',       'Fiction, non-fiction, and academic books');

-- Sample Products
INSERT INTO Products (category_id, product_name, description, price, stock_quantity) VALUES
    (1, 'Wireless Bluetooth Earbuds',  'Noise-cancelling TWS earbuds with 24h battery life',  1499.00, 150),
    (1, 'USB-C Fast Charger 65W',      'GaN charger compatible with laptops and phones',        899.00, 200),
    (2, 'Classic Polo T-Shirt',        '100% cotton, available in 5 colours',                   599.00, 300),
    (3, 'Data Structures with Java',   'Comprehensive guide for BCA/MCA students',              450.00,  80);

-- ============================================================================
-- End of schema
-- ============================================================================
