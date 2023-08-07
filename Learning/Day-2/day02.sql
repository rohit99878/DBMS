--Difference Between Char, varchar and text
CREATE TABLE demo(c1 char(4),c2 varchar(4),c3 text(4));
INSERT INTO demo VALUES("abcd","abcd","abcde");
SELECT * from demo;

INSERT INTO demo VALUES("pqrst","pqrs","pqrs"); --ERROR:Data too long for column 'c1' at row 1
INSERT INTO demo VALUES("pqrs","pqrst","pqrs");--ERROR:Data too long for column 'c2' at row 1
INSERT INTO demo VALUES("xy","xy","xy");

--To import the SQL script first create your database;
CREATE DATABASE classwork;
use classwork;

--SOURCE <file path.sql>
SOURCE F:\Teaching\PG_Courses\DBDA\dbt\db\classwork-db.sql

--Check all data present inside table dept
SELECT * from dept;

--Check all data present inside table emp
SELECT * from emp;

--I want to select only empno,ename,sal from emp;
SELECT empno,ename,sal from emp;

--I want to calculate DA on my salary and show it in the output DA(sal*0.5)
SELECT empno,ename,sal,sal*0.5 from emp;

--I want to calculate Total sal from my sal and DA and show it in the output.
SELECT empno,ename,sal,sal*0.5,sal+sal*0.5 from emp;

--If you want to give a name to a computed column use alais
SELECT empno,ename,sal*0.5 as DA,sal,sal+sal*0.5 as Total_salary from emp;
SELECT empno,ename,sal*0.5 DA,sal,sal+sal*0.5  Total_salary from emp;

--I want employee no,name and his deptno from employee table.
SELECT empno,ename,deptno from emp;

--I want to show emp details along with the dept names if 10-"Accounting" 20-"Development" n-"UNKNOWN"
SELECT empno,ename,deptno,CASE
WHEN deptno=10 THEN "ACCOUNTING"
WHEN deptno=20 THEN "DEVELOPMENT"
ELSE "OTHER"
END as deptname from emp;

--Give me unique jobs and deptno from employee table;
    SELECT job,deptno from emp;
    SELECT DISTINCT deptno from emp;
    SELECT DISTINCT job from emp;
    SELECT DISTINCT deptno,job from emp;

