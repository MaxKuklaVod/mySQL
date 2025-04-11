CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    CustomerID INT,
    ProductName VARCHAR(255),
    CustomerAddress VARCHAR(255)
);

INSERT INTO Product VALUES
(1, 101, 'Chair', 'Lenina St, 15'),
(2, 102, 'Table', 'Mira Ave, 32'),
(3, 101, 'Wardrobe', 'Lenina St, 15'), -- Дублирование адреса
(4, 103, 'Bed', 'Pushkina St, 7');

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Address VARCHAR(255)
);

INSERT INTO Customers (CustomerID, Address)
SELECT DISTINCT CustomerID, CustomerAddress
FROM Product;

-- Удаление дублирующего столбца
ALTER TABLE Product
DROP COLUMN CustomerAddress;

-- Добавление внешнего ключа
ALTER TABLE Product
ADD CONSTRAINT fk_customer
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    CustomerID INT,
    ProductName VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);