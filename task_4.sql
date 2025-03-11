/*Задание 4.*/

--Находим пиццерию с самым большим количеством пицц в меню.
WITH pizza_count AS (
    SELECT
        name AS restaurant_name,
        JSONB_EACH_TEXT(menu -> 'Пицца') AS pizza_name
    FROM cafe.restaurants
    WHERE type = 'pizzeria'
),
ranked_restaurants AS (
    SELECT
        restaurant_name,
        COUNT(pizza_name) AS pizza_count,
        DENSE_RANK() OVER (ORDER BY COUNT(pizza_name) DESC) AS rank
    FROM pizza_count
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    pizza_count
FROM ranked_restaurants
WHERE rank = 1;