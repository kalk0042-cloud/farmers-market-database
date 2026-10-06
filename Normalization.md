Database Normalization

Farmers Market Database Application

Overview

The Farmers Market Database was designed using relational database normalization principles to reduce data duplication, prevent update anomalies, and maintain data integrity.

The schema is normalized through Third Normal Form (3NF).

The database contains the following core tables:

Market

Vendor

MarketVendor

Product

ProductOffering

Customer

PreOrder

PreOrderItem

Normalization was especially important because markets may contain many vendors, vendors may participate in many markets, vendors may offer many products, and customer orders may contain multiple products.

First Normal Form (1NF)

A table is in First Normal Form when:

Each table has a primary key.

Each column contains a single atomic value.

There are no repeating groups or multiple values stored in one field.

All tables in the Farmers Market Database satisfy 1NF.

For example, the Product table stores one product per row.

Instead of storing several products in one Vendor column such as:

Tomatoes, Corn, Eggs

products are stored individually in the Product table.

The relationship between vendors and products is represented through ProductOffering.

Similarly, an order does not store multiple products in a single column. Each product included in an order receives its own row in PreOrderItem.

This prevents repeating groups and keeps all values atomic.

Second Normal Form (2NF)

A table is in Second Normal Form when:

It is already in First Normal Form.

Every non-key attribute depends on the entire primary key rather than only part of it.

The Farmers Market Database satisfies 2NF because each table stores attributes that depend on its identifying key.

For example, the Product table contains:

product_id

product_name

category

description

The product name, category, and description all describe the product identified by product_id.

Vendor information is not stored in Product because vendor information depends on vendor_id rather than product_id.

The same principle applies to Market, Customer, Vendor, PreOrder, and the other tables.

Third Normal Form (3NF)

A table is in Third Normal Form when:

It satisfies Second Normal Form.

Non-key attributes depend only on the primary key.

Non-key attributes do not depend on other non-key attributes.

The Farmers Market Database achieves 3NF by separating information into entities based on what each fact describes.

Product Normalization

The Product table contains:

product_id

product_name

category

description

Each non-key attribute describes only the product identified by product_id.

The Product table does not contain:

vendor_name

market_name

product price

quantity available

Those values depend on other entities or relationships.

For example, price and quantity available may change depending on which vendor is selling the product and at which market it is being sold.

For that reason, price and inventory are stored in ProductOffering rather than Product.

This prevents duplicate product information and allows the same product to be offered by multiple vendors.

Vendor and Market Normalization

Market and Vendor have a many-to-many relationship.

One farmers market may have many vendors, and one vendor may participate in several farmers markets.

Instead of placing multiple vendor IDs inside Market or multiple market IDs inside Vendor, the database uses the MarketVendor junction table.

MarketVendor contains:

market_vendor_id

market_id

vendor_id

stall_number

active

This structure eliminates repeating groups and properly represents the many-to-many relationship.

The market name and address are stored only in Market.

The vendor name, email, and phone number are stored only in Vendor.

Therefore, changes to a market or vendor can be made in one location instead of being repeated throughout the database.

ProductOffering Normalization

The ProductOffering table represents a product being sold by a particular vendor at a particular market.

It contains:

offering_id

market_vendor_id

product_id

price

quantity_available

active

Price and quantity_available are stored here because those values describe the specific product offering.

For example, one vendor could sell tomatoes for $4.00 at one farmers market while another vendor sells tomatoes for $5.00.

The Product table should not contain a single tomato price because the price is not a property of tomatoes in general. It is a property of a specific vendor's offering.

This separation removes transitive dependencies and keeps the design in 3NF.

Customer Normalization

The Customer table stores:

customer_id

first_name

last_name

email

phone

Each of these attributes describes only the customer identified by customer_id.

Customer information is not repeated in every order.

Instead, PreOrder stores customer_id as a foreign key.

For example, the system does not need to repeat a customer's first name, last name, email address, and phone number each time that customer places an order.

This reduces duplication and prevents inconsistent customer information.

PreOrder Normalization

The PreOrder table represents the overall order.

It contains:

preorder_id

customer_id

market_vendor_id

order_date

pickup_date

status

total_amount

The order does not store customer names or vendor names directly.

Instead:

customer_id references Customer.

market_vendor_id references MarketVendor.

This ensures customer, vendor, and market details remain stored in their appropriate tables.

The PreOrder table therefore contains only information that directly describes the order.

PreOrderItem Normalization

A single pre-order may contain more than one product.

Instead of creating columns such as:

product1

product2

product3

or storing several products inside one field, the database uses the PreOrderItem table.

PreOrderItem contains:

preorder_item_id

preorder_id

offering_id

quantity

unit_price

line_total

Each row represents one product offering included in one pre-order.

This allows an order to contain any number of items without changing the table structure.

The preorder_id foreign key identifies which order the item belongs to, while offering_id identifies the particular product offering being purchased.

Prevention of Database Anomalies

Normalization also helps prevent common database anomalies.

Update Anomaly

Without normalization, a vendor's phone number might appear in many different product or market records.

Changing the phone number would require updating every occurrence.

In this design, the phone number is stored once in Vendor.

Insert Anomaly

A new product can be added to Product even if it has not yet been offered at a farmers market.

The product does not require duplicate vendor or market information simply to exist.

Delete Anomaly

Deleting a ProductOffering does not delete the Product itself.

For example, if a vendor temporarily stops selling tomatoes, the product "Tomatoes" can remain in the Product table for use by other vendors.

Likewise, deleting an order does not remove the customer's main record.

Primary Keys and Foreign Keys

Each table has a primary key that uniquely identifies each record.

Examples include:

Market.market_id

Vendor.vendor_id

Product.product_id

Customer.customer_id

PreOrder.preorder_id

Foreign keys establish relationships between the tables.

Examples include:

MarketVendor.market_id → Market.market_id

MarketVendor.vendor_id → Vendor.vendor_id

ProductOffering.product_id → Product.product_id

PreOrder.customer_id → Customer.customer_id

PreOrderItem.preorder_id → PreOrder.preorder_id

These relationships help maintain referential integrity and prevent records from referencing nonexistent data.

Conclusion

The Farmers Market Database satisfies Third Normal Form because each table represents a distinct entity or relationship, each non-key attribute depends on the table's key, and attributes that belong to other entities are stored in separate related tables.

The normalized structure reduces unnecessary duplication, improves data consistency, and supports the application's required features, including:

Browsing farmers markets

Viewing vendors at a market

Searching for products across markets

Tracking product availability

Creating customer pre-orders

Processing orders through database transactions

This structure provides a scalable and maintainable foundation for the final Farmers Market application.
