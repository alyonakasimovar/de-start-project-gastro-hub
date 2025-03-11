/*Задание 1.*/

-- Создание представления для топ-3 заведений внутри каждого типа заведений по среднему чеку за все даты.
CREATE OR REPLACE VIEW cafe.v_best_restaurants_by_average_check AS
SELECT
    name,
    type,
    avg_check
FROM (
    SELECT
        name,
        type,
        avg_check,
        -- ROW_NUMBER() использована вместо RANK(), чтобы избежать дубликатов rank в случае одинаковых средних чеков.
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY avg_check DESC) AS rank 
    FROM (
        SELECT
            r.name,
            r.type,
            AVG(s.avg_check)::numeric(6,2) AS avg_check
        FROM cafe.sales s
        JOIN cafe.restaurants r USING (restaurant_uuid)
        GROUP BY r.name, r.type
    ) restaurant_avg_check
) ranked
WHERE rank <= 3
ORDER BY type, avg_check DESC;