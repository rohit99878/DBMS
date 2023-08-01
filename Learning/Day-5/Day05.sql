/*
        **AGENDA
        GROUP Functions
        Group BY Clause
        Having Clause
        Joins
*/
--Single Row Functions
--It is going to work on each row and process the result for each row
--n input rows -> n output rows

--GROUP Functions
--n input rows -> 1 output row

SUM(),AVG(),COUNT(),MAX(),MIN()

--Display sum of all salaries from emp table
SELECT SUM(sal) FROM emp;
SELECT AVG(sal) FROM emp;

--Display max sal of the employee
SELECT MAX(sal) FROM emp;
--Display min sal of the employee
SELECT MIN(sal) FROM emp;

--Display Count of Employees
SELECT COUNT(empno) FROM emp;

/*
To set sql_mode permanently.
step 1: Run Notepad -- "Run as Administrator".
step 2: Open my.ini from C:\ProgramData\MySQL\MySQL Server 8.0.
step 3: Under [mysqld] change sql_mode.
sql-mode=ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION
step 4: Restart MySQL server (or restart computer).
*/

/* Limitations of Group Functions
SELECT ename,MAX(sal) FROM emp; // Cannot use no aggreted column
SELECT LOWER(ename),MAX(sal) FROM emp; //Single row funs cannot be used with grp funs
SELECT ename,sal FROM emp WHERE sal=MAX(sal); //Grp func cannot be used inside Where clause

*/

--**GROUP BY Clause
--Disaply MAX salary department wise
/*
10 -> 5000
20 -> 3000
30 -> 2850
*/
SELECT deptno,MAX(sal) FROM emp GROUP BY deptno;

--Display count of emps from each job.
SELECT job,COUNT(empno) FROM emp GROUP BY job;

--Dispaly count of emps in each dept job wise;
SELECT deptno,job,COUNT(empno) FROM emp GROUP BY deptno,job;


--Disaply MAX salary department wise sorted by deptno
SELECT deptno,MAX(sal) FROM emp GROUP BY deptno ORDER BY deptno;

--Dispaly count of emps in each dept job wise sorted by deptno;
SELECT deptno,job,COUNT(empno) FROM emp GROUP BY deptno,job ORDER BY deptno;


--**Having Clause

--Dispaly count of emps deptwise except dept 30 
SELECT deptno,COUNT(empno) FROM emp GROUP BY deptno HAVING deptno!=30;

--Display Max sal of emps deptwise from dept 10,20
SELECT deptno,MAX(sal) FROM emp GROUP BY deptno HAVING deptno IN(10,20);
--This is less efficient as compared to where clause
SELECT deptno,MAX(sal) FROM emp WHERE deptno IN(10,20) GROUP BY deptno;
--This is a bit efficient

--Display all those depts having max(sal) >= 3000
SELECT deptno,MAX(sal) FROM emp GROUP BY deptno;
SELECT deptno,MAX(sal) FROM emp GROUP BY deptno HAVING MAX(sal)>=3000;

/* **DIFF Between Where and Having Clause
Where Clause cannot be used with Group Functions
Where clause can be used with Groub By Clause
In general with Group By Clause Having Clause Should be used
Where Clasue is bit efficient then Having Clause
IF the condition is based on group Function you must compulsary use Having Clause
*/

--Dispaly depts whose COUNT employees is > 2;
SELECT deptno,COUNT(empno) FROM emp GROUP BY deptno HAVING COUNT(empno)>2;

--Display job having highest avg(sal)
SELECT job,Avg(sal) FROM emp GROUP BY job;
SELECT job,Avg(sal) FROM emp GROUP BY job ORDER BY AVG(sal) DESC;
SELECT job,Avg(sal) FROM emp GROUP BY job ORDER BY AVG(sal) DESC LIMIT 1;


--Joins
Imported joins.sql in your Classwork database.
SELECT * FROM emps;
SELECT * FROM depts;
SELECT * FROM meeting;

