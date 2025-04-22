-- 1. Импорт данных (выполняется в командной строке)
-- mysql -u username -p database_name < stats.sql

-- 2. Подсчет суммы хитов и загрузок

-- 2.а) По каждому дню (агрегация по дате)
SELECT 
    date,
    SUM(hits) AS total_hits,
    SUM(loads) AS total_loads
FROM stats
GROUP BY date
ORDER BY date;

-- 2.б) По каждой стране (агрегация по стране)
SELECT 
    country,
    SUM(hits) AS total_hits,
    SUM(loads) AS total_loads
FROM stats
GROUP BY country
ORDER BY country;

-- 2.в) Комбинированная агрегация по дате и стране
SELECT 
    date,
    country,
    SUM(hits) AS total_hits,
    SUM(loads) AS total_loads
FROM stats
GROUP BY date, country
ORDER BY date, country;

-- 3. Расчет средних значений

-- 3.а) Среднее количество хитов по дням
SELECT 
    date,
    AVG(hits) AS avg_hits_per_day,
    -- Дополнительная статистика для анализа распределения
    MIN(hits) AS min_hits,
    MAX(hits) AS max_hits,
    STDDEV(hits) AS hits_std_dev
FROM stats
GROUP BY date
ORDER BY date;

-- 3.б) Среднее количество хитов по странам
SELECT 
    country,
    AVG(hits) AS avg_hits_per_country,
    COUNT(*) AS records_count -- Количество записей для оценки репрезентативности
FROM stats
GROUP BY country
ORDER BY avg_hits_per_country DESC;

-- 4. Анализ загрузок

-- 4.а) Средние загрузки по дням с дополнительной статистикой
SELECT 
    date,
    AVG(loads) AS avg_loads,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loads) AS median_loads
FROM stats
GROUP BY date
ORDER BY date;

-- 4.б) Средние загрузки по странам
SELECT 
    country,
    AVG(loads) AS avg_loads,
    SUM(loads) AS total_loads
FROM stats
GROUP BY country
HAVING COUNT(*) > 3 -- Исключаем страны с малым количеством данных
ORDER BY avg_loads DESC;

-- 5. Экстремальные значения загрузок

-- 5.а) По дням с указанием дат максимума и минимума
SELECT 
    MAX(loads) AS absolute_max_loads,
    (SELECT date FROM stats WHERE loads = (SELECT MAX(loads) FROM stats) LIMIT 1) AS max_date,
    MIN(loads) AS absolute_min_loads,
    (SELECT date FROM stats WHERE loads = (SELECT MIN(loads) FROM stats) LIMIT 1) AS min_date
FROM stats;

-- 5.б) По странам с фильтрацией аномалий
SELECT 
    country,
    MAX(loads) AS max_loads,
    MIN(loads) AS min_loads
FROM stats
WHERE loads > 0 -- Исключаем нулевые значения
GROUP BY country
ORDER BY max_loads DESC;

-- 6. Расчет конверсии (загрузки/хиты)

-- 6.а) Ежедневная конверсия с обработкой деления на ноль
SELECT 
    date,
    CASE 
        WHEN SUM(hits) = 0 THEN 0 
        ELSE SUM(loads)/SUM(hits) 
    END AS conversion_rate,
    SUM(hits) AS daily_hits,
    SUM(loads) AS daily_loads
FROM stats
GROUP BY date
ORDER BY conversion_rate DESC;

-- 7. Анализ максимальной конверсии

-- 7.а) День с максимальной конверсией (топ-1)
SELECT 
    date,
    SUM(loads)/NULLIF(SUM(hits), 0) AS conversion_rate
FROM stats
GROUP BY date
ORDER BY conversion_rate DESC NULLS LAST
LIMIT 1;

-- 7.б) Топ-5 стран по конверсии с минимальным порогом активности
SELECT 
    country,
    SUM(loads)/SUM(hits) AS conversion_rate,
    SUM(hits) AS total_hits,
    SUM(loads) AS total_loads
FROM stats
GROUP BY country
HAVING SUM(hits) >= 100 -- Только страны со значительной активностью
ORDER BY conversion_rate DESC
LIMIT 5;

-- 8. Дополнительный анализ: тренды и корреляции

-- 8.а) Недельная динамика конверсии
SELECT 
    YEAR(date) AS year,
    WEEK(date) AS week,
    AVG(loads/hits) AS avg_conversion
FROM stats
WHERE hits > 0
GROUP BY YEAR(date), WEEK(date)
ORDER BY year, week;

-- 8.б) Корреляция между хитами и загрузками по странам
SELECT 
    country,
    CORR(hits, loads) AS hits_loads_correlation
FROM stats
GROUP BY country
HAVING COUNT(*) > 5 -- Только для стран с достаточными данными
ORDER BY hits_loads_correlation DESC;