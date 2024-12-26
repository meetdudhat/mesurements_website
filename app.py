from flask import Flask, render_template, request, redirect, url_for
import sqlite3

app = Flask(__name__)
DB_PATH = "database/sabha_prasad.db"

def query_db(query, args=(), one=False):
    with sqlite3.connect(DB_PATH) as conn:
        conn.row_factory = sqlite3.Row
        cur = conn.execute(query, args)
        rv = cur.fetchall()
        return (rv[0] if rv else None) if one else rv

@app.route("/")
def home():
    return render_template("home.html")

@app.route("/search", methods=["GET", "POST"])
def search():
    food_items = query_db("SELECT food_name FROM Food_Items")
    events = query_db("SELECT event_name || ' (' || event_date || ')' AS event_label FROM Events")
    grouped_results = {}

    if request.method == "POST":
        selected_food = request.form.get("food_item")
        selected_event = request.form.get("event")
        query = """
        SELECT e.event_name, e.event_date, e.attendees, f.food_name, efi.quantity,
               i.ingredient_name, fii.ingredient_quantity_per_serving  AS ingredient_quantity
        FROM Event_Food_Items efi
        JOIN Events e ON e.event_id = efi.event_id
        JOIN Food_Items f ON efi.food_item_id = f.food_item_id
        JOIN Food_Item_Ingredients fii ON f.food_item_id = fii.food_item_id
        JOIN Ingredients i ON fii.ingredient_id = i.ingredient_id
        WHERE 1=1
        """
        filters = []
        if selected_food:
            query += """
            AND e.event_id IN (
                SELECT efi.event_id
                FROM Event_Food_Items efi
                JOIN Food_Items f ON efi.food_item_id = f.food_item_id
                WHERE f.food_name = ?
            )
            """
            filters.append(selected_food)
        if selected_event:
            event_name = selected_event.split(" (")[0]
            query += " AND e.event_name = ?"
            filters.append(event_name)
        raw_results = query_db(query, filters)

        for row in raw_results:
            event_key = (row["event_name"], row["event_date"], row["attendees"])
            if event_key not in grouped_results:
                grouped_results[event_key] = {}
            food_key = (row["food_name"], row["quantity"])
            if food_key not in grouped_results[event_key]:
                grouped_results[event_key][food_key] = []
            grouped_results[event_key][food_key].append({
                "ingredient_name": row["ingredient_name"],
                "ingredient_quantity": row["ingredient_quantity"]
            })

    return render_template("search.html", food_items=food_items, events=events, grouped_results=grouped_results)

@app.route("/add", methods=["GET", "POST"])
def add():
    if request.method == "POST":
        if 'event_name' in request.form:
            event_name = request.form.get("event_name")
            event_date = request.form.get("event_date")
            attendees = request.form.get("attendees")

            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.cursor()
                cur.execute("INSERT INTO Events (event_name, event_date, attendees) VALUES (?, ?, ?)",
                            (event_name, event_date, attendees))
                conn.commit()
            return redirect(url_for("add"))

        elif 'food_item' in request.form:
            event_id = request.form.get("event_id")
            food_item = request.form.get("food_item")
            quantity = request.form.get("quantity")

            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.cursor()
                cur.execute("INSERT OR IGNORE INTO Food_Items (food_name) VALUES (?)", (food_item,))
                cur.execute("SELECT food_item_id FROM Food_Items WHERE food_name = ?", (food_item,))
                food_item_id = cur.fetchone()[0]
                cur.execute("INSERT INTO Event_Food_Items (event_id, food_item_id, quantity) VALUES (?, ?, ?)",
                            (event_id, food_item_id, quantity))
                conn.commit()
            return redirect(url_for("add"))

        elif 'ingredient_item' in request.form:
            event_id = request.form.get("event_id")
            food_item_id = request.form.get("food_item_id")
            ingredient_item = request.form.get("ingredient_item")
            ingredient_quantity = request.form.get("ingredient_quantity")

            with sqlite3.connect(DB_PATH) as conn:
                cur = conn.cursor()
                cur.execute("INSERT OR IGNORE INTO Ingredients (ingredient_name) VALUES (?)", (ingredient_item,))
                cur.execute("SELECT ingredient_id FROM Ingredients WHERE ingredient_name = ?", (ingredient_item,))
                ingredient_id = cur.fetchone()[0]
                cur.execute("INSERT INTO Food_Item_Ingredients (food_item_id, ingredient_id, ingredient_quantity_per_serving) VALUES (?, ?, ?)",
                            (food_item_id, ingredient_id, ingredient_quantity))
                conn.commit()
            return redirect(url_for("add"))

    events = query_db("SELECT event_id, event_name || ' (' || event_date || ')' AS event_label FROM Events")
    food_items = query_db("SELECT food_item_id, food_name FROM Food_Items")
    ingredients = query_db("SELECT ingredient_id, ingredient_name FROM Ingredients")
    return render_template("add.html", events=events, food_items=food_items, ingredients=ingredients)

if __name__ == "__main__":
    app.run(debug=True)