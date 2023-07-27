--This will create databse with the given name
CREATE DATABASE sunbeam;

--This will delete the database
DROP DATABASE <database_name>

SHOW DATABASES;

--If i want to see on which database i am currently working on
SELECT database();

--If you want to use/go into the database then use the query
USE sunbeam;

--If you want to see the existing tables inside database then use the query
SHOW tables;

--create table <tablename> (col_name datatype, col_name datatype ....);
CREATE TABLE dbda_students(id int,name CHAR(10),marks float);

--To Check the Structure of our Table
--DESC tablename;
DESC dbda_students;

--If you want to see the data inside your table
SELECT * from dbda_students;

--Add/Insert the data inside your Table
INSERT INTO dbda_students VALUES(56910,"Pratik",90);
INSERT INTO dbda_students VALUES(56354,"Nikita",80),(56387,"Nirbhay",70);
INSERT INTO dbda_students(id,name,marks) VALUES(56572,"Nikhil",75);
INSERT INTO dbda_students(id,name) VALUES(34567,"Rohan");

--To clear screen in mysql shell
\! cls;