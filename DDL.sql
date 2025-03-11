/*Создание схемы и таблиц.*/

-- Создание схемы
CREATE SCHEMA IF NOT EXISTS cafe;

-- Создание типа данных для типа ресторана
CREATE TYPE cafe.restaurant_type AS ENUM (
    'coffee_shop',
    'restaurant',
    'bar',
    'pizzeria'
);

-- Создание таблицы ресторанов
CREATE TABLE IF NOT EXISTS cafe.restaurants (
    restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
    name VARCHAR NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu JSONB
);

-- Создание таблицы менеджеров
CREATE TABLE IF NOT EXISTS cafe.managers (
    manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
    name VARCHAR NOT NULL,
    phone VARCHAR NOT NULL
);

-- Создание таблицы связи ресторанов и менеджеров с указанием периодов работы
CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates (
    restaurant_uuid UUID REFERENCES cafe.restaurants(restaurant_uuid),
    manager_uuid UUID REFERENCES cafe.managers(manager_uuid),
    start_work_date DATE NOT NULL,
    end_work_date DATE,
    PRIMARY KEY (restaurant_uuid, manager_uuid)
);

-- Создание таблицы продаж
CREATE TABLE IF NOT EXISTS cafe.sales (
    report_date DATE NOT NULL DEFAULT CURRENT_DATE,
    restaurant_uuid UUID REFERENCES cafe.restaurants(restaurant_uuid),
    avg_check NUMERIC(6, 2) NOT NULL,
    PRIMARY KEY (report_date, restaurant_uuid)
);