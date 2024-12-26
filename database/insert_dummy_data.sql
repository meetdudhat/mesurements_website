-- Insert into Events
INSERT INTO Events (event_name, event_date, attendees) VALUES
('Company Picnic', '2024-06-15', 50),
('Birthday Party', '2024-07-20', 30),
('Community Meetup', '2024-08-10', 70);

-- Insert into Food_Items
INSERT INTO Food_Items (food_name) VALUES
('Sandwich'),
('Pasta Salad'),
('Fruit Platter');

-- Insert into Ingredients
INSERT INTO Ingredients (ingredient_name) VALUES
('Bread'),
('Cucumber'),
('Cheese'),
('Pasta'),
('Tomato'),
('Lettuce'),
('Apples'),
('Bananas'),
('Grapes');

-- Insert into Event_Food_Items
INSERT INTO Event_Food_Items (event_id, food_item_id, quantity) VALUES
(1, 1, 50), -- Sandwich for 50 people at Company Picnic
(1, 2, 30), -- Pasta Salad for 50 people at Company Picnic
(2, 1, 20), -- Sandwich for 30 people at Birthday Party
(2, 3, 10), -- Fruit Platter for 30 people at Birthday Party
(3, 1, 70), -- Sandwich for 70 people at Community Meetup
(3, 3, 35); -- Fruit Platter for 70 people at Community Meetup

-- Insert into Food_Item_Ingredients
INSERT INTO Food_Item_Ingredients (food_item_id, ingredient_id, ingredient_quantity_per_serving) VALUES
(1, 1, 2), -- Sandwich needs 2 slices of Bread per serving
(1, 2, 4), -- Sandwich needs 4 slices of Cucumber per serving
(1, 3, 1), -- Sandwich needs 1 slice of Cheese per serving
(2, 4, 100), -- Pasta Salad needs 100g of Pasta per serving
(2, 5, 50), -- Pasta Salad needs 50g of Tomato per serving
(2, 6, 20), -- Pasta Salad needs 20g of Lettuce per serving
(3, 7, 1), -- Fruit Platter needs 1 Apple per serving
(3, 8, 1), -- Fruit Platter needs 1 Banana per serving
(3, 9, 20); -- Fruit Platter needs 20g of Grapes per serving
