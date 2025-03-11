/*Задание 3.*/

-- Находим топ-3 заведения, где чаще всего менялся менеджер за весь период.
WITH count_managers AS (
    SELECT
        r.name,
        COUNT(rmwd.*) manager_change_count
    FROM cafe.restaurant_manager_work_dates rmwd
    JOIN cafe.restaurants r USING (restaurant_uuid)
    GROUP BY r.name
),
ranked_managers as (
    SELECT
        *,
        -- ROW_NUMBER() использована вместо RANK(), чтобы избежать дубликатов rank в случае если есть заведения с одинаковым изменением менеджеров.
        ROW_NUMBER() OVER (ORDER BY manager_change_count DESC) AS rank
    FROM count_managers
)
SELECT
    name,
    manager_change_count
FROM ranked_managers
WHERE rank <= 3;