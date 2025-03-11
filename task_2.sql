/*Задание 2.*/

-- Создание материализованного представления, которое показывает,
-- как изменяется средний чек для каждого заведения от года к году за все года за исключением 2023 года.
DROP MATERIALIZED VIEW cafe.v_changes_average_check_by_year;
CREATE MATERIALIZED VIEW cafe.v_changes_average_check_by_year AS
SELECT
    year,
    r.name,
    r.type,
    avg_check,
    LAG(avg_check, 1) OVER (PARTITION BY restaurant_uuid ORDER BY year) AS avg_check_prev,
    ROUND(
        ((avg_check - LAG(avg_check, 1) OVER (PARTITION BY restaurant_uuid ORDER BY year)) 
        / LAG(avg_check, 1) OVER (PARTITION BY restaurant_uuid ORDER BY year) * 100)::numeric, 2
    ) AS percent_change
FROM (
    SELECT
        EXTRACT(YEAR FROM report_date) AS year,
        restaurant_uuid,
        ROUND(AVG(avg_check)::numeric, 2) AS avg_check
    FROM cafe.sales
    WHERE EXTRACT(YEAR FROM report_date) <> 2023
    GROUP BY EXTRACT(YEAR FROM report_date), restaurant_uuid
) AS avg_check_year
JOIN cafe.restaurants r USING (restaurant_uuid)
ORDER BY r.name, year;
