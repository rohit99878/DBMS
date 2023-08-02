/*
    **AGENDA
        JOINS
*/
--Imported file joins.sql
SELECT * FROM emps;
--SELECT * FROM depts;
SELECT * FROm addr;
SELECT * FROM meeting;
SELECT * FROM emp_meeting;

--Dispaly Deptname and emp name from respective tables(emps & depts)
1. CROSS JOIN
SELECT dname,ename FROM emps CROSS JOIN depts; -- COl names are different use this syntax
SELECT dname,ename FROM depts CROSS JOIN emps;
SELECT depts.deptno,dname,ename FROM depts CROSS JOIN emps; --If col names are same
SELECT d.deptno,dname,ename FROM depts AS d CROSS JOIN emps AS e; --You can use alias for the tables
SELECT d.deptno,dname,ename FROM depts d CROSS JOIN emps e; --Use of 'AS' Keyword is optional

2. INNER JOIN
--Dispaly Deptname and emp name from respective tables(emps & depts)
SELECT d.dname,e.ename FROM emps e INNER JOIN depts d ON e.deptno=d.deptno;
--This is call as equi-Join
SELECT d.dname,e.ename FROM emps e INNER JOIN depts d ON e.deptno>d.deptno;
--This is called as non-equi Join

3. LEFT JOIN
--Dispaly Deptname and emp name from respective tables(emps & depts)
SELECT d.dname,e.ename FROM depts d LEFT OUTER JOIN emps e ON e.deptno=d.deptno;
SELECT d.dname,e.ename FROM depts d LEFT JOIN emps e ON e.deptno=d.deptno;
SELECT d.dname,e.ename FROM emps e LEFT JOIN depts d ON e.deptno=d.deptno;

4.RIGHT JOIN
--Dispaly Deptname and emp name from respective tables(emps & depts)
SELECT d.dname,e.ename FROM depts d RIGHT OUTER JOIN emps e ON e.deptno=d.deptno;
SELECT d.dname,e.ename FROM depts d RIGHT JOIN emps e ON e.deptno=d.deptno;
SELECT d.dname,e.ename FROM emps e RIGHT JOIN depts d ON e.deptno=d.deptno;

5. FULL Outer JOIN
SET 
UNION
UNION ALL
-- display dname and ename using set operator
SELECT dname from depts
UNION ALL
SELECT ename from emps;

SELECT dname from depts
UNION
SELECT ename from emps;

SELECT d.dname,e.ename FROM depts d LEFT OUTER JOIN emps e ON e.deptno=d.deptno
UNION ALL
SELECT d.dname,e.ename FROM depts d RIGHT OUTER JOIN emps e ON e.deptno=d.deptno;

SELECT d.dname,e.ename FROM depts d LEFT OUTER JOIN emps e ON e.deptno=d.deptno
UNION
SELECT d.dname,e.ename FROM depts d RIGHT OUTER JOIN emps e ON e.deptno=d.deptno;

6. SELF JOIN
--Dispaly ename and Respective manager name
SELECT e.ename,m.ename FROM emps e INNER JOIN emps m ON e.mgr=m.empno;
SELECT e.ename,m.ename as Manager FROM emps e INNER JOIN emps m ON e.mgr=m.empno;
SELECT e.ename,m.ename as Manager FROM emps e LEFT JOIN emps m ON e.mgr=m.empno;


--**JOINS PRACTICE

--dispaly ename,dept name and district of that employee
SELECT e.ename,d.dname FROM emps e INNER JOIN depts d ON e.deptno=d.deptno;
SELECT e.ename,a.dist FROM emps e INNER JOIN addr a ON e.empno=a.empno;

SELECT e.ename,d.dname,a.dist FROM emps e 
INNER JOIN depts d ON e.deptno=d.deptno
INNER JOIN addr a ON e.empno=a.empno;

SELECT e.ename,d.dname,a.dist FROM emps e 
LEFT JOIN depts d ON e.deptno=d.deptno
INNER JOIN addr a ON e.empno=a.empno;

--dispaly emps names and their meeting topics.
SELECT e.ename,em.meetno FROM emp_meeting em INNER JOIN emps e ON em.empno = e.empno;

SELECT em.meetno,m.topic FROM emp_meeting em INNER JOIN meeting m ON em.meetno=m.meetno;

SELECT e.ename,m.topic FROM emp_meeting em
INNER JOIN emps e ON em.empno = e.empno
INNER JOIN meeting m ON em.meetno=m.meetno;

--dispaly emps names their meeting topics and their district
SELECT e.ename,m.topic,a.dist FROM emp_meeting em
INNER JOIN emps e ON em.empno = e.empno
INNER JOIN meeting m ON em.meetno=m.meetno
INNER JOIN addr a ON e.empno=a.empno;

--dispaly emps names their meeting topics and their dept name
SELECT e.ename,m.topic,d.dname FROM emp_meeting em
INNER JOIN emps e ON em.empno = e.empno
INNER JOIN meeting m ON em.meetno=m.meetno
LEFT JOIN depts d ON e.deptno=d.deptno;

-- print dept name and count of employees in that dept.
SELECT d.dname,COUNT(e.empno) FROM emps e
INNER JOIN depts d ON e.deptno=d.deptno
GROUP BY d.dname;

SELECT d.dname,COUNT(e.empno) FROM emps e
RIGHT JOIN depts d ON e.deptno=d.deptno
GROUP BY d.dname;

--dispaly emps and their meeting count in desc order of meeting count
SELECT e.ename,COUNT(em.meetno) FROM emps e
INNER JOIN emp_meeting em ON e.empno = em.empno
GROUP BY e.ename ORDER BY COUNT(em.meetno) DESC;

--dispaly all emps from 'DEV' Dept
SELECT e.ename , d.dname FROM emps e
INNER JOIN depts d ON e.deptno = d.deptno
WHERE d.dname = "DEV";