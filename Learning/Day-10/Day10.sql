/* AGENDA
    Index
    Constrains
*/

**Index

SELECT * FROM books;
SELECT * FROM BOOKS WHERE subject='C Programming';
EXPLAIN FORMAT = JSON SELECT * FROM BOOKS WHERE subject='C Programming';
--1.55

**SIMPLE INDEX
CREATE INDEX idx_book_subject ON books(subject);

SELECT * FROM BOOKS WHERE subject='C Programming';
EXPLAIN FORMAT = JSON SELECT * FROM BOOKS WHERE subject='C Programming';
--0.90

--To check indexes applied on the table use below query
SHOW INDEXES FROM books;

**UNIQUE INDEX
CREATE UNIQUE INDEX idx_emps_ename ON emps(ename);
INSERT INTO emps(empno,ename) VALUES(6,"Nilesh");
--ERROR 1062 (23000): Duplicate entry 'Nilesh' for key 'emps.idx_emps_ename'

**COMPOSITE INDEX
Creating index on two columns
CREATE INDEX idx_emp_empno_ename ON emp(empno,ename);
CREATE UNIQUE INDEX idx_emp_empno_ename ON emps(empno,ename);

--To drop index if you have created by mistake
drop index index_name ON table_name;

**Clustered Index
If your table have a primary key in that case a index is automatically created.
Such index is called as Clustered index.

 DESC books;
 SHOW INDEXES FROM books;

**Constraints
    If we want to apply some restrictions on columns of particular table then we should use Constraints.
    Some constaraints can be applied on column level as well as on table level

1. Primary key
    Values cannot be null
    Duplicate values not allowed

    1.a COMPOSITE Primary Key
        It is a primary key based on two columns
        Combination of these columns should be UNIQUE
    
    1.b SURROGATE Primary Key
        AUTO_INCREMENT

2. Foreign key
3. UNIQUE
    Duplicate Values not allowed
    Null values are allowed

4. Not Null
    Values cannot be null
    Duplicate values are allowed

5. CHECK

--create a table of employee with data as eid,ename,sal,comm,dept
CREATE TABLE employee (
    eid int Primary Key,
    ename char(15) UNIQUE,
    sal double NOT NULL,
    comm float,
    dept int 
);

CREATE TABLE employee1 (
    eid int,
    ename char(15),
    sal double NOT NULL,
    comm float,
    dept int,
    Primary Key(eid),
    UNIQUE(ename)
);


DESC employee;
SHOW INDEXES FROM employee;

INSERT INTO employee(eid,ename,sal) VALUES(1,"Rohan",10000); --OK
SELECT * FROM employee;

INSERT INTO employee(eid,ename) VALUES(2,"Ganesh"); --Not Ok bcoz sal cannot be null
INSERT INTO employee(eid,ename,sal) VALUES(2,"Ganesh",0);--OK

INSERT INTO employee(eid,ename,sal) VALUES(3,"Rohan",20000); --Not OK bcoz duplicate values not allowed for ename
INSERT INTO employee(eid,sal) VALUES(3,20000);--OK bcoz null values are allowed for ename

INSERT INTO employee(eid,ename,sal) VALUES(3,"Rahul",30000); --Not Ok bcoz Duplicate values not allowed for primary key
INSERT INTO employee(ename,sal) VALUES("Rahul",30000); --Not OK bcoz primary key cannot be null

INSERT INTO employee(eid,ename,sal) VALUES(4,"Rahul",30000); --OK

CREATE TABLE employee2 (
    eid int,
    ename char(15),
    sal double NOT NULL,
    comm float,
    dept int,
    Primary Key(eid,ename)
);

INSERT INTO employee2(eid,ename,sal) VALUES(1,"Rohan",10000);

CREATE TABLE employee3 (
    eid int UNIQUE AUTO_INCREMENT,
    ename char(15),
    sal double,
    comm float,
    dept int
);

INSERT INTO employee3(ename,sal) VALUES("Rohan",10000);
INSERT INTO employee3(ename,sal) VALUES("Rohan",10000);
INSERT INTO employee3(ename,sal) VALUES("Rohan",10000);

CREATE TABLE employee4 (
    eid int UNIQUE AUTO_INCREMENT,
    ename char(15),
    sal double, 
    comm float,
    dept int,
    CHECK (sal>5000)
);

INSERT INTO employee4(ename,sal) VALUES("Rohan",10000); --OK
INSERT INTO employee4(ename,sal) VALUES("Rahul",4000); --Not OK check constraint fail


CREATE TABLE employee5 (
    eid int,
    ename char(15),
    sal double, 
    comm float,
    dept int,
    Primary key (eid,ename)
);
CREATE UNIQUE INDEX idx_emp5_ename ON employee5(ename);