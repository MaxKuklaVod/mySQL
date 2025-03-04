-- Создание таблицы MediaList для хранения информации о медиа (игры, фильмы, книги)
CREATE TABLE MediaList (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- Уникальный идентификатор записи (первичный ключ)
    title VARCHAR(255) NOT NULL,                -- Название медиа (игра, фильм или книга)
    type ENUM('Игры', 'Фильмы', 'Книги') NOT NULL, -- Тип медиа: игры, фильмы или книги (ограничение на три значения)
    release_date DATE,                         -- Дата выхода медиа (формат: ГГГГ-ММ-ДД)
    duration DECIMAL(5, 2),                    -- Продолжительность: 
                                               -- - Игры — часы,
                                               -- - Фильмы — минуты,
                                               -- - Книги — часы на прочтение
    rating DECIMAL(3, 1),                      -- Рейтинг (например, 9.5/10)
    author VARCHAR(100) NOT NULL               -- Автор/разработчик/режиссер медиа
);

-- Вставка данных о играх в таблицу MediaList
INSERT INTO MediaList (title, type, release_date, duration, rating, author)
VALUES 
    ('Dark Souls Remastered', 'Игры', '2018-05-25', 60.00, 9.4, 'FromSoftware'), -- Игра Dark Souls Remastered
    ('Dark Souls II: Scholar of the First Sin', 'Игры', '2015-04-07', 70.00, 8.9, 'FromSoftware'), -- Игра Dark Souls II
    ('Dark Souls III', 'Игры', '2016-04-12', 65.00, 9.5, 'FromSoftware'), -- Игра Dark Souls III
    ('Elden Ring', 'Игры', '2022-02-25', 100.00, 9.7, 'FromSoftware'); -- Игра Elden Ring

-- Вставка данных о книгах в таблицу MediaList
INSERT INTO MediaList (title, type, release_date, duration, rating, author)
VALUES 
    ('Метро 2033', 'Книги', '2005-03-18', 12.00, 8.7, 'Дмитрий Глуховский'), -- Книга Метро 2033
    ('Метро 2034', 'Книги', '2009-03-03', 10.00, 8.5, 'Дмитрий Глуховский'), -- Книга Метро 2034
    ('Метро 2035', 'Книги', '2015-02-27', 15.00, 9.0, 'Дмитрий Глуховский'), -- Книга Метро 2035
    ('Будущее', 'Книги', '2013-09-10', 8.00, 8.0, 'Дмитрий Глуховский'), -- Книга Будущее
    ('Сумерки', 'Книги', '2017-06-20', 11.00, 8.3, 'Дмитрий Глуховский'); -- Книга Сумерки

-- Вставка данных о фильмах в таблицу MediaList
INSERT INTO MediaList (title, type, release_date, duration, rating, author)
VALUES 
    ('Гнев', 'Фильмы', '2014-03-28', 121.00, 7.5, 'Тони Гиглио'), -- Фильм Гнев
    ('Ходячие Мертвецы', 'Фильмы', '2004-03-19', 101.00, 7.8, 'Зак Снайдер'), -- Фильм Ходячие Мертвецы
    ('Хантер Киллер', 'Фильмы', '2018-10-26', 122.00, 6.9, 'Дон Кирк'), -- Фильм Хантер Киллер
    ('Воздушный Маршал', 'Фильмы', '2005-04-22', 105.00, 6.7, 'Уэс Крэйвен'), -- Фильм Воздушный Маршал
    ('Однажды в Голливуде', 'Фильмы', '2019-07-26', 161.00, 8.0, 'Квентин Тарантино'); -- Фильм Однажды в Голливуде

-- Выборка всех данных из таблицы MediaList
SELECT * FROM MediaList;