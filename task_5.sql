/*Задание 5.*/

-- Находим самую дорогую пиццу для каждой пиццерии.
WITH menu_cte AS (
    SELECT
        name AS restaurant_name,
        'Пицца' AS dish_type,
        (jsonb_each_text(menu -> 'Пицца')).key AS pizza_name,
        (jsonb_each_text(menu -> 'Пицца')).value::integer AS price
    FROM cafe.restaurants
    WHERE type = 'pizzeria'
),
ranked_menu AS (
    SELECT
        restaurant_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY restaurant_name ORDER BY price DESC) AS rank
    FROM menu_cte
)
SELECT
    restaurant_name,
    dish_type,
    pizza_name,
    price
FROM ranked_menu
WHERE rank = 1
ORDER BY restaurant_name;