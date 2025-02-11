-- 1) Поиск данных по именам
-- а) Robert
SELECT * 
FROM `clients` 
WHERE name = 'Robert';

-- б) Jeffrey
SELECT * 
FROM `clients` 
WHERE name = 'Jeffrey';

-- в) John
SELECT * 
FROM `clients` 
WHERE name = 'John';

-- г) Richard
SELECT * 
FROM `clients` 
WHERE name = 'Richard';

-- д) David
SELECT * 
FROM `clients` 
WHERE name = 'David';

-- е) Поиск по всем указанным именам в одном запросе
SELECT * 
FROM `clients` 
WHERE name IN ('Robert', 'Jeffrey', 'John', 'Richard', 'David');

-- 2) Поиск данных по гендерам
-- а) По мужчинам (gender = 'M')
SELECT * 
FROM `clients` 
WHERE gender = 'M';

-- б) По женщинам (gender = 'F')
SELECT * 
FROM `clients` 
WHERE gender = 'F';

-- 3) Поиск имени и телефона по фамилии
-- а) Williams
SELECT name, phone 
FROM `clients` 
WHERE lastname = 'Williams';

-- б) Jones
SELECT name, phone 
FROM `clients` 
WHERE lastname = 'Jones';

-- в) Brown
SELECT name, phone 
FROM `clients` 
WHERE lastname = 'Brown';

-- г) Miller
SELECT name, phone 
FROM `clients` 
WHERE lastname = 'Miller';

-- д) Поиск по всем указанным фамилиям в одном запросе
SELECT name, phone 
FROM `clients` 
WHERE lastname IN ('Williams', 'Jones', 'Brown', 'Miller');

-- 4) Поиск даты рождения и пола пользователя по имени или фамилии
-- а) Kelly
SELECT dbirth, gender 
FROM `clients` 
WHERE name = 'Kelly' OR lastname = 'Kelly';

-- б) Thomas
SELECT dbirth, gender 
FROM `clients` 
WHERE name = 'Thomas' OR lastname = 'Thomas';

-- в) Clark
SELECT dbirth, gender 
FROM `clients` 
WHERE name = 'Clark' OR lastname = 'Clark';

-- г) Joseph
SELECT dbirth, gender 
FROM `clients` 
WHERE name = 'Joseph' OR lastname = 'Joseph';

-- 5) Определение полей пола, даты рождения и номера телефона по имени и фамилии
-- а) Tom Brown
SELECT gender, dbirth, phone 
FROM `clients` 
WHERE name = 'Tom' AND lastname = 'Brown';

-- б) Janet Silberstein
SELECT gender, dbirth, phone 
FROM `clients` 
WHERE name = 'Janet' AND lastname = 'Silberstein';

-- в) John Foster
SELECT gender, dbirth, phone 
FROM `clients` 
WHERE name = 'John' AND lastname = 'Foster';