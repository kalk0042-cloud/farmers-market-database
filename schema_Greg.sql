
-- I wanted to add what I made for comparision. Greg --

Create DATABASE Farmers_Market;
Use farmers_market;
DROP TABLE IF EXISTS Market;
Create Table Market (
    market_id INT,
    market_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    address VARCHAR(150) NOT NULL,
    city VARCHAR(75) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    market_day VARCHAR(20),
    start_time time,
    end_time time,
    active bool,
    PRIMARY KEY (market_id)
);

DROP TABLE IF EXISTS Vendor;
CREATE TABLE Vendor (
    vendor_id INT,
    vendor_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    active bool,
    PRIMARY KEY (vendor_id)
);

DROP TABLE IF EXISTS MarketVendor;
CREATE TABLE MarketVendor (
    market_vendor_id INT,
    market_id INT NOT NULL,
    vendor_id INT NOT NULL,
    stall_number VARCHAR(20),
    active BOOL,
    PRIMARY KEY (market_vendor_id),
    FOREIGN KEY (market_id) REFERENCES market(market_id),
    FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id)
);

DROP TABLE IF EXISTS Product;
CREATE TABLE Product (
    product_id INT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description VARCHAR(255),
    PRIMARY KEY (product_id)
);
DROP TABLE IF EXISTS ProductOffering;
CREATE TABLE ProductOffering (
    offering_id INT,
    market_vendory_id INT NOT NULL,
    product_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_available INT NOT NULL,
    active bool,
    PRIMARY KEY (offering_id),
    FOREIGN KEY (market_vendory_id) REFERENCES marketvendor (market_vendor_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id)
);
DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
    customer_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS PreOrder;
CREATE TABLE PreOrder (
    preorder_id INT,
    customer_id INT NOT NULL,
    market_vendor_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    pickup_date DATE,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (preorder_id),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id),
    FOREIGN KEY (market_vendor_id) REFERENCES MarketVendor (market_vendor_id)
);
DROP TABLE IF EXISTS PreOrderItem;
CREATE TABLE PreOrderItem (
    preorder_item_id INT,
    preorder_id INT NOT NULL,
    offering_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (preorder_item_id),
    FOREIGN KEY (preorder_id) REFERENCES PreOrder (preorder_id),
    FOREIGN KEY (offering_id) REFERENCES ProductOffering (offering_id)
);










