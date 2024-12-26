SELECT e.event_name, e.event_date, e.attendees, efi.quantity
FROM Events e
JOIN Event_Food_Items efi ON e.event_id = efi.event_id
JOIN Food_Items fi ON efi.food_item_id = fi.food_item_id
WHERE fi.food_name = 'Sandwich';

SELECT i.ingredient_name, SUM(efi.quantity * fii.ingredient_quantity_per_serving) AS total_quantity
FROM Event_Food_Items efi
JOIN Food_Items fi ON efi.food_item_id = fi.food_item_id
JOIN Food_Item_Ingredients fii ON fi.food_item_id = fii.food_item_id
JOIN Ingredients i ON fii.ingredient_id = i.ingredient_id
WHERE fi.food_name = 'Sandwich'
GROUP BY i.ingredient_name;


SELECT 
    e.event_name,
    e.event_date,
    e.attendees,
    f.food_name,
    efi.quantity,
    i.ingredient_name,
    fii.ingredient_quantity_per_serving * efi.quantity AS ingredient_quantity
FROM 
    Event_Food_Items efi
JOIN 
    Events e ON e.event_id = efi.event_id
JOIN 
    Food_Items f ON efi.food_item_id = f.food_item_id
JOIN 
    Food_Item_Ingredients fii ON f.food_item_id = fii.food_item_id
JOIN 
    Ingredients i ON fii.ingredient_id = i.ingredient_id
WHERE 
    e.event_name = 'Company Picnic'
ORDER BY 
    efi.food_item_id, i.ingredient_name;
