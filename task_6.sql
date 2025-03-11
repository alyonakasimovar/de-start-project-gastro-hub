/*Задание 6.*/

-- Начинаем транзакцию.
BEGIN;

-- Блокируем только те строки, которые будем обновлять.
-- Используем FOR UPDATE, чтобы запретить изменение этих строк другими транзакциями.
SELECT *
FROM cafe.restaurants
WHERE menu #>> '{Кофе, Капучино}' IS NOT NULL
FOR UPDATE;

-- Обновляем цены на капучино.
WITH updated_prices AS (
    SELECT
        name,
        ((menu #>> '{Кофе, Капучино}')::integer * 1.2)::integer AS new_price
    FROM cafe.restaurants
    WHERE menu #>> '{Кофе, Капучино}' IS NOT NULL
)
UPDATE cafe.restaurants r
SET menu = jsonb_set(menu, '{Кофе, Капучино}', to_jsonb(up.new_price))
FROM updated_prices up
WHERE r.name = up.name;

-- Завершаем транзакцию.
COMMIT;