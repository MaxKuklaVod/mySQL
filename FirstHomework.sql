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