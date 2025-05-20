-- Студенты
CREATE TABLE `students` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(50) NOT NULL DEFAULT '',
  `lastname` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
);

-- Изучаемые предметы
CREATE TABLE `subjects` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
);

-- Оценки студентов по предметам с указанием даты оценки
CREATE TABLE `student_marks` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT(10) UNSIGNED NOT NULL,
  `subject_id` INT(10) UNSIGNED NOT NULL,
  `date` DATE NOT NULL,
  `mark` TINYINT(1) UNSIGNED NOT NULL DEFAULT '5',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `subject_id` (`subject_id`),
  KEY `student_subject` (`student_id`,`subject_id`)
);

-- Расписание предметов
CREATE TABLE `subject_schedules` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject_id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `date` DATE NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`)
);

-----------------------------------------------------

-- Заполнение таблицы students
INSERT INTO `students` (`firstname`, `lastname`) VALUES
('Иван', 'Иванов'),
('Петр', 'Петров'),
('Сидор', 'Сидоров'),
('Анна', 'Кузнецова'),
('Мария', 'Соколова');

-- Заполнение таблицы subjects
INSERT INTO `subjects` (`name`) VALUES
('Математика'),
('Физика'),
('История'),
('Литература'),
('Информатика');

-- Заполнение таблицы subject_schedules (расписание)
-- Предположим, занятия были с 1 мая по сегодня
INSERT INTO `subject_schedules` (`subject_id`, `date`) VALUES
(1, '2024-05-01'), (2, '2024-05-01'), -- Математика, Физика
(3, '2024-05-02'), (4, '2024-05-02'), -- История, Литература
(1, '2024-05-03'), (5, '2024-05-03'), -- Математика, Информатика
(2, '2024-05-06'), (3, '2024-05-06'), -- Физика, История
(4, '2024-05-07'), (5, '2024-05-07'), -- Литература, Информатика
(1, '2024-05-08'), (2, '2024-05-08'),
(3, '2024-05-09'), (4, '2024-05-09'),
(1, '2024-05-10'), (5, '2024-05-10'),
(1, '2024-05-13'), (2, '2024-05-13'),
(3, '2024-05-14'), (4, '2024-05-14'),
(1, '2024-05-15'), (5, '2024-05-15'),
(2, '2024-05-16'), (3, '2024-05-16'),
(4, '2024-05-17'), (5, '2024-05-17'),
(1, '2024-05-20'), (2, '2024-05-20'),
(3, '2024-05-21'), (4, '2024-05-21'),
(1, '2024-05-22'), (5, '2024-05-22');


-- Заполнение таблицы student_marks (оценки)
-- Иван Иванов (id=1)
INSERT INTO `student_marks` (`student_id`, `subject_id`, `date`, `mark`) VALUES
(1, 1, '2024-05-01', 5), (1, 1, '2024-05-03', 4), (1, 1, '2024-05-08', 5), (1, 1, '2024-05-10', 5), (1, 1, '2024-05-15', 4),
(1, 2, '2024-05-01', 4), (1, 2, '2024-05-06', 3), (1, 2, '2024-05-13', 4),
(1, 3, '2024-05-02', 5), (1, 3, '2024-05-09', 5),
(1, 5, '2024-05-03', 5), (1, 5, '2024-05-10', 5);

-- Петр Петров (id=2)
INSERT INTO `student_marks` (`student_id`, `subject_id`, `date`, `mark`) VALUES
(2, 1, '2024-05-01', 3), (2, 1, '2024-05-08', 3), (2, 1, '2024-05-15', 2),
(2, 2, '2024-05-01', 4), (2, 2, '2024-05-06', 4), (2, 2, '2024-05-13', 5),
(2, 4, '2024-05-02', 3), (2, 4, '2024-05-09', 4),
(2, 5, '2024-05-07', 3), (2, 5, '2024-05-17', 3);

-- Сидор Сидоров (id=3)
INSERT INTO `student_marks` (`student_id`, `subject_id`, `date`, `mark`) VALUES
(3, 1, '2024-05-03', 5), (3, 1, '2024-05-10', 5), (3, 1, '2024-05-22', 5),
(3, 3, '2024-05-02', 4), (3, 3, '2024-05-06', 4), (3, 3, '2024-05-14', 5),
(3, 5, '2024-05-03', 5), (3, 5, '2024-05-17', 5), (3, 5, '2024-05-22', 4);

-- Анна Кузнецова (id=4)
INSERT INTO `student_marks` (`student_id`, `subject_id`, `date`, `mark`) VALUES
(4, 2, '2024-05-06', 5), (4, 2, '2024-05-13', 5), (4, 2, '2024-05-20', 4),
(4, 4, '2024-05-02', 5), (4, 4, '2024-05-07', 5), (4, 4, '2024-05-14', 5), (4, 4, '2024-05-21', 4),
(4, 1, '2024-05-15', 4), (4, 1, '2024-05-20', 4);

-- Мария Соколова (id=5)
INSERT INTO `student_marks` (`student_id`, `subject_id`, `date`, `mark`) VALUES
(5, 1, '2024-05-01', 2), (5, 1, '2024-05-08', 3), (5, 1, '2024-05-13', 2),
(5, 3, '2024-05-06', 3), (5, 3, '2024-05-14', 3), (5, 3, '2024-05-21', 4),
(5, 4, '2024-05-07', 4), (5, 4, '2024-05-17', 3),
(5, 5, '2024-05-10', 3), (5, 5, '2024-05-15', 3), (5, 5, '2024-05-22', 2);

-- Упражнение 1
-------------------------------------------------------------------------

SELECT
    s.firstname AS Имя,
    s.lastname AS Фамилия,
    sub.name AS Предмет,
    ROUND(AVG(sm.mark), 2) AS Средний_балл
FROM
    students s
JOIN
    student_marks sm ON s.id = sm.student_id
JOIN
    subjects sub ON sm.subject_id = sub.id
GROUP BY
    s.id, s.firstname, s.lastname, sub.id, sub.name
ORDER BY
    s.lastname, s.firstname, sub.name;

------------------------------------------------------------

SELECT
    s.firstname AS Имя,
    s.lastname AS Фамилия,
    sm.mark AS Оценка,
    COUNT(sm.mark) AS Количество
FROM
    students s
JOIN
    student_marks sm ON s.id = sm.student_id
GROUP BY
    s.id, s.firstname, s.lastname, sm.mark
ORDER BY
    s.lastname, s.firstname, sm.mark DESC;

------------------------------------------------------------

-- Общий средний балл для каждого студента
CREATE OR REPLACE VIEW student_overall_avg_mark AS
SELECT
    s.id,
    s.firstname,
    s.lastname,
    AVG(sm.mark) AS overall_avg
FROM
    students s
JOIN
    student_marks sm ON s.id = sm.student_id
GROUP BY
    s.id, s.firstname, s.lastname;

-- Самый успевающий
(SELECT
    'Самый успевающий' AS Статус,
    firstname AS Имя,
    lastname AS Фамилия,
    ROUND(overall_avg, 2) AS Средний_балл
FROM
    student_overall_avg_mark
ORDER BY
    overall_avg DESC
LIMIT 1)
UNION ALL
-- Самый неуспевающий
(SELECT
    'Самый неуспевающий' AS Статус,
    firstname AS Имя,
    lastname AS Фамилия,
    ROUND(overall_avg, 2) AS Средний_балл
FROM
    student_overall_avg_mark
ORDER BY
    overall_avg ASC
LIMIT 1);

------------------------------------------------

SELECT
    sub.name AS Предмет,
    ROUND(AVG(sm.mark), 2) AS Средний_балл_по_предмету
FROM
    subjects sub
JOIN
    student_marks sm ON sub.id = sm.subject_id
GROUP BY
    sub.id, sub.name
ORDER BY
    Средний_балл_по_предмету DESC
LIMIT 1;

------------------------------------------------

SELECT
    ss.date AS Дата,
    GROUP_CONCAT(sub.name ORDER BY sub.name SEPARATOR ', ') AS Предметы
FROM
    subject_schedules ss
JOIN
    subjects sub ON ss.subject_id = sub.id
GROUP BY
    ss.date
ORDER BY
    ss.date;

------------------------------------------------

-- Упражнение 2
CREATE TABLE `student_presents` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT(10) UNSIGNED NOT NULL,
  `subject_schedule_id` INT(10) UNSIGNED NOT NULL, -- Ссылка на конкретное занятие в расписании
  `is_present` BOOLEAN NOT NULL DEFAULT TRUE, -- TRUE - присутствовал, FALSE - отсутствовал
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_schedule_unique` (`student_id`, `subject_schedule_id`), -- Студент не может быть дважды отмечен на одном занятии
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_schedule_id`) REFERENCES `subject_schedules`(`id`) ON DELETE CASCADE
);

------------------------------------------------

INSERT INTO `student_presents` (`student_id`, `subject_schedule_id`, `is_present`) VALUES
-- Иван Иванов (id=1)
(1, 1, TRUE), (1, 2, TRUE),   -- 2024-05-01
(1, 5, TRUE),                 -- 2024-05-03 (пропустил Информатику, но мы не знаем, не было ли уважительной причины - для простоты не отмечаем)
(1, 23, TRUE), (1, 24, FALSE), -- 2024-05-20 (Математика - был, Физика - не был)
(1, 27, TRUE),                -- 2024-05-22 (Математика - был, Информатику пропустил)

-- Петр Петров (id=2)
(2, 1, FALSE), (2, 2, TRUE),  -- 2024-05-01
(2, 23, TRUE), (2, 24, TRUE), -- 2024-05-20
(2, 25, FALSE), (2, 26, TRUE),-- 2024-05-21
(2, 27, TRUE),                -- 2024-05-22

-- Сидор Сидоров (id=3)
(3, 3, TRUE), (3, 4, TRUE),   -- 2024-05-02
(3, 23, TRUE), (3, 24, TRUE), -- 2024-05-20
(3, 25, TRUE), (3, 26, FALSE),-- 2024-05-21
(3, 27, TRUE),                -- 2024-05-22

-- Анна Кузнецова (id=4)
(4, 1, TRUE), (4, 2, FALSE),
(4, 23, TRUE), (4, 24, TRUE),
(4, 25, TRUE), (4, 26, TRUE),
(4, 27, FALSE),

-- Мария Соколова (id=5)
(5, 1, FALSE), (5, 2, FALSE),
(5, 23, FALSE), (5, 24, TRUE),
(5, 25, FALSE), (5, 26, FALSE),
(5, 27, TRUE);

----------------------------------------------

SELECT
    s.firstname AS Имя,
    s.lastname AS Фамилия,
    sub.name AS Предмет,
    SUM(sp.is_present) AS Посещено_занятий, -- TRUE кастуется к 1, FALSE к 0 в MySQL при суммировании
    COUNT(sp.id) - SUM(sp.is_present) AS Пропущено_занятий,
    COUNT(sp.id) AS Всего_занятий_отмечено,
    ROUND((SUM(sp.is_present) / COUNT(sp.id)) * 100, 2) AS Процент_посещаемости
FROM
    students s
JOIN
    student_presents sp ON s.id = sp.student_id
JOIN
    subject_schedules ss ON sp.subject_schedule_id = ss.id
JOIN
    subjects sub ON ss.subject_id = sub.id
GROUP BY
    s.id, s.firstname, s.lastname, sub.id, sub.name
ORDER BY
    s.lastname, s.firstname, sub.name;

----------------------------------------------