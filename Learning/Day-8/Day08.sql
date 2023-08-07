/*
    **Agenda
        Transaction
            Savepoint
            ROW LOCKING
            Table Locking
        SUB-Query
*/

--Transactions
--SAVEPOINT;

USE classwork;
SELECT * FROM emps;

START TRANSACTION;
INSERT INTO emps(empno,ename) VALUES (6,'Rohan');
SELECT * FROM emps;
SAVEPOINT sp1;
UPDATE emps SET deptno=10 WHERE empno = 6;
SELECT * FROM emps;
SAVEPOINT sp2;
UPDATE emps SET mgr=4 WHERE empno = 6;
SELECT * FROM emps;
ROLLBACK TO sp2;

COMMIT OR ROLLBACK; -- Depending on what you want to do with transaction

--**ROW LOCKING
OPTTIMISTIC LOCKING
1. When in an transaction you perform any DML Operation on any row then that row gets locked
    for all the users.
2. If any user want to Perform any DML operations on same row he will go in wait state.
3. IF the Transaction is not commited and is taking time the user will get "Lock wait timeout exceeded" message
4. Except that locked row other user can do all DML OPerations on remaning rows.
5. The locking and unlocking of that that is been done by mysql automatically is called as OPTTIMISTIC LOCKING

PESSIMISTIC LOCKING
1. If Locking of row is done by the user then such type of row locking is called as PESSISMETIC LOCKING.

--TABLE LOCK;
In MYSQL if Table is not indexed then the entire table is been locked during Transaction.
IF the table is indexed (eg- Primary key is present) in that case only the row is locked. 

root> DESC BOOKS; --Primary key is their
root> DESC EMP; -- Primary key is not their
root>START TRANSACTION;
root>UPDATE emp SET comm=300 WHERE empno=7566;
mgr>UPDATE emp SET comm=500 WHERE empno=7566; --You will go in Lock state
mgr>UPDATE emp SET comm=500 WHERE empno=7499; -- You will go in Lock state (Table is Locked)
--Reason is EMP table is not indexed
root>ROLLBACK;

root>START TRANSACTION;
root>UPDATE books SET price=300 WHERE id=1001;
mgr>UPDATE books SET price=350 WHERE id=1001; --You will go in Lock state(Row is Locked)
mgr>UPDATE books SET price=350 WHERE id=1002; -- It will be Executed  (Table is not locked as the books table is indexed on col id)
root> COMMIT;
SELECT * FROM books;

--**SUBQUERY
--IT is a Query inside another Query
--This type the inner query gives the result and the outer query gets executed for that result.
--Output of your inner query is given as input to your Outer query.

1.Single Row SubQuery.
    The inner query return only one row.
    The result is used with relational operators.

--Display emps with max/highest salary.
SELECT * FROM emp ORDER BY sal DESC LIMIT 1; --Partial result
SELECT * FROM emp WHERE sal= MAX(sal); -- Group func cannot be used with WHERE.

SET @sal = (SELECT MAX(sal) FROM emp);
SELECT * FROM emp WHERE sal=@sal;

SELECT * FROM emp WHERE sal = (SELECT MAX(sal) FROM emp);


--Display emps with second highest salary.
SELECT * FROM emp ORDER BY sal DESC LIMIT 1,2; -- Partial Complete

SET @sal=(SELECT DISTINCT sal FROM emp ORDER BY sal DESC LIMIT 1,1);
SELECT * FROM emp WHERE sal=@sal;

SELECT * FROM emp WHERE sal=(SELECT DISTINCT sal FROM emp ORDER BY sal DESC LIMIT 1,1);

--Display emps with 3st highest salary
SELECT * FROM emp WHERE sal=(SELECT DISTINCT sal FROM emp ORDER BY sal DESC LIMIT 2,1);


Multi Row SubQuery
    In this type your sub query returns multiple rows.
    The output of subquery is compared by using IN,ALL and ANY 
    ALL and ANY can be used only with SUB-Query
    ALL and ANY must be used with relational Operators
    ALL Works as Logical AND
    ANY Works as Logical OR

--Dispaly emps having sal greater than all salesman
SELECT sal FROM emp WHERE job='SALESMAN';
--SELECT MAX(sal) FROM emp WHERE job='SALESMAN';
--SELECT * FROM emp WHERE sal > ANY(SELECT sal FROM emp WHERE job='SALESMAN'); Logical OR
SELECT * FROM emp WHERE sal > ALL(SELECT sal FROM emp WHERE job='SALESMAN'); --Logical AND

--Display emps having sal less than any of the emp from dept 20.
SELECT * FROM emp WHERE sal < ANY(SELECT sal FROM emp WHERE deptno=20); 

--Display dname which have employees.
--SELECT DISTINCT d.dname FROM emp e INNER JOIN dept d ON e.deptno=d.deptno;
--Dname -> dept  Where-> deptno  deptno->emp
SELECT DISTINCT deptno FROM emp;
SELECT dname FROM dept WHERE deptno IN (SELECT DISTINCT deptno FROM emp);

--Display dname which have no employees.
SELECT dname FROM dept WHERE deptno NOT IN (SELECT DISTINCT deptno FROM emp);
SELECT dname FROM dept WHERE deptno != ALL (SELECT DISTINCT deptno FROM emp);
--SELECT dname FROM dept WHERE deptno != ANY (SELECT DISTINCT deptno FROM emp);//Incorrect

