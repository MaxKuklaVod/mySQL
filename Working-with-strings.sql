-- 1. Выборка id и имен клиентов в верхнем и нижнем регистрах
-- а) Верхний регистр
SELECT id, UPPER(name) AS upper_name FROM clients;

-- б) Нижний регистр
SELECT id, LOWER(name) AS lower_name FROM clients;

-- 2. Вывод full_name и phone_number в сокращенном виде
SELECT 
    CONCAT(lastname, ' ', name) AS full_name,
    CONCAT(
        SUBSTRING(phone FROM 1 FOR 3),
        '***',
        SUBSTRING(phone FROM LENGTH(phone) FOR 1)
    ) AS phone_number
FROM clients;

-- 3. Клиенты с фамилиями, содержащими tt, ss, ll
SELECT 
    CONCAT(LEFT(name, 1), '. ', lastname) AS formatted_name
FROM clients
WHERE lastname ~ 'tt|ss|ll';  -- Регулярное выражение для поиска подстрок

-- 4. Поиск по телефонным номерам
-- а) Начинаются на 586
SELECT * FROM clients WHERE phone LIKE '586%';

-- б) Содержат 657
SELECT * FROM clients WHERE phone LIKE '%657%';

-- в) Заканчиваются на 707
SELECT * FROM clients WHERE phone LIKE '%707';