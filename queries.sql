USE farmers_market_db;



SELECT -- returns all active markets --
    market_id,
    market_name,
    description,
    address,
    city,
    state,
    zip_code,
    market_day,
    start_time,
    end_time
FROM Market
WHERE active = TRUE
ORDER BY market_name;




SET @market_id = 1;

SELECT -- returns selected market --
    market_id,
    market_name,
    description,
    address,
    city,
    state,
    zip_code,
    market_day,
    start_time,
    end_time
FROM Market
WHERE market_id = @market_id
  AND active = TRUE;




SET @market_id = 1;

SELECT -- returns vendors at selected market --
    v.vendor_id,
    v.vendor_name,
    v.description,
    v.phone,
    v.email,
    mv.stall_number
FROM MarketVendor AS mv
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
WHERE mv.market_id = @market_id
  AND mv.active = TRUE
  AND v.active = TRUE
ORDER BY v.vendor_name;




SET @search_term = 'tomato';

SELECT -- searched or an item, returns the vendor, market, price, and qty, of item --
    p.product_id,
    p.product_name,
    p.category,
    v.vendor_id,
    v.vendor_name,
    m.market_id,
    m.market_name,
    m.city,
    po.offering_id,
    po.price,
    po.quantity_available
FROM Product AS p
JOIN ProductOffering AS po
    ON p.product_id = po.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
WHERE p.product_name LIKE CONCAT('%', @search_term, '%')
  AND po.active = TRUE
  AND mv.active = TRUE
  AND v.active = TRUE
  AND m.active = TRUE
  AND po.quantity_available > 0
ORDER BY p.product_name, po.price;



SET @market_id = 1;

SELECT -- returns all products offered at a selected market --
    p.product_name,
    p.category,
    v.vendor_name,
    mv.stall_number,
    po.offering_id,
    po.price,
    po.quantity_available
FROM ProductOffering AS po
JOIN Product AS p
    ON po.product_id = p.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
WHERE mv.market_id = @market_id
  AND po.active = TRUE
  AND mv.active = TRUE
  AND v.active = TRUE
ORDER BY v.vendor_name, p.product_name;




SET @offering_id = 1;

SELECT -- returns information about a specific product offering --
    po.offering_id,
    p.product_name,
    p.description AS product_description,
    p.category,
    v.vendor_name,
    m.market_name,
    m.address,
    m.city,
    m.state,
    po.price,
    po.quantity_available
FROM ProductOffering AS po
JOIN Product AS p
    ON po.product_id = p.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
WHERE po.offering_id = @offering_id
  AND po.active = TRUE;




SET @offering_id = 1;
SET @requested_quantity = 2;

SELECT -- looks up a product offering and tests the qty agaist the user qty, returns the qty available and if the requested qty is availble --
    po.offering_id,
    po.quantity_available,
    @requested_quantity AS requested_quantity,
    CASE
        WHEN po.quantity_available >= @requested_quantity
            THEN 'AVAILABLE'
        ELSE 'NOT ENOUGH INVENTORY'
    END AS inventory_status
FROM ProductOffering AS po
WHERE po.offering_id = @offering_id
  AND po.active = TRUE;


SET @preorder_id = 1;

SELECT -- returns customer and order information about a pre order --
    o.preorder_id,
    o.order_date,
    o.pickup_date,
    o.status,
    o.total_amount,
    c.first_name,
    c.last_name,
    c.email,
    m.market_name,
    v.vendor_name
FROM PreOrder AS o
JOIN Customer AS c
    ON o.customer_id = c.customer_id
JOIN MarketVendor AS mv
    ON o.market_vendor_id = mv.market_vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
WHERE o.preorder_id = @preorder_id;



SET @preorder_id = 1;

SELECT -- returns the items from a pre-order --
    oi.preorder_item_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.line_total
FROM PreOrderItem AS oi
JOIN ProductOffering AS po
    ON oi.offering_id = po.offering_id
JOIN Product AS p
    ON po.product_id = p.product_id
WHERE oi.preorder_id = @preorder_id
ORDER BY p.product_name;




SET @customer_id = 1;

SELECT -- returns in order information about a customer --
    o.preorder_id,
    o.order_date,
    o.pickup_date,
    o.status,
    o.total_amount,
    m.market_name,
    v.vendor_name
FROM PreOrder AS o
JOIN MarketVendor AS mv
    ON o.market_vendor_id = mv.market_vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
WHERE o.customer_id = @customer_id
ORDER BY o.order_date DESC;



SET @category = 'Vegetables';

SELECT -- returns information about products, market, vendors, price and qty, by product category --
    p.product_name,
    p.category,
    v.vendor_name,
    m.market_name,
    po.price,
    po.quantity_available
FROM Product AS p
JOIN ProductOffering AS po
    ON p.product_id = po.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
WHERE p.category = @category
  AND po.active = TRUE
  AND po.quantity_available > 0
ORDER BY p.product_name, po.price;



SET @QTY = 15;
SELECT -- returns product, vendory, market, and qty information that have 15 or less availble qty --
    p.product_name,
    v.vendor_name,
    m.market_name,
    po.quantity_available
FROM ProductOffering AS po
JOIN Product AS p
    ON po.product_id = p.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
WHERE po.active = TRUE
  AND po.quantity_available <= @QTY
ORDER BY po.quantity_available ASC, p.product_name;




SELECT -- returns the number of active vendors at each market --
    m.market_id,
    m.market_name,
    COUNT(mv.market_vendor_id) AS vendor_count
FROM Market AS m
LEFT JOIN MarketVendor AS mv
    ON m.market_id = mv.market_id
   AND mv.active = TRUE
WHERE m.active = TRUE
GROUP BY
    m.market_id,
    m.market_name
ORDER BY m.market_name;


SET @search_term = 'tomato';

SELECT -- returns qty, price, market, and vendor of a search of product name, includes wildcards for product names that containt the search term --
    p.product_name,
    v.vendor_name,
    m.market_name,
    po.price,
    po.quantity_available
FROM Product AS p
JOIN ProductOffering AS po
    ON p.product_id = po.product_id
JOIN MarketVendor AS mv
    ON po.market_vendor_id = mv.market_vendor_id
JOIN Vendor AS v
    ON mv.vendor_id = v.vendor_id
JOIN Market AS m
    ON mv.market_id = m.market_id
WHERE p.product_name LIKE CONCAT('%', @search_term, '%')
  AND po.active = TRUE
  AND po.quantity_available > 0
ORDER BY po.price ASC, m.market_name;


SELECT
    (SELECT COUNT(*) FROM Market) AS total_markets,
    (SELECT COUNT(*) FROM Vendor) AS total_farmers,
    (SELECT COUNT(*) FROM Product) AS total_unique_products;

-- Expected:
-- total_markets = 10
-- total_farmers = 20
-- total_unique_products = 50
