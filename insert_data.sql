\c online_store;
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Иван', 'Петров', 'ivan@mail.ru', '+7-900-111-22-33', 'Москва, ул. Тверская, 1'),
('Мария', 'Сидорова', 'maria@mail.ru', '+7-900-222-33-44', 'Санкт-Петербург, Невский пр., 10'),
('Алексей', 'Иванов', 'alexey@mail.ru', '+7-900-333-44-55', 'Казань, ул. Баумана, 5');

-- Добавление товаров
INSERT INTO products (sku, name, description, price, stock_quantity) VALUES
('SKU-001', 'Ноутбук Lenovo ThinkPad', '15.6", Intel Core i5, 16GB RAM', 75000.00, 10),
('SKU-002', 'Смартфон Samsung Galaxy', '6.7", 128GB, AMOLED', 50000.00, 25),
('SKU-003', 'Наушники Sony WH-1000XM5', 'Беспроводные, шумоподавление', 30000.00, 15),
('SKU-004', 'Клавиатура Logitech MX Keys', 'Беспроводная, подсветка', 12000.00, 8);

-- Добавление заказов
INSERT INTO orders (customer_id, status, total_amount) VALUES
(1, 'delivered', 125000.00),   -- Иван: ноутбук + наушники
(2, 'shipped', 50000.00),      -- Мария: смартфон
(1, 'processing', 12000.00),   -- Иван: клавиатура
(3, 'pending', 75000.00);      -- Алексей: ноутбук

-- Добавление позиций в заказах
INSERT INTO order_items (order_id, product_id, quantity, price_at_order) VALUES
(1, 1, 1, 75000.00),   -- Заказ 1: ноутбук
(1, 3, 1, 30000.00),   -- Заказ 1: наушники
(2, 2, 1, 50000.00),   -- Заказ 2: смартфон
(3, 4, 1, 12000.00),   -- Заказ 3: клавиатура
(4, 1, 1, 75000.00);   -- Заказ 4: ноутбук
