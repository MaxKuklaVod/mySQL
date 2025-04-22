-----1. Основные подсчеты клиентов-----

-- 1.а) Общее количество клиентов в базе
SELECT COUNT(*) AS total_clients
FROM clients;
-- | total_clients |
-- |---------------|
-- | 378           |

-- 1.б) Количество клиентов, родившихся до 1990 года
SELECT COUNT(*) AS clients_born_before_1990
FROM clients
WHERE YEAR(dbirth) < 1990;
-- | clients_born_before_1990 |
-- |--------------------------|
-- | 332                      |

-- 1.в) Подсчет клиентов с определенными именами
SELECT 
    name, 
    COUNT(*) AS count_by_name
FROM clients
WHERE name IN ('Thomas', 'Barbara', 'Willie')
GROUP BY name;
-- | name    | count_by_name |
-- |---------|---------------|
-- | Barbara | 2             |
-- | Thomas  | 5             |
-- | Willie  | 1             |


-----2. Анализ по годам рождения-----

-- 2.а) Распределение клиентов по годам рождения
SELECT 
    YEAR(dbirth) AS birth_year, 
    COUNT(*) AS count_by_year
FROM clients
GROUP BY birth_year
ORDER BY birth_year;
-- |  birth_year  |    count_by_year    |
-- |--------------|---------------------|
-- | 1930         | 6                   |
-- | 1931         | 1                   |
-- | 1932         | 6                   |
-- | 1933         | 3                   |
-- | 1934         | 5                   |
-- | 1935         | 9                   |
-- | 1936         | 6                   |
-- | 1937         | 7                   |
-- | 1938         | 2                   |
-- | 1939         | 4                   |
-- | 1940         | 4                   |
-- | 1941         | 5                   |
-- | 1942         | 5                   |
-- | 1943         | 5                   |
-- | 1944         | 3                   |
-- | 1945         | 5                   |
-- | 1947         | 6                   |
-- | 1948         | 4                   |
-- | 1949         | 7                   |
-- | 1950         | 3                   |
-- | 1951         | 8                   |
-- | 1952         | 5                   |
-- | 1953         | 4                   |
-- | 1954         | 5                   |
-- | 1955         | 10                  |


-- 2.б) Распределение клиентов по годам рождения с разбивкой по полу
SELECT 
    YEAR(dbirth) AS birth_year, 
    gender, 
    COUNT(*) AS count_by_gender_and_year
FROM clients
GROUP BY birth_year, gender
ORDER BY birth_year, gender;
-- | birth_year | gender | count_by_gender_and_year |
-- |------------|--------|--------------------------|
-- | 1930       | M      | 5                        |
-- | 1930       | F      | 1                        |
-- | 1931       | M      | 1                        |
-- | 1932       | M      | 3                        |
-- | 1932       | F      | 3                        |
-- | 1933       | M      | 1                        |
-- | 1933       | F      | 2                        |
-- | 1934       | M      | 3                        |
-- | 1934       | F      | 2                        |
-- | 1935       | M      | 3                        |
-- | 1935       | F      | 6                        |
-- | 1936       | M      | 4                        |
-- | 1936       | F      | 2                        |
-- | 1937       | M      | 4                        |
-- | 1937       | F      | 3                        |
-- | 1938       | M      | 1                        |
-- | 1938       | F      | 1                        |
-- | 1939       | F      | 4                        |
-- | 1940       | M      | 3                        |
-- | 1940       | F      | 1                        |
-- | 1941       | M      | 1                        |
-- | 1941       | F      | 4                        |
-- | 1942       | M      | 3                        |
-- | 1942       | F      | 2                        |
-- | 1943       | M      | 4                        |


-----3. Анализ по месяцам рождения-----

-- 3) Количество клиентов, рожденных в каждом месяце
SELECT 
    MONTHNAME(dbirth) AS month_name,
    COUNT(*) AS count_by_month
FROM clients
GROUP BY month_name
ORDER BY MONTH(dbirth);
-- | month_name | count_by_month |
-- |------------|----------------|
-- | January    | 33             |
-- | February   | 28             |
-- | March      | 31             |
-- | April      | 35             |
-- | May        | 39             |
-- | June       | 27             |
-- | July       | 36             |
-- | August     | 37             |
-- | September  | 27             |
-- | October    | 27             |
-- | November   | 31             |
-- | December   | 27             |


-----4. Расчет возрастных характеристик-----

-- 4.а) Средний возраст клиентов (целое число)
SELECT 
    FLOOR(AVG(TIMESTAMPDIFF(YEAR, dbirth, CURDATE()))) AS average_age
FROM clients;
-- | average_age |
-- |-------------|
-- | 59          |

-- 4.б) Минимальный возраст среди клиентов
SELECT 
    MIN(TIMESTAMPDIFF(YEAR, dbirth, CURDATE())) AS min_age
FROM clients;
-- | min_age |
-- |---------|
-- | 25      |

-- 4.в) Максимальный возраст среди клиентов
SELECT 
    MAX(TIMESTAMPDIFF(YEAR, dbirth, CURDATE())) AS max_age
FROM clients;
-- | max_age |
-- |---------|
-- | 95      |


-----5. Уникальные имена по декадам рождения-----

-- 5) Уникальные имена клиентов, рожденных в 1960-1969 годах
SELECT DISTINCT name
FROM clients
WHERE YEAR(dbirth) BETWEEN 1960 AND 1969
ORDER BY name;
-- | №  | Имя        |
-- |----|------------|
-- | 1  | Ahti       |
-- | 2  | Alan       |
-- | 3  | Alec       |
-- | 4  | Amos       |
-- | 5  | Arthur     |
-- | 6  | Barbara    |
-- | 7  | Bennie     |
-- | 8  | Betty      |
-- | 9  | Beverly    |
-- | 10 | Bryan      |
-- | 11 | Carrie     |
-- | 12 | Cheryl     |
-- | 13 | Christopher|
-- | 14 | Clark      |
-- | 15 | Clinton    |
-- | 16 | David      |
-- | 17 | Donna      |
-- | 18 | Douglas    |
-- | 19 | Elidia     |
-- | 20 | Elizabeth  |
-- | 21 | Enid       |
-- | 22 | Ethel      |
-- | 23 | Francine   |
-- | 24 | Irene      |
-- | 25 | Jeff       |

-- Уникальные имена клиентов, рожденных в 1970-1979 годах
SELECT DISTINCT name
FROM clients
WHERE YEAR(dbirth) BETWEEN 1970 AND 1979
ORDER BY name;
-- | №  | Имя        |
-- |----|------------|
-- | 1  | Janice     |
-- | 2  | Janet      |
-- | 3  | Jan        |
-- | 4  | Jean       |
-- | 5  | Inge       |
-- | 6  | Ethel      |
-- | 7  | Ester      |
-- | 8  | Erica      |
-- | 9  | Eddie      |
-- | 10 | Dianne     |
-- | 11 | Devin      |
-- | 12 | Dennis     |
-- | 13 | Daniel     |
-- | 14 | Corinna    |
-- | 15 | Cora       |
-- | 16 | Clarissa   |
-- | 17 | Christopher|
-- | 18 | Christine  |
-- | 19 | Charles    |
-- | 20 | Carol      |
-- | 21 | Brandon    |
-- | 22 | Austin     |
-- | 23 | Anne       |
-- | 24 | Amy        |
-- | 25 | Allison    |

-- Уникальные имена клиентов, рожденных в 1980-1989 годах
SELECT DISTINCT name
FROM clients
WHERE YEAR(dbirth) BETWEEN 1980 AND 1989
ORDER BY name;
-- | №  | Имя       |
-- |----|-----------|
-- | 1  | Alan      |
-- | 2  | Arthur    |
-- | 3  | Beverly   |
-- | 4  | Brandi    |
-- | 5  | Carly     |
-- | 6  | Charles   |
-- | 7  | Chase     |
-- | 8  | Cindy     |
-- | 9  | David     |
-- | 10 | Dawn      |
-- | 11 | Donna     |
-- | 12 | Douglas   |
-- | 13 | Eric      |
-- | 14 | Frank     |
-- | 15 | Glenda    |
-- | 16 | Guillermo |
-- | 17 | Humberto  |
-- | 18 | Irving    |
-- | 19 | Janet     |
-- | 20 | Jason     |
-- | 21 | Jennifer  |
-- | 22 | Jerry     |
-- | 23 | Jesus     |
-- | 24 | Joan      |
-- | 25 | Jodie     |

-- Уникальные имена клиентов, рожденных в 1990-1999 годах
SELECT DISTINCT name
FROM clients
WHERE YEAR(dbirth) BETWEEN 1990 AND 1999
ORDER BY name;
-- | №  | Имя       |
-- |----|-----------|
-- | 1  | Alphonso  |
-- | 2  | Anthony   |
-- | 3  | Betsy     |
-- | 4  | Booker    |
-- | 5  | Brandy    |
-- | 6  | Carl      |
-- | 7  | Christian |
-- | 8  | Christine |
-- | 9  | Clarice   |
-- | 10 | Connie    |
-- | 11 | Curtis    |
-- | 12 | Deborah   |
-- | 13 | Edward    |
-- | 14 | Elise     |
-- | 15 | Elsie     |
-- | 16 | Emily     |
-- | 17 | Evelyn    |
-- | 18 | Fred      |
-- | 19 | George    |
-- | 20 | Goldie    |
-- | 21 | James     |
-- | 22 | Janet     |
-- | 23 | Jeffrey   |
-- | 24 | Jodie     |
-- | 25 | Johanna   |


-----6. Гендерное распределение по историческим периодам-----

-- 6) Количество мужчин и женщин, рожденных в 1940-1949 годах
SELECT 
    gender, 
    COUNT(*) AS count
FROM clients
WHERE YEAR(dbirth) BETWEEN 1940 AND 1949
GROUP BY gender;
-- | gender | count |
-- |--------|-------|
-- | M      | 26    |
-- | F      | 18    |

-- Количество мужчин и женщин, рожденных в 1950-1959 годах
SELECT 
    gender, 
    COUNT(*) AS count
FROM clients
WHERE YEAR(dbirth) BETWEEN 1950 AND 1959
GROUP BY gender;
-- | gender | count |
-- |--------|-------|
-- | M      | 28    |
-- | F      | 27    |

-- Количество мужчин и женщин, рожденных в 1960-1969 годах
SELECT 
    gender, 
    COUNT(*) AS count
FROM clients
WHERE YEAR(dbirth) BETWEEN 1960 AND 1969
GROUP BY gender;
-- | gender | count |
-- |--------|-------|
-- | M      | 39    |
-- | F      | 24    |

-- Количество мужчин и женщин, рожденных в 1970-1979 годах
SELECT 
    gender, 
    COUNT(*) AS count
FROM clients
WHERE YEAR(dbirth) BETWEEN 1970 AND 1979
GROUP BY gender;
-- | gender | count |
-- |--------|-------|
-- | M      | 30    |
-- | F      | 34    |

