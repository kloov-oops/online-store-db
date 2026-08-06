# Online Store Database

## Описание проекта
Проект представляет собой реляционную базу данных для интернет-магазина, разработанную на **PostgreSQL** в среде **Ubuntu 22.04**. База данных хранит информацию о клиентах, товарах, заказах и позициях в заказах.

## Цель проекта
Продемонстрировать навыки проектирования реляционных баз данных, написания SQL-запросов и оформления технической документации.

## Технологии
- **СУБД:** PostgreSQL 14+
- **ОС:** Ubuntu 22.04 LTS
- **Инструменты:** psql (командная строка)

## Схема базы данных (ER-диаграмма)

### Сущности и связи
- **customers** (клиенты) — хранит информацию о покупателях
- **products** (товары) — хранит информацию о товарах
- **orders** (заказы) — хранит информацию о заказах
- **order_items** (позиции заказа) — связующая таблица между заказами и товарами

### Связи
- `customers` → `orders`: один ко многим (1:N)
- `orders` → `order_items`: один ко многим (1:N)
- `products` → `order_items`: один ко многим (1:N)

### ER-диаграмма
┌──────────────┐          ┌─────────────┐
│ customers    │          │ orders      │
├──────────────┤          ├─────────────┤
│ id (PK)      │          │ id (PK)     │
│ first_name   │    1:N   │ customer_id │
│ last_name    │---------→│ order_date  │
│ email        │          │ status      │
│ phone        │          │ total_amount│
│ address      │          └─────────────┘
│ registered_at│                 │
└──────────────┘                 │  1:N
                                 │
                                 ↓
┌───────────────┐          ┌───────────────┐
│ products      │          │ order_items   │
├───────────────┤   1:N    ├───────────────┤
│ id (PK)       │---------→│ id (PK)       │
│ sku           │          │ order_id      │
│ name          │          │ product_id    │
│ description   │          │ quantity      │
│ price         │          │ price_at_order│
│ stock_quantity│          └───────────────┘
│ created_at    │
└───────────────┘

## Установка и развертывание

### 1. Установка PostgreSQL
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib -y
2. Создание базы данных и пользователя
bash
sudo -u postgres psql
CREATE DATABASE online_store;
CREATE USER store_admin WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE online_store TO store_admin;
\q
3. Создание таблиц
bash
sudo -u postgres psql -d online_store -f create_tables.sql
4. Заполнение тестовыми данными
bash
sudo -u postgres psql -d online_store -f insert_data.sql
SQL-запросы для анализа данных
1. Топ-3 самых продаваемых товара
sql
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 3;
2. Общая сумма покупок по каждому клиенту
sql
SELECT c.first_name || ' ' || c.last_name AS customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC;
3. Количество заказов по статусам
sql
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;
4. Клиенты с наибольшим количеством заказов
sql
SELECT c.first_name || ' ' || c.last_name AS customer_name, COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC;
5. Товары, требующие пополнения (остаток < 10)
sql
SELECT name, stock_quantity
FROM products
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;
Структура репозитория
text
online_store_db/
├── README.md              # Документация проекта
├── create_tables.sql      # Скрипт создания таблиц
├── insert_data.sql        # Скрипт заполнения тестовыми данными
├── queries.sql            # Аналитические запросы
└── online_store_dump.sql  # Дамп всей базы данных
Выводы
В ходе проекта были приобретены и продемонстрированы навыки:

Проектирования реляционной схемы базы данных (ER-диаграмма, нормализация)

Работы с PostgreSQL в командной строке Ubuntu

Написания SQL-запросов с JOIN, GROUP BY, агрегатными функциями

Оформления технической документации

Контакты
https://github.com/kloov-oops
kloov-oops-jiv@proton.me
