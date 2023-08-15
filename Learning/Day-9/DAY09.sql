/*
    *Agenda
        SUB-QUERY
        Views
*/

--Dispaly dname that emp
SELECT dname FROM dept WHERE deptno IN (SELECT deptno FROM emp);
ACCOUNTING -> 14 rows
RESEARCH -> 14 rows
SALES -> 14 rows
OPERATIONS -> 14 rows

SELECT dname FROM dept WHERE deptno IN (SELECT DISTINCT deptno FROM emp);
ACCOUNTING -> 3 rows
RESEARCH -> 3 rows
SALES -> 3 rows
OPERATIONS -> 3 rows

While writing subquery if we are able to optimize the inner query so that it can produce minimum no
of rows then it should be done by using some conditions
If we dont optimize our inner query then your subqueires will be slower than your joins
The conditions in your inner query can be given by using WHERE CLAUSE

**If the condition in the WHERE CLAUSE of inner query depends on the the current row of your outer
query then such type of subquery is called as CORELATED SUBQUERY. 


CORELATED SUBQUERY
--Dispaly dname from emp table
SELECT d.dname FROM dept d WHERE d.deptno IN(SELECT e.deptno FROM emp e WHERE e.deptno = d.deptno);
ACCOUNTING -> 3 rows
RESEARCH -> 5 rows
SALES -> 6 rows
OPERATIONS -> 0 rows

SELECT d.dname FROM dept d WHERE d.deptno IN(SELECT DISTINCT e.deptno FROM emp e WHERE e.deptno = d.deptno);
ACCOUNTING ->1 row
RESEARCH -> 1 row
SALES -> 1 row
OPERATIONS -> 0 row

SELECT d.dname FROM dept d WHERE EXISTS(SELECT DISTINCT e.deptno FROM emp e WHERE e.deptno = d.deptno);


SUBQUERY in PROJECTION,
IN subquery if innery query is written in projection part i.e(columns are selected)
then such type is called as subquery in projection.

--display deptno and the employees count in that dept
SELECT deptno,COUNT(empno) FROM emp GROUP BY deptno;

--display deptno and the employees count, Total no of emps.
SELECT deptno,COUNT(empno) Emps,(SELECT COUNT(*) FROM emp) TOTAL FROM emp GROUP BY deptno;

--dispaly dname and count of emp in that dept 
SELECT d.dname,(SELECT COUNT(*) FROM emp e WHERE e.deptno=d.deptno)emps  FROM dept d;

--dispaly dname,job, and count of emp in that dept
SELECT deptno ,JOB,COUNT(*) emps,(SELECT dname FROM dept WHERE deptno = emp.deptno)FROM emp GROUP BY deptno,job;


--**SUBQUERY in FROM CLAUSE from emp table
-- dispaly emp name and category as rich or poor (sal<2000 then poor 2000<sal<3000 middle sal>3000 as rich)
 SELECT ename,IF(sal<2000,"POOR","RICH") from emp;

SELECT ename,CASE
WHEN sal<2000 THEN "POOR"
WHEN sal>2000 THEN "RICH"
END AS category
FROM emp;

--category name as rich or poor and the count of emps in this category
SELECT category,COUNT(*) FROM
(SELECT ename,CASE
WHEN sal<2000 THEN "POOR"
WHEN sal>2000 THEN "RICH"
END AS category
FROM emp) emp_category
GROUP BY category;

If inner subquery is written in FROM CLAUSE then it outputs a table.
The table is called as Derived table.
This is also called as inline view.


using SUB-QUERY IN dml OPERATIONS
--insert an emp with dept as OPERATIONS
INSERT INTO emp(empno,ename,deptno) VALUES(1,"ROHAN",(SELECT deptno from dept WHERE dname="OPERATIONS"));

--update comm of emps to rs 100 where dept as OPERATIONS
UPDATE emp SET comm=100 WHERE deptno=(SELECT deptno from dept WHERE dname="OPERATIONS");

--delete all emps from dept OPERATIONS
DELETE FROM emp WHERE deptno = (SELECT deptno from dept WHERE dname="OPERATIONS");

--delete emp having max sal
DELETE FROM emp WHERE sal=(SELECT MAX(sal) FROM emp);
--FOR DML Operations using subquery we cannot perform all dml opertaions on same table
--if the inner query is selecting from the same table.
SET @sal = (SELECT MAX(sal) FROM emp);
DELETE FROM emp WHERE sal=@sal;

SUBQUERY
outer qurey -> inner query

inner query -> single row -> single row subquery
inner query -> multiple rows -> multiple row subquery
inner query -> have condition using where clause on current row of outer query -> CORELATED subquery

SUBQUERY query -> can be written in projection
SUBQUERY query -> can be written in FROM CLAUSE
SUBQUERY query -> can be used for DML OPERATIONS


Execution of Query depends on
1. Server Machine
2. Version
3. Configuration of the Machine
4. Amount of data
5. Optimizations performed

IF the query_cost is less then it means that your query is more efficient
IF the query_cost is more then it means that your query is less efficient

EXPLAIN FORMAT = JSON SELECT dname FROM dept WHERE deptno IN (SELECT deptno FROM emp);
query_cost=5.10 --Your query is more efficient

EXPLAIN FORMAT = JSON SELECT DISTINCT d.dname from dept d inner join emp e ON d.deptno = e.deptno;
query_cost = 6.50 --Your query is less efficient as compared to above query

EXPLAIN FORMAT = JSON SELECT d.dname FROM dept d WHERE EXISTS(SELECT DISTINCT e.deptno FROM emp e WHERE e.deptno = d.deptno);
query_cost=5.10

EXPLAIN FORMAT = JSON SELECT d.dname,(SELECT COUNT(*) FROM emp e WHERE e.deptno=d.deptno)emps  FROM dept d;
query_cost=0.65

EXPLAIN FORMAT = JSON SELECT category,COUNT(*) FROM
(SELECT ename,CASE
WHEN sal<2000 THEN "POOR"
WHEN sal>2000 THEN "RICH"
END AS category
FROM emp) emp_category
GROUP BY category;


--**VIEW
    This is just projection of Data.
    Output of view is not stored on server.
    The select query is stored in compiled format

-- dispaly emp name and category as rich or poor (sal<2000 then poor sal>3000 as rich)
SELECT ename,CASE 
WHEN sal<2000 THEN "POOR"
WHEN sal>2000 THEN "RICH"
END AS category
FROM emp;

--To create view
CREATE VIEW emp_category AS
SELECT ename,CASE
WHEN sal<2000 THEN "POOR"
WHEN sal>2000 THEN "RICH"
END AS category
FROM emp;

SHOW TABLES;
SELECT * FROM emp_category;
SHOW FULL TABLES; --It will show which are tables are which are views

--To delete the view you can use query as below
DROP VIEW view_name;

--dispaly category name and count of emps in that category.
EXPAIN FORMAT = JSON SELECT category,COUNT(*) FROM emp_category GROUP BY category;

SIMPLE VIEW
--To create a view on emp to fetch only empno,emp name and sal.
CREATE VIEW v_emp AS SELECT empno,ename,sal FROM emp;
I can Perform All DML Operation on SIMPLE View.

COMPLEX VIEW
--To create view on emp to fetch deptno,job and count of employees
CREATE VIEW v_empCount AS SELECT deptno,job,COUNT(*)CountOfEmps FROM emp GROUP BY deptno,job;
I cannot perform DML Operations On COMPLEX View.

INSERT INTO emp(empno,ename,sal,deptno,job) VALUES(1,"ROHAN",10000,40,"Cordinator");
SELECT * FROM v_emp;
SELECT * FROM v_empCount;

INSERT INTO v_emp(empno,ename,sal) VALUES(2,"RAHUL",11000);
INSERT INTO v_empCount(deptno,job,CountOfEmps) VALUES(40,"DEVELOPMENT",1);

