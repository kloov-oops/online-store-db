import psycopg2
import csv
import json
from datetime import datetime

# Параметры подключения к БД
DB_CONFIG = {
    "host": "localhost",
    "database": "online_store",
    "user": "store_admin",
    "password": "21112015nov4909"  # ЗАМЕНИ НА СВОЙ ПАРОЛЬ
}

def get_connection():
    """Создаёт и возвращает соединение с БД."""
    return psycopg2.connect(**DB_CONFIG)

def run_query(query):
    """Выполняет запрос и возвращает список строк."""
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(query)
    rows = cur.fetchall()
    colnames = [desc[0] for desc in cur.description]
    cur.close()
    conn.close()
    return colnames, rows

def print_table(colnames, rows):
    """Выводит таблицу в читаемом виде."""
    print(" | ".join(colnames))
    print("-" * 60)
    for row in rows:
        print(" | ".join(str(item) for item in row))
    print()

def save_to_csv(filename, colnames, rows):
    """Сохраняет результаты в CSV."""
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f, delimiter=';')
        writer.writerow(colnames)
        writer.writerows(rows)
    print(f"Результат сохранён в {filename}")

def main():
    print("=== Аналитика интернет-магазина ===\n")

    # 1. Топ-3 товара
    query_top = """
        SELECT p.name, SUM(oi.quantity) AS total_sold
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        GROUP BY p.name
        ORDER BY total_sold DESC
        LIMIT 3;
    """
    cols, rows = run_query(query_top)
    print("📊 Топ-3 самых продаваемых товара:")
    print_table(cols, rows)
    save_to_csv("top_products.csv", cols, rows)

    # 2. Траты по клиентам
    query_spending = """
        SELECT c.first_name || ' ' || c.last_name AS customer, SUM(o.total_amount) AS total_spent
        FROM customers c
        JOIN orders o ON c.id = o.customer_id
        GROUP BY c.id, c.first_name, c.last_name
        ORDER BY total_spent DESC;
    """
    cols, rows = run_query(query_spending)
    print("💰 Траты по клиентам:")
    print_table(cols, rows)
    save_to_csv("customer_spending.csv", cols, rows)

    # 3. Помесячная выручка
    query_revenue = """
        SELECT DATE_TRUNC('month', order_date) AS month, SUM(total_amount) AS revenue
        FROM orders
        WHERE status = 'delivered'
        GROUP BY month
        ORDER BY month;
    """
    cols, rows = run_query(query_revenue)
    print("📈 Помесячная выручка:")
    print_table(cols, rows)
    save_to_csv("monthly_revenue.csv", cols, rows)

    print("✅ Аналитика выполнена. Файлы сохранены.")

if __name__ == "__main__":
    main()
