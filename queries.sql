\c online_store;
-- 1. Топ-3 самых продаваемых товара (по количеству)
SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 3;

-- 2. Общая сумма продаж по каждому клиенту (с сортировкой от большего к меньшему)
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 3. Количество заказов по статусам
SELECT 
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- 4. Клиенты, которые сделали больше всего заказов
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC;

-- 5. Средний чек по каждому клиенту
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    AVG(o.total_amount) AS avg_order_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY avg_order_amount DESC;

-- 6. Товары, которых осталось меньше 10 на складе (нужно пополнять)
SELECT 
    name,
    stock_quantity
FROM products
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;
