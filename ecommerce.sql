CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT UNIQUE,
    amount DECIMAL(10,2),
    payment_date DATE,
    method VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers VALUES
(1, 'Alice', 'alice@gmail.com', '9876543210'),
(2, 'Bob', 'bob@gmail.com', '9123456780');

SELECT * from Customers;

INSERT INTO Products VALUES
(101, 'Laptop', 55000, 30),
(102, 'Headphones', 1500, 100),
(103, 'Keyboard', 1200, 50);

SELECT * from Products;

INSERT INTO Orders VALUES
(201, 1, '2025-01-10'),
(202, 2, '2025-01-11');

SELECT * from Orders;

INSERT INTO OrderItems VALUES
(1, 201, 101, 1),
(2, 201, 102, 2),
(3, 202, 103, 1);

SELECT * from OrderItems;

INSERT INTO Payments VALUES
(1, 201, 58000, '2025-01-10', 'UPI'),
(2, 202, 1200, '2025-01-11', 'Card');

SELECT * from Payments;

SELECT o.order_id, c.name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

SELECT c.name, SUM(p.amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.name;

SELECT oi.order_id, p.product_name, oi.quantity
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
WHERE order_id = 201;

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

SELECT c.name, SUM(p.amount) total
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Payments p ON o.order_id = p.order_id
GROUP BY c.name
HAVING total > 10000;

SELECT o.order_id, c.name
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
JOIN Customers c ON o.customer_id = c.customer_id
WHERE p.order_id IS NULL;

SELECT DISTINCT c.name
FROM Customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM Orders o
    JOIN OrderItems oi ON o.order_id = oi.order_id
    WHERE oi.product_id = 101
);


UPDATE Products 
SET stock = stock - 2
WHERE product_id = 102;


