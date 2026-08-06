\c online_store;

-- Очистка таблиц
TRUNCATE TABLE order_items CASCADE;
TRUNCATE TABLE payments CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE suppliers CASCADE;

-- Сброс последовательностей 
ALTER SEQUENCE categories_id_seq RESTART WITH 1;
ALTER SEQUENCE suppliers_id_seq RESTART WITH 1;
ALTER SEQUENCE customers_id_seq RESTART WITH 1;
ALTER SEQUENCE products_id_seq RESTART WITH 1;
ALTER SEQUENCE orders_id_seq RESTART WITH 1;
ALTER SEQUENCE payments_id_seq RESTART WITH 1;
ALTER SEQUENCE order_items_id_seq RESTART WITH 1;

-- 1. Вставка категорий
INSERT INTO categories (id, name, description) VALUES
(1, 'Электроника', 'Смартфоны, ноутбуки, планшеты'),
(2, 'Аксессуары', 'Наушники, клавиатуры, мыши'),
(3, 'Бытовая техника', 'Холодильники, стиральные машины');

-- 2. Вставка поставщиков
INSERT INTO suppliers (id, name, contact_person, phone, email, address) VALUES
(1, 'ООО Техно', 'Иван Смирнов', '+7-900-111-11-11', 'tehno@mail.ru', 'Москва, ул. Ленина, 1'),
(2, 'ЗАО Комплект', 'Ольга Кузнецова', '+7-900-222-22-22', 'komplekt@mail.ru', 'СПб, Невский, 20'),
(3, 'ИП Иванов', 'Петр Иванов', '+7-900-333-33-33', 'ivanov@mail.ru', 'Казань, ул. Баумана, 10');

-- 3. Вставка клиентов (те же, что были, но с явными id)
INSERT INTO customers (id, first_name, last_name, email, phone, address) VALUES
(1, 'Иван', 'Петров', 'ivan@mail.ru', '+7-900-111-22-33', 'Москва, ул. Тверская, 1'),
(2, 'Мария', 'Сидорова', 'maria@mail.ru', '+7-900-222-33-44', 'Санкт-Петербург, Невский пр., 10'),
(3, 'Алексей', 'Иванов', 'alexey@mail.ru', '+7-900-333-44-55', 'Казань, ул. Баумана, 5');

-- 4. Вставка товаров с категориями и поставщиками
INSERT INTO products (id, sku, name, description, price, stock_quantity, category_id, supplier_id) VALUES
(1, 'SKU-001', 'Ноутбук Lenovo ThinkPad', '15.6", Intel Core i5, 16GB RAM', 75000.00, 10, 1, 1),
(2, 'SKU-002', 'Смартфон Samsung Galaxy', '6.7", 128GB, AMOLED', 50000.00, 25, 1, 1),
(3, 'SKU-003', 'Наушники Sony WH-1000XM5', 'Беспроводные, шумоподавление', 30000.00, 15, 2, 2),
(4, 'SKU-004', 'Клавиатура Logitech MX Keys', 'Беспроводная, подсветка', 12000.00, 8, 2, 2);

-- 5. Вставка заказов (пока без платежей, добавим позже)
INSERT INTO orders (id, customer_id, status, total_amount) VALUES
(1, 1, 'delivered', 0),   -- Иван: ноутбук + наушники, сумму пересчитает триггер
(2, 2, 'shipped', 0),      -- Мария: смартфон
(3, 1, 'processing', 0),   -- Иван: клавиатура
(4, 3, 'pending', 0);      -- Алексей: ноутбук

-- 6. Вставка позиций заказов (триггеры пересчитают total_amount и остатки)
INSERT INTO order_items (id, order_id, product_id, quantity, price_at_order) VALUES
(1, 1, 1, 1, 75000.00),   -- Заказ 1: ноутбук
(2, 1, 3, 1, 30000.00),   -- Заказ 1: наушники
(3, 2, 2, 1, 50000.00),   -- Заказ 2: смартфон
(4, 3, 4, 1, 12000.00),   -- Заказ 3: клавиатура
(5, 4, 1, 1, 75000.00);   -- Заказ 4: ноутбук

-- 7. Вставка платежей (после заказов, чтобы ссылаться на существующие order_id)
INSERT INTO payments (id, order_id, amount, method, status, payment_date) VALUES
(1, 1, 125000.00, 'card', 'completed', CURRENT_TIMESTAMP),
(2, 2, 50000.00,  'online', 'completed', CURRENT_TIMESTAMP),
(3, 3, 12000.00,  'card', 'completed', CURRENT_TIMESTAMP),
(4, 4, 75000.00,  'online', 'pending', CURRENT_TIMESTAMP);
