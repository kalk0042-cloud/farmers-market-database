
from database import get_db_connection


def test_connection():
    connection = None
    cursor = None

    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        print("Connected to MySQL successfully!")

        cursor.execute("SELECT DATABASE() AS db_name")
        result = cursor.fetchone()
        print("Database:", result["db_name"])

        cursor.execute("""
            SELECT
                market_id,
                market_name,
                city,
                state
            FROM Market
            WHERE active = TRUE
            ORDER BY market_name
        """)

        markets = cursor.fetchall()

        print(f"\nFound {len(markets)} active markets:\n")

        for market in markets:
            print(
                f"{market['market_id']}: "
                f"{market['market_name']} - "
                f"{market['city']}, "
                f"{market['state']}"
            )

    except Exception as error:
        print("Database connection or query failed.")
        print("Error:", error)

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()


if __name__ == "__main__":
    test_connection()
