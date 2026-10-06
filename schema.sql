-- ============================================================
-- Farmers Market Database
-- schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS farmers_market_db;

USE farmers_market_db;

DROP TABLE IF EXISTS PreOrderItem;
DROP TABLE IF EXISTS PreOrder;
DROP TABLE IF EXISTS ProductOffering;
DROP TABLE IF EXISTS MarketVendor;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Vendor;
DROP TABLE IF EXISTS Market;

-- ============================================================
-- MARKET
-- Stores information about each farmers market
-- ============================================================

CREATE TABLE Market (
    market_id INT UNSIGNED AUTO_INCREMENT,
    market_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    address VARCHAR(150) NOT NULL,
    city VARCHAR(75) NOT NULL,
    state CHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    market_day VARCHAR(20),
    start_time TIME,
    end_time TIME,
    active BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (market_id)
);

-- ============================================================
-- VENDOR
-- Stores information about vendors participating in markets
-- ============================================================

CREATE TABLE Vendor (
    vendor_id INT UNSIGNED AUTO_INCREMENT,
    vendor_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    active BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (vendor_id)
);

-- ============================================================
-- PRODUCT
-- Stores the master list of available product types
-- ============================================================

CREATE TABLE Product (
    product_id INT UNSIGNED AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description VARCHAR(255),

    PRIMARY KEY (product_id)
);

-- ============================================================
-- CUSTOMER
-- Stores customer information for pre-orders
-- ============================================================

CREATE TABLE Customer (
    customer_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),

    PRIMARY KEY (customer_id),

    UNIQUE (email)
);

-- ============================================================
-- MARKETVENDOR
-- ============================================================

CREATE TABLE MarketVendor (
    market_vendor_id INT UNSIGNED AUTO_INCREMENT,
    market_id INT UNSIGNED NOT NULL,
    vendor_id INT UNSIGNED NOT NULL,
    stall_number VARCHAR(20),
    active BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (market_vendor_id),

    CONSTRAINT uq_market_vendor
        UNIQUE (market_id, vendor_id),

    CONSTRAINT fk_marketvendor_market
        FOREIGN KEY (market_id)
        REFERENCES Market(market_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_marketvendor_vendor
        FOREIGN KEY (vendor_id)
        REFERENCES Vendor(vendor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================================
-- PRODUCTOFFERING
-- ============================================================

CREATE TABLE ProductOffering (
    offering_id INT UNSIGNED AUTO_INCREMENT,
    market_vendor_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_available INT UNSIGNED NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (offering_id),

    CONSTRAINT uq_product_offering
        UNIQUE (market_vendor_id, product_id),

    CONSTRAINT fk_offering_marketvendor
        FOREIGN KEY (market_vendor_id)
        REFERENCES MarketVendor(market_vendor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_offering_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_quantity
        CHECK (quantity_available >= 0)
);

-- ============================================================
-- PREORDER
-- ============================================================

CREATE TABLE PreOrder (
    preorder_id INT UNSIGNED AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    market_vendor_id INT UNSIGNED NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pickup_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    PRIMARY KEY (preorder_id),

    CONSTRAINT fk_preorder_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_preorder_marketvendor
        FOREIGN KEY (market_vendor_id)
        REFERENCES MarketVendor(market_vendor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_preorder_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_preorder_status
        CHECK (
            status IN (
                'Pending',
                'Confirmed',
                'Ready',
                'Picked Up',
                'Cancelled'
            )
        )
);

-- ============================================================
-- PREORDERITEM
-- ============================================================

CREATE TABLE PreOrderItem (
    preorder_item_id INT UNSIGNED AUTO_INCREMENT,
    preorder_id INT UNSIGNED NOT NULL,
    offering_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (preorder_item_id),

    CONSTRAINT uq_preorder_item
        UNIQUE (preorder_id, offering_id),

    CONSTRAINT fk_preorderitem_preorder
        FOREIGN KEY (preorder_id)
        REFERENCES PreOrder(preorder_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_preorderitem_offering
        FOREIGN KEY (offering_id)
        REFERENCES ProductOffering(offering_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_preorderitem_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_preorderitem_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_preorderitem_line_total
        CHECK (line_total >= 0)
);


CREATE INDEX idx_market_city
ON Market(city);

CREATE INDEX idx_vendor_name
ON Vendor(vendor_name);

CREATE INDEX idx_product_name
ON Product(product_name);

CREATE INDEX idx_product_category
ON Product(category);

CREATE INDEX idx_preorder_customer
ON PreOrder(customer_id);

CREATE INDEX idx_preorder_status
ON PreOrder(status);
