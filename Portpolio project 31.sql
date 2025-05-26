CREATE DATABASE OnlineBookstore;

--Switch database
\c OnlineBookstore;

-- Create Table
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR (100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10, 2),
	Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books table:

COPY Books (Book_ID, Title, Author,	Genre,	Published_Year,	Price, Stock)
FROM 'C:\Users\DELL\Downloads\Books.csv'
CSV HEADER;

-- Import Data into Customers table:

COPY Customers(Customer_ID,	Name, Email, Phone,	City, Country)
FROM 'C:\Users\DELL\Downloads\Customers.csv'
CSV HEADER;

--Import data into Orders table:

COPY Orders (Order_ID, Customer_ID, Book_ID,Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\DELL\Downloads\Orders.csv'
CSV HEADER;

-- 1) Show all the books in the 'Fiction' genre:

SELECT * FROM Books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books
WHERE published_year > 1950;

-- 3) List all the customers from the Canada:

SELECT * FROM Customers
WHERE  country ='Canada';

-- 4)Show orders placed in November 2023:

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Show the total stock of books available:

SELECT SUM (stock) AS Total_stock
FROM Books;

-- 6)Find the details of the most expensive books.

SELECT * FROM Books ORDER BY price DESC;

SELECT * FROM Books ORDER BY price DESC LIMIT 5;

-- 7) Show all the customers who ordered more than one quantity of books.

SELECT * FROM Orders
WHERE quantity > 1;

-- 8) Show the all Orders where the total ammount excest $20.

SELECT * FROM Orders
WHERE total_amount > 20;

-- 9) List all genres available to the Books table:

SELECT DISTINCT genre FROM Books;       --DISTINCT ka use duplicate records ko remove karata hai
                                        -- only unique genre hi show kareg

-- 10) Find the book with the lowest stock:

SELECT * FROM Books
ORDER BY stock;

--Highest stock ke liye:

SELECT * FROM Books ORDER BY stock DESC
LIMIT 1;               
 
-- 11) Calculate the total revenue generated from all orders:

SELECT SUM (total_amount) AS Revenue
FROM Orders;

-- ADVANCE QUERIES

--1) Show the total number of books sold for each genre:

SELECT b.Genre, SUM (o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b
ON o.book_id = b.book_id       -- ye step dono table me book_id coman hai isliye
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT customer_id, COUNT(Order_id) AS ORDER_COUNT
FROM Orders
GROUP BY customer_id
HAVING COUNT(Order_id) >= 2;    --GROUP BY ke bad Conditions apply krne ke liye HAVING ka use hai

--name add karane ke liye:

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM Orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >= 2;

-- 4)Find the most frequently ordered books:

SELECT Book_id, COUNT (order_id) AS ORDER_COUNT
FROM Orders
GROUP BY Book_id
ORDER BY ORDER_COUNT DESC;

--book ka name add krne ke liye JOIN ka use kiya:

SELECT o.Book_id, b.title, COUNT (o.order_id) AS ORDER_COUNT
FROM Orders o
JOIN Books b
ON o.book_id = b.book_id
GROUP BY o.Book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 5;

-- 5) Show the Top 3 most expensive books of 'Fantasy' genre:

SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6)Show the total quantity of books sold by each outhor:

SELECT b.author, SUM(o.quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are located

SELECT DISTINCT c.city,total_amount  --DISTINCT ka use repited city na aye isliye
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customers who spent the most on orders:

SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC LIMIT 5;

-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
     b.stock-COALESCE(SUM(o.quantity),0) AS Remaining_quantity   
FROM Books b
LEFT JOIN Orders o ON b.book_id = o.book_id
GROUP BY b.book_id ORDER BY book_id;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;






