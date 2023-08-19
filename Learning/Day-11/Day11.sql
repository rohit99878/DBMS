/* AGENDA
    CONSTRAINT -> Foreign Key
    Alter
    Stored Procedure
*/

**Foreign Key.
--Depts.
CREATE TABLE depts(dno int Primary Key, dname CHAR(15));
INSERT INTO depts VALUES(10,"Administration");
INSERT INTO depts VALUES(20,"Quality Analysis");
INSERT INTO depts VALUES(30,"Development");

--Emps.
CREATE TABLE emps(
    eid int Primary key auto_increment,
    ename char(20),
    sal double,
    dno int,
    Foreign key(dno) references depts(dno)
);

INSERT INTO emps(ename,sal,dno) VALUES("Rohan",10000,10);
INSERT INTO emps(ename,sal,dno) VALUES("Ganesh",20000,20);
INSERT INTO emps(ename,sal,dno) VALUES("Girish",30000,30);


SELECT * FROM emps;
SELECT * FROM depts;

--INSERT INTO emps(ename,sal,dno) VALUES("Nilesh",40000,40); -- Not OK, Fk constraint fails
INSERT INTO emps(ename,sal) VALUES("Nilesh",40000); -- dno is going to be null

UPDATE emps SET dno=40 WHERE eid=5; --NOT ok FK constraint Fail

INSERT INTO depts VALUES(40,"OPERATIONS");

UPDATE emps SET dno=40 WHERE eid=5; --OK as dept 40 exists now.

DELETE FROM depts WHERE dno=20;--Not Ok FK constraint fails

DELETE from emps where dno=20;

DELETE FROM depts WHERE dno=20;--Ok


CREATE TABLE emps2(
    eid int Primary key auto_increment,
    ename char(20),
    sal double,
    dno int,
    Foreign key(dno) references depts(dno) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO emps2(ename,sal,dno) SELECT ename,sal,dno from emps;
drop table emps;

DELETE FROM depts WHERE dno=40;--Ok Had cascading effets on emps2
UPDATE depts SET dno=20 WHERE dno=30; --OK Had cascading effects on emps2

--To see all applied constraints we can use below query
SHOW CREATE TABLE table_name;

--If you want top give user defined names to the constraints you can do as below
CREATE TABLE emps3(
    eid int Primary key auto_increment,
    ename char(20),
    sal double,
    dno int,
    CONSTRAINT fk_emps3_dno Foreign key(dno) references depts(dno) ON DELETE CASCADE ON UPDATE CASCADE
);


--ALTER
To modify the table structure.

1. To add column
ALTER TABLE emps3 ADD job CHAR(20);

2. To modify col type
ALTER TABLE emps3 MODIFY job CHAR(15);

3. To CHANGE col name
ALTER TABLE emps3 CHANGE job jobs CHAR(15);

4.To Rename the table name
ALTER TABLE emps3 RENAME emps;

5.TO ADD CONSTRAINT to the column
ALTER TABLE emps ADD CONSTRAINT UNIQUE(ename);

6.TO delete the column
ALTER TABLE emps drop column jobs;

7. To delete the constraint
ALTER TABLE emps drop CONSTRAINT ename; --ename is the constraint name

8. To change auto_increment initial VALUE
ALTER TABLE emps auto_increment=100;


**SQL/PSM
    Persistant Stored Modules
    It was inspired from PL/SQL from Oracle
    It helps to write programs in froms of block in mysql.

Programs can be stored in mysql as
    Stored Procedure
    Triggers.

Stored Procedure
1. This does not return any value.
2. The result generated by the PSM can be printed on console.
3. The result generated by the PSM can be inserted in another table.
4. The result generated by the PSM can be taken out by OUT parameter..

To write a stored Procedure you need a .sql file

To execute that stored procedure you need to call that procedure
call procedure_name();

--Q1. Write stored procedure to print hello world on terminal(psm01)
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm01.sql
    call sp_hello();

CREATE TABLE result(id int,val VARCHAR(30));

--Q2. Write stored procedure to print hello world on terminal and insert in result table(psm02)
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm02.sql
    call sp_hello2();

--Q3. Write a procedure to calculate area of rectangle, take len and breadth from user4
    --Store the area in your result table. (psm03)
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm03.sql

--Q4. Write a procedure to calculate sum of even numbers in given range.
    --Store that result in your result table. (psm04)
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm04.sql
    call sp_even_sum(2,8);

--Q5. Write procedure to take a number and give the square of that number.(psm05)
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm05.sql

SELECT @res; --NULL
call sp_square(5,@res);
SELECT @res; --25

--Q5. Write procedure to take a number and give the square of that number.(psm06)
    --Using INOUT PARAMETER
    --SOURCE F:\Teaching\PG_Courses\DBDA\dbt\Day11\psm06.sql
SELECT @res1; --NULL
SET @res1 = 8;
SELECT @res1; --8
call sp_square2(@res1);
SELECT @res1; --64

