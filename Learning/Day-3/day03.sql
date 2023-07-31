/*
        *Agenda
            DQL 
                Limit
                Order by
                Where Clause
                    Operators-> Relational,Logical,NUll
            DML
                UPDATE
                DELETE
*/

--DQL Queries

--*LIMIT
--It is used to fetch only limited amount of data/rows in output

--display only first 5 employees
SELECT * FROM emp LIMIT 5;

--display only first 10 employees
SELECT * FROM emp LIMIT 10;

--display 3 employes Skipping first 5emp.
SELECT * FROM emp LIMIT 8;
SELECT * FROM emp LIMIT 5;

--ORDER BY
/*
If i want my data to be in sorted manner in Ascending or Descending order
we must use ORDER BY.
Deafult Sorting Order is Ascending
*/

--Display all emps in their name in alphabetical order
SELECT * FROM emp ORDER BY ename ASC; --ASC -> Ascending

--Display all emps according to their highest salary first
--SORT all emps based on their salarys in desc order
SELECT * FROM emp ORDER BY sal DESC; --DESC -> Descending

--Display all emps according to their lowest salary first
SELECT * FROM emp ORDER BY sal;

--Sort employees based on job Asc and their sal in desc.
--In every job category sort the salarys in desc order.
SELECT * FROM emp ORDER BY job , sal DESC;

--I want to dispaly top 3 salaried employees
SELECT * FROM emp ORDER BY sal DESC;
SELECT * FROM emp ORDER BY sal DESC LIMIT 3;

--I want to dispaly lowest 3 salaried employees
SELECT * FROM emp ORDER BY sal LIMIT 3;

--dispaly only 2nd lowest salary person
SELECT * FROM emp ORDER BY sal;
SELECT * FROM emp ORDER BY sal LIMIT 1,1;

--Dispaly all emps sorted based on their DA
SELECT empno,ename,sal,sal*0.5 FROM emp;
SELECT empno,ename,sal,sal*0.5 FROM emp ORDER BY sal*0.5;
SELECT empno,ename,sal,sal*0.5 FROM emp ORDER BY 4;


--** WHERE CLAUSE
/*
When you require to give some condition for fetching the result you must use where clause
*/
--Display all emps from 20 dept only
SELECT * FROM emp WHERE deptno = 20;

--Disply the emp details of empno=7839;
SELECT * FROM emp WHERE empno = 7839;

--Dispaly all emps having sal more than 2000
SELECT * FROM emp WHERE sal > 2000;

--Display all emps having job as analyst.
SELECT * FROM emp WHERE job="Analyst";

--Display all emp having salary in between 1000 and 3000 including both ranges.
SELECT * FROM emp WHERE sal>=1000 AND sal<=3000;
SELECT * FROM emp WHERE sal BETWEEN 1000 AND 3000;

--Dispaly all emp having salary greter than 1500 and they are from dept 20;
SELECT * FROM emp WHERE sal>=1500 AND deptno=20;

--Display the emps who work as CLERK or who work as SALSEMAN
SELECT * FROM emp WHERE job="Clerk" OR job="SALESMAN";
SELECT * FROM emp WHERE job IN ("Clerk","SALESMAN");


--Dispaly all emps except emps from dept 30.
SELECT * FROM emp WHERE deptno!=30;
SELECT * FROM emp WHERE deptno<>30;
SELECT * FROM emp WHERE NOT deptno=30;

--Display all emps having commision as null;
SELECT * FROM emp Where comm=NULL; --error
SELECT * FROM emp Where comm IS NULL; 

--Display all emps having not null commision;
SELECT * FROM emp WHERE NOT comm IS NULL;
SELECT * FROM emp WHERE comm IS NOT NULL; 

--Display emps whose names>A till names<J
SELECT * FROM emp WHERE ename>"A" and ename<="J"; --It is goint to reject names starting from "JA"

--Dispaly emps with hire date greater than 1982
SELECT * FROM emp WHERE hire>"1982-01-01";


--LIKE OPERATOR
/*
IT is being used for string data
It is used for searching
WILDCARD Characters
% -> To search for any no of occurances
_ -> To Search only single occurance
*/

--Dispaly all emps starting with letter M
SELECT * FROM emp WHERE ename LIKE "M%";

--Diplay all emps ending in H
SELECT * FROM emp WHERE ename LIKE "%H";

--Dispaly all emps having letter A somewhere in the name;
SELECT * FROM emp WHERE ename LIKE "%A%";

--Dispaly all emps having letter A twice somewhere in the name;
SELECT * FROM emp WHERE ename LIKE "%A%A%";

--Display all emps having 4 characters in their name
SELECT * FROM emp WHERE ename LIKE "____";
SELECT * FROM emp WHERE ename LIKE "_____";

--Display all emps having 3rd character as R
SELECT * FROM emp WHERE ename LIKE "__R_"; -- It will return names with exact 4 characters
SELECT * FROM emp WHERE ename LIKE "__R%"; --It will retrun names withy n no of characters

--display emp who have highest salary in between 1000 and 3000
SELECT * FROM emp WHERE sal BETWEEN 1000 and 3000;
SELECT * FROM emp WHERE sal BETWEEN 1000 and 3000 ORDER BY sal DESC;
SELECT * FROM emp WHERE sal BETWEEN 1000 and 3000 ORDER BY sal DESC LIMIT 1;

--dispaly emps from dept 20 and 30  who have 5th highest salary.
SELECT * FROM emp WHERE deptno IN(20,30);
SELECT * FROM emp WHERE deptno IN(20,30) ORDER BY sal DESC;
SELECT * FROM emp WHERE deptno IN(20,30) ORDER BY sal DESC LIMIT 4,1;










