# Online_Bookstore_Project_using-SQL

## Overview
This project is a SQL-based analysis of an online bookstore database. It includes a wide range of queries from basic data retrieval (e.g., listing fiction books, filtering by country or date) to advanced analytics such as calculating total revenue, identifying top customers, and tracking inventory. The queries help explore customer behavior, book sales, stock levels, and genre trends, making it a complete mini-case study in SQL for e-commerce data.

## Objective
The goal of this project is to explore and analyze data from an online bookstore using SQL. Through a series of practical queries, the project aims to answer real-world business questions such as tracking book sales, monitoring stock, identifying top customers, and analyzing genre trends. It’s designed to strengthen SQL skills while working with realistic e-commerce data.

## Dataset
**books**(https://github.com/Issita/Online_Bookstore_Project_in-SQL/blob/main/Books.csv)
**customer**(https://github.com/Issita/Online_Bookstore_Project_in-SQL/blob/main/Customers.csv)
**orders**(https://github.com/Issita/Online_Bookstore_Project_in-SQL/blob/main/Orders.csv)
## Business Problems and Solutions

## 1. **Retrieve all books in the "Fiction" genre:**
``` sql
SELECT * FROM BOOKS
WHERE GENRE = 'Fiction';
```
## 2. **Find books published after the year 1950:**
```sql
SELECT * FROM BOOKS
WHERE PUBLISHED_YEAR > 1950;
```
## 3. **List all customers from the Canada:**
```sql
SELECT * FROM CUSTOMERS
WHERE COUNTRY = 'Canada';
```
## 4. **Show orders placed in November 2023:**
```sql
SELECT * FROM ORDERS
WHERE ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';
```
## 5. **Retrieve the total stock of books available:**
```sql
SELECT 
SUM(Stock) AS TOTAL_STOCK
FROM BOOKS;
```
## 6. **Find the details of the most expensive book:**
```sql
SELECT * FROM BOOKS
ORDER BY PRICE DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;
```
## 7. **Show all customers who ordered more than 1 quantity of a book:**
```sql
SELECT * FROM ORDERS
WHERE QUANTITY > 1;
```
## 8. **Retrieve all orders where the total amount exceeds $20:**
```sql
SELECT * FROM ORDERS
WHERE TOTAL_AMOUNT > 20;
```
## 9. **List all genres available in the Books table:**
```sql
SELECT DISTINCT GENRE FROM BOOKS;
```
## 10. **Find the book with the lowest stock:**
```sql
SELECT * FROM BOOKS
ORDER BY STOCK
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;
```
## 11. **Calculate the total revenue generated from all orders:**
```sql
SELECT 
SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM ORDERS;
```
## 12. **Retrieve the total number of books sold for each genre:**
```sql
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
```
## 13. **Find the average price of books in the "Fantasy" genre:**
```sql
SELECT 
AVG(PRICE) AS AVGERAGE_PRICE
FROM BOOKS
WHERE GENRE = 'Fantasy';
```
## 14. **List customers who have placed at least 2 orders:**
```sql
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
```
## 15. **Find the most frequently ordered book:**
```sql
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

```
## 16. **Show the top 3 most expensive books of 'Fantasy' Genre :**
```sql
SELECT TOP 3 * FROM BOOKS
WHERE GENRE = 'Fantasy'
ORDER BY PRICE DESC;
```
## 17. **Retrieve the total quantity of books sold by each author:**
```sql
SELECT
B.AUTHOR,
SUM(O.QUANTITY) AS TOTAL_QUANTITY
FROM BOOKS AS B
JOIN
ORDERS AS O
ON
B.Book_ID = O.Book_ID
GROUP BY B.AUTHOR;
```
## 18. **List the cities where customers who spent over $30 are located:**
```sql
SELECT 
DISTINCT C.CITY,
O.TOTAL_AMOUNT
FROM ORDERS AS O
JOIN
CUSTOMERS AS C
ON 
C.CUSTOMER_ID=O.CUSTOMER_ID 
WHERE O.TOTAL_AMOUNT > 30 ;
```
## 19. **Find the customer who spent the most on orders:**
```sql
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
```
## 20. **Calculate the stock remaining after fulfilling all orders:*
```sql
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
```


