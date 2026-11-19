from flask import Flask, render_template, request, redirect, url_for, flash
from datetime import date
from decimal import Decimal
from database import get_db_connection

app = Flask(__name__)
import os

app.secret_key = os.environ.get(
    "SECRET_KEY",
    "local-development-only-change-me"
)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/markets")
def markets():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        cursor.execute("""
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
            ORDER BY market_name
        """)

        market_list = cursor.fetchall()

    finally:
        cursor.close()
        connection.close()

    return render_template(
        "markets.html",
        markets=market_list
    )


@app.route("/markets/<int:market_id>")
def market_details(market_id):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        # Get information for the selected market
        cursor.execute("""
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
            WHERE market_id = %s
              AND active = TRUE
        """, (market_id,))

        market = cursor.fetchone()

        if market is None:
            return "Market not found", 404

        # Get vendors participating at this market
        cursor.execute("""
            SELECT
                v.vendor_id,
                v.vendor_name,
                v.description,
                v.phone,
                v.email,
                mv.stall_number
            FROM MarketVendor mv
            JOIN Vendor v
                ON mv.vendor_id = v.vendor_id
            WHERE mv.market_id = %s
              AND mv.active = TRUE
              AND v.active = TRUE
            ORDER BY v.vendor_name
        """, (market_id,))

        vendors = cursor.fetchall()

        # Get products offered at this market
        cursor.execute("""
            SELECT
                po.offering_id,
                p.product_name,
                p.category,
                p.description,
                v.vendor_name,
                po.price,
                po.quantity_available
            FROM ProductOffering po
            JOIN Product p
                ON po.product_id = p.product_id
            JOIN MarketVendor mv
                ON po.market_vendor_id = mv.market_vendor_id
            JOIN Vendor v
                ON mv.vendor_id = v.vendor_id
            WHERE mv.market_id = %s
              AND po.active = TRUE
              AND mv.active = TRUE
              AND v.active = TRUE
            ORDER BY v.vendor_name, p.product_name
        """, (market_id,))

        products = cursor.fetchall()

    finally:
        cursor.close()
        connection.close()

    return render_template(
        "market_details.html",
        market=market,
        vendors=vendors,
        products=products
    )

@app.route("/products")
def products():
    from flask import request

    search_term = request.args.get("search", "").strip()
    category = request.args.get("category", "").strip()

    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        # Get categories for the dropdown
        cursor.execute("""
            SELECT DISTINCT category
            FROM Product
            WHERE category IS NOT NULL
            ORDER BY category
        """)

        categories = [
            row["category"]
            for row in cursor.fetchall()
        ]

        # Search products across all markets
        query = """
            SELECT
                po.offering_id,
                p.product_name,
                p.category,
                p.description,
                v.vendor_name,
                m.market_id,
                m.market_name,
                m.city,
                po.price,
                po.quantity_available
            FROM ProductOffering po
            JOIN Product p
                ON po.product_id = p.product_id
            JOIN MarketVendor mv
                ON po.market_vendor_id = mv.market_vendor_id
            JOIN Vendor v
                ON mv.vendor_id = v.vendor_id
            JOIN Market m
                ON mv.market_id = m.market_id
            WHERE po.active = TRUE
              AND mv.active = TRUE
              AND v.active = TRUE
              AND m.active = TRUE
              AND po.quantity_available > 0
        """

        params = []

        if search_term:
            query += """
                AND (
                    p.product_name LIKE %s
                    OR v.vendor_name LIKE %s
                    OR m.market_name LIKE %s
                )
            """

            search_value = f"%{search_term}%"
            params.extend([
                search_value,
                search_value,
                search_value
            ])

        if category:
            query += " AND p.category = %s"
            params.append(category)

        query += " ORDER BY p.product_name, po.price"

        cursor.execute(query, tuple(params))
        product_list = cursor.fetchall()

    finally:
        cursor.close()
        connection.close()

    return render_template(
        "products.html",
        products=product_list,
        categories=categories,
        search_term=search_term,
        selected_category=category
    )

# ==========================================
# PRE-ORDER CHECKOUT
# ==========================================

@app.route("/checkout/<int:offering_id>", methods=["GET", "POST"])
def checkout(offering_id):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        if request.method == "POST":
            try:
                customer_id = int(request.form["customer_id"])
                quantity = int(request.form["quantity"])
                pickup_date = date.fromisoformat(
                    request.form["pickup_date"]
                )
            except (ValueError, KeyError):
                flash("Please enter valid order information.")
                return redirect(url_for(
                    "checkout", offering_id=offering_id
                ))

            if quantity < 1 or pickup_date < date.today():
                flash("Check your quantity and pickup date.")
                return redirect(url_for(
                    "checkout", offering_id=offering_id
                ))

            # Start the database transaction
            connection.start_transaction()

            # Lock the offering while checking inventory
            cursor.execute("""
                SELECT
                    po.offering_id,
                    po.market_vendor_id,
                    po.price,
                    po.quantity_available
                FROM ProductOffering po
                JOIN MarketVendor mv
                    ON po.market_vendor_id = mv.market_vendor_id
                JOIN Vendor v
                    ON mv.vendor_id = v.vendor_id
                JOIN Market m
                    ON mv.market_id = m.market_id
                WHERE po.offering_id = %s
                  AND po.active = TRUE
                  AND mv.active = TRUE
                  AND v.active = TRUE
                  AND m.active = TRUE
                FOR UPDATE
            """, (offering_id,))

            offering = cursor.fetchone()

            if not offering:
                connection.rollback()
                flash("This product is no longer available.")
                return redirect(url_for("products"))

            if offering["quantity_available"] < quantity:
                connection.rollback()
                flash("Not enough inventory is available.")
                return redirect(url_for(
                    "checkout", offering_id=offering_id
                ))

            # Validate the customer
            cursor.execute("""
                SELECT customer_id
                FROM Customer
                WHERE customer_id = %s
            """, (customer_id,))

            if cursor.fetchone() is None:
                connection.rollback()
                flash("Please select a valid customer.")
                return redirect(url_for(
                    "checkout", offering_id=offering_id
                ))

            price = Decimal(str(offering["price"]))
            total = price * quantity

            # Create the pre-order
            cursor.execute("""
                INSERT INTO PreOrder (
                    customer_id,
                    market_vendor_id,
                    order_date,
                    pickup_date,
                    status,
                    total_amount
                )
                VALUES (%s, %s, NOW(), %s, %s, %s)
            """, (
                customer_id,
                offering["market_vendor_id"],
                pickup_date,
                "Pending",
                total
            ))

            preorder_id = cursor.lastrowid

            # Save the ordered product
            cursor.execute("""
                INSERT INTO PreOrderItem (
                    preorder_id,
                    offering_id,
                    quantity,
                    unit_price,
                    line_total
                )
                VALUES (%s, %s, %s, %s, %s)
            """, (
                preorder_id,
                offering_id,
                quantity,
                price,
                total
            ))

            # Deduct purchased quantity from inventory
            cursor.execute("""
                UPDATE ProductOffering
                SET quantity_available =
                    quantity_available - %s
                WHERE offering_id = %s
            """, (quantity, offering_id))

            # All operations succeeded
            connection.commit()

            return redirect(url_for(
                "order_confirmation",
                preorder_id=preorder_id
            ))

        # GET: Display the selected product
        cursor.execute("""
            SELECT
                po.offering_id,
                p.product_name,
                p.description,
                po.price,
                po.quantity_available,
                v.vendor_name,
                m.market_name
            FROM ProductOffering po
            JOIN Product p
                ON po.product_id = p.product_id
            JOIN MarketVendor mv
                ON po.market_vendor_id = mv.market_vendor_id
            JOIN Vendor v
                ON mv.vendor_id = v.vendor_id
            JOIN Market m
                ON mv.market_id = m.market_id
            WHERE po.offering_id = %s
              AND po.active = TRUE
              AND mv.active = TRUE
              AND v.active = TRUE
              AND m.active = TRUE
        """, (offering_id,))

        offering = cursor.fetchone()

        if not offering:
            return "Product not found", 404

        # Retrieve customers for the checkout form
        cursor.execute("""
            SELECT customer_id, first_name, last_name
            FROM Customer
            ORDER BY last_name, first_name
        """)

        customers = cursor.fetchall()

        return render_template(
            "checkout.html",
            offering=offering,
            customers=customers,
            today=date.today().isoformat()
        )

    except Exception:
        connection.rollback()
        app.logger.exception("Checkout transaction failed")
        flash("The order could not be processed. No changes were saved.")
        return redirect(url_for("products"))

    finally:
        cursor.close()
        connection.close()

# ==========================================
# PRE-ORDER CONFIRMATION
# ==========================================

@app.route("/confirmation/<int:preorder_id>")
def order_confirmation(preorder_id):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        # Retrieve the saved order and customer
        cursor.execute("""
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
            FROM PreOrder o
            JOIN Customer c
                ON o.customer_id = c.customer_id
            JOIN MarketVendor mv
                ON o.market_vendor_id = mv.market_vendor_id
            JOIN Market m
                ON mv.market_id = m.market_id
            JOIN Vendor v
                ON mv.vendor_id = v.vendor_id
            WHERE o.preorder_id = %s
        """, (preorder_id,))

        order = cursor.fetchone()

        if order is None:
            return "Order not found", 404

        # Retrieve all products in the order
        cursor.execute("""
            SELECT
                p.product_name,
                oi.quantity,
                oi.unit_price,
                oi.line_total
            FROM PreOrderItem oi
            JOIN ProductOffering po
                ON oi.offering_id = po.offering_id
            JOIN Product p
                ON po.product_id = p.product_id
            WHERE oi.preorder_id = %s
            ORDER BY p.product_name
        """, (preorder_id,))

        items = cursor.fetchall()

    finally:
        cursor.close()
        connection.close()

    return render_template(
        "confirmation.html",
        order=order,
        items=items
    )

if __name__ == "__main__":
    app.run(debug=True)
