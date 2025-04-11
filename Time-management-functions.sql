-- 1. Выборка года рождения
SELECT 
    id,
    EXTRACT(YEAR FROM dbirth) AS birth_year
FROM clients;

-- 2. Текущий возраст
-- а) Полных лет
SELECT 
    id,
    name,
    lastname,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, dbirth)) AS full_years
FROM clients;

-- б) Лет до конца текущего года
SELECT 
    id,
    name,
    lastname,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dbirth) AS years_until_end_of_year
FROM clients;

-- 3. Полных лет на конкретные даты
-- а) На 8 декабря 1992 года
SELECT 
    id,
    name,
    lastname,
    CASE 
        WHEN dbirth > '1992-12-08' THEN NULL  -- если родился после даты
        ELSE EXTRACT(YEAR FROM AGE('1992-12-08', dbirth))
    END AS years_on_1992_12_08
FROM clients;

-- б) На 15 июля 2024 года
SELECT 
    id,
    name,
    lastname,
    CASE 
        WHEN dbirth > '2024-07-15' THEN NULL
        ELSE EXTRACT(YEAR FROM AGE('2024-07-15', dbirth))
    END AS years_on_2024_07_15
FROM clients;

-- 4. Дни рождения в ближайшие периоды
-- Вспомогательный CTE для расчета следующего дня рождения
WITH next_birthdays AS (
    SELECT 
        id,
        name,
        lastname,
        dbirth,
        -- Дата следующего дня рождения
        CASE 
            WHEN 
                -- Если день рождения уже прошел в этом году
                DATE_TRUNC('day', dbirth) < DATE_TRUNC('day', CURRENT_DATE) 
            THEN 
                -- Следующий год
                (DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year') 
                + (DATE_TRUNC('day', dbirth) - DATE_TRUNC('year', dbirth))
            ELSE 
                -- Текущий год
                DATE_TRUNC('year', CURRENT_DATE) 
                + (DATE_TRUNC('day', dbirth) - DATE_TRUNC('year', dbirth))
        END AS next_birthday
    FROM clients
)

-- а) Ближайшая неделя
SELECT 
    id,
    name,
    lastname,
    next_birthday
FROM next_birthdays
WHERE next_birthday BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days';

-- б) Ближайшие две недели
SELECT 
    id,
    name,
    lastname,
    next_birthday
FROM next_birthdays
WHERE next_birthday BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '14 days';

-- в) До конца текущего месяца
SELECT 
    id,
    name,
    lastname,
    next_birthday
FROM next_birthdays
WHERE next_birthday <= DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day';