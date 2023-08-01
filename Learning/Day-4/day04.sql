/*
    DML QUERIES
    DDL QUERIES
    DUAL
    SQL Functions
*/

--**DML QUERIES (UPDATE)

--I want to increase the price of c programming book by rs 100;
UPDATE books SET price = price + 100 WHERE id=1001;

--I want to increase the price of c programming subject books by rs 50;
UPDATE books SET price = price + 50 WHERE subject = 'C Programming';


--DELETE
--I want to delete book no 4003
DELETE FROM books WHERE id=4003;


--**DDL Queries
--TRUNCATE
/*
It will delete only data from the table
Table structure will remain as it is
It is working same as delete only where clause cannot be used with Truncate
*/
--I want to delete all rows from my table books.
TRUNCATE table books;

--DROP
--IT will delete entire table/database
--Entire Structure will be deleted
DROP TABLE books;

--DUAL
/*
It is a Virtual table
It consists of one row and one columns
It was given by Oracle
It was added in ANSI SQL
*/
SELECT 5+7 from DUAL;
SELECT 5+7;


--SQL FUNCTIONS
--Predefined functions taht can do some specific TASK

HELP FUNCTIONS;
--HELP <Function/Category name>

--String Functions.

--To convert string to lower case
SELECT LOWER("SunBEam");

--To convert string to Upper case
SELECT UPPER("SunBEam");

--To print n no of characters from left side
SELECT LEFT("SunBeam",3);

--To print n no of characters from right side
SELECT RIGHT("SunBeam",3); 

--  *SunBeam
SELECT LPAD("Sunbeam",8,'*');

--  SunBeam**
SELECT RPAD("Sunbeam",9,'*');

-- **SUNBEAM**
SELECT RPAD(LPAD("Sunbeam",9,'*'),11,'*'); -- **Sunbeam**

--To get substring from an entire string
SELECT SUBSTRING('SunBeam',3,4);
SELECT SUBSTRING('SunBeam',-5,4);

--To join two or more Strings
SELECT CONCAT("Rohan","Paramane");

--IF i want 1st letter of ename as caps and rest all letters as small.//Assignment

--To fetch length of String
SELECT LENGTH("Sunbeam  ");

--to remove blank spaces
SELECT TRIM("   SUNBEAM      ") as trim FROM DUAL;


--Numeric Functions

--To get exponential of a number
SELECT POWER(3,2);

SELECT PI();

SELECT SQRT(9); -- Will give squraroot of a number

--To get the rounded numbers up to specified digits
-- +ve 2nd argument will round up numbers after decimal value
-- -ve 2nd argument will round up numbers before decimal value
SELECT ROUND(123.567,2);
SELECT ROUND(123.567,-2);

--To round off to neareast Higher integer value
SELECT CEIL(123.56);
--To round off to neareast Lower integer value
SELECT FLOOR(123.56);


--**Flow Control Functions
--if(true){}else{}
SELECT ename,sal,IF(sal>2000,'RICH','POOR') as Status FROM emp;

--If my commision is null then print its salary
SELECT ename ,sal,comm, IFNULL(comm,0) FROM emp;

--IF salary is 3000 print it as null
SELECT ename , NULLIF(sal,3000) FROM emp;


SELECT USER(); -- This will give the current user working.
SELECT DATABASE(); -- This will give the current database in use
SELECT VERSION(); --IT will print the mysql version

/*Link for Accessing docs related to functions
https://dev.mysql.com/doc/refman/8.0/en/functions.html
*/

--DATE FUNCTIONS

--To print current Date and TIME
SELECT NOW();
SELECT SYSDATE();

--To fetch only date use date function
SELECT DATE(NOW());

--To fetch only Time use Time function
SELECT Time(NOW());


--To get help of date_add use query -> help date_add
--To add no of days,month,year
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 1 MONTH);
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);

--Look for DATE_DIFF  //Homework

SELECT DAY(NOW());
SELECT MONTH(NOW());
SELECT YEAR(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT WEEKDAY(NOW());



