-- Events Table
CREATE TABLE IF NOT EXISTS Events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_name TEXT NOT NULL,
    event_date DATE NOT NULL,
    attendees INTEGER NOT NULL
);

-- Food Items Table
CREATE TABLE IF NOT EXISTS Food_Items (
    food_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    food_name TEXT NOT NULL UNIQUE
);

-- Ingredients Table
CREATE TABLE IF NOT EXISTS Ingredients (
    ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ingredient_name TEXT NOT NULL UNIQUE
);

-- Event_Food_Items Table
CREATE TABLE IF NOT EXISTS Event_Food_Items (
    event_food_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    food_item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events (event_id),
    FOREIGN KEY (food_item_id) REFERENCES Food_Items (food_item_id)
);

-- Food_Item_Ingredients Table
CREATE TABLE IF NOT EXISTS Food_Item_Ingredients (
    food_item_ingredient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    food_item_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    ingredient_quantity_per_serving REAL NOT NULL,
    FOREIGN KEY (food_item_id) REFERENCES Food_Items (food_item_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients (ingredient_id)
);