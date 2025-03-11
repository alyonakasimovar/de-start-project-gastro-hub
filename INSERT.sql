/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/

-- Наполнение таблицы ресторанов
INSERT INTO cafe.restaurants (name, type, menu)
SELECT DISTINCT
    s.cafe_name,
    s.type::cafe.restaurant_type,
    m.menu
FROM raw_data.sales s
JOIN raw_data.menu m USING (cafe_name);

-- Наполнение таблицы менеджеров
INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT
    manager,
    manager_phone
FROM raw_data.sales;

-- Наполнение таблицы связи ресторанов и менеджеров с указанием периодов работы
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_work_date, end_work_date)
SELECT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_work_date,
    MAX(s.report_date) AS end_work_date
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.name
JOIN cafe.managers m ON s.manager = m.name
GROUP BY
    r.restaurant_uuid,
    m.manager_uuid;

-- Наполнение таблицы продаж
INSERT INTO cafe.sales (report_date, restaurant_uuid, avg_check)
SELECT
    s.report_date,
    r.restaurant_uuid,
    AVG(s.avg_check) AS avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.name
GROUP BY
    s.report_date,
    r.restaurant_uuid;