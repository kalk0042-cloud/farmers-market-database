USE farmers_market_db;

DELETE FROM PreOrderItem;
DELETE FROM PreOrder;
DELETE FROM ProductOffering;
DELETE FROM MarketVendor;
DELETE FROM Customer;
DELETE FROM Product;
DELETE FROM Vendor;
DELETE FROM Market;


INSERT INTO Market
(market_id, market_name, description, address, city, state, zip_code, market_day, start_time, end_time, active)
VALUES
(1, 'Ramsey Farmers Market', 'Local produce, baked goods, flowers, and artisan foods.', '7550 Sunwood Dr NW', 'Ramsey', 'MN', '55303', 'Saturday', '08:00:00', '13:00:00', TRUE),
(2, 'Anoka Community Market', 'Seasonal farmers market featuring local growers and makers.', '2015 1st Ave', 'Anoka', 'MN', '55303', 'Thursday', '15:00:00', '19:00:00', TRUE),
(3, 'Elk River Farmers Market', 'Family-friendly market with produce, meat, honey, and crafts.', '716 Main St NW', 'Elk River', 'MN', '55330', 'Thursday', '15:00:00', '19:00:00', TRUE),
(4, 'Maple Grove Farmers Market', 'Fresh Minnesota-grown food and locally made products.', '12951 Weaver Lake Rd', 'Maple Grove', 'MN', '55369', 'Thursday', '15:00:00', '19:00:00', TRUE),
(5, 'Brooklyn Park Farmers Market', 'Neighborhood market offering fresh food from regional farmers.', '5600 85th Ave N', 'Brooklyn Park', 'MN', '55443', 'Wednesday', '14:00:00', '18:00:00', TRUE),
(6, 'Blaine Farmers Market', 'Weekly market featuring vegetables, fruit, bakery items, and more.', '10801 Town Square Dr NE', 'Blaine', 'MN', '55449', 'Saturday', '09:00:00', '14:00:00', TRUE),
(7, 'Coon Rapids Farmers Market', 'Community farmers market with locally grown and handmade products.', '11155 Robinson Dr NW', 'Coon Rapids', 'MN', '55433', 'Wednesday', '15:00:00', '19:00:00', TRUE),
(8, 'Champlin Farmers Market', 'Small local market focused on fresh produce and specialty foods.', '11955 Champlin Dr', 'Champlin', 'MN', '55316', 'Tuesday', '15:00:00', '19:00:00', TRUE),
(9, 'Andover Farmers Market', 'Local vendors offering produce, meat, eggs, baked goods, and honey.', '1685 Crosstown Blvd NW', 'Andover', 'MN', '55304', 'Saturday', '09:00:00', '13:00:00', TRUE),
(10, 'Saint Michael Farmers Market', 'Seasonal community market serving Saint Michael and nearby areas.', '11800 Town Center Dr NE', 'Saint Michael', 'MN', '55376', 'Thursday', '15:00:00', '19:00:00', TRUE);


INSERT INTO Vendor
(vendor_id, vendor_name, description, phone, email, active)
VALUES
(1, 'North Star Produce Farm', 'Seasonal vegetables and herbs grown in central Minnesota.', '763-555-0101', 'northstar@example.com', TRUE),
(2, 'Sunny Acres Orchard', 'Apples, berries, and seasonal fruit.', '763-555-0102', 'sunnyacres@example.com', TRUE),
(3, 'Prairie Gold Honey', 'Raw local honey and beeswax products.', '763-555-0103', 'prairiegold@example.com', TRUE),
(4, 'Riverbend Family Farm', 'Mixed vegetables, sweet corn, and pumpkins.', '763-555-0104', 'riverbend@example.com', TRUE),
(5, 'Maple Lane Bakery', 'Fresh breads, muffins, cookies, and pies.', '763-555-0105', 'maplelane@example.com', TRUE),
(6, 'Green Valley Organics', 'Organic greens, root vegetables, and herbs.', '763-555-0106', 'greenvalley@example.com', TRUE),
(7, 'Twin Pines Poultry', 'Farm-fresh eggs and locally raised poultry.', '763-555-0107', 'twinpines@example.com', TRUE),
(8, 'Lakeside Dairy Farm', 'Cheese, butter, yogurt, and other dairy products.', '763-555-0108', 'lakesidedairy@example.com', TRUE),
(9, 'Harvest Moon Farm', 'Seasonal vegetables and fall produce.', '763-555-0109', 'harvestmoon@example.com', TRUE),
(10, 'Wildflower Gardens', 'Cut flowers, herbs, and edible flowers.', '763-555-0110', 'wildflower@example.com', TRUE),
(11, 'Red Barn Beef', 'Locally raised beef and specialty meat products.', '763-555-0111', 'redbarnbeef@example.com', TRUE),
(12, 'Morning Dew Produce', 'Fresh vegetables, melons, and berries.', '763-555-0112', 'morningdew@example.com', TRUE),
(13, 'Minnesota Maple Co', 'Pure maple syrup and maple products.', '763-555-0113', 'mnmaple@example.com', TRUE),
(14, 'Stone Mill Pantry', 'Jams, pickles, salsa, and preserved foods.', '763-555-0114', 'stonemill@example.com', TRUE),
(15, 'Cedar Creek Mushrooms', 'Fresh culinary mushrooms grown locally.', '763-555-0115', 'cedarcreek@example.com', TRUE),
(16, 'Golden Grain Farm', 'Whole grains, flour, and farm-grown dry beans.', '763-555-0116', 'goldengrain@example.com', TRUE),
(17, 'Blue Sky Berry Farm', 'Strawberries, blueberries, raspberries, and jam berries.', '763-555-0117', 'blueskyberry@example.com', TRUE),
(18, 'Oak Hill Herbs', 'Fresh herbs, garlic, and specialty greens.', '763-555-0118', 'oakhill@example.com', TRUE),
(19, 'Country Crust Bakery', 'Sourdough bread, rolls, pastries, and cookies.', '763-555-0119', 'countrycrust@example.com', TRUE),
(20, 'Meadowbrook Farmstead', 'Eggs, vegetables, cheese, and seasonal farm products.', '763-555-0120', 'meadowbrook@example.com', TRUE);

INSERT INTO Product
(product_id, product_name, category, description)
VALUES
(1, 'Tomatoes', 'Vegetables', 'Fresh field-grown tomatoes.'),
(2, 'Sweet Corn', 'Vegetables', 'Fresh-picked Minnesota sweet corn.'),
(3, 'Cucumbers', 'Vegetables', 'Crisp slicing cucumbers.'),
(4, 'Zucchini', 'Vegetables', 'Fresh green zucchini.'),
(5, 'Carrots', 'Vegetables', 'Fresh bunch carrots.'),
(6, 'Green Beans', 'Vegetables', 'Tender fresh green beans.'),
(7, 'Bell Peppers', 'Vegetables', 'Assorted sweet bell peppers.'),
(8, 'Jalapeno Peppers', 'Vegetables', 'Fresh jalapeno peppers.'),
(9, 'Red Potatoes', 'Vegetables', 'Locally grown red potatoes.'),
(10, 'Yellow Onions', 'Vegetables', 'Minnesota-grown yellow onions.'),
(11, 'Garlic', 'Vegetables', 'Fresh cured garlic bulbs.'),
(12, 'Broccoli', 'Vegetables', 'Fresh broccoli heads.'),
(13, 'Cauliflower', 'Vegetables', 'Fresh cauliflower heads.'),
(14, 'Spinach', 'Greens', 'Fresh baby spinach.'),
(15, 'Kale', 'Greens', 'Fresh kale bunches.'),
(16, 'Romaine Lettuce', 'Greens', 'Crisp romaine lettuce.'),
(17, 'Basil', 'Herbs', 'Fresh basil bunches.'),
(18, 'Cilantro', 'Herbs', 'Fresh cilantro bunches.'),
(19, 'Dill', 'Herbs', 'Fresh dill bunches.'),
(20, 'Apples', 'Fruit', 'Seasonal Minnesota apples.'),
(21, 'Strawberries', 'Fruit', 'Fresh local strawberries.'),
(22, 'Blueberries', 'Fruit', 'Fresh local blueberries.'),
(23, 'Raspberries', 'Fruit', 'Fresh local raspberries.'),
(24, 'Watermelon', 'Fruit', 'Fresh whole watermelon.'),
(25, 'Cantaloupe', 'Fruit', 'Fresh cantaloupe.'),
(26, 'Pumpkin', 'Vegetables', 'Seasonal carving or cooking pumpkin.'),
(27, 'Raw Honey', 'Pantry', 'Raw local wildflower honey.'),
(28, 'Maple Syrup', 'Pantry', 'Pure Minnesota maple syrup.'),
(29, 'Strawberry Jam', 'Pantry', 'Small-batch strawberry jam.'),
(30, 'Dill Pickles', 'Pantry', 'Crisp small-batch dill pickles.'),
(31, 'Fresh Salsa', 'Pantry', 'Fresh tomato salsa.'),
(32, 'Sourdough Bread', 'Bakery', 'Artisan sourdough loaf.'),
(33, 'Whole Wheat Bread', 'Bakery', 'Fresh whole wheat loaf.'),
(34, 'Blueberry Muffins', 'Bakery', 'Fresh blueberry muffins.'),
(35, 'Chocolate Chip Cookies', 'Bakery', 'Homemade chocolate chip cookies.'),
(36, 'Apple Pie', 'Bakery', 'Fresh-baked apple pie.'),
(37, 'Farm Fresh Eggs', 'Dairy & Eggs', 'One dozen farm-fresh eggs.'),
(38, 'Cheddar Cheese', 'Dairy & Eggs', 'Locally produced cheddar cheese.'),
(39, 'Plain Yogurt', 'Dairy & Eggs', 'Fresh plain farm yogurt.'),
(40, 'Salted Butter', 'Dairy & Eggs', 'Locally churned salted butter.'),
(41, 'Ground Beef', 'Meat', 'One-pound package of ground beef.'),
(42, 'Beef Roast', 'Meat', 'Locally raised beef roast.'),
(43, 'Whole Chicken', 'Meat', 'Locally raised whole chicken.'),
(44, 'Oyster Mushrooms', 'Mushrooms', 'Fresh oyster mushrooms.'),
(45, 'Shiitake Mushrooms', 'Mushrooms', 'Fresh shiitake mushrooms.'),
(46, 'All-Purpose Flour', 'Grains', 'Locally milled all-purpose flour.'),
(47, 'Dry Black Beans', 'Grains', 'Farm-grown dry black beans.'),
(48, 'Sunflower Bouquet', 'Flowers', 'Seasonal sunflower bouquet.'),
(49, 'Mixed Flower Bouquet', 'Flowers', 'Seasonal mixed flower bouquet.'),
(50, 'Fresh Mint', 'Herbs', 'Fresh mint bunches.');


INSERT INTO MarketVendor
(market_vendor_id, market_id, vendor_id, stall_number, active)
VALUES
(1, 1, 1, 'A1', TRUE),
(2, 1, 2, 'A2', TRUE),
(3, 2, 3, 'B1', TRUE),
(4, 2, 4, 'B2', TRUE),
(5, 3, 5, 'C1', TRUE),
(6, 3, 6, 'C2', TRUE),
(7, 4, 7, 'D1', TRUE),
(8, 4, 8, 'D2', TRUE),
(9, 5, 9, 'E1', TRUE),
(10, 5, 10, 'E2', TRUE),
(11, 6, 11, 'F1', TRUE),
(12, 6, 12, 'F2', TRUE),
(13, 7, 13, 'G1', TRUE),
(14, 7, 14, 'G2', TRUE),
(15, 8, 15, 'H1', TRUE),
(16, 8, 16, 'H2', TRUE),
(17, 9, 17, 'I1', TRUE),
(18, 9, 18, 'I2', TRUE),
(19, 10, 19, 'J1', TRUE),
(20, 10, 20, 'J2', TRUE),
(21, 3, 1, 'C3', TRUE),
(22, 5, 5, 'E3', TRUE),
(23, 7, 10, 'G3', TRUE),
(24, 9, 15, 'I3', TRUE);


INSERT INTO ProductOffering
(offering_id, market_vendor_id, product_id, price, quantity_available, active)
VALUES
(1, 1, 1, 4.00, 35, TRUE),
(2, 1, 2, 6.00, 40, TRUE),
(3, 1, 3, 2.50, 30, TRUE),
(4, 2, 20, 5.00, 25, TRUE),
(5, 2, 21, 6.50, 18, TRUE),
(6, 2, 23, 5.50, 15, TRUE),

(7, 3, 27, 9.00, 20, TRUE),
(8, 3, 29, 7.00, 16, TRUE),
(9, 4, 4, 3.00, 22, TRUE),
(10, 4, 26, 8.00, 30, TRUE),
(11, 4, 6, 4.00, 24, TRUE),

(12, 5, 32, 7.00, 14, TRUE),
(13, 5, 34, 6.00, 18, TRUE),
(14, 5, 35, 5.00, 25, TRUE),
(15, 6, 14, 4.00, 20, TRUE),
(16, 6, 15, 3.50, 20, TRUE),
(17, 6, 17, 3.00, 25, TRUE),

(18, 7, 37, 5.00, 35, TRUE),
(19, 7, 43, 18.00, 12, TRUE),
(20, 8, 38, 8.50, 16, TRUE),
(21, 8, 39, 6.00, 20, TRUE),
(22, 8, 40, 7.50, 18, TRUE),

(23, 9, 5, 3.00, 25, TRUE),
(24, 9, 9, 5.00, 30, TRUE),
(25, 9, 10, 4.00, 28, TRUE),
(26, 10, 48, 10.00, 14, TRUE),
(27, 10, 49, 14.00, 12, TRUE),
(28, 10, 50, 3.00, 20, TRUE),

(29, 11, 41, 7.50, 25, TRUE),
(30, 11, 42, 24.00, 10, TRUE),
(31, 12, 22, 6.00, 18, TRUE),
(32, 12, 24, 7.00, 15, TRUE),
(33, 12, 25, 5.00, 15, TRUE),

(34, 13, 28, 12.00, 18, TRUE),
(35, 14, 30, 7.00, 25, TRUE),
(36, 14, 31, 6.50, 18, TRUE),
(37, 15, 44, 8.00, 20, TRUE),
(38, 15, 45, 9.00, 18, TRUE),

(39, 16, 46, 6.00, 24, TRUE),
(40, 16, 47, 5.50, 22, TRUE),
(41, 17, 21, 6.00, 24, TRUE),
(42, 17, 22, 6.50, 20, TRUE),
(43, 17, 23, 6.50, 20, TRUE),

(44, 18, 11, 2.00, 35, TRUE),
(45, 18, 18, 3.00, 25, TRUE),
(46, 18, 19, 3.00, 25, TRUE),
(47, 19, 33, 6.50, 18, TRUE),
(48, 19, 36, 14.00, 10, TRUE),
(49, 20, 37, 5.50, 30, TRUE),
(50, 20, 38, 8.00, 15, TRUE),

(51, 21, 1, 4.25, 20, TRUE),
(52, 21, 2, 6.50, 25, TRUE),
(53, 22, 32, 7.50, 10, TRUE),
(54, 22, 35, 5.50, 18, TRUE),
(55, 23, 48, 11.00, 10, TRUE),
(56, 23, 49, 15.00, 8, TRUE),
(57, 24, 44, 8.50, 15, TRUE),
(58, 24, 45, 9.50, 12, TRUE),
(59, 20, 7, 4.00, 22, TRUE),
(60, 20, 12, 4.50, 18, TRUE);

INSERT INTO Customer
(customer_id, first_name, last_name, email, phone)
VALUES
(1, 'Emma', 'Johnson', 'emma.johnson@sample.com', '763-555-0201'),
(2, 'Noah', 'Williams', 'noah.williams@sample.com', '763-555-0202'),
(3, 'Olivia', 'Brown', 'olivia.brown@sample.com', '763-555-0203'),
(4, 'Liam', 'Miller', 'liam.miller@sample.com', '763-555-0204'),
(5, 'Sophia', 'Davis', 'sophia.davis@sample.com', '763-555-0205');

INSERT INTO PreOrder
(preorder_id, customer_id, market_vendor_id, order_date, pickup_date, status, total_amount)
VALUES
(1, 1, 1, '2026-10-10 09:15:00', '2026-10-17', 'Confirmed', 14.00),
(2, 2, 5, '2026-10-10 12:30:00', '2026-10-15', 'Pending', 19.00),
(3, 3, 7, '2026-10-11 14:10:00', '2026-10-17', 'Ready', 10.00);

INSERT INTO PreOrderItem
(preorder_item_id, preorder_id, offering_id, quantity, unit_price, line_total)
VALUES
(1, 1, 1, 2, 4.00, 8.00),
(2, 1, 2, 1, 6.00, 6.00),
(3, 2, 12, 1, 7.00, 7.00),
(4, 2, 13, 2, 6.00, 12.00),
(5, 3, 18, 2, 5.00, 10.00);

SELECT COUNT(*) AS market_count FROM Market;
SELECT COUNT(*) AS farmer_count FROM Vendor;
SELECT COUNT(*) AS product_count FROM Product;
SELECT COUNT(*) AS offering_count FROM ProductOffering;


