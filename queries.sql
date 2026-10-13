USE farmers_market_db;



SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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

SELECT
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




SELECT
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
  AND po.quantity_available <= 15
ORDER BY po.quantity_available ASC, p.product_name;




SELECT
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

SELECT
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
