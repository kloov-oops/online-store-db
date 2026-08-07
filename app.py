from flask import Flask, jsonify, request
import psycopg2
from datetime import datetime

app = Flask(__name__)

DB_CONFIG = {
    "host": "localhost",
    "database": "online_store",
    "user": "store_admin",
    "password": "21112015nov4909"
}

def get_connection():
    return psycopg2.connect(**DB_CONFIG)

def run_query(query, params=None):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(query, params or ())
    if query.strip().upper().startswith("SELECT"):
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]
        cur.close()
        conn.close()
        return colnames, rows
    else:
        conn.commit()
        cur.close()
        conn.close()
        return None

@app.route('/top-products', methods=['GET'])
def top_products():
    query = """
        SELECT p.name, SUM(oi.quantity) AS total_sold
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        GROUP BY p.name
        ORDER BY total_sold DESC
        LIMIT 3;
    """
    cols, rows = run_query(query)
    result = [dict(zip(cols, row)) for row in rows]
    return jsonify(result)

@app.route('/customer-spending', methods=['GET'])
def customer_spending():
    query = """
        SELECT c.first_name || ' ' || c.last_name AS customer, SUM(o.total_amount) AS total_spent
        FROM customers c
        JOIN orders o ON c.id = o.customer_id
        GROUP BY c.id, c.first_name, c.last_name
        ORDER BY total_spent DESC;
    """
    cols, rows = run_query(query)
    result = [dict(zip(cols, row)) for row in rows]
    return jsonify(result)

@app.route('/monthly-revenue', methods=['GET'])
def monthly_revenue():
    query = """
        SELECT DATE_TRUNC('month', order_date) AS month, SUM(total_amount) AS revenue
        FROM orders
        WHERE status = 'delivered'
        GROUP BY month
        ORDER BY month;
    """
    cols, rows = run_query(query)
    result = []
    for row in rows:
        month = row[0].strftime('%Y-%m') if isinstance(row[0], datetime) else str(row[0])
        result.append({'month': month, 'revenue': float(row[1])})
    return jsonify(result)

@app.route('/add-order', methods=['POST'])
def add_order():
    data = request.get_json()
    customer_id = data.get('customer_id')
    items = data.get('items')  # список [{"product_id": 1, "quantity": 2}, ...]
    if not customer_id or not items:
        return jsonify({"error": "customer_id и items обязательны"}), 400

    conn = get_connection()
    cur = conn.cursor()
    try:
        # Создаём заказ (total_amount будет 0, триггер пересчитает)
        cur.execute(
            "INSERT INTO orders (customer_id, status, total_amount) VALUES (%s, 'pending', 0) RETURNING id;",
            (customer_id,)
        )
        order_id = cur.fetchone()[0]

        # Вставляем позиции
        for item in items:
            product_id = item['product_id']
            quantity = item['quantity']
            # Берём текущую цену товара
            cur.execute("SELECT price FROM products WHERE id = %s;", (product_id,))
            price = cur.fetchone()[0]
            cur.execute(
                "INSERT INTO order_items (order_id, product_id, quantity, price_at_order) VALUES (%s, %s, %s, %s);",
                (order_id, product_id, quantity, price)
            )

        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"order_id": order_id, "status": "created"}), 201
    except Exception as e:
        conn.rollback()
        cur.close()
        conn.close()
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
