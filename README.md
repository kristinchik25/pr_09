# pr_09
## Практическая работа 9. Геопространственный анализ. 
## Цель:
Определение ближайшего дилерского центра для каждого клиента.
Маркетологи компании пытаются повысить вовлеченность клиентов,
необходимо им помочь найти ближайший дилерский центр.
Разработчикам продукта также интересно знать, каково среднее
расстояние между каждым клиентом и ближайшим к нему дилерским
центром.

## Задачи:
1. Проверить наличие геопространственных данных в базе данных.
2. Создать временную таблицу с координатами долготы и широты для каждого клиента.
3. Создать аналогичную таблицу для каждого дилерского центра.
4. Соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого
дилерского центра (в киллометрах).
5. Определить ближайший дилерский центр для каждого клиента.
6. Провести выгрузку полученного результата из временной таблицы в CSV.
7. Построить карту клиентов и сервисных центров в облачной визуализации Yandex DataLence.
8. Удалить временные таблицы.

## Выполнение практической работы

## Задание 1. Создать временную таблицу с координатами долготы и широты для каждого клиента.

````
CREATE TEMP TABLE customer_points AS (
SELECT
customer_id,
point(longitude, latitude) AS lng_lat_point
FROM customers
WHERE longitude IS NOT NULL
AND latitude IS NOT NULL
);
````
## Результат
![image](https://github.com/user-attachments/assets/938e4bfe-b571-461a-9fec-92f2a4d756fc)

Проверим данные
````
SELECT * FROM customer_points;
````
## Результат
![image](https://github.com/user-attachments/assets/0d43ff9f-1cb8-44ed-bf48-824738f3d09e)

## Задание 2. Создаем аналогичную таблицу для каждого дилерского центра.
````
CREATE TEMP TABLE dealership_points AS(
SELECT dealership_id,
point(longitude, latitude) AS lng_lat_point
FROM dealerships);
````
## Результат
![image](https://github.com/user-attachments/assets/299f20cb-9aae-41ca-bf27-9e33ae5d66b1)

Проверим данные
````
SELECT * FROM dealership_points
````
## Результат
![image](https://github.com/user-attachments/assets/3f4eaf82-4ee2-4d0f-9b05-881b386e2250)


## Задание 3. Теперь нужно соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого дилерского центра (в киллометрах).
````
CREATE TEMP TABLE customer_dealership_distance AS(
SELECT customer_id,
dealership_id,
c.lng_lat_point <@> d.lng_lat_point AS distance
FROM customer_points c
CROSS JOIN dealership_points d)
````
## Результат
![image](https://github.com/user-attachments/assets/aa891518-f380-4fc1-a2e8-b81d33feb178)


Проверим данные
````
SELECT * FROM customer_dealership_distance
````
## Результат
![image](https://github.com/user-attachments/assets/4cea210b-d8b6-4369-824a-73ebf494d9a0)



## Задание 4. Определяем ближайший дилерский центр для каждого клиента.
````
CREATE TEMP TABLE closest_dealerships AS(
SELECT DISTINCT ON (customer_id)
customer_id,
dealership_id,
distance
FROM customer_dealership_distance
ORDER BY customer_id, distance)
````

## Результат

![image](https://github.com/user-attachments/assets/ef82229c-d1f2-4da0-b934-1dc45a90932c)

Проверим данные
````
SELECT * FROM closest_dealerships
````
## Результат
![image](https://github.com/user-attachments/assets/a98bc4b2-834d-4cd1-ba0b-552d16af87a3)


## Задание 5.Проведем выгрузку полученного результата из временной таблицы в CSV
Чтобы сохранить этот результат, необходимо просто нажать на эту кнопку, файл автоматически скачивается в формате CSV


 ![image](https://github.com/user-attachments/assets/d7270b4d-ad34-44c9-86ba-45b246cf6475)

## Результат
![image](https://github.com/user-attachments/assets/f2586907-b45d-4577-a5f7-7df92858f90a)


## Задание 6.Построим карту клиентов и сервисных центров в облачной визуализации Yandex DataLence.
Работу будем выполнять в Yandex DataLence, сначала нужно авторизоваться, создать подключение к базе данных, используя данные, выданные преподавателем. Создаем датасет, где выбираем необходимые таблицы
 
![image](https://github.com/user-attachments/assets/9f42a582-fc77-4277-b8ef-65458f35386a)

Затем добавляем необходимые поля, тип данных-геоточка
````
CONCAT('[', [latitude],',', [longitude], ']')
````

````
CONCAT('[', [latitude(1)],',', [longitude(1)], ']')
````

![image](https://github.com/user-attachments/assets/7e509859-fd5d-4deb-9763-a27ae2ea936d)

После настраиваем слои

![image](https://github.com/user-attachments/assets/6b8169b4-7841-4a84-94d7-561ec79203a4)

![image](https://github.com/user-attachments/assets/0ff4b455-beb3-4bae-a8a5-0cfed72af7b0)

Сохраняем результат и получаем работающую карту клиентов и сервесных центров
![image](https://github.com/user-attachments/assets/b8f967bc-4bfe-4313-b08a-a97a5134aefd)

##Ссылка на карту
https://datalens.yandex.cloud/preview/6nrfxd9hx6p8s

## Задание 7. Удаляем временные таблицы
````
DROP TABLE IF EXISTS closest_dealerships;
DROP TABLE IF EXISTS customer_dealership_distance;
DROP TABLE IF EXISTS dealership_points;
DROP TABLE IF EXISTS customer_points; 
````
## Выводы
В ходе работы были изучены принципы и технологии работы с временными таблицами в SQL, включая создание, наполнение и анализ промежуточных данных. Были получены практические навыки выполнения операций выборки и обработки данных с использованием временных таблиц.
