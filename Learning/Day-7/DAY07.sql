/*
    Agenda
        Non Standard Joins
        Security
        Transactions
*/


--**Non Standard Joins
--Display dname and emp name from respective Tables.
SELECT d.dname,e.ename from emps e JOIN depts d;

SELECT d.dname,e.ename from emps e JOIN depts d ON e.deptno = d.deptno;

SELECT d.dname,e.ename from emps e CROSS JOIN depts d WHERE e.deptno=d.deptno;

SELECT d.dname,e.ename from emps e,depts d WHERE e.deptno=d.deptno;
--Old Style Join

SELECT d.dname,e.ename from emps e JOIN depts d USING(deptno);
--It is going to map col names in both tables
--It is always a type of eqi-join

--Natural Join
--Display dname and emp name from respective Tables.
SELECT d.dname,e.ename FROM emps e NATURAL JOIN depts d;
--It is internally executed as Inner Join.
--Botn the tables should have comman column with same name

--**Security
    Permissions -> Privileges

1. SYSTEM Permissions
mysql -u root -p
--Database Administrator is the responsible Person to use this root user.
--CREATE,ALTER,DROP

2. Object Privilege
--It is been given to diffent users.
--TABLE,VIEWS,Triggers,Functions

PROMPT \u>
root>SELECT user FROM mysql.user;

root>CREATE USER 'dev1'@'localhost' IDENTIFIED BY 'dev1';

root>SELECT user FROM mysql.user;

root>CREATE USER 'dev2'@'localhost' IDENTIFIED BY 'dev2';

root>CREATE USER 'teamlead'@'localhost' IDENTIFIED BY 'teamlead';

root>SELECT user,host FROM mysql.user;

root>CREATE USER 'mgr' IDENTIFIED BY 'mgr';

--OPEN another CMD
mysql -u mgr -p --press enter
mysql>SELECT USER();
mysql> PROMPT \u>
mgr>

root>SHOW DATABASES;
mgr>SHOW DATABASES;
mgr>SHOW GRANTS;  --USAGE --no permissions

root>GRANT ALL ON classwork.* TO 'mgr';
root> FLUSH PRIVILEGES;

mgr>SHOW DATABASES; --You will be able to see classwork database
mgr>SHOW GRANTS;
mgr>USE classwork;
mgr>SHOW TABLES;
mgr>SELECT * FROM emps;

root>GRANT ALL ON classwork.* TO 'mgr' WITH GRANT OPTION;
root>FLUSH PRIVILEGES;

mgr>SHOW GRANTS;

mgr>USE classwork;
mgr>GRANT ALL ON classwork.emps TO 'teamlead'@'localhost';
mgr>GRANT ALL ON classwork.depts TO 'teamlead'@'localhost';


teamlead> SHOW DATABASES;
teamlead> USE classwork;
teamlead> SHOW TABLES;
teamlead> SELECT * FROM emps;

mgr>GRANT SELECT ON classwork.emps TO 'dev1'@'localhost';
dev1> SHOW DATABSES;
dev1> USE CLASSWORK;
dev1> SHOW TABLES;
dev1> SELECT * FROM emps;
dev1>--We Tried to insert and delete but we got error saying Permission denied.

root> DROP USER 'dev2'@'localhost';
mgr>GRANT INSERT ON classwork.emps TO 'dev1'@'localhost';
dev1>--We tried to insert and it was successful
mgr>REVOKE INSERT ON classwork.emps FROM 'dev1'@'localhost';
dev1>--We Tried to insert but we got error saying Permission denied.


--TRANSACTIONS
    START TRANSACTION;
    COMMIT;

    START TRANSACTION;
    ROLLBACK;
    COMMIT;

START TRANSACTION -> It will begin your transaction and all changes in record will be stored in temp table.
COMMIT -> It will finalize the records that are updated. From temp table to orignal table the data will be updated
ROLLBACK-> Changes done inside the Transaction will be discarded.
        -> Once commited we cannot go back. It should be done before Commit.

RDBMS TRANSACTION ACID Properties
A-Automicity -> 
    Transaction can be successful/fail.
    Partial Transactions are not stored in RDBMS.
C-Consistency -> 
    After Commit then and only then the updated record will be vicible to all users.
I-Isolation ->
    Every Transaction is Isolated from other Transactions.
D-Durability ->
    After the Completion of Transaction the updated data will be stored on the server.


