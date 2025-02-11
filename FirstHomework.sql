-- 1) Поиск данных по именам
-- а) Robert
SELECT * FROM `clients` WHERE name = "Robert";
-- б) Jeffrey
SELECT * FROM `clients` WHERE name = "Jeffrey";
-- в) John
SELECT * FROM `clients` WHERE name = "John";
-- г) Richard
SELECT * FROM `clients` WHERE name = "Richard";
-- д) David
SELECT * FROM `clients` WHERE name = "David";
-- е) по всем этим значениям в одном запросе
SELECT * FROM `clients` WHERE name in ("Robert", "Jeffrey", "John", "Richard", "David");

-- 2) Поиск данных по гендерам
-- а) по мужчинам
SELECT * FROM `clients` WHERE gender = "M";
-- б) по женщинам
SELECT * FROM `clients` WHERE gender = "F";

-- 3) Поиск имени и телефона по фамилии
-- а) Williams
SELECT name, phone FROM `clients` WHERE lastname = "Williams";
-- б) Jones
SELECT name, phone FROM `clients` WHERE lastname = "Jones";
-- в) Brown
SELECT name, phone FROM `clients` WHERE lastname = "Brown";
-- г) Miller
SELECT name, phone FROM `clients` WHERE lastname = "Miller";
-- д) по всем этим значениям в одном запросе
SELECT name, phone FROM `clients` WHERE lastname in ("Williams", "Jones", "Brown", "Miller");