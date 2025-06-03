**1. Введение в реляционные базы данных. Язык SQL**

**Подробно:**
Реляционная база данных (РБД) — это база данных, основанная на реляционной модели данных. Информация в РБД хранится в виде таблиц (отношений).
*   **Таблица:** Состоит из строк (записей или кортежей) и столбцов (атрибутов или полей). Каждая строка представляет собой набор связанных значений, относящихся к одному объекту или сущности. Каждый столбец представляет атрибут этой сущности и имеет определенный тип данных.
*   **Отношения:** Связи между таблицами устанавливаются с помощью ключей (первичных и внешних). Это позволяет избегать дублирования данных и поддерживать их целостность.
*   **Свойства РБД (ACID):**
    *   **Atomicity (Атомарность):** Транзакция выполняется либо полностью, либо не выполняется вовсе.
    *   **Consistency (Согласованность):** Транзакция переводит базу данных из одного согласованного состояния в другое.
    *   **Isolation (Изолированность):** Параллельные транзакции не должны влиять друг на друга.
    *   **Durability (Долговечность):** Если транзакция успешно завершена, ее результаты сохраняются даже в случае сбоев системы.

**Язык SQL (Structured Query Language):**
SQL — это декларативный язык программирования, применяемый для создания, модификации и управления данными в реляционных базах данных.
Основные категории команд SQL:
*   **DDL (Data Definition Language) – Язык определения данных:** Команды для определения и управления структурой объектов базы данных.
    *   `CREATE`: Создание объектов (таблиц, индексов, представлений и т.д.).
    *   `ALTER`: Изменение структуры существующих объектов.
    *   `DROP`: Удаление объектов.
    *   `TRUNCATE`: Удаление всех записей из таблицы (быстрее, чем `DELETE` без `WHERE`, но не логируется и не активирует триггеры на удаление строк).
*   **DML (Data Manipulation Language) – Язык манипулирования данными:** Команды для работы с данными внутри таблиц.
    *   `SELECT`: Извлечение данных.
    *   `INSERT`: Добавление новых данных.
    *   `UPDATE`: Изменение существующих данных.
    *   `DELETE`: Удаление данных.
*   **DCL (Data Control Language) – Язык управления данными:** Команды для управления правами доступа к данным.
    *   `GRANT`: Предоставление привилегий пользователям.
    *   `REVOKE`: Отзыв привилегий.
*   **TCL (Transaction Control Language) – Язык управления транзакциями:** Команды для управления транзакциями.
    *   `COMMIT`: Сохранение изменений, сделанных в текущей транзакции.
    *   `ROLLBACK`: Откат изменений, сделанных в текущей транзакции.
    *   `SAVEPOINT`: Установка точки сохранения внутри транзакции.

**Пример из кода (DML - выборка данных):**
Предположим, у нас есть таблица `Employees` (Сотрудники) со столбцами `EmployeeID`, `FirstName`, `LastName`, `Department`.

```sql
-- Выбрать имена и фамилии всех сотрудников из отдела 'IT'
SELECT FirstName, LastName
FROM Employees
WHERE Department = 'IT';
```

---

**2. Определение структуры таблицы (CREATE TABLE)**

**Подробно:**
Команда `CREATE TABLE` используется для создания новой таблицы в базе данных. При создании таблицы необходимо определить:
1.  **Имя таблицы:** Уникальное в пределах схемы базы данных.
2.  **Список столбцов (полей):** Для каждого столбца указывается:
    *   **Имя столбца:** Уникальное в пределах таблицы.
    *   **Тип данных:** Определяет, какие значения могут храниться в столбце (например, `INT`, `VARCHAR`, `DATE`).
    *   **Ограничения (Constraints):** Правила, которым должны соответствовать данные в столбце или таблице.
        *   `NOT NULL`: Столбец не может содержать значения `NULL`.
        *   `UNIQUE`: Все значения в столбце должны быть уникальными.
        *   `PRIMARY KEY`: Комбинация `NOT NULL` и `UNIQUE`. Уникально идентифицирует каждую запись в таблице. Может быть только один на таблицу.
        *   `FOREIGN KEY`: Обеспечивает ссылочную целостность между таблицами. Значения в этом столбце должны соответствовать значениям в `PRIMARY KEY` или `UNIQUE` столбце другой (или этой же) таблицы.
        *   `CHECK`: Условие, которому должны удовлетворять значения в столбце.
        *   `DEFAULT`: Значение по умолчанию, если при вставке данных значение для этого столбца не указано.

**Пример из кода:**
Создадим таблицу `Students` (Студенты) со следующими полями:
*   `StudentID` (ID студента): целое число, первичный ключ, автоинкремент (если поддерживается СУБД).
*   `FirstName` (Имя): строка до 50 символов, не может быть пустым.
*   `LastName` (Фамилия): строка до 50 символов, не может быть пустым.
*   `BirthDate` (Дата рождения): дата.
*   `GroupID` (ID группы): целое число, может быть пустым (студент может быть еще не распределен в группу).
*   `EnrollmentDate` (Дата зачисления): дата, по умолчанию текущая дата.

```sql
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT, -- В некоторых СУБД: IDENTITY(1,1) или SERIAL
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    BirthDate DATE,
    GroupID INT,
    EnrollmentDate DATE DEFAULT CURRENT_DATE -- Или GETDATE() / NOW() в зависимости от СУБД
);
```
*Примечание: `AUTO_INCREMENT` (MySQL), `IDENTITY(seed, increment)` (SQL Server), `SERIAL` (PostgreSQL) – это специфичные для СУБД способы реализации автоинкремента для первичных ключей.*

---

**3. Управление структурой таблиц (ALTER TABLE)**

**Подробно:**
Команда `ALTER TABLE` используется для изменения структуры существующей таблицы. С ее помощью можно:
*   **Добавлять столбцы:** `ADD COLUMN`
*   **Удалять столбцы:** `DROP COLUMN`
*   **Изменять тип данных или атрибуты существующих столбцов:** `MODIFY COLUMN` (MySQL, Oracle) или `ALTER COLUMN` (SQL Server, PostgreSQL)
*   **Добавлять или удалять ограничения:** `ADD CONSTRAINT`, `DROP CONSTRAINT`
*   **Переименовывать столбцы или таблицу:** `RENAME COLUMN`, `RENAME TO` (синтаксис может отличаться в разных СУБД).

**Примеры из кода:**
Используем таблицу `Students` из предыдущего примера.

1.  **Добавить столбец `Email`:**
    ```sql
    ALTER TABLE Students
    ADD COLUMN Email VARCHAR(100) UNIQUE;
    ```

2.  **Изменить тип данных столбца `GroupID` на `VARCHAR(10)` и сделать его обязательным (если данные позволяют):**
    *Сначала убедимся, что нет NULL значений или конвертируем их, если меняем на NOT NULL.*
    ```sql
    -- Для MySQL/Oracle:
    ALTER TABLE Students
    MODIFY COLUMN GroupID VARCHAR(10) NOT NULL;

    -- Для SQL Server/PostgreSQL:
    ALTER TABLE Students
    ALTER COLUMN GroupID TYPE VARCHAR(10); -- Сначала меняем тип

    ALTER TABLE Students
    ALTER COLUMN GroupID SET NOT NULL; -- Затем добавляем ограничение NOT NULL (PostgreSQL)
    -- Или через ADD CONSTRAINT для SQL Server, если нужно имя ограничению
    -- ALTER TABLE Students ADD CONSTRAINT CK_GroupID_NotEmpty CHECK (GroupID IS NOT NULL); -- Это не то же самое, что NOT NULL атрибут
    -- Правильнее для SQL Server: ALTER TABLE Students ALTER COLUMN GroupID VARCHAR(10) NOT NULL;
    ```
    *Примечание: Изменение типа данных может быть сложной операцией, если в столбце уже есть данные, несовместимые с новым типом.*

3.  **Удалить столбец `BirthDate`:**
    ```sql
    ALTER TABLE Students
    DROP COLUMN BirthDate;
    ```

4.  **Добавить ограничение `FOREIGN KEY` на столбец `GroupID`, ссылающийся на таблицу `Groups`:**
    (Предполагается, что таблица `Groups` с первичным ключом `GroupID` уже существует)
    ```sql
    -- Сначала создадим таблицу Groups для примера
    CREATE TABLE Groups (
        GroupID VARCHAR(10) PRIMARY KEY,
        GroupName VARCHAR(50) NOT NULL
    );

    -- Теперь добавляем внешний ключ в таблицу Students
    ALTER TABLE Students
    ADD CONSTRAINT FK_Students_GroupID
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID);
    ```

---

**4. Типы данных и атрибуты**

**Подробно:**
**Типы данных** определяют вид данных, которые могут храниться в столбце таблицы (или переменной, параметре функции/процедуры). Выбор правильного типа данных важен для:
*   **Целостности данных:** Гарантирует, что в столбец попадают только корректные значения.
*   **Эффективности хранения:** Меньшие типы данных занимают меньше места.
*   **Производительности запросов:** Операции над данными соответствующего типа выполняются быстрее.

Основные категории типов данных:
1.  **Числовые типы:**
    *   `INT` (или `INTEGER`): Целые числа (например, `TINYINT`, `SMALLINT`, `BIGINT` для разных диапазонов).
    *   `DECIMAL` (или `NUMERIC`): Числа с фиксированной точностью (например, `DECIMAL(10, 2)` - всего 10 цифр, 2 из них после запятой). Используются для финансовых данных.
    *   `FLOAT`, `REAL`, `DOUBLE PRECISION`: Числа с плавающей запятой (приблизительные значения).
2.  **Строковые типы:**
    *   `CHAR(n)`: Строка фиксированной длины `n`. Если строка короче, дополняется пробелами.
    *   `VARCHAR(n)`: Строка переменной длины до `n` символов. Занимает место по фактической длине строки + небольшой оверхед.
    *   `TEXT` (или `CLOB`): Для хранения больших текстовых данных.
3.  **Типы даты и времени:**
    *   `DATE`: Хранит дату (год, месяц, день).
    *   `TIME`: Хранит время (часы, минуты, секунды).
    *   `DATETIME` или `TIMESTAMP`: Хранит дату и время. `TIMESTAMP` часто используется для отслеживания времени изменения записи и может автоматически обновляться.
    *   `INTERVAL`: Хранит промежуток времени.
4.  **Бинарные типы:**
    *   `BINARY(n)`, `VARBINARY(n)`: Аналогичны `CHAR` и `VARCHAR`, но для бинарных данных.
    *   `BLOB` (Binary Large Object): Для хранения больших бинарных данных (изображения, файлы).
5.  **Логический тип:**
    *   `BOOLEAN` (или `BIT` в некоторых СУБД): Хранит значения `TRUE`, `FALSE` (иногда `NULL`).
6.  **Другие типы:** `XML`, `JSON`, `UUID`, геометрические типы и т.д.

**Атрибуты столбцов:**
Это дополнительные свойства, определяющие поведение столбца. Ранее упоминались в `CREATE TABLE`:
*   `NOT NULL`: Значение не может быть `NULL`.
*   `UNIQUE`: Значение должно быть уникальным в столбце.
*   `PRIMARY KEY`: Уникально идентифицирует строку, неявно `NOT NULL` и `UNIQUE`.
*   `FOREIGN KEY`: Ссылка на `PRIMARY KEY` другой таблицы.
*   `DEFAULT значение`: Значение по умолчанию, если не указано при вставке.
*   `AUTO_INCREMENT` / `IDENTITY` / `SERIAL`: Автоматическое увеличение числового значения (обычно для `PRIMARY KEY`).
*   `CHECK (условие)`: Ограничение на значения в столбце.

**Пример из кода:**
Создадим таблицу `Products` с различными типами данных и атрибутами.
```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT, -- Числовой, первичный ключ, автоинкремент
    ProductName VARCHAR(255) NOT NULL,       -- Строка переменной длины, обязательное поле
    SKU VARCHAR(50) UNIQUE,                  -- Строка, уникальный артикул
    Description TEXT,                        -- Длинный текст описания (может быть NULL)
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0), -- Десятичное число, обязательное, не может быть отрицательным
    StockQuantity INT DEFAULT 0,             -- Целое число, по умолчанию 0
    LastStockUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Дата и время, обновляется при изменении записи (синтаксис MySQL)
    IsActive BOOLEAN DEFAULT TRUE            -- Логический тип, по умолчанию TRUE
);
```
*Примечание: `ON UPDATE CURRENT_TIMESTAMP` является специфичной для MySQL конструкцией. В других СУБД это реализуется через триггеры.*

---

**5. Индексы (ключи)**

**Подробно:**
**Индексы** — это специальные структуры данных в СУБД, которые позволяют ускорить операции поиска и выборки данных из таблиц. Они работают подобно алфавитному указателю в книге: вместо того чтобы просматривать всю книгу (таблицу), вы смотрите в указатель (индекс) и быстро находите нужную страницу (запись).

*   **Как работают:** Индексы обычно создаются на одном или нескольких столбцах таблицы. СУБД поддерживает отсортированную структуру данных (часто B-дерево или его вариации) для этих столбцов, содержащую значения индексированных столбцов и указатели на соответствующие строки в таблице.
*   **Преимущества:**
    *   **Ускорение `SELECT` запросов:** Особенно с условиями `WHERE`, `JOIN ON`, `ORDER BY`, `GROUP BY` по индексированным столбцам.
    *   **Обеспечение уникальности:** Уникальные индексы (`UNIQUE`, `PRIMARY KEY`) гарантируют, что в индексированных столбцах не будет дубликатов.
*   **Недостатки:**
    *   **Занимают место на диске:** Индексы — это дополнительные структуры.
    *   **Замедляют операции модификации данных (`INSERT`, `UPDATE`, `DELETE`):** При изменении данных в таблице СУБД также должна обновить все связанные индексы.
    *   **Накладные расходы на поддержку:** СУБД тратит ресурсы на поддержание индексов в актуальном состоянии.

**Типы индексов (ключей):**

1.  **Первичный ключ (Primary Key):**
    *   Уникально идентифицирует каждую запись в таблице.
    *   Не может содержать `NULL` значений.
    *   На таблицу может быть только один первичный ключ.
    *   Автоматически создает уникальный кластерный индекс (в большинстве СУБД, если не указано иное).
    *   **Кластерный индекс:** Определяет физический порядок хранения строк в таблице. Поэтому он может быть только один.

2.  **Внешний ключ (Foreign Key):**
    *   Столбец (или набор столбцов) в одной таблице, который ссылается на первичный или уникальный ключ в другой (или той же) таблице.
    *   Обеспечивает ссылочную целостность данных (нельзя вставить значение во внешний ключ, если его нет в связанной таблице; нельзя удалить/изменить запись в родительской таблице, если на нее есть ссылки, без каскадных операций).
    *   Для внешних ключей рекомендуется создавать обычные (неуникальные) индексы для ускорения операций `JOIN`.

3.  **Уникальный индекс (Unique Index):**
    *   Гарантирует, что все значения в индексированном столбце (или комбинации столбцов) уникальны.
    *   Может содержать одно значение `NULL` (в большинстве СУБД, но поведение может отличаться).
    *   Первичный ключ всегда является уникальным индексом.

4.  **Обычный (неуникальный) индекс (Non-Unique Index):**
    *   Просто ускоряет поиск по столбцу(ам), не накладывая ограничений на уникальность.
    *   Используется для часто запрашиваемых столбцов в `WHERE`, `JOIN`, `ORDER BY`.

5.  **Составной (композитный) индекс (Composite Index):**
    *   Индекс, построенный на нескольких столбцах. Порядок столбцов в таком индексе важен.
    *   Эффективен, если запросы фильтруют по первому столбцу индекса или по первым нескольким столбцам.

**Примеры из кода:**

1.  **Создание первичного ключа (уже было в `CREATE TABLE`):**
    ```sql
    CREATE TABLE Departments (
        DepartmentID INT PRIMARY KEY,
        DepartmentName VARCHAR(100) NOT NULL
    );
    ```

2.  **Создание таблицы с внешним ключом и автоматическим созданием индекса на него (часто происходит):**
    ```sql
    CREATE TABLE Employees (
        EmployeeID INT PRIMARY KEY,
        FirstName VARCHAR(50),
        LastName VARCHAR(50),
        DepartmentID INT,
        CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
    );
    -- На DepartmentID в Employees хорошо бы иметь обычный индекс для ускорения JOINs
    -- Многие СУБД создают его автоматически для FK, но можно и явно:
    CREATE INDEX IDX_Employee_DepartmentID ON Employees(DepartmentID);
    ```

3.  **Создание уникального индекса на столбец `Email`:**
    ```sql
    -- Если таблица Employees уже существует и в ней есть столбец Email
    ALTER TABLE Employees
    ADD COLUMN Email VARCHAR(100);

    CREATE UNIQUE INDEX UQ_Employee_Email ON Employees(Email);
    -- Или при создании таблицы: Email VARCHAR(100) UNIQUE
    ```

4.  **Создание обычного (неуникального) индекса на столбец `LastName`:**
    ```sql
    CREATE INDEX IDX_Employee_LastName ON Employees(LastName);
    ```

5.  **Создание составного индекса на `LastName` и `FirstName`:**
    ```sql
    CREATE INDEX IDX_Employee_FullName ON Employees(LastName, FirstName);
    -- Этот индекс будет полезен для запросов типа:
    -- SELECT * FROM Employees WHERE LastName = 'Иванов' AND FirstName = 'Иван';
    -- А также для: SELECT * FROM Employees WHERE LastName = 'Иванов';
    -- Но менее полезен (или бесполезен) для: SELECT * FROM Employees WHERE FirstName = 'Иван';
    ```

---

**6. Вставка и обновление данных (INSERT, UPDATE, DELETE)**

**Подробно:**
Это основные команды DML (Data Manipulation Language) для изменения содержимого таблиц.

1.  **`INSERT INTO` (Вставка данных):**
    *   Добавляет одну или несколько новых строк в таблицу.
    *   **Синтаксис 1 (с указанием столбцов):**
        `INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);`
        Рекомендуемый способ, т.к. не зависит от порядка столбцов в таблице.
    *   **Синтаксис 2 (без указания столбцов):**
        `INSERT INTO table_name VALUES (value1, value2, ...);`
        Требует, чтобы значения перечислялись строго в том порядке, в котором столбцы определены в таблице, и чтобы были указаны значения для всех столбцов (кроме тех, что имеют `DEFAULT` или `AUTO_INCREMENT`).
    *   **Вставка результатов запроса:**
        `INSERT INTO table_name (column1, column2, ...) SELECT columnA, columnB, ... FROM another_table WHERE condition;`

2.  **`UPDATE` (Обновление данных):**
    *   Изменяет существующие данные в одной или нескольких строках таблицы.
    *   **Синтаксис:**
        `UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;`
    *   **ВАЖНО:** Если пропустить условие `WHERE`, будут обновлены **все строки** в таблице. Это очень опасная операция.

3.  **`DELETE FROM` (Удаление данных):**
    *   Удаляет одну или несколько строк из таблицы.
    *   **Синтаксис:**
        `DELETE FROM table_name WHERE condition;`
    *   **ВАЖНО:** Если пропустить условие `WHERE`, будут удалены **все строки** из таблицы. Эта операция логируется (в отличие от `TRUNCATE TABLE`) и может быть медленной для больших таблиц.
    *   `TRUNCATE TABLE table_name;` удаляет все строки из таблицы быстро, но обычно не вызывает триггеры на удаление и не логируется по-строчно, что делает откат невозможным стандартными средствами.

**Примеры из кода:**
Используем таблицы `Departments` и `Employees`.

```sql
-- Вспомогательные таблицы, если их еще нет
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT, -- Для MySQL/PostgreSQL (SERIAL)
    -- EmployeeID INT PRIMARY KEY IDENTITY(1,1), -- Для SQL Server
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    CONSTRAINT FK_Emp_Dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
```

1.  **Вставка данных:**
    ```sql
    -- Вставка в Departments
    INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (1, 'IT');
    INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (2, 'Sales');
    INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (3, 'HR');

    -- Вставка в Employees (с указанием столбцов)
    INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, HireDate)
    VALUES ('Иван', 'Иванов', 1, 60000.00, '2022-08-15');

    INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, HireDate)
    VALUES ('Петр', 'Петров', 2, 55000.00, '2023-01-10');

    INSERT INTO Employees (FirstName, LastName, Salary, HireDate) -- DepartmentID будет NULL
    VALUES ('Сидор', 'Сидоров', 50000.00, '2023-03-20');

    -- Вставка нескольких строк (синтаксис может немного отличаться)
    INSERT INTO Employees (FirstName, LastName, DepartmentID, Salary, HireDate) VALUES
    ('Анна', 'Смирнова', 1, 62000.00, '2022-09-01'),
    ('Елена', 'Кузнецова', 2, 58000.00, '2023-02-01');
    ```

2.  **Обновление данных:**
    ```sql
    -- Обновить зарплату Ивана Иванова (предположим, его EmployeeID = 1)
    UPDATE Employees
    SET Salary = 65000.00
    WHERE FirstName = 'Иван' AND LastName = 'Иванов'; -- Лучше по EmployeeID, если он известен

    -- Повысить зарплату всем сотрудникам IT-отдела на 10%
    UPDATE Employees
    SET Salary = Salary * 1.10
    WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'IT');

    -- Перевести Сидора Сидорова в отдел HR (DepartmentID = 3)
    UPDATE Employees
    SET DepartmentID = 3
    WHERE FirstName = 'Сидор' AND LastName = 'Сидоров';
    ```

3.  **Удаление данных:**
    ```sql
    -- Удалить сотрудника с EmployeeID = (ID Сидора Сидорова, допустим, он стал 3 после автоинкремента)
    -- Сначала найдем его ID, если не знаем
    -- SELECT EmployeeID FROM Employees WHERE FirstName = 'Сидор' AND LastName = 'Сидоров';
    -- Предположим, ID = 3
    DELETE FROM Employees
    WHERE EmployeeID = 3;

    -- Удалить всех сотрудников с зарплатой меньше 50000 (ОПАСНО без проверки!)
    -- DELETE FROM Employees
    -- WHERE Salary < 50000;

    -- Удалить все записи из таблицы Employees (ОЧЕНЬ ОПАСНО!)
    -- DELETE FROM Employees;

    -- Очистить таблицу Employees (быстро, но без возможности отката и триггеров)
    -- TRUNCATE TABLE Employees;
    ```

---

**7. Нормализация**

**Подробно:**
**Нормализация** — это процесс организации данных в базе данных с целью уменьшения избыточности данных и улучшения их целостности. Это достигается путем разделения больших таблиц на меньшие, хорошо структурированные таблицы, и определения связей между ними. Основная цель — избежать аномалий данных:
*   **Аномалия вставки:** Невозможность вставить данные об одной сущности без данных о другой (например, нельзя добавить новый курс, если на него еще не записан ни один студент, если вся информация хранится в одной таблице "Студент-Курс").
*   **Аномалия обновления:** Изменение одного и того же факта требует обновления нескольких записей (например, если адрес клиента дублируется для каждого его заказа, изменение адреса потребует обновления всех заказов).
*   **Аномалия удаления:** Удаление одной информации приводит к потере другой, связанной, но не зависимой напрямую (например, удаление последнего студента, записанного на курс, приводит к потере информации о самом курсе).

**Нормальные формы (НФ):**
Существует несколько уровней нормализации, наиболее часто используются первые три:

1.  **Первая нормальная форма (1НФ):**
    *   Все атрибуты (значения в ячейках) должны быть атомарными (неделимыми).
    *   Не должно быть повторяющихся групп столбцов.
    *   Каждая строка должна быть уникальной (обычно обеспечивается первичным ключом).
    *   *Пример нарушения:* Столбец "Телефоны" содержит несколько номеров через запятую. *Решение:* Вынести телефоны в отдельную таблицу `Телефоны_Студента(ID_Студента, Телефон)`.

2.  **Вторая нормальная форма (2НФ):**
    *   Таблица должна быть в 1НФ.
    *   Все неключевые атрибуты должны полностью зависеть от всего первичного ключа (если ключ составной). Не должно быть частичных зависимостей.
    *   *Пример нарушения:* Таблица `Заказы_Товары(НомерЗаказа, КодТовара, НаименованиеТовара, Количество)`. Первичный ключ `(НомерЗаказа, КодТовара)`. `НаименованиеТовара` зависит только от `КодТовара` (частичная зависимость). *Решение:* Разделить на `Заказы_Товары(НомерЗаказа, КодТовара, Количество)` и `Товары(КодТовара, НаименованиеТовара)`.

3.  **Третья нормальная форма (3НФ):**
    *   Таблица должна быть в 2НФ.
    *   Все неключевые атрибуты должны зависеть только от первичного ключа и не должны зависеть от других неключевых атрибутов (отсутствие транзитивных зависимостей).
    *   *Пример нарушения:* Таблица `Сотрудники(ID_Сотрудника, Имя, ID_Отдела, НазваниеОтдела, АдресОтдела)`. `НазваниеОтдела` и `АдресОтдела` зависят от `ID_Отдела`, который не является частью первичного ключа. `ID_Сотрудника -> ID_Отдела -> НазваниеОтдела`. *Решение:* Разделить на `Сотрудники(ID_Сотрудника, Имя, ID_Отдела)` и `Отделы(ID_Отдела, НазваниеОтдела, АдресОтдела)`.

Существуют и более высокие нормальные формы (BCNF, 4НФ, 5НФ, DKNF), но 3НФ часто является достаточной для большинства приложений. Денормализация (обратный процесс) иногда применяется для повышения производительности запросов за счет контролируемой избыточности.

**Пример из кода (приведение к 3НФ):**

**Исходная ненормализованная таблица `StudentCoursesRaw`:**
Предположим, у нас есть таблица, где хранится информация о студентах, курсах, на которые они записаны, и преподавателях этих курсов.
```
StudentID | StudentName | StudentEmail      | CourseCode | CourseName      | CourseCredits | InstructorID | InstructorName | InstructorEmail
----------|-------------|-------------------|------------|-----------------|---------------|--------------|----------------|-----------------
1         | Иван Иванов | ivan@example.com  | CS101      | Введение в C++  | 3             | P10          | Проф. Смирнов  | smirnov@edu.com
1         | Иван Иванов | ivan@example.com  | MA202      | Мат. Анализ     | 4             | P20          | Проф. Петрова  | petrova@edu.com
2         | Анна Кузнецова| anna@example.com  | CS101      | Введение в C++  | 3             | P10          | Проф. Смирнов  | smirnov@edu.com
```
**Проблемы:**
*   Данные студента (Имя, Email) повторяются для каждого курса.
*   Данные курса (Название, Кредиты) повторяются для каждого студента.
*   Данные преподавателя (Имя, Email) повторяются для каждого курса, который он ведет.
*   Аномалии: если Проф. Смирнов перестанет вести CS101, и это был его единственный курс, мы можем потерять информацию о нем. Если Иван Иванов отчислится, мы можем потерять информацию о курсах, если он был единственным студентом.

**Нормализация:**

1.  **Таблица `Students` (Студенты):**
    ```sql
    CREATE TABLE Students (
        StudentID INT PRIMARY KEY,
        StudentName VARCHAR(100) NOT NULL,
        StudentEmail VARCHAR(100) UNIQUE
    );
    INSERT INTO Students (StudentID, StudentName, StudentEmail) VALUES
    (1, 'Иван Иванов', 'ivan@example.com'),
    (2, 'Анна Кузнецова', 'anna@example.com');
    ```

2.  **Таблица `Instructors` (Преподаватели):**
    ```sql
    CREATE TABLE Instructors (
        InstructorID VARCHAR(10) PRIMARY KEY, -- Используем VARCHAR для P10, P20
        InstructorName VARCHAR(100) NOT NULL,
        InstructorEmail VARCHAR(100) UNIQUE
    );
    INSERT INTO Instructors (InstructorID, InstructorName, InstructorEmail) VALUES
    ('P10', 'Проф. Смирнов', 'smirnov@edu.com'),
    ('P20', 'Проф. Петрова', 'petrova@edu.com');
    ```

3.  **Таблица `Courses` (Курсы):**
    ```sql
    CREATE TABLE Courses (
        CourseCode VARCHAR(10) PRIMARY KEY,
        CourseName VARCHAR(100) NOT NULL,
        CourseCredits INT,
        InstructorID VARCHAR(10), -- Ответственный преподаватель за курс
        FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
    );
    INSERT INTO Courses (CourseCode, CourseName, CourseCredits, InstructorID) VALUES
    ('CS101', 'Введение в C++', 3, 'P10'),
    ('MA202', 'Мат. Анализ', 4, 'P20');
    ```
    *Примечание: Если один курс могут вести несколько преподавателей, или один преподаватель может вести несколько курсов (многие-ко-многим), то `InstructorID` из `Courses` убирается, и создается связующая таблица `CourseInstructors(CourseCode, InstructorID)`.* Для простоты здесь оставлена связь "один курс - один основной преподаватель".

4.  **Таблица `Enrollments` (Зачисления студентов на курсы) - связующая таблица:**
    ```sql
    CREATE TABLE Enrollments (
        EnrollmentID INT PRIMARY KEY AUTO_INCREMENT, -- Суррогатный ключ для простоты
        StudentID INT,
        CourseCode VARCHAR(10),
        EnrollmentDate DATE DEFAULT CURRENT_DATE,
        Grade CHAR(1), -- Оценка
        UNIQUE (StudentID, CourseCode), -- Студент не может быть записан на один и тот же курс дважды
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
        FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
    );
    INSERT INTO Enrollments (StudentID, CourseCode) VALUES
    (1, 'CS101'),
    (1, 'MA202'),
    (2, 'CS101');
    ```
Теперь данные хранятся без избыточности, и аномалии устранены. Чтобы получить исходный вид, нужно будет использовать `JOIN` между этими таблицами.

---

**8. Строковые функции и работа со строками**

**Подробно:**
Строковые функции используются для манипулирования текстовыми данными в SQL. Они позволяют извлекать части строк, изменять их регистр, объединять строки, искать подстроки и многое другое. Набор функций и их синтаксис могут незначительно отличаться в разных СУБД, но основные концепции схожи.

Основные строковые функции:

*   **`CONCAT()` или `||` (оператор конкатенации):** Объединяет две или более строки.
    *   `CONCAT(string1, string2, ...)`
    *   `string1 || string2` (стандарт SQL, поддерживается PostgreSQL, Oracle)
*   **`LENGTH()` или `LEN()`:** Возвращает длину строки (количество символов).
    *   `LENGTH(string)` (MySQL, PostgreSQL, Oracle)
    *   `LEN(string)` (SQL Server)
*   **`SUBSTRING()` или `SUBSTR()`:** Извлекает подстроку из строки.
    *   `SUBSTRING(string FROM start_position FOR length)` (стандарт SQL, PostgreSQL)
    *   `SUBSTRING(string, start_position, length)` (MySQL, SQL Server)
    *   `SUBSTR(string, start_position, length)` (Oracle)
*   **`UPPER()`:** Преобразует строку в верхний регистр.
*   **`LOWER()`:** Преобразует строку в нижний регистр.
*   **`TRIM()`:** Удаляет начальные и/или конечные пробелы (или другие указанные символы).
    *   `TRIM([BOTH | LEADING | TRAILING] [characters] FROM string)`
    *   `LTRIM(string)`: Удаляет начальные пробелы.
    *   `RTRIM(string)`: Удаляет конечные пробелы.
*   **`REPLACE()`:** Заменяет все вхождения одной подстроки на другую.
    *   `REPLACE(string, substring_to_replace, replacement_substring)`
*   **`POSITION()` или `CHARINDEX()` или `INSTR()`:** Возвращает позицию первого вхождения подстроки в строке.
    *   `POSITION(substring IN string)` (стандарт SQL, PostgreSQL)
    *   `CHARINDEX(substring, string, [start_location])` (SQL Server)
    *   `INSTR(string, substring, [start_position], [nth_appearance])` (Oracle, MySQL)
*   **`LEFT()` / `RIGHT()`:** Возвращают указанное количество символов с начала или конца строки (не во всех СУБД, но часто есть).
    *   `LEFT(string, number_of_chars)`
    *   `RIGHT(string, number_of_chars)`
*   **`LIKE` оператор (используется в `WHERE`):** Поиск по шаблону.
    *   `%`: Соответствует любой последовательности символов (включая пустую).
    *   `_`: Соответствует любому одиночному символу.
*   **`FORMAT()` (или `TO_CHAR()` для Oracle/PostgreSQL):** Форматирует значение (часто число или дату) в строку по заданному шаблону.

**Примеры из кода:**
Предположим, есть таблица `Users`:
```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    FullName VARCHAR(100),
    Email VARCHAR(100)
);

INSERT INTO Users (UserID, Username, FullName, Email) VALUES
(1, 'john_doe', '  John Doe  ', 'john.doe@example.com'),
(2, 'jane_smith', 'Jane Smith', 'JANE.SMITH@EXAMPLE.ORG'),
(3, 'bob_builder', 'Bob The Builder', 'bob@example.net');
```

1.  **Объединение имени пользователя и email:**
    ```sql
    -- Используя CONCAT (MySQL, PostgreSQL, SQL Server 2012+)
    SELECT Username, Email, CONCAT(Username, ' <', LOWER(Email), '>') AS UserInfo
    FROM Users;

    -- Используя || (PostgreSQL, Oracle)
    -- SELECT Username, Email, Username || ' <' || LOWER(Email) || '>' AS UserInfo
    -- FROM Users;
    ```
    Результат для первой строки: `john_doe <john.doe@example.com>`

2.  **Извлечение доменного имени из Email:**
    ```sql
    -- Для MySQL/PostgreSQL (SUBSTRING и POSITION)
    SELECT Email, SUBSTRING(Email FROM POSITION('@' IN Email) + 1) AS DomainName
    FROM Users;

    -- Для SQL Server (SUBSTRING и CHARINDEX)
    -- SELECT Email, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email) - CHARINDEX('@', Email)) AS DomainName
    -- FROM Users;
    ```
    Результат для первой строки: `example.com`

3.  **Приведение `FullName` к нормальному виду (удаление пробелов, первая буква заглавная, остальные строчные - сложнее, обычно делают только регистр и trim):**
    ```sql
    SELECT FullName, UPPER(TRIM(FullName)) AS NormalizedFullNameUpper,
           LOWER(TRIM(FullName)) AS NormalizedFullNameLower
    FROM Users
    WHERE UserID = 1;
    ```
    Результат для `UserID = 1`: `JOHN DOE` и `john doe`

4.  **Замена части email:**
    ```sql
    SELECT Email, REPLACE(Email, '.com', '.net') AS ModifiedEmail
    FROM Users
    WHERE Email LIKE '%.com';
    ```
    Результат для `john.doe@example.com`: `john.doe@example.net`

5.  **Поиск пользователей с определенным именем:**
    ```sql
    SELECT UserID, FullName
    FROM Users
    WHERE FullName LIKE 'John%'; -- Начинается с John
    ```
    Результат: `UserID = 1, FullName = '  John Doe  '`

6.  **Получение длины имени пользователя:**
    ```sql
    -- Для MySQL, PostgreSQL, Oracle
    SELECT Username, LENGTH(Username) AS UsernameLength
    FROM Users;

    -- Для SQL Server
    -- SELECT Username, LEN(Username) AS UsernameLength
    -- FROM Users;
    ```
    Результат для `john_doe`: `8`

---

**9. Временные функции и работа с датами и временем**

**Подробно:**
Функции даты и времени в SQL позволяют манипулировать значениями типов `DATE`, `TIME`, `DATETIME`, `TIMESTAMP`, `INTERVAL`. Они используются для:
*   Получения текущей даты и/или времени.
*   Извлечения частей даты/времени (год, месяц, день, час и т.д.).
*   Арифметических операций с датами (сложение, вычитание интервалов).
*   Сравнения дат и времени.
*   Форматирования дат и времени для отображения.

Синтаксис и набор функций могут сильно отличаться между СУБД.

**Основные функции (названия могут варьироваться):**

1.  **Получение текущей даты/времени:**
    *   `NOW()`: Текущая дата и время (MySQL, PostgreSQL).
    *   `GETDATE()`: Текущая дата и время (SQL Server).
    *   `SYSDATE`: Текущая дата и время (Oracle).
    *   `CURRENT_TIMESTAMP`: Стандарт SQL, текущая дата и время с информацией о временной зоне.
    *   `CURRENT_DATE`: Стандарт SQL, текущая дата.
    *   `CURRENT_TIME`: Стандарт SQL, текущее время.

2.  **Извлечение частей даты/времени:**
    *   `EXTRACT(part FROM datetime_value)`: Стандарт SQL. `part` может быть `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND`. (PostgreSQL, Oracle, MySQL)
    *   `YEAR(date_value)`, `MONTH(date_value)`, `DAY(date_value)` и т.д.: Специфичные функции (MySQL, SQL Server - `DATEPART(part, date_value)`).
    *   `DATEPART(datepart, date)`: (SQL Server)
    *   `TO_CHAR(datetime_value, format_string)`: (Oracle, PostgreSQL) - очень гибкая функция для извлечения и форматирования.

3.  **Арифметика с датами:**
    *   `DATE_ADD(date, INTERVAL expression unit)` / `DATE_SUB(date, INTERVAL expression unit)`: (MySQL). `unit` может быть `DAY`, `MONTH`, `YEAR`, `HOUR` и т.д.
        *   Пример: `DATE_ADD('2023-01-01', INTERVAL 1 MONTH)`
    *   `DATEADD(datepart, number, date)` / `DATEDIFF(datepart, startdate, enddate)`: (SQL Server).
        *   Пример: `DATEADD(mm, 1, '2023-01-01')`
    *   Сложение/вычитание интервалов: `date_value + INTERVAL '1 day'` (PostgreSQL, Oracle).
        *   Пример: `'2023-01-01'::date + INTERVAL '1 month'` (PostgreSQL)
    *   Вычитание дат для получения интервала: `date1 - date2` (результат может быть числом дней или интервалом).

4.  **Форматирование дат/времени:**
    *   `DATE_FORMAT(date, format_string)`: (MySQL)
    *   `FORMAT(date, format_string, [culture])`: (SQL Server 2012+)
    *   `TO_CHAR(datetime_value, format_string)`: (Oracle, PostgreSQL)

**Примеры из кода:**
Предположим, есть таблица `Orders`:
```sql
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATETIME,         -- В MySQL, SQL Server
    -- OrderDate TIMESTAMP,      -- В PostgreSQL, Oracle
    RequiredDeliveryDate DATE,
    ShippedDate DATETIME NULL   -- Может быть NULL, если еще не отправлен
);

INSERT INTO Orders (OrderID, OrderDate, RequiredDeliveryDate, ShippedDate) VALUES
(1, '2023-10-26 10:00:00', '2023-11-01', '2023-10-27 15:30:00'),
(2, '2023-10-28 11:30:00', '2023-11-05', NULL),
(3, CURRENT_TIMESTAMP, CURRENT_DATE + INTERVAL '7' DAY, NULL); -- Пример для MySQL/PostgreSQL
-- (3, GETDATE(), DATEADD(day, 7, GETDATE()), NULL); -- Пример для SQL Server
```

1.  **Получить текущую дату и время:**
    ```sql
    -- MySQL, PostgreSQL
    SELECT NOW() AS CurrentDateTime;
    -- SQL Server
    -- SELECT GETDATE() AS CurrentDateTime;
    -- Oracle
    -- SELECT SYSDATE AS CurrentDateTime FROM DUAL;
    ```

2.  **Извлечь год и месяц из `OrderDate`:**
    ```sql
    -- Стандартный SQL (PostgreSQL, MySQL, Oracle)
    SELECT OrderID, EXTRACT(YEAR FROM OrderDate) AS OrderYear, EXTRACT(MONTH FROM OrderDate) AS OrderMonth
    FROM Orders;

    -- MySQL также:
    -- SELECT OrderID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth FROM Orders;

    -- SQL Server:
    -- SELECT OrderID, DATEPART(year, OrderDate) AS OrderYear, DATEPART(month, OrderDate) AS OrderMonth FROM Orders;
    ```

3.  **Добавить 5 дней к `OrderDate`:**
    ```sql
    -- MySQL
    SELECT OrderID, OrderDate, DATE_ADD(OrderDate, INTERVAL 5 DAY) AS OrderDatePlus5Days
    FROM Orders;

    -- SQL Server
    -- SELECT OrderID, OrderDate, DATEADD(day, 5, OrderDate) AS OrderDatePlus5Days
    -- FROM Orders;

    -- PostgreSQL/Oracle
    -- SELECT OrderID, OrderDate, OrderDate + INTERVAL '5 day' AS OrderDatePlus5Days
    -- FROM Orders;
    ```

4.  **Рассчитать количество дней между `OrderDate` и `ShippedDate` (длительность обработки):**
    ```sql
    -- MySQL (DATEDIFF возвращает разницу в днях)
    SELECT OrderID, DATEDIFF(ShippedDate, OrderDate) AS ProcessingDays
    FROM Orders
    WHERE ShippedDate IS NOT NULL;

    -- SQL Server (DATEDIFF возвращает разницу в указанных единицах)
    -- SELECT OrderID, DATEDIFF(day, OrderDate, ShippedDate) AS ProcessingDays
    -- FROM Orders
    -- WHERE ShippedDate IS NOT NULL;

    -- PostgreSQL (вычитание дат типа date возвращает int (дни), timestamp возвращает interval)
    -- SELECT OrderID, ShippedDate::date - OrderDate::date AS ProcessingDays
    -- FROM Orders
    -- WHERE ShippedDate IS NOT NULL;
    -- Или EXTRACT(EPOCH FROM (ShippedDate - OrderDate)) / (60*60*24) для точного количества дней из timestamp
    ```

5.  **Отформатировать `OrderDate` в виде 'ДД.ММ.ГГГГ ЧЧ:МИ':**
    ```sql
    -- MySQL
    SELECT OrderID, DATE_FORMAT(OrderDate, '%d.%m.%Y %H:%i') AS FormattedOrderDate
    FROM Orders;

    -- SQL Server (2012+)
    -- SELECT OrderID, FORMAT(OrderDate, 'dd.MM.yyyy HH:mm') AS FormattedOrderDate
    -- FROM Orders;

    -- PostgreSQL/Oracle
    -- SELECT OrderID, TO_CHAR(OrderDate, 'DD.MM.YYYY HH24:MI') AS FormattedOrderDate
    -- FROM Orders;
    ```

---

**10. Методы подсчета и агрегации**

**Подробно:**
Агрегатные функции в SQL выполняют вычисления над набором значений (например, столбцом таблицы) и возвращают одно сводное значение. Они часто используются с предложением `GROUP BY` для вычисления агрегатов по группам строк.

**Основные агрегатные функции:**

*   **`COUNT(*)`:** Возвращает общее количество строк в группе (или таблице, если `GROUP BY` отсутствует).
*   **`COUNT(column_name)`:** Возвращает количество строк, где `column_name` имеет не-NULL значение.
*   **`COUNT(DISTINCT column_name)`:** Возвращает количество уникальных не-NULL значений в `column_name`.
*   **`SUM(column_name)`:** Возвращает сумму всех не-NULL значений в `column_name` (для числовых типов).
*   **`AVG(column_name)`:** Возвращает среднее значение всех не-NULL значений в `column_name` (для числовых типов).
*   **`MIN(column_name)`:** Возвращает минимальное значение в `column_name`.
*   **`MAX(column_name)`:** Возвращает максимальное значение в `column_name`.

**Предложение `GROUP BY`:**
*   Используется для группировки строк с одинаковыми значениями в одном или нескольких столбцах.
*   Агрегатные функции затем применяются к каждой группе отдельно.
*   Все столбцы в списке `SELECT`, которые не являются агрегатными функциями, должны быть перечислены в предложении `GROUP BY`.

**Предложение `HAVING`:**
*   Используется для фильтрации групп, созданных предложением `GROUP BY`.
*   Работает аналогично `WHERE`, но `WHERE` фильтрует строки *до* группировки, а `HAVING` фильтрует группы *после* того, как они были сформированы и агрегатные функции вычислены.
*   В `HAVING` можно использовать агрегатные функции, в `WHERE` — нет (за исключением подзапросов).

**Порядок выполнения (логический):**
1.  `FROM` (и `JOIN`)
2.  `WHERE`
3.  `GROUP BY`
4.  `HAVING`
5.  `SELECT`
6.  `DISTINCT`
7.  `ORDER BY`
8.  `LIMIT` / `TOP`

**Примеры из кода:**
Используем таблицу `Products` (Товары) и `OrderDetails` (Детали заказов).
```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10, 2)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, CategoryID, Price) VALUES
(1, 'Ноутбук Alpha', 1, 1200.00),
(2, 'Смартфон Beta', 2, 800.00),
(3, 'Клавиатура Gamma', 1, 50.00),
(4, 'Мышь Delta', 1, 25.00),
(5, 'Монитор Epsilon', 3, 300.00);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
(101, 1, 1, 1), -- Ноутбук
(102, 1, 3, 1), -- Клавиатура
(103, 1, 4, 1), -- Мышь
(104, 2, 2, 2), -- 2 Смартфона
(105, 2, 5, 1), -- Монитор
(106, 3, 1, 1), -- Ноутбук
(107, 3, 5, 2); -- 2 Монитора
```

1.  **Общее количество товаров:**
    ```sql
    SELECT COUNT(*) AS TotalProducts
    FROM Products;
    -- Результат: 5
    ```

2.  **Количество уникальных категорий товаров:**
    ```sql
    SELECT COUNT(DISTINCT CategoryID) AS UniqueCategories
    FROM Products;
    -- Результат: 3 (если категории 1, 2, 1, 1, 3)
    ```

3.  **Средняя цена товаров:**
    ```sql
    SELECT AVG(Price) AS AveragePrice
    FROM Products;
    -- Результат: (1200+800+50+25+300)/5 = 475
    ```

4.  **Количество товаров и средняя цена по каждой категории:**
    ```sql
    SELECT CategoryID,
           COUNT(*) AS ProductsInCategory,
           AVG(Price) AS AvgPriceInCategory
    FROM Products
    GROUP BY CategoryID;
    /* Результат:
    CategoryID | ProductsInCategory | AvgPriceInCategory
    -----------|--------------------|-------------------
    1          | 3                  | (1200+50+25)/3 = 425.00
    2          | 1                  | 800.00
    3          | 1                  | 300.00
    */
    ```

5.  **Общая сумма продаж по каждому товару (из `OrderDetails` и `Products`):**
    ```sql
    SELECT p.ProductName,
           SUM(od.Quantity) AS TotalQuantitySold,
           SUM(od.Quantity * p.Price) AS TotalRevenue
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName -- Группируем по ID и имени, чтобы имя попало в SELECT
    ORDER BY TotalRevenue DESC;
    /* Примерный результат:
    ProductName     | TotalQuantitySold | TotalRevenue
    ----------------|-------------------|-------------
    Ноутбук Alpha    | 2                 | 2400.00
    Смартфон Beta   | 2                 | 1600.00
    Монитор Epsilon | 3                 | 900.00
    Клавиатура Gamma| 1                 | 50.00
    Мышь Delta       | 1                 | 25.00
    */
    ```

6.  **Категории, в которых более одного товара и средняя цена выше 100:**
    ```sql
    SELECT CategoryID,
           COUNT(*) AS ProductsInCategory,
           AVG(Price) AS AvgPriceInCategory
    FROM Products
    GROUP BY CategoryID
    HAVING COUNT(*) > 1 AND AVG(Price) > 100;
    /* Результат (для данных выше):
    CategoryID | ProductsInCategory | AvgPriceInCategory
    -----------|--------------------|-------------------
    1          | 3                  | 425.00
    */
    ```

---

**11. Сложные запросы**

**Подробно:**
Сложные запросы — это запросы, которые объединяют несколько концепций SQL для извлечения или обработки данных специфическим образом. Они часто включают:
*   **`JOIN` операции (INNER, LEFT/RIGHT/FULL OUTER):** Для объединения данных из двух или более таблиц на основе связанных столбцов.
    *   `INNER JOIN`: Возвращает строки, когда есть совпадение в обеих таблицах.
    *   `LEFT JOIN` (или `LEFT OUTER JOIN`): Возвращает все строки из левой таблицы и совпадающие строки из правой таблицы. Если совпадения нет, столбцы правой таблицы будут `NULL`.
    *   `RIGHT JOIN` (или `RIGHT OUTER JOIN`): Возвращает все строки из правой таблицы и совпадающие строки из левой. Если совпадения нет, столбцы левой таблицы будут `NULL`.
    *   `FULL OUTER JOIN`: Возвращает все строки из обеих таблиц. Если совпадения нет, соответствующие столбцы другой таблицы будут `NULL`.
*   **Подзапросы (Subqueries):** Запросы, вложенные в другой SQL-запрос. Могут использоваться в:
    *   `SELECT` списке (скалярный подзапрос – должен возвращать одно значение).
    *   `FROM` предложении (производная таблица – подзапрос возвращает набор строк).
    *   `WHERE` или `HAVING` предложении (для сравнения, с операторами `IN`, `NOT IN`, `EXISTS`, `NOT EXISTS`, `=`, `>`, `<` и т.д.).
        *   `IN`: Проверяет, присутствует ли значение в наборе, возвращаемом подзапросом.
        *   `EXISTS`: Проверяет, возвращает ли подзапрос хотя бы одну строку.
*   **Объединенные запросы (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT`):**
    *   `UNION`: Объединяет результаты двух или более `SELECT` запросов, удаляя дубликаты строк.
    *   `UNION ALL`: Объединяет результаты, сохраняя все дубликаты.
    *   `INTERSECT`: Возвращает строки, которые присутствуют в результатах обоих запросов.
    *   `EXCEPT` (или `MINUS` в Oracle): Возвращает строки из первого запроса, которых нет во втором.
    *   *Требование:* Количество и типы данных столбцов в объединяемых `SELECT` должны совпадать.
*   **Общие табличные выражения (Common Table Expressions - CTEs):** С помощью `WITH` clause. Позволяют определить временный именованный результирующий набор, на который можно ссылаться в последующем `SELECT`, `INSERT`, `UPDATE` или `DELETE`. Улучшают читаемость и структуру сложных запросов, позволяют делать рекурсивные запросы.
*   **Оконные функции (Window Functions):** Выполняют вычисления для набора строк таблицы, которые каким-либо образом связаны с текущей строкой. Похожи на агрегатные функции, но не схлопывают строки в одну, а возвращают значение для каждой строки. Используются с `OVER()` clause. (Например, `ROW_NUMBER()`, `RANK()`, `SUM() OVER (...)`).

**Примеры из кода:**
Используем таблицы `Employees`, `Departments` и `Salaries` (зарплаты по месяцам).
```sql
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);
INSERT INTO Departments VALUES (1, 'IT'), (2, 'Sales'), (3, 'HR'), (4, 'Finance');

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
INSERT INTO Employees VALUES
(101, 'Иван', 'Иванов', 1, '2020-01-15'),
(102, 'Петр', 'Петров', 1, '2021-03-10'),
(103, 'Анна', 'Сидорова', 2, '2019-07-01'),
(104, 'Елена', 'Смирнова', 2, '2022-11-05'),
(105, 'Сергей', 'Кузнецов', 3, '2020-05-20'),
(106, 'Ольга', 'Васильева', NULL, '2023-01-01'); -- Сотрудник без отдела

CREATE TABLE Salaries (
    EmployeeID INT,
    SalaryMonth DATE,
    Amount DECIMAL(10,2),
    PRIMARY KEY (EmployeeID, SalaryMonth),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
INSERT INTO Salaries VALUES
(101, '2023-10-01', 70000), (101, '2023-11-01', 72000),
(102, '2023-10-01', 65000), (102, '2023-11-01', 65000),
(103, '2023-10-01', 80000), (103, '2023-11-01', 80000),
(104, '2023-10-01', 75000), (104, '2023-11-01', 77000);
-- Сотрудники 105, 106 еще не получали зарплату в этих месяцах или ее нет в таблице
```

1.  **Список всех сотрудников и названия их отделов (включая сотрудников без отдела):**
    ```sql
    SELECT e.FirstName, e.LastName, d.DepartmentName
    FROM Employees e
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
    -- Ольга Васильева будет с DepartmentName = NULL
    ```

2.  **Сотрудники, чья последняя зарплата (за ноябрь 2023) выше средней зарплаты по их отделу за тот же месяц (используя подзапросы и CTE):**
    ```sql
    WITH MonthlySalaries AS (
        -- Зарплаты сотрудников за ноябрь 2023
        SELECT EmployeeID, Amount, DepartmentID
        FROM Salaries s
        JOIN Employees e ON s.EmployeeID = e.EmployeeID
        WHERE SalaryMonth = '2023-11-01'
    ),
    AvgDeptSalaries AS (
        -- Средние зарплаты по отделам за ноябрь 2023
        SELECT DepartmentID, AVG(Amount) AS AvgSalary
        FROM MonthlySalaries
        GROUP BY DepartmentID
    )
    SELECT e.FirstName, e.LastName, d.DepartmentName, ms.Amount AS EmployeeSalary, ads.AvgSalary AS DepartmentAvgSalary
    FROM Employees e
    JOIN MonthlySalaries ms ON e.EmployeeID = ms.EmployeeID
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN AvgDeptSalaries ads ON e.DepartmentID = ads.DepartmentID
    WHERE ms.Amount > ads.AvgSalary;
    ```

3.  **Найти отделы, в которых нет сотрудников (используя `NOT EXISTS` или `LEFT JOIN / IS NULL`):**
    ```sql
    -- C NOT EXISTS
    SELECT d.DepartmentName
    FROM Departments d
    WHERE NOT EXISTS (
        SELECT 1
        FROM Employees e
        WHERE e.DepartmentID = d.DepartmentID
    );
    -- Результат: Finance

    -- C LEFT JOIN / IS NULL
    SELECT d.DepartmentName
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    WHERE e.EmployeeID IS NULL;
    -- Результат: Finance
    ```

4.  **Список сотрудников из IT и HR отделов (используя `UNION`):**
    *(Этот пример немного искусственный, проще было бы `WHERE d.DepartmentName IN ('IT', 'HR')`, но для демонстрации `UNION`)*
    ```sql
    SELECT e.FirstName, e.LastName, d.DepartmentName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = 'IT'
    UNION
    SELECT e.FirstName, e.LastName, d.DepartmentName
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = 'HR';
    ```

5.  **Ранжирование сотрудников по дате найма в каждом отделе (оконная функция):**
    ```sql
    SELECT
        e.FirstName,
        e.LastName,
        d.DepartmentName,
        e.HireDate,
        ROW_NUMBER() OVER (PARTITION BY e.DepartmentID ORDER BY e.HireDate ASC) AS RankInDeptByHireDate
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.DepartmentID IS NOT NULL
    ORDER BY d.DepartmentName, RankInDeptByHireDate;
    ```
    Этот запрос присвоит ранг каждому сотруднику внутри его отдела на основе даты найма. Самый "старый" сотрудник в отделе получит ранг 1.

---

**12. Представления (Views)**

**Подробно:**
**Представление (View)** — это виртуальная таблица, основанная на результате выполнения SQL-запроса. Представления не хранят данные сами по себе (за исключением материализованных представлений, которые являются отдельной концепцией). Вместо этого они хранят сам SQL-запрос. Когда вы обращаетесь к представлению, СУБД выполняет этот сохраненный запрос и возвращает результат, как если бы это была реальная таблица.

**Преимущества использования представлений:**

1.  **Упрощение сложных запросов:** Длинные и сложные запросы с множеством `JOIN`'ов или вычислений можно сохранить как представление. Затем пользователи могут делать простые `SELECT` запросы к этому представлению.
2.  **Безопасность данных:** Представления могут ограничивать доступ к данным:
    *   Можно скрыть определенные столбцы, которые не должны быть видны пользователю.
    *   Можно отфильтровать строки, например, показать менеджеру только данные его отдела.
3.  **Логическая независимость данных:** Если структура базовых таблиц меняется (например, столбец переименован или таблица разделена), можно изменить определение представления так, чтобы оно по-прежнему возвращало данные в ожидаемом формате. Приложения, использующие представление, не потребуют изменений.
4.  **Согласованность данных:** Представления могут предоставлять данные в определенном формате или с предварительно вычисленными значениями, обеспечивая единообразие для всех пользователей.
5.  **Переиспользование SQL-кода:** Определив логику один раз в представлении, ее можно многократно использовать.

**Создание и использование представлений:**
*   **`CREATE VIEW view_name AS SELECT_statement;`**
*   **`SELECT * FROM view_name;`** (Работает как с обычной таблицей)
*   **`DROP VIEW view_name;`** (Удаляет представление, базовые таблицы не затрагиваются)
*   **`ALTER VIEW view_name AS SELECT_statement;`** (Изменяет определение представления) или `CREATE OR REPLACE VIEW` (в некоторых СУБД).

**Обновляемые представления:**
Некоторые простые представления (обычно основанные на одной таблице, без агрегаций, `GROUP BY`, `DISTINCT`) могут быть обновляемыми. Это означает, что можно выполнять команды `INSERT`, `UPDATE`, `DELETE` непосредственно к представлению, и эти изменения будут применены к базовой таблице. Однако, если представление сложное, оно, как правило, будет только для чтения. Опция `WITH CHECK OPTION` может быть добавлена, чтобы гарантировать, что все вставки или обновления через представление соответствуют условиям `WHERE` самого представления.

**Примеры из кода:**
Используем таблицы `Employees` и `Departments` из предыдущего примера.

1.  **Создание представления для отображения полной информации о сотрудниках и их отделах:**
    ```sql
    CREATE VIEW EmployeeDetails AS
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.HireDate,
        d.DepartmentName,
        d.DepartmentID
    FROM Employees e
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
    ```
    Теперь можно запрашивать данные так:
    ```sql
    SELECT * FROM EmployeeDetails;

    SELECT FirstName, LastName, DepartmentName
    FROM EmployeeDetails
    WHERE DepartmentName = 'IT';
    ```

2.  **Создание представления, показывающего только активных сотрудников IT-отдела (пример ограничения доступа):**
    Предположим, в `Employees` есть столбец `IsActive BOOLEAN`.
    ```sql
    -- Добавим столбец для примера
    -- ALTER TABLE Employees ADD COLUMN IsActive BOOLEAN DEFAULT TRUE;
    -- UPDATE Employees SET IsActive = FALSE WHERE EmployeeID = 102;

    CREATE VIEW ActiveITEmployees AS
    SELECT EmployeeID, FirstName, LastName, HireDate
    FROM Employees
    WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'IT')
    AND IsActive = TRUE; -- Предполагая, что такой столбец есть
    ```
    Теперь пользователи, имеющие доступ только к `ActiveITEmployees`, увидят ограниченный набор данных.
    ```sql
    SELECT * FROM ActiveITEmployees;
    ```

3.  **Представление с агрегацией (обычно не обновляемое):**
    Статистика по количеству сотрудников в каждом отделе.
    ```sql
    CREATE VIEW DepartmentStats AS
    SELECT
        d.DepartmentName,
        COUNT(e.EmployeeID) AS NumberOfEmployees
    FROM Departments d
    LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentID, d.DepartmentName;
    ```
    Использование:
    ```sql
    SELECT * FROM DepartmentStats
    ORDER BY NumberOfEmployees DESC;
    ```

4.  **Удаление представления:**
    ```sql
    DROP VIEW ActiveITEmployees;
    ```

---

**13. Пользовательские функции (User-Defined Functions - UDF)**

**Подробно:**
**Пользовательская функция (UDF)** — это программный объект в СУБД, который принимает ноль или более входных параметров и возвращает значение. UDF создаются пользователями для инкапсуляции часто используемой логики или вычислений, которые не могут быть легко выражены стандартными SQL-операторами.

**Типы пользовательских функций:**

1.  **Скалярные функции (Scalar Functions):**
    *   Возвращают одно значение указанного типа данных (например, число, строку, дату).
    *   Могут использоваться в большинстве мест, где допустимо выражение (например, в `SELECT` списке, `WHERE` предложении, `SET` предложении команды `UPDATE`).

2.  **Табличные функции (Table-Valued Functions - TVF):**
    *   Возвращают набор строк, т.е. таблицу.
    *   Могут использоваться в предложении `FROM` запроса, как если бы это была обычная таблица или представление.
    *   **Встроенные (inline) TVF:** Обычно содержат один `SELECT` запрос. Более производительны. (SQL Server)
    *   **Многооператорные (multi-statement) TVF:** Могут содержать более сложную логику, несколько SQL-операторов, переменные. (SQL Server)
    *   В PostgreSQL функции, возвращающие `SETOF <тип_строки>` или `TABLE(...)`, являются табличными.

**Преимущества использования UDF:**

*   **Модульность и переиспользование кода:** Сложную логику можно определить один раз и вызывать многократно.
*   **Улучшение читаемости SQL-запросов:** Замена сложных выражений вызовом функции.
*   **Расширение возможностей SQL:** Реализация специфических для бизнеса вычислений.
*   **Централизация бизнес-логики:** Изменения в логике делаются в одном месте (в функции).

**Создание и использование UDF (синтаксис сильно зависит от СУБД):**

*   **`CREATE FUNCTION function_name ([parameter1 datatype, ...]) RETURNS return_datatype AS BEGIN ... RETURN ... END;`** (Общий шаблон, детали сильно отличаются).
*   Языки для написания UDF: SQL (PL/SQL для Oracle, T-SQL для SQL Server, PL/pgSQL для PostgreSQL), а также внешние языки (C, Java, Python и т.д. в некоторых СУБД).

**Примеры из кода:**

1.  **Скалярная функция для вычисления полного имени (T-SQL для SQL Server):**
    ```sql
    CREATE FUNCTION dbo.GetFullName (@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
    RETURNS NVARCHAR(101)
    AS
    BEGIN
        RETURN ISNULL(@FirstName, '') + ' ' + ISNULL(@LastName, '');
    END;
    GO

    -- Использование:
    SELECT dbo.GetFullName(FirstName, LastName) AS FullName, HireDate
    FROM Employees;
    ```
    **Скалярная функция для вычисления полного имени (PL/pgSQL для PostgreSQL):**
    ```sql
    CREATE OR REPLACE FUNCTION GetFullName (p_firstname VARCHAR, p_lastname VARCHAR)
    RETURNS VARCHAR
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN COALESCE(p_firstname, '') || ' ' || COALESCE(p_lastname, '');
    END;
    $$;

    -- Использование:
    SELECT GetFullName(FirstName, LastName) AS FullName, HireDate
    FROM Employees;
    ```

2.  **Скалярная функция для расчета возраста (PL/pgSQL для PostgreSQL):**
    ```sql
    CREATE OR REPLACE FUNCTION CalculateAge (p_birthdate DATE)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
        IF p_birthdate IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN DATE_PART('year', AGE(CURRENT_DATE, p_birthdate));
    END;
    $$;

    -- Использование (предположим, в Employees есть BirthDate):
    -- ALTER TABLE Employees ADD COLUMN BirthDate DATE;
    -- UPDATE Employees SET BirthDate = '1990-05-15' WHERE EmployeeID = 101;
    SELECT FirstName, LastName, CalculateAge(BirthDate) AS Age
    FROM Employees
    WHERE EmployeeID = 101;
    ```

3.  **Табличная функция: получить сотрудников определенного отдела (T-SQL для SQL Server - Inline TVF):**
    ```sql
    CREATE FUNCTION dbo.GetEmployeesByDepartment (@DepartmentID INT)
    RETURNS TABLE
    AS
    RETURN (
        SELECT EmployeeID, FirstName, LastName, HireDate
        FROM Employees
        WHERE DepartmentID = @DepartmentID
    );
    GO

    -- Использование:
    SELECT * FROM dbo.GetEmployeesByDepartment(1); -- Получить всех сотрудников из отдела с ID=1 (IT)
    ```
    **Табличная функция: получить сотрудников определенного отдела (PL/pgSQL для PostgreSQL):**
    ```sql
    CREATE OR REPLACE FUNCTION GetEmployeesByDepartment (p_department_id INT)
    RETURNS TABLE (emp_id INT, emp_firstname VARCHAR, emp_lastname VARCHAR, emp_hiredate DATE)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT EmployeeID, FirstName, LastName, HireDate
        FROM Employees
        WHERE DepartmentID = p_department_id;
    END;
    $$;

    -- Использование:
    SELECT * FROM GetEmployeesByDepartment(1);
    ```

**Важно:** Чрезмерное использование скалярных UDF в `WHERE` или `JOIN` условиях может негативно сказаться на производительности, так как они могут выполняться для каждой строки и мешать оптимизатору запросов.

---

**14. Хранимые процедуры (Stored Procedures)**

**Подробно:**
**Хранимая процедура (Stored Procedure, SP)** — это именованный набор одной или нескольких SQL-инструкций (включая DDL, DML, вызовы других процедур, управляющие конструкции, такие как `IF/ELSE`, циклы), который скомпилирован и сохранен в базе данных. Процедуры могут принимать входные параметры, возвращать выходные параметры и наборы результатов (result sets).

**Преимущества использования хранимых процедур:**

1.  **Модульность и переиспользование кода:** Как и функции, позволяют инкапсулировать логику.
2.  **Уменьшение сетевого трафика:** Вместо отправки множества SQL-команд на сервер, приложение отправляет только имя процедуры и параметры. Вся логика выполняется на сервере.
3.  **Повышение производительности:**
    *   План выполнения для процедуры обычно кэшируется после первого вызова, что ускоряет последующие вызовы.
    *   Уменьшение сетевого трафика также способствует производительности.
4.  **Безопасность:**
    *   Можно предоставить пользователю права на выполнение процедуры, не давая ему прямых прав на базовые таблицы. Это позволяет контролировать операции с данными.
    *   Защита от SQL-инъекций, если параметры используются корректно (не динамической конкатенацией в строку запроса).
5.  **Централизация бизнес-логики:** Логика приложения хранится на сервере БД, что упрощает ее обновление и поддержку.
6.  **Поддержка транзакций:** Процедуры могут управлять транзакциями, обеспечивая атомарность операций.

**Отличие от Пользовательских Функций (UDF):**
*   **Возвращаемые значения:** Скалярные UDF всегда возвращают одно значение и могут использоваться в SQL-выражениях. Хранимые процедуры могут не возвращать ничего, возвращать значения через выходные параметры или возвращать один или несколько наборов результатов (как `SELECT`).
*   **Использование:** UDF (особенно скалярные) часто используются внутри SQL-запросов. Хранимые процедуры обычно вызываются отдельно командой `EXECUTE` или `CALL`.
*   **Побочные эффекты:** UDF (особенно те, что используются в `SELECT`) обычно не должны иметь побочных эффектов (т.е. не должны изменять состояние БД, например, делать `INSERT`/`UPDATE`/`DELETE`). Хранимые процедуры часто используются именно для модификации данных.
*   **Транзакции:** Хранимые процедуры могут содержать полноценное управление транзакциями (`COMMIT`, `ROLLBACK`). Функции обычно не могут.

**Создание и использование (синтаксис сильно зависит от СУБД):**

*   `CREATE PROCEDURE procedure_name ([IN|OUT|INOUT param_name datatype, ...]) AS BEGIN ... END;` (Общий шаблон)
*   `EXEC procedure_name [param_value, ...];` или `CALL procedure_name [param_value, ...];`

**Примеры из кода:**

1.  **Процедура для добавления нового сотрудника (T-SQL для SQL Server):**
    ```sql
    CREATE PROCEDURE dbo.AddEmployee
        @FirstName NVARCHAR(50),
        @LastName NVARCHAR(50),
        @DepartmentID INT,
        @HireDate DATE,
        @NewEmployeeID INT OUTPUT -- Выходной параметр для ID нового сотрудника
    AS
    BEGIN
        SET NOCOUNT ON; -- Отключает вывод сообщения о количестве обработанных строк

        INSERT INTO Employees (FirstName, LastName, DepartmentID, HireDate)
        VALUES (@FirstName, @LastName, @DepartmentID, @HireDate);

        SET @NewEmployeeID = SCOPE_IDENTITY(); -- Получаем ID последней вставленной записи
    END;
    GO

    -- Использование:
    DECLARE @EmpID INT;
    EXEC dbo.AddEmployee
        @FirstName = 'Новый',
        @LastName = 'Сотрудников',
        @DepartmentID = 1,
        @HireDate = '2023-11-15',
        @NewEmployeeID = @EmpID OUTPUT;
    SELECT @EmpID AS GeneratedEmployeeID;
    ```
    **Процедура для добавления нового сотрудника (PL/pgSQL для PostgreSQL):**
    ```sql
    CREATE OR REPLACE PROCEDURE AddEmployee (
        p_firstname VARCHAR,
        p_lastname VARCHAR,
        p_department_id INT,
        p_hiredate DATE,
        INOUT p_new_employee_id INT DEFAULT NULL -- Используем INOUT для возврата ID
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Employees (FirstName, LastName, DepartmentID, HireDate)
        VALUES (p_firstname, p_lastname, p_department_id, p_hiredate)
        RETURNING EmployeeID INTO p_new_employee_id; -- Возвращает ID в параметр
    END;
    $$;

    -- Использование:
    CALL AddEmployee('Алексей', 'Новиков', 2, '2023-11-16'); -- p_new_employee_id будет обновлен
    -- Чтобы получить значение p_new_employee_id, его нужно объявить как переменную сессии
    -- или использовать функцию, если нужно вернуть значение напрямую в SELECT
    -- Пример с функцией для PostgreSQL для простоты получения ID:
    CREATE OR REPLACE FUNCTION AddEmployeeAndGetId (
        p_firstname VARCHAR, p_lastname VARCHAR, p_department_id INT, p_hiredate DATE
    )
    RETURNS INT
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_new_employee_id INT;
    BEGIN
        INSERT INTO Employees (FirstName, LastName, DepartmentID, HireDate)
        VALUES (p_firstname, p_lastname, p_department_id, p_hiredate)
        RETURNING EmployeeID INTO v_new_employee_id;
        RETURN v_new_employee_id;
    END;
    $$;
    SELECT AddEmployeeAndGetId('Мария', 'Лебедева', 3, '2023-11-17');
    ```

2.  **Процедура для получения списка сотрудников отдела и общего их числа (возвращает набор результатов и выходной параметр - T-SQL):**
    ```sql
    CREATE PROCEDURE dbo.GetEmployeesInDepartment
        @DepartmentID INT,
        @EmployeeCount INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT EmployeeID, FirstName, LastName, HireDate
        FROM Employees
        WHERE DepartmentID = @DepartmentID;

        SELECT @EmployeeCount = COUNT(*)
        FROM Employees
        WHERE DepartmentID = @DepartmentID;
    END;
    GO

    -- Использование:
    DECLARE @Count INT;
    EXEC dbo.GetEmployeesInDepartment @DepartmentID = 1, @EmployeeCount = @Count OUTPUT;
    SELECT @Count AS TotalEmployeesInDept;
    -- Первый результат будет таблица сотрудников, второй - значение @Count
    ```
    **Для PostgreSQL аналог с возвратом набора и параметра сложнее сделать в одной процедуре. Обычно возвращают либо набор (`RETURNS TABLE` или `SETOF`), либо используют `OUT` параметры для скалярных значений (но не вместе с `RETURNS TABLE` в одной функции).**
    Можно сделать функцию, возвращающую `REFCURSOR` и `OUT` параметр, или два отдельных вызова.

    Проще всего для PostgreSQL сделать функцию, возвращающую таблицу:
    ```sql
    CREATE OR REPLACE FUNCTION GetEmployeesInDepartment (p_department_id INT)
    RETURNS TABLE (emp_id INT, emp_firstname VARCHAR, emp_lastname VARCHAR, emp_hiredate DATE)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT EmployeeID, FirstName, LastName, HireDate
        FROM Employees
        WHERE DepartmentID = p_department_id;
    END;
    $$;
    -- Использование:
    SELECT * FROM GetEmployeesInDepartment(1);
    -- А количество можно получить отдельным запросом или внутри приложения.
    ```

---

**15. Триггеры**

**Подробно:**
**Триггер** — это специальный тип хранимой процедуры, который автоматически выполняется (срабатывает) в ответ на определенные события DML (`INSERT`, `UPDATE`, `DELETE`) или DDL (`CREATE`, `ALTER`, `DROP`) в указанной таблице или базе данных.

**Основные характеристики и назначение триггеров:**

1.  **Автоматическое выполнение:** Не требуют явного вызова.
2.  **Связь с событием:** Определяются для конкретного события (например, `AFTER INSERT`, `BEFORE UPDATE`).
3.  **Контекст выполнения:**
    *   **Строковые триггеры (`FOR EACH ROW`):** Выполняются для каждой строки, затронутой операцией DML. Внутри таких триггеров доступны специальные псевдо-записи (часто `NEW` и `OLD` или `INSERTED` и `DELETED`) для доступа к данным вставляемой/обновляемой/удаляемой строки.
    *   **Операторные триггеры (`FOR EACH STATEMENT`):** Выполняются один раз для всей DML-операции, независимо от количества затронутых строк. (Менее распространены или имеют другой синтаксис, чем `FOR EACH ROW`).
4.  **Время срабатывания:**
    *   **`BEFORE` (или `INSTEAD OF` для представлений):** Триггер срабатывает до выполнения DML-операции. Может использоваться для проверки данных, их модификации перед записью или для отмены операции.
    *   **`AFTER`:** Триггер срабатывает после успешного выполнения DML-операции. Используется для логирования, каскадных обновлений, оповещений.

**Применение триггеров:**

*   **Поддержание целостности данных:** Реализация сложных правил, которые не могут быть обеспечены стандартными ограничениями (`CHECK`, `FOREIGN KEY`).
*   **Аудит и логирование изменений:** Запись информации о том, кто, когда и какие данные изменил, в отдельную таблицу аудита.
*   **Автоматизация действий:** Например, автоматическое обновление поля `LastModifiedDate` при изменении строки.
*   **Каскадные операции:** Реализация пользовательской логики для каскадного обновления или удаления в связанных таблицах.
*   **Предотвращение нежелательных операций.**

**Внимание:**
*   Чрезмерное или некорректное использование триггеров может усложнить отладку и негативно сказаться на производительности.
*   Логика в триггерах должна быть максимально простой и быстрой.
*   Следует избегать рекурсивных триггеров (когда триггер вызывает операцию, которая снова активирует тот же триггер), если это не сделано намеренно и контролируемо.

**Создание и использование (синтаксис зависит от СУБД):**

*   `CREATE TRIGGER trigger_name {BEFORE | AFTER} {INSERT | UPDATE | DELETE} ON table_name FOR EACH ROW BEGIN ... END;` (Общий шаблон)

**Примеры из кода:**

Предположим, у нас есть таблица `Employees` и таблица `AuditLog`.
```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10,2),
    LastModified TIMESTAMP -- Будем обновлять триггером
);

CREATE TABLE AuditLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT, -- Или SERIAL
    TableName VARCHAR(100),
    OperationType VARCHAR(10), -- INSERT, UPDATE, DELETE
    OldData TEXT,              -- JSON или XML представление старых данных
    NewData TEXT,              -- JSON или XML представление новых данных
    ChangedBy VARCHAR(100),    -- Имя пользователя (если доступно)
    ChangeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

1.  **Триггер для автоматического обновления `LastModified` (PL/pgSQL для PostgreSQL):**
    Сначала функция, затем триггер.
    ```sql
    CREATE OR REPLACE FUNCTION update_last_modified_column()
    RETURNS TRIGGER AS $$
    BEGIN
       NEW.LastModified = NOW(); -- NEW ссылается на строку, которая будет вставлена/обновлена
       RETURN NEW; -- Обязательно для BEFORE триггера
    END;
    $$ language 'plpgsql';

    CREATE TRIGGER employees_last_modified_trigger
    BEFORE UPDATE ON Employees
    FOR EACH ROW
    EXECUTE FUNCTION update_last_modified_column();

    -- Пример работы:
    -- INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary) VALUES (1, 'Иван', 'Иванов', 50000);
    -- UPDATE Employees SET Salary = 55000 WHERE EmployeeID = 1; -- LastModified обновится
    ```
    **Триггер для автоматического обновления `LastModified` (T-SQL для SQL Server):**
    ```sql
    CREATE TRIGGER TR_Employees_LastModified
    ON Employees
    AFTER UPDATE -- Или BEFORE UPDATE, но AFTER чаще для таких вещей
    AS
    BEGIN
        SET NOCOUNT ON;
        IF UPDATE(Salary) OR UPDATE(FirstName) OR UPDATE(LastName) -- Срабатывает только если определенные поля изменены
        BEGIN
            UPDATE e
            SET LastModified = GETDATE()
            FROM Employees e
            INNER JOIN inserted i ON e.EmployeeID = i.EmployeeID; -- 'inserted' это псевдо-таблица с новыми значениями
        END
    END;
    GO
    ```
    *Примечание: В MySQL можно проще: `LastModified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` прямо в определении таблицы.*

2.  **Триггер для логирования изменений зарплаты (T-SQL для SQL Server):**
    ```sql
    CREATE TRIGGER TR_Audit_SalaryChange
    ON Employees
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF UPDATE(Salary) -- Срабатывает, только если столбец Salary был обновлен
        BEGIN
            INSERT INTO AuditLog (TableName, OperationType, OldData, NewData, ChangedBy)
            SELECT
                'Employees',
                'UPDATE',
                (SELECT d.Salary AS OldSalary FROM deleted d WHERE d.EmployeeID = i.EmployeeID FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), -- Старое значение
                (SELECT i.Salary AS NewSalary FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), -- Новое значение
                SUSER_SNAME() -- Текущий пользователь SQL Server
            FROM inserted i -- 'inserted' содержит новые значения
            LEFT JOIN deleted d ON i.EmployeeID = d.EmployeeID -- 'deleted' содержит старые значения для UPDATE/DELETE
            WHERE i.Salary <> ISNULL(d.Salary, -1); -- Логируем только реальное изменение зарплаты
        END
    END;
    GO

    -- Пример работы:
    -- INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, LastModified) VALUES (1, 'Иван', 'Иванов', 50000, GETDATE());
    -- UPDATE Employees SET Salary = 60000 WHERE EmployeeID = 1;
    -- SELECT * FROM AuditLog;
    ```
    **Триггер для логирования изменений зарплаты (PL/pgSQL для PostgreSQL):**
    ```sql
    CREATE OR REPLACE FUNCTION audit_salary_change_func()
    RETURNS TRIGGER AS $$
    BEGIN
        IF TG_OP = 'UPDATE' THEN
            IF OLD.Salary IS DISTINCT FROM NEW.Salary THEN -- Логируем только если зарплата действительно изменилась
                INSERT INTO AuditLog (TableName, OperationType, OldData, NewData, ChangedBy)
                VALUES (
                    TG_TABLE_NAME,
                    TG_OP,
                    ROW_TO_JSON(OLD)::TEXT, -- Сериализуем всю старую строку в JSON
                    ROW_TO_JSON(NEW)::TEXT, -- Сериализуем всю новую строку в JSON
                    CURRENT_USER
                );
            END IF;
        ELSIF TG_OP = 'INSERT' THEN
             INSERT INTO AuditLog (TableName, OperationType, NewData, ChangedBy)
                VALUES (
                    TG_TABLE_NAME,
                    TG_OP,
                    ROW_TO_JSON(NEW)::TEXT,
                    CURRENT_USER
                );
        ELSIF TG_OP = 'DELETE' THEN
             INSERT INTO AuditLog (TableName, OperationType, OldData, ChangedBy)
                VALUES (
                    TG_TABLE_NAME,
                    TG_OP,
                    ROW_TO_JSON(OLD)::TEXT,
                    CURRENT_USER
                );
        END IF;
        RETURN NEW; -- Для INSERT/UPDATE. Для DELETE можно RETURN OLD или RETURN NULL.
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER employees_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON Employees
    FOR EACH ROW
    EXECUTE FUNCTION audit_salary_change_func();

    -- Пример работы:
    -- INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary) VALUES (1, 'Иван', 'Иванов', 50000);
    -- UPDATE Employees SET Salary = 55000 WHERE EmployeeID = 1;
    -- DELETE FROM Employees WHERE EmployeeID = 1;
    -- SELECT * FROM AuditLog;
    ```
