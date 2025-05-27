-- Database: postgres

-- DROP DATABASE IF EXISTS postgres;

CREATE DATABASE postgres
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru-RU'
    LC_CTYPE = 'ru-RU'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE postgres
    IS 'default administrative connection database';

-- Задание 1. Создать временную таблицу с координатами долготы и широты для каждого клиента.
CREATE TEMP TABLE customer_points AS (
SELECT
customer_id,
point(longitude, latitude) AS lng_lat_point
FROM customers
WHERE longitude IS NOT NULL
AND latitude IS NOT NULL
);

-- Проверим данные
SELECT * FROM customer_points;

-- Задание 2. Создаем аналогичную таблицу для каждого дилерского центра.
CREATE TEMP TABLE dealership_points AS(
SELECT dealership_id,
point(longitude, latitude) AS lng_lat_point
FROM dealerships);

-- Проверим данные
SELECT * FROM dealership_points

-- Задание 3. Теперь нужно соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого дилерского центра (в киллометрах).
CREATE TEMP TABLE customer_dealership_distance AS(
SELECT customer_id,
dealership_id,
c.lng_lat_point <@> d.lng_lat_point AS distance
FROM customer_points c
CROSS JOIN dealership_points d)

-- Проверим данные
SELECT * FROM customer_dealership_distance

-- Задание 4. Определяем ближайший дилерский центр для каждого клиента.
CREATE TEMP TABLE closest_dealerships AS(
SELECT DISTINCT ON (customer_id)
customer_id,
dealership_id,
distance
FROM customer_dealership_distance
ORDER BY customer_id, distance)

-- Проверим данные
SELECT * FROM closest_dealerships

-- Задание 5. Решение задания 5 предоставлено на гитхабе
-- Задание 6. Решение представлено на гитхабе
-- Задание 7. Удаление временных таблиц 
DROP TABLE IF EXISTS closest_dealerships;
DROP TABLE IF EXISTS customer_dealership_distance;
DROP TABLE IF EXISTS dealership_points;
DROP TABLE IF EXISTS customer_points; 







