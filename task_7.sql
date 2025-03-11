/*Задание 7.*/

-- Начинаем транзакцию.
BEGIN;

-- Блокируем таблицу managers в режиме EXCLUSIVE, чтобы запретить изменения другими транзакциями.
-- Таблица остается доступной для чтения.
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;

-- Добавляем новое поле для массива номеров телефонов.
ALTER TABLE cafe.managers 
ADD COLUMN phones VARCHAR[];

-- Обновляем поле с массивом номеров телефонов.
WITH updated_phones AS (
    SELECT
        name,
        phone,
        CONCAT('8-800-2500-', ROW_NUMBER() OVER (ORDER BY name) + 99) AS new_phone
    FROM cafe.managers
)
UPDATE cafe.managers m
SET phones = ARRAY[up.new_phone, up.phone]
FROM updated_phones up
WHERE m.name = up.name;

-- Удаляем старое поле с телефоном.
ALTER TABLE cafe.managers 
DROP COLUMN phone;

-- Завершаем транзакцию.
COMMIT;