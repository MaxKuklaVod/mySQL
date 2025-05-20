-- Добавляем столбцы для времени начала и конца
ALTER TABLE `subject_schedules`
ADD COLUMN `start_time` TIME NULL AFTER `date`,
ADD COLUMN `end_time` TIME NULL AFTER `start_time`;

-- Обновим существующие записи, добавив время
-- Это примерное заполнение, вам нужно будет адаптировать под ваши данные и логику
-- Будем считать, что занятия идут парами с небольшими перерывами.
-- Длительность занятия - 1 час 30 минут (90 минут). Перерыв 15 минут.
-- 1-я пара: 09:00 - 10:30
-- 2-я пара: 10:45 - 12:15
-- 3-я пара: 13:00 - 14:30
-- 4-я пара: 14:45 - 16:15

-- Пример для нескольких дат. Вам нужно будет пройтись по всем вашим данным.
-- Для упрощения, предположим, что если в один день два предмета, то они идут последовательно.
-- Если один, то он первый.

-- 2024-05-01: Математика (id=1), Физика (id=2)
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-01';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 2 AND `date` = '2024-05-01';

-- 2024-05-02: История (id=3), Литература (id=4)
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 3 AND `date` = '2024-05-02';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 4 AND `date` = '2024-05-02';

-- 2024-05-03: Математика (id=1), Информатика (id=5)
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-03';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 5 AND `date` = '2024-05-03';

-- ... и так далее для всех записей в subject_schedules
-- Пример с "окном" побольше
-- 2024-05-06: Физика (id=2), История (id=3)
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 2 AND `date` = '2024-05-06';
UPDATE `subject_schedules` SET `start_time` = '13:00:00', `end_time` = '14:30:00' WHERE `subject_id` = 3 AND `date` = '2024-05-06'; -- Окно с 10:30 до 13:00

-- Для остальных дат заполним по аналогии, стараясь не создавать наложений
-- (Это ручной процесс, в реальности мог бы быть скрипт, если бы была четкая логика)
-- Пример для 2024-05-07
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 4 AND `date` = '2024-05-07';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 5 AND `date` = '2024-05-07';
-- 2024-05-08
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-08';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 2 AND `date` = '2024-05-08';
-- 2024-05-09
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 3 AND `date` = '2024-05-09';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 4 AND `date` = '2024-05-09';
-- 2024-05-10
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-10';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 5 AND `date` = '2024-05-10';
-- и так далее для всех дат...
-- ...
-- 2024-05-20
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-20';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 2 AND `date` = '2024-05-20';
-- 2024-05-21
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 3 AND `date` = '2024-05-21';
UPDATE `subject_schedules` SET `start_time` = '10:45:00', `end_time` = '12:15:00' WHERE `subject_id` = 4 AND `date` = '2024-05-21';
-- 2024-05-22
UPDATE `subject_schedules` SET `start_time` = '09:00:00', `end_time` = '10:30:00' WHERE `subject_id` = 1 AND `date` = '2024-05-22';
UPDATE `subject_schedules` SET `start_time` = '13:00:00', `end_time` = '14:30:00' WHERE `subject_id` = 5 AND `date` = '2024-05-22'; -- "Окно"

-----------------------------------------------------

CREATE OR REPLACE VIEW `general_schedule_view` AS
SELECT
    ss.date AS Дата,
    ss.start_time AS Начало,
    ss.end_time AS Конец,
    sub.name AS Предмет
FROM
    `subject_schedules` ss
JOIN
    `subjects` sub ON ss.subject_id = sub.id
ORDER BY
    ss.date, ss.start_time;

-- Просмотр представления
SELECT * FROM `general_schedule_view`;
SELECT * FROM `general_schedule_view` WHERE Дата = '2024-05-06';

CREATE OR REPLACE VIEW `student_individual_schedule_view` AS
SELECT
    s.id AS student_id,
    s.firstname AS Имя_студента,
    s.lastname AS Фамилия_студента,
    ss.date AS Дата,
    ss.start_time AS Начало,
    ss.end_time AS Конец,
    sub.name AS Предмет,
    sp.is_present AS Присутствовал
FROM
    `students` s
JOIN
    `student_presents` sp ON s.id = sp.student_id
JOIN
    `subject_schedules` ss ON sp.subject_schedule_id = ss.id
JOIN
    `subjects` sub ON ss.subject_id = sub.id
ORDER BY
    s.lastname, s.firstname, ss.date, ss.start_time;

-- Просмотр представления
SELECT * FROM `student_individual_schedule_view`;
SELECT * FROM `student_individual_schedule_view` WHERE Фамилия_студента = 'Иванов';

--------------------------------------------------

CREATE OR REPLACE VIEW `student_subject_avg_marks_view` AS
SELECT
    s.firstname AS Имя_студента,
    s.lastname AS Фамилия_студента,
    sub.name AS Предмет,
    ROUND(AVG(sm.mark), 2) AS Средний_балл,
    s.id as student_id,
    sub.id as subject_id
FROM
    `students` s
JOIN
    `student_marks` sm ON s.id = sm.student_id
JOIN
    `subjects` sub ON sm.subject_id = sub.id
GROUP BY
    s.id, s.firstname, s.lastname, sub.id, sub.name;

-- Использование:
SELECT * FROM `student_subject_avg_marks_view` WHERE Фамилия_студента = 'Петров';
SELECT Предмет, AVG(Средний_балл) AS Общий_средний_по_предмету
FROM `student_subject_avg_marks_view`
GROUP BY Предмет
ORDER BY Общий_средний_по_предмету DESC;

CREATE OR REPLACE VIEW `student_mark_counts_view` AS
SELECT
    s.firstname AS Имя_студента,
    s.lastname AS Фамилия_студента,
    sm.mark AS Оценка,
    COUNT(sm.mark) AS Количество,
    s.id as student_id
FROM
    `students` s
JOIN
    `student_marks` sm ON s.id = sm.student_id
GROUP BY
    s.id, s.firstname, s.lastname, sm.mark;

-- Использование:
SELECT * FROM `student_mark_counts_view` WHERE Фамилия_студента = 'Иванов' ORDER BY Оценка DESC;
SELECT Имя_студента, Фамилия_студента, SUM(Количество) AS Всего_оценок
FROM `student_mark_counts_view`
GROUP BY Имя_студента, Фамилия_студента
ORDER BY Всего_оценок DESC;

-- Это представление было создано в прошлом задании, просто убедимся что оно есть
CREATE OR REPLACE VIEW `student_overall_avg_mark_view` AS
SELECT
    s.id AS student_id,
    s.firstname AS Имя_студента,
    s.lastname AS Фамилия_студента,
    AVG(sm.mark) AS Общий_средний_балл
FROM
    `students` s
JOIN
    `student_marks` sm ON s.id = sm.student_id
GROUP BY
    s.id, s.firstname, s.lastname;

-- Самый успевающий:
SELECT * FROM `student_overall_avg_mark_view` ORDER BY Общий_средний_балл DESC LIMIT 1;
-- Самый неуспевающий:
SELECT * FROM `student_overall_avg_mark_view` ORDER BY Общий_средний_балл ASC LIMIT 1;

CREATE OR REPLACE VIEW `subject_avg_mark_view` AS
SELECT
    sub.name AS Предмет,
    ROUND(AVG(sm.mark), 2) AS Средний_балл_по_предмету,
    sub.id as subject_id
FROM
    `subjects` sub
JOIN
    `student_marks` sm ON sub.id = sm.subject_id
GROUP BY
    sub.id, sub.name;

-- Самая "легкая" дисциплина:
SELECT * FROM `subject_avg_mark_view` ORDER BY Средний_балл_по_предмету DESC LIMIT 1;
-- Дисциплины со средним баллом выше 4:
SELECT * FROM `subject_avg_mark_view` WHERE Средний_балл_по_предмету > 4.0;

CREATE OR REPLACE VIEW `daily_subject_list_view` AS
SELECT
    ss.date AS Дата,
    GROUP_CONCAT(DISTINCT sub.name ORDER BY sub.name SEPARATOR ', ') AS Предметы_в_этот_день
FROM
    `subject_schedules` ss
JOIN
    `subjects` sub ON ss.subject_id = sub.id
GROUP BY
    ss.date;

-- Использование:
SELECT * FROM `daily_subject_list_view` ORDER BY Дата DESC;
SELECT * FROM `daily_subject_list_view` WHERE Дата = '2024-05-01';

CREATE OR REPLACE VIEW `student_attendance_report_view` AS
SELECT
    s.firstname AS Имя,
    s.lastname AS Фамилия,
    sub.name AS Предмет,
    SUM(sp.is_present) AS Посещено_занятий,
    COUNT(sp.id) - SUM(sp.is_present) AS Пропущено_занятий,
    COUNT(sp.id) AS Всего_занятий_отмечено, -- по которым есть запись в student_presents
    ROUND((SUM(sp.is_present) / COUNT(sp.id)) * 100, 2) AS Процент_посещаемости,
    s.id as student_id,
    sub.id as subject_id
FROM
    `students` s
JOIN
    `student_presents` sp ON s.id = sp.student_id
JOIN
    `subject_schedules` ss ON sp.subject_schedule_id = ss.id
JOIN
    `subjects` sub ON ss.subject_id = sub.id
GROUP BY
    s.id, s.firstname, s.lastname, sub.id, sub.name;

-- Использование:
SELECT * FROM `student_attendance_report_view` WHERE Фамилия = 'Иванов';
SELECT Предмет, AVG(Процент_посещаемости) AS Средний_процент_посещаемости_по_предмету
FROM `student_attendance_report_view`
GROUP BY Предмет
ORDER BY Средний_процент_посещаемости_по_предмету ASC;

SELECT * FROM `general_schedule_view`
WHERE Дата BETWEEN '2024-05-06' AND '2024-05-10'
ORDER BY Дата, Начало;

SELECT Дата, Начало, Конец, Предмет
FROM `student_individual_schedule_view`
WHERE Фамилия_студента = 'Петров' AND Имя_студента = 'Петр' AND Присутствовал = FALSE
ORDER BY Дата, Начало;

SELECT Имя_студента, Фамилия_студента, Средний_балл
FROM `student_subject_avg_marks_view`
WHERE Предмет = 'Математика' AND Средний_балл < 4.0
ORDER BY Средний_балл ASC;

SELECT Имя_студента, Фамилия_студента, Количество
FROM `student_mark_counts_view`
WHERE Оценка = 5
ORDER BY Количество DESC;

SELECT Имя, Фамилия, Процент_посещаемости
FROM `student_attendance_report_view`
WHERE Предмет = 'Информатика' AND Процент_посещаемости < 70.0
ORDER BY Процент_посещаемости ASC;

SELECT Имя_студента, Фамилия_студента, ROUND(Общий_средний_балл, 2) AS Средний_балл
FROM `student_overall_avg_mark_view`
ORDER BY Общий_средний_балл DESC
LIMIT 3;