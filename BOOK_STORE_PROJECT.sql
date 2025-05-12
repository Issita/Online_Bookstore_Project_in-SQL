CREATE DATABASE PROJECTS;
USE PROJECTS;

--Tables
SELECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM BOOKS
WHERE GENRE = 'Fiction';


-- 2) Find books published after the year 1950:

SELECT * FROM BOOKS
WHERE PUBLISHED_YEAR > 1950;

-- 3) List all customers from the Canada:

SELECT * FROM CUSTOMERS
WHERE COUNTRY = 'Canada';


-- 4) Show orders placed in November 2023:

SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT 
SUM(Stock) AS TOTAL_STOCK
FROM BOOKS;


-- 6) Find the details of the most expensive book:

SELECT * FROM BOOKS
ORDER BY PRICE DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM ORDERS
WHERE QUANTITY > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT > 20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT GENRE FROM BOOKS;


-- 10) Find the book with the lowest stock:

SELECT * FROM BOOKS
ORDER BY STOCK
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;


-- 11) Calculate the total revenue generated from all orders:

SELECT 
SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM ORDERS;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT
B.GENRE,
SUM(O.QUANTITY)AS NUMBER_OF_BOOKS
FROM ORDERS AS O
JOIN
BOOKS AS B
ON
O.BOOK_ID = B.BOOK_ID
GROUP BY B.GENRE ;


--ANOTHER METHOD

WITH GENRE_SALES AS(
	SELECT 
	B.GENRE,
	O.QUANTITY
	FROM ORDERS AS O
	JOIN
	BOOKS AS B
	ON
	O.BOOK_ID = B.BOOK_ID
)
SELECT 
GENRE,
SUM(QUANTITY)AS NUMBER_OF_BOOKS
FROM GENRE_SALES
GROUP BY GENRE;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT 
AVG(PRICE) AS AVGERAGE_PRICE
FROM BOOKS
WHERE GENRE = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:

SELECT 
CUSTOMER_ID,
COUNT(*) 
FROM ORDERS
GROUP BY CUSTOMER_ID
HAVING COUNT(*) >= 2;


--ANOTHER METHOD

WITH ORDER_COUNT AS (
	SELECT 
	O.CUSTOMER_ID,
	C.NAME,
	COUNT(O.CUSTOMER_ID) AS ORDER_COUNT_BOOKS
	FROM  ORDERS AS O
	JOIN
	CUSTOMERS AS C
	ON
	O.CUSTOMER_ID = C.CUSTOMER_ID
	GROUP BY O.CUSTOMER_ID,C.NAME
)
SELECT 
CUSTOMER_ID,
NAME
FROM ORDER_COUNT
WHERE ORDER_COUNT_BOOKS > = 2;


-- 4) Find the most frequently ordered book:

SELECT * FROM BOOKS;
SELECT * FROM ORDERS;

SELECT TOP 1
BOOK_ID,
SUM(QUANTITY) AS TOTAL_ORDERS
FROM ORDERS
GROUP BY BOOK_ID
ORDER BY SUM(QUANTITY) DESC;

--ANOTHER METHOD

WITH BOOK_ORDER AS(

	SELECT 
	BOOK_ID,
	SUM(QUANTITY) AS TOTAL_ORDER
	FROM ORDERS
	GROUP BY BOOK_ID
),
RANKED_BOOKS AS (
	SELECT * ,
	RANK() OVER (ORDER BY TOTAL_ORDER DESC)AS RANKING
	FROM BOOK_ORDER
)

SELECT 
BOOK_ID,
TOTAL_ORDER,
RANKING
FROM RANKED_BOOKS
WHERE RANKING =1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT TOP 3 * FROM BOOKS
WHERE GENRE = 'Fantasy'
ORDER BY PRICE DESC;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT * FROM BOOKS;
SELECT * FROM ORDERS;

SELECT
B.AUTHOR,
SUM(O.QUANTITY) AS TOTAL_QUANTITY
FROM BOOKS AS B
JOIN
ORDERS AS O
ON
B.Book_ID = O.Book_ID
GROUP BY B.AUTHOR;


-- 7) List the cities where customers who spent over $30 are located:

SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;

SELECT 
DISTINCT C.CITY,
O.TOTAL_AMOUNT
FROM ORDERS AS O
JOIN
CUSTOMERS AS C
ON 
C.CUSTOMER_ID=O.CUSTOMER_ID 
WHERE O.TOTAL_AMOUNT > 30 ;

-- 8) Find the customer who spent the most on orders:

SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;


SELECT TOP 1
C.CUSTOMER_ID,
C.NAME,
SUM(O.TOTAL_AMOUNT) AS SPENT
FROM CUSTOMERS AS C
JOIN
ORDERS AS O
ON 
C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID,C.NAME
ORDER BY SUM(O.TOTAL_AMOUNT) DESC;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT * FROM BOOKS
SELECT * FROM ORDERS

SELECT
B.BOOK_ID,
B.TITLE,
B.STOCK,
O.QUANTITY,
COALESCE((B.STOCK-(CAST(O.QUANTITY AS INT))),B.STOCK) AS STOCK_REMAINING
FROM BOOKS AS B
LEFT JOIN
ORDERS AS O
ON
B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE, B.STOCK, O.QUANTITY
ORDER BY  O.QUANTITY;