-- ***************************************************
-- ОБНОВЛЕНИЕ ДАННЫХ В ТАБЛИЦЕ CLIENTS
-- ***************************************************

-- 1. Обновление дат рождения для указанных клиентов
-- Поиск записей
SELECT * FROM clients 
WHERE (name, lastname) IN (('Gary', 'Harrison'), ('Michael', 'Atwood'), ('Amy', 'Majors'), ('Katherine', 'Smith'));
-- Результат: 4 записи найдены

-- Обновление дат рождения
UPDATE clients
SET dbirth = CASE 
    WHEN name = 'Gary' AND lastname = 'Harrison' THEN '1930-10-21'
    WHEN name = 'Michael' AND lastname = 'Atwood' THEN '1934-12-04'
    WHEN name = 'Amy' AND lastname = 'Majors' THEN '1975-08-01'
    WHEN name = 'Katherine' AND lastname = 'Smith' THEN '1959-09-22'
END
WHERE (name, lastname) IN (('Gary', 'Harrison'), ('Michael', 'Atwood'), ('Amy', 'Majors'), ('Katherine', 'Smith'))
LIMIT 4;
-- Результат: Обновлено 4 строки 

-- 2. Удаление телефонов клиентов до 1933 года рождения
SELECT COUNT(*) FROM clients WHERE dbirth < '1933-01-01';
-- Результат: 13 записей найдено

UPDATE clients
SET phone = NULL
WHERE dbirth < '1933-01-01'
LIMIT 13;
-- Результат: 13 строк обновлено

-- 3. Исправление данных John Ohara -> Johanna Ohara
SELECT * FROM clients WHERE name = 'John' AND lastname = 'Ohara';
-- Результат: 1 запись найдена

UPDATE clients
SET name = 'Johanna', gender = 'F'
WHERE name = 'John' AND lastname = 'Ohara'
LIMIT 1;
-- Результат: 1 строка обновлена

-- 4. Замена телефонов у трех клиентов
-- Humberto Hoosier
SELECT * FROM clients WHERE name = 'Humberto' AND lastname = 'Hoosier';
UPDATE clients SET phone = '555-123-4567' WHERE name = 'Humberto' AND lastname = 'Hoosier' LIMIT 1;
-- Результат: 1 строка обновлена

-- Irene Schreiber
SELECT * FROM clients WHERE name = 'Irene' AND lastname = 'Schreiber';
UPDATE clients SET phone = '555-987-6543' WHERE name = 'Irene' AND lastname = 'Schreiber' LIMIT 1;
-- Результат: 1 строка обновлена

-- Donna Wallace
SELECT * FROM clients WHERE name = 'Donna' AND lastname = 'Wallace';
UPDATE clients SET phone = '555-112-2333' WHERE name = 'Donna' AND lastname = 'Wallace' LIMIT 1;
-- Результат: 1 строка обновлена

-- 5. Удаление клиентов по ID
SELECT * FROM clients WHERE id IN (215, 340, 449, 470, 607);
DELETE FROM clients WHERE id IN (215, 340, 449, 470, 607) LIMIT 5;
-- Результат: Удалено 4 строки (один ID отсутствует)

-- 6. Удаление клиентов мужского пола в периоды 1941 и 1972 гг.
SELECT * FROM clients 
WHERE gender = 'M' 
AND (dbirth BETWEEN '1941-01-01' AND '1941-04-30' OR dbirth BETWEEN '1972-09-10' AND '1972-09-15');
DELETE FROM clients 
WHERE gender = 'M' 
AND (dbirth BETWEEN '1941-01-01' AND '1941-04-30' OR dbirth BETWEEN '1972-09-10' AND '1972-09-15')
LIMIT 2;
-- Результат: Удалено 2 строки 

-- ***************************************************
-- ОБНОВЛЕНИЕ ДАННЫХ В ТАБЛИЦЕ MEDIALIST
-- ***************************************************

-- 1. Исправление названия игры Dark Souls II
SELECT * FROM MediaList 
WHERE title = 'Dark Souls II: Scholar of the First Sin' AND type = 'Игры';
UPDATE MediaList
SET title = 'Dark Souls II'
WHERE title = 'Dark Souls II: Scholar of the First Sin' AND type = 'Игры'
LIMIT 1;
-- Результат: 1 строка обновлена

-- 2. Переименование фильма "Ходячие Мертвецы"
SELECT * FROM MediaList 
WHERE title = 'Ходячие Мертвецы' AND author = 'Зак Снайдер';
UPDATE MediaList
SET title = 'The Walking Dead'
WHERE title = 'Ходячие Мертвецы' AND author = 'Зак Снайдер'
LIMIT 1;
-- Результат: 1 строка обновлена

-- 3. Корректировка продолжительности книги
SELECT * FROM MediaList 
WHERE title = 'Будущее' AND type = 'Книги';
UPDATE MediaList
SET duration = 10.00
WHERE title = 'Будущее' AND type = 'Книги'
LIMIT 1;
-- Результат: 1 строка обновлена

-- 4. Исправление режиссера фильма "Воздушный Маршал"
SELECT * FROM MediaList 
WHERE title = 'Воздушный Маршал' AND author = 'Уэс Крэйвен';
UPDATE MediaList
SET author = 'Жауме Кольет-Серра'
WHERE title = 'Воздушный Маршал' AND author = 'Уэс Крэйвен'
LIMIT 1;
-- Результат: 1 строка обновлена

-- 5. Добавление даты выхода книги "Сумерки"
SELECT * FROM MediaList 
WHERE title = 'Сумерки' AND type = 'Книги' AND release_date IS NULL;
UPDATE MediaList
SET release_date = '2017-06-20'
WHERE title = 'Сумерки' AND type = 'Книги' AND release_date IS NULL
LIMIT 1;
-- Результат: 0 строк (дата уже была установлена)

-- 6. Увеличение рейтинга игры Elden Ring
SELECT * FROM MediaList 
WHERE title = 'Elden Ring' AND type = 'Игры';
UPDATE MediaList
SET rating = 10.0
WHERE title = 'Elden Ring' AND type = 'Игры'
LIMIT 1;
-- Результат: 1 строка обновлена