-- Файл: library_db_project.sql
-- Проект БД: Библиотека
-- Описание: Скрипт для создания структуры базы данных "Библиотека",
-- заполнения её начальными данными и создания представлений.

-- -----------------------------------------------------
-- Удаление существующих объектов (для чистого старта)
-- -----------------------------------------------------
DROP VIEW IF EXISTS `view_overdue_loans`;
DROP VIEW IF EXISTS `view_available_book_copies`;
DROP VIEW IF EXISTS `view_reader_active_loans`;
DROP VIEW IF EXISTS `view_full_book_info`;

DROP TABLE IF EXISTS `loans`;
DROP TABLE IF EXISTS `book_copies`;
DROP TABLE IF EXISTS `book_genres`;
DROP TABLE IF EXISTS `book_authors`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `genres`;
DROP TABLE IF EXISTS `publishers`;
DROP TABLE IF EXISTS `authors`;
DROP TABLE IF EXISTS `readers`;

-- -----------------------------------------------------
-- Таблица: `authors` (Авторы)
-- Описание: Хранит информацию об авторах книг.
-- -----------------------------------------------------
CREATE TABLE `authors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор автора (PK)',
  `first_name` VARCHAR(100) NOT NULL COMMENT 'Имя автора',
  `last_name` VARCHAR(100) NOT NULL COMMENT 'Фамилия автора',
  `middle_name` VARCHAR(100) NULL COMMENT 'Отчество автора (опционально)',
  `birth_date` DATE NULL COMMENT 'Дата рождения (опционально)',
  `biography` TEXT NULL COMMENT 'Краткая биография (опционально)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Авторы книг';

-- -----------------------------------------------------
-- Таблица: `publishers` (Издательства)
-- Описание: Хранит информацию об издательствах.
-- -----------------------------------------------------
CREATE TABLE `publishers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор издательства (PK)',
  `name` VARCHAR(255) NOT NULL COMMENT 'Название издательства',
  `city` VARCHAR(100) NULL COMMENT 'Город издательства (опционально)',
  `contact_info` VARCHAR(255) NULL COMMENT 'Контактная информация (телефон, email, опционально)',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_publisher_name` (`name` ASC) COMMENT 'Название издательства должно быть уникальным'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Издательства';

-- -----------------------------------------------------
-- Таблица: `genres` (Жанры)
-- Описание: Справочник жанров литературы.
-- -----------------------------------------------------
CREATE TABLE `genres` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор жанра (PK)',
  `name` VARCHAR(100) NOT NULL COMMENT 'Название жанра',
  `description` TEXT NULL COMMENT 'Описание жанра (опционально)',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_genre_name` (`name` ASC) COMMENT 'Название жанра должно быть уникальным'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Жанры литературы';

-- -----------------------------------------------------
-- Таблица: `books` (Книги - как произведения)
-- Описание: Информация о книгах как о литературных произведениях.
-- -----------------------------------------------------
CREATE TABLE `books` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор книги (PK)',
  `title` VARCHAR(255) NOT NULL COMMENT 'Название книги',
  `isbn` VARCHAR(20) NOT NULL COMMENT 'Международный стандартный книжный номер (ISBN)',
  `publication_year` YEAR NULL COMMENT 'Год издания',
  `publisher_id` INT UNSIGNED NULL COMMENT 'ID издательства (FK к publishers.id)',
  `pages_count` INT UNSIGNED NULL COMMENT 'Количество страниц',
  `description` TEXT NULL COMMENT 'Краткое описание/аннотация',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_isbn` (`isbn` ASC) COMMENT 'ISBN должен быть уникальным',
  INDEX `idx_book_title` (`title` ASC) COMMENT 'Индекс по названию для быстрого поиска',
  CONSTRAINT `fk_book_publisher`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `publishers` (`id`)
    ON DELETE SET NULL -- Если издательство удаляется, у книги это поле станет NULL
    ON UPDATE CASCADE -- Если ID издательства меняется, обновить и здесь
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Книги как литературные произведения';

-- -----------------------------------------------------
-- Таблица: `book_authors` (Авторы книг - связующая таблица)
-- Описание: Связывает книги с их авторами (реализация связи многие-ко-многим).
-- -----------------------------------------------------
CREATE TABLE `book_authors` (
  `book_id` INT UNSIGNED NOT NULL COMMENT 'ID книги (FK к books.id)',
  `author_id` INT UNSIGNED NOT NULL COMMENT 'ID автора (FK к authors.id)',
  PRIMARY KEY (`book_id`, `author_id`) COMMENT 'Составной первичный ключ',
  CONSTRAINT `fk_bookauthors_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `books` (`id`)
    ON DELETE CASCADE -- Если книга удаляется, удалить и эту связь
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bookauthors_author`
    FOREIGN KEY (`author_id`)
    REFERENCES `authors` (`id`)
    ON DELETE CASCADE -- Если автор удаляется, удалить и эту связь
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Связь книги-авторы (многие-ко-многим)';

-- -----------------------------------------------------
-- Таблица: `book_genres` (Жанры книг - связующая таблица)
-- Описание: Связывает книги с их жанрами (реализация связи многие-ко-многим).
-- -----------------------------------------------------
CREATE TABLE `book_genres` (
  `book_id` INT UNSIGNED NOT NULL COMMENT 'ID книги (FK к books.id)',
  `genre_id` INT UNSIGNED NOT NULL COMMENT 'ID жанра (FK к genres.id)',
  PRIMARY KEY (`book_id`, `genre_id`) COMMENT 'Составной первичный ключ',
  CONSTRAINT `fk_bookgenres_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `books` (`id`)
    ON DELETE CASCADE -- Если книга удаляется, удалить и эту связь
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bookgenres_genre`
    FOREIGN KEY (`genre_id`)
    REFERENCES `genres` (`id`)
    ON DELETE CASCADE -- Если жанр удаляется, удалить и эту связь
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Связь книги-жанры (многие-ко-многим)';

-- -----------------------------------------------------
-- Таблица: `book_copies` (Экземпляры книг)
-- Описание: Хранит информацию о конкретных физических экземплярах книг.
-- -----------------------------------------------------
CREATE TABLE `book_copies` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор экземпляра (PK)',
  `book_id` INT UNSIGNED NOT NULL COMMENT 'ID книги, к которой относится экземпляр (FK к books.id)',
  `inventory_number` VARCHAR(50) NOT NULL COMMENT 'Инвентарный номер экземпляра (уникальный)',
  `status` ENUM('available', 'on_loan', 'damaged', 'lost', 'under_repair') NOT NULL DEFAULT 'available' COMMENT 'Статус экземпляра',
  `acquisition_date` DATE NOT NULL COMMENT 'Дата поступления экземпляра в библиотеку',
  `location` VARCHAR(100) NULL COMMENT 'Местоположение в библиотеке (полка, зал, опционально)',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_inventory_number` (`inventory_number` ASC) COMMENT 'Инвентарный номер должен быть уникальным',
  INDEX `idx_bookcopy_status` (`status` ASC) COMMENT 'Индекс по статусу для быстрого поиска доступных книг',
  CONSTRAINT `fk_bookcopy_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `books` (`id`)
    ON DELETE CASCADE -- Если удаляется книга (произведение), удаляются и все ее экземпляры
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Физические экземпляры книг';

-- -----------------------------------------------------
-- Таблица: `readers` (Читатели)
-- Описание: Информация о зарегистрированных читателях библиотеки.
-- -----------------------------------------------------
CREATE TABLE `readers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор читателя (PK)',
  `library_card_number` VARCHAR(20) NOT NULL COMMENT 'Номер читательского билета (уникальный)',
  `first_name` VARCHAR(100) NOT NULL COMMENT 'Имя читателя',
  `last_name` VARCHAR(100) NOT NULL COMMENT 'Фамилия читателя',
  `middle_name` VARCHAR(100) NULL COMMENT 'Отчество читателя (опционально)',
  `birth_date` DATE NOT NULL COMMENT 'Дата рождения',
  `address` VARCHAR(255) NULL COMMENT 'Адрес проживания',
  `phone_number` VARCHAR(20) NULL COMMENT 'Контактный телефон',
  `email` VARCHAR(100) NULL COMMENT 'Адрес электронной почты (уникальный, опционально)',
  `registration_date` DATE NOT NULL COMMENT 'Дата регистрации в библиотеке',
  `notes` TEXT NULL COMMENT 'Заметки о читателе (например, "часто берет детективы")',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_library_card_number` (`library_card_number` ASC) COMMENT 'Номер читательского билета должен быть уникальным',
  UNIQUE INDEX `uq_reader_email` (`email` ASC) COMMENT 'Email читателя должен быть уникальным, если указан'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Зарегистрированные читатели библиотеки';

-- -----------------------------------------------------
-- Таблица: `loans` (Выдачи книг)
-- Описание: Информация о фактах выдачи книг читателям.
-- -----------------------------------------------------
CREATE TABLE `loans` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор выдачи (PK)',
  `book_copy_id` INT UNSIGNED NOT NULL COMMENT 'ID выданного экземпляра книги (FK к book_copies.id)',
  `reader_id` INT UNSIGNED NOT NULL COMMENT 'ID читателя, которому выдана книга (FK к readers.id)',
  `loan_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время выдачи книги (по умолчанию текущие)',
  `due_date` DATE NOT NULL COMMENT 'Ожидаемая дата возврата',
  `return_date` DATETIME NULL COMMENT 'Фактическая дата и время возврата (NULL, если книга еще не возвращена)',
  `fine_amount` DECIMAL(10,2) NULL DEFAULT 0.00 COMMENT 'Сумма штрафа за просрочку (если есть)',
  `notes` TEXT NULL COMMENT 'Заметки по выдаче (например, "выдано с повреждением обложки")',
  PRIMARY KEY (`id`),
  INDEX `idx_loan_active` (`book_copy_id` ASC, `return_date` ASC) COMMENT 'Индекс для быстрого поиска активных выдач по экземпляру',
  CONSTRAINT `fk_loan_bookcopy`
    FOREIGN KEY (`book_copy_id`)
    REFERENCES `book_copies` (`id`)
    ON DELETE RESTRICT -- Нельзя удалить экземпляр, если он связан с выдачей (даже прошлой)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_loan_reader`
    FOREIGN KEY (`reader_id`)
    REFERENCES `readers` (`id`)
    ON DELETE RESTRICT -- Нельзя удалить читателя, если у него есть история выдач
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Информация о выдачах книг читателям';


-- -----------------------------------------------------
-- Начальное заполнение данными (Sample Data)
-- -----------------------------------------------------

-- Авторы
INSERT INTO `authors` (`first_name`, `last_name`, `birth_date`, `biography`) VALUES
('Лев', 'Толстой', '1828-09-09', 'Русский писатель, один из величайших писателей-романистов мира.'),
('Федор', 'Достоевский', '1821-11-11', 'Русский писатель, мыслитель, философ и публицист.'),
('Александр', 'Пушкин', '1799-06-06', 'Русский поэт, драматург и прозаик, заложивший основы русского реалистического направления.'),
('Михаил', 'Булгаков', '1891-05-15', 'Русский писатель, драматург, театральный режиссёр и актёр.'),
('Joanne', 'Rowling', '1965-07-31', 'Британская писательница, сценаристка и кинопродюсер.');

-- Издательства
INSERT INTO `publishers` (`name`, `city`, `contact_info`) VALUES
('Эксмо', 'Москва', 'info@eksmo.ru'),
('АСТ', 'Москва', '+7-499-951-60-00'),
('Азбука-Аттикус', 'Санкт-Петербург', 'office@azbooka-atticus.ru'),
('Bloomsbury Publishing', 'London', 'contact@bloomsbury.com');

-- Жанры
INSERT INTO `genres` (`name`, `description`) VALUES
('Классическая проза', 'Литературные произведения, считающиеся образцовыми для своей эпохи или для мировой литературы в целом.'),
('Фантастика', 'Жанр художественной литературы, кино и изобразительного искусства, характеризующийся использованием фантастического допущения.'),
('Детектив', 'Жанр художественной литературы (и кинематографа), произведения которого описывают процесс исследования загадочного происшествия с целью выяснения его обстоятельств и раскрытия загадки.'),
('Роман', 'Литературный жанр, обычно прозаический, который зародился в средние века у романских народов как рассказ на народном языке.'),
('Фэнтези', 'Жанр фантастической литературы, основанный на использовании мифологических и сказочных мотивов.'),
('Научная литература', 'Совокупность письменных трудов, которые создаются в результате исследований, теоретических обобщений, сделанных в рамках научного метода.');

-- Книги (произведения)
INSERT INTO `books` (`title`, `isbn`, `publication_year`, `publisher_id`, `pages_count`, `description`) VALUES
('Война и мир', '978-5-699-12806-0', 2015, (SELECT id FROM publishers WHERE name='Эксмо'), 1225, 'Роман-эпопея Льва Николаевича Толстого, описывающий русское общество в эпоху войн против Наполеона в 1805—1812 годах.'),
('Преступление и наказание', '978-5-389-04987-8', 2018, (SELECT id FROM publishers WHERE name='Азбука-Аттикус'), 608, 'Философско-психологический роман Фёдора Михайловича Достоевского.'),
('Евгений Онегин', '978-5-17-086071-0', 2014, (SELECT id FROM publishers WHERE name='АСТ'), 320, 'Роман в стихах Александра Сергеевича Пушкина, одно из самых значительных произведений русской словесности.'),
('Мастер и Маргарита', '978-5-389-07402-3', 2019, (SELECT id FROM publishers WHERE name='Азбука-Аттикус'), 480, 'Роман Михаила Афанасьевича Булгакова. Сложное сатирико-философское произведение.'),
('Harry Potter and the Philosopher''s Stone', '978-0-7475-3269-9', 1997, (SELECT id FROM publishers WHERE name='Bloomsbury Publishing'), 223, 'First book in the Harry Potter series by J.K. Rowling.');

-- Связи Книга-Автор
INSERT INTO `book_authors` (`book_id`, `author_id`) VALUES
((SELECT id FROM books WHERE isbn='978-5-699-12806-0'), (SELECT id FROM authors WHERE last_name='Толстой')),
((SELECT id FROM books WHERE isbn='978-5-389-04987-8'), (SELECT id FROM authors WHERE last_name='Достоевский')),
((SELECT id FROM books WHERE isbn='978-5-17-086071-0'), (SELECT id FROM authors WHERE last_name='Пушкин')),
((SELECT id FROM books WHERE isbn='978-5-389-07402-3'), (SELECT id FROM authors WHERE last_name='Булгаков')),
((SELECT id FROM books WHERE isbn='978-0-7475-3269-9'), (SELECT id FROM authors WHERE last_name='Rowling'));

-- Связи Книга-Жанр
INSERT INTO `book_genres` (`book_id`, `genre_id`) VALUES
((SELECT id FROM books WHERE isbn='978-5-699-12806-0'), (SELECT id FROM genres WHERE name='Классическая проза')),
((SELECT id FROM books WHERE isbn='978-5-699-12806-0'), (SELECT id FROM genres WHERE name='Роман')),
((SELECT id FROM books WHERE isbn='978-5-389-04987-8'), (SELECT id FROM genres WHERE name='Классическая проза')),
((SELECT id FROM books WHERE isbn='978-5-389-04987-8'), (SELECT id FROM genres WHERE name='Роман')),
((SELECT id FROM books WHERE isbn='978-5-17-086071-0'), (SELECT id FROM genres WHERE name='Классическая проза')),
((SELECT id FROM books WHERE isbn='978-5-17-086071-0'), (SELECT id FROM genres WHERE name='Роман')),
((SELECT id FROM books WHERE isbn='978-5-389-07402-3'), (SELECT id FROM genres WHERE name='Классическая проза')),
((SELECT id FROM books WHERE isbn='978-5-389-07402-3'), (SELECT id FROM genres WHERE name='Фэнтези')),
((SELECT id FROM books WHERE isbn='978-0-7475-3269-9'), (SELECT id FROM genres WHERE name='Фэнтези'));

-- Читатели
INSERT INTO `readers` (`library_card_number`, `first_name`, `last_name`, `birth_date`, `address`, `phone_number`, `email`, `registration_date`, `notes`) VALUES
('RDR001', 'Иван', 'Иванов', '1990-05-15', 'г. Москва, ул. Ленина, д. 1, кв. 10', '+79001112233', 'ivanov@example.com', CURDATE() - INTERVAL 30 DAY, 'Предпочитает научную фантастику'),
('RDR002', 'Мария', 'Петрова', '1985-11-20', 'г. Санкт-Петербург, пр. Невский, д. 5, кв. 5', '+79012223344', 'petrova@example.com', CURDATE() - INTERVAL 60 DAY, NULL),
('RDR003', 'Сергей', 'Сидоров', '2000-01-30', 'г. Москва, ул. Пушкина, д. 15', '+79023334455', 'sidorov@example.com', CURDATE() - INTERVAL 5 DAY, 'Студент');

-- Экземпляры книг
INSERT INTO `book_copies` (`book_id`, `inventory_number`, `status`, `acquisition_date`, `location`) VALUES
((SELECT id FROM books WHERE isbn='978-5-699-12806-0'), 'INV00001', 'available', CURDATE() - INTERVAL 100 DAY, 'Зал 1, Стеллаж А, Полка 3'),
((SELECT id FROM books WHERE isbn='978-5-699-12806-0'), 'INV00002', 'on_loan', CURDATE() - INTERVAL 100 DAY, 'Зал 1, Стеллаж А, Полка 3'), -- Выдан
((SELECT id FROM books WHERE isbn='978-5-389-04987-8'), 'INV00003', 'available', CURDATE() - INTERVAL 90 DAY, 'Зал 1, Стеллаж Б, Полка 1'),
((SELECT id FROM books WHERE isbn='978-5-17-086071-0'), 'INV00004', 'available', CURDATE() - INTERVAL 120 DAY, 'Зал 2, Стеллаж В, Полка 5'),
((SELECT id FROM books WHERE isbn='978-5-389-07402-3'), 'INV00005', 'available', CURDATE() - INTERVAL 80 DAY, 'Зал 2, Стеллаж Г, Полка 2'),
((SELECT id FROM books WHERE isbn='978-5-389-07402-3'), 'INV00006', 'damaged', CURDATE() - INTERVAL 80 DAY, 'Ремонтный отдел, ожидание ремонта'),
((SELECT id FROM books WHERE isbn='978-0-7475-3269-9'), 'INV00007', 'available', CURDATE() - INTERVAL 50 DAY, 'Зал 3, Стеллаж Д, Полка 1');


-- Выдачи книг (Loans)
-- Выдача INV00002 (Война и мир) читателю RDR001 (Иванов)
INSERT INTO `loans` (`book_copy_id`, `reader_id`, `loan_date`, `due_date`, `notes`) VALUES
((SELECT id FROM book_copies WHERE inventory_number = 'INV00002'), 
 (SELECT id FROM readers WHERE library_card_number = 'RDR001'), 
 CURDATE() - INTERVAL 10 DAY, -- Выдано 10 дней назад
 (CURDATE() - INTERVAL 10 DAY) + INTERVAL 14 DAY, -- Срок возврата через 14 дней от даты выдачи
 'Выдано 10 дней назад, срок возврата через 4 дня');

-- Пример просроченной выдачи (для теста представления)
-- Книга INV00001 (Война и мир) выдана читателю RDR002 (Петрова) и просрочена.
-- Сначала сделаем ее доступной (если она была в другом статусе), потом выдадим и просрочим.
UPDATE book_copies SET status = 'available' WHERE inventory_number = 'INV00001'; -- Убедимся, что доступна
INSERT INTO `loans` (`book_copy_id`, `reader_id`, `loan_date`, `due_date`, `notes`)
VALUES(
    (SELECT id FROM book_copies WHERE inventory_number = 'INV00001'),
    (SELECT id FROM readers WHERE library_card_number = 'RDR002'),
    CURDATE() - INTERVAL 20 DAY, -- Выдана 20 дней назад
    (CURDATE() - INTERVAL 20 DAY) + INTERVAL 14 DAY, -- Срок возврата был 6 дней назад
    'Эта книга должна быть просрочена'
);
UPDATE book_copies SET status = 'on_loan' WHERE inventory_number = 'INV00001'; -- Отмечаем, что книга выдана


-- -----------------------------------------------------
-- Представления (Views)
-- -----------------------------------------------------

-- 1. Представление: `view_full_book_info`
-- Описание: Предоставляет полную информацию о книгах, включая авторов и жанры.
CREATE OR REPLACE VIEW `view_full_book_info` AS
SELECT
    b.id AS book_id,
    b.title AS book_title,
    b.isbn,
    b.publication_year,
    p.name AS publisher_name,
    b.pages_count,
    GROUP_CONCAT(DISTINCT CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS authors,
    GROUP_CONCAT(DISTINCT g.name ORDER BY g.name SEPARATOR ', ') AS genres,
    b.description
FROM
    `books` b
LEFT JOIN
    `publishers` p ON b.publisher_id = p.id
LEFT JOIN
    `book_authors` ba ON b.id = ba.book_id
LEFT JOIN
    `authors` a ON ba.author_id = a.id
LEFT JOIN
    `book_genres` bg ON b.id = bg.book_id
LEFT JOIN
    `genres` g ON bg.genre_id = g.id
GROUP BY
    b.id, b.title, b.isbn, b.publication_year, p.name, b.pages_count, b.description;

-- 2. Представление: `view_reader_active_loans`
-- Описание: Отображает книги, находящиеся на руках у читателей (не возвращенные).
CREATE OR REPLACE VIEW `view_reader_active_loans` AS
SELECT
    r.library_card_number,
    CONCAT(r.first_name, ' ', r.last_name) AS reader_name,
    b.title AS book_title,
    bc.inventory_number,
    l.loan_date,
    l.due_date,
    DATEDIFF(l.due_date, CURDATE()) AS days_until_due, -- Положительное - дней до срока, отрицательное - дней просрочки
    l.id as loan_id -- ID выдачи для удобства
FROM
    `loans` l
JOIN
    `readers` r ON l.reader_id = r.id
JOIN
    `book_copies` bc ON l.book_copy_id = bc.id
JOIN
    `books` b ON bc.book_id = b.id
WHERE
    l.return_date IS NULL; -- Только активные (невозвращенные) выдачи

-- 3. Представление: `view_available_book_copies`
-- Описание: Показывает список доступных для выдачи экземпляров книг.
CREATE OR REPLACE VIEW `view_available_book_copies` AS
SELECT
    b.title AS book_title,
    vfbi.authors,
    vfbi.genres,
    bc.inventory_number,
    bc.location,
    p.name AS publisher_name,
    b.publication_year,
    bc.id as book_copy_id -- ID экземпляра для удобства
FROM
    `book_copies` bc
JOIN
    `books` b ON bc.book_id = b.id
LEFT JOIN
    `publishers` p ON b.publisher_id = p.id
LEFT JOIN
    `view_full_book_info` vfbi ON b.id = vfbi.book_id -- Используем ранее созданное представление
WHERE
    bc.status = 'available';

-- 4. Представление: `view_overdue_loans`
-- Описание: Отображает список просроченных выдач.
CREATE OR REPLACE VIEW `view_overdue_loans` AS
SELECT
    r.library_card_number,
    CONCAT(r.last_name, ' ', r.first_name, IF(r.middle_name IS NOT NULL, CONCAT(' ', r.middle_name), '')) AS reader_full_name,
    r.phone_number AS reader_phone,
    r.email AS reader_email,
    b.title AS book_title,
    vfbi.authors AS book_authors,
    bc.inventory_number,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS days_overdue,
    l.id as loan_id -- ID выдачи для удобства
FROM
    `loans` l
JOIN
    `readers` r ON l.reader_id = r.id
JOIN
    `book_copies` bc ON l.book_copy_id = bc.id
JOIN
    `books` b ON bc.book_id = b.id
LEFT JOIN
    `view_full_book_info` vfbi ON b.id = vfbi.book_id -- Для получения авторов и др. информации о книге
WHERE
    l.return_date IS NULL AND l.due_date < CURDATE(); -- Не возвращена и срок прошел

-- -----------------------------------------------------
-- Конец скрипта
-- -----------------------------------------------------
COMMIT; -- Применяем все изменения