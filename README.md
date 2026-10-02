# Farmers Market Database Application

## Database

## Project Proposal

### Project Overview

The Farmers Market Database Application will be a database-driven web application that allows customers to browse local farmers markets, view participating vendors, search for available products, and place product pre-orders.

The purpose of the project is to demonstrate the complete database development life cycle, including requirements analysis, database modeling, relational database design, database implementation, graphical user interface development, querying, and transaction processing.

The application will provide a graphical user interface so that users can interact with the database without directly entering SQL commands.

### Application Features

#### Browse Farmers Markets

Users will be able to view a list of farmers markets stored in the database. Market information may include the market name, address, city, state, operating day, hours, and description.

#### View Market Details and Vendors

Users will be able to select a farmers market to view more information about that location.

The market details page will also display the vendors participating in the selected market.

Because vendors may participate in more than one farmers market, the database uses a MarketVendor table to represent the many-to-many relationship between markets and vendors.

#### Search for Products

Users will be able to search for products across all participating farmers markets.

Search results will identify the product, vendor, farmers market, price, and current available quantity.

The ProductOffering table will associate products with a vendor at a specific farmers market and will store the price and inventory available at that location.

#### Customer Pre-Orders

Customers will be able to select an available product and place a pre-order for pickup from a participating vendor.

Each pre-order will include customer information, order date, pickup information, status, selected products, quantities, prices, and total cost.

#### Database Transaction Processing

The pre-order process will use a database transaction.

When a customer submits an order, the application will:

1. Verify that sufficient product inventory is available.
2. Create the pre-order record.
3. Create the associated pre-order item record or records.
4. Reduce the available quantity of each ordered product.
5. Commit the transaction when all operations succeed.

If any required database operation fails, the transaction will be rolled back so that an incomplete order or incorrect inventory update is not stored.

### Database Entities

The database design contains the following primary entities:

- Market
- Vendor
- MarketVendor
- Product
- ProductOffering
- Customer
- PreOrder
- PreOrderItem

The MarketVendor table resolves the many-to-many relationship between farmers markets and vendors.

The ProductOffering table connects products with vendors participating at specific farmers markets while storing product price and available inventory.

The PreOrder and PreOrderItem tables store customer orders and the individual products included within those orders.

### Planned User Interface

The completed application is expected to include the following pages:

1. Home page
2. Farmers market listing page
3. Market details and vendor page
4. Product search page
5. Product search results
6. Pre-order form
7. Pre-order confirmation page

### Planned Technology Stack

The project is planned as a web-based application using:

- Python
- Flask
- HTML
- CSS
- MySQL
- GitHub for source control
- GitHub Projects for project management

### Final Project Goal

The final application will demonstrate how a normalized relational database can support a practical farmers market management and pre-order system.

## Team Members

* Amber Kalk
* Gregory Lindberg
* Alexander Niemi

## Project Management

* Github Projects 
* 

<img width="1882" height="873" alt="Image" src="https://github.com/user-attachments/assets/80680121-540f-40c6-b5b8-741c1f30cbd5" />


Users will be able to browse markets, view participating vendors, search for products across markets, and submit pre-orders through a graphical interface while 
the application performs database queries and transaction processing behind the scenes.
