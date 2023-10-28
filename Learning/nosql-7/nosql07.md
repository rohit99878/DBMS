# Database Technologies - NoSQL & DWH

## Agenda
* Cassandra Architecture
* Cassandra Examples

### Cassandra Query Language (CQL)

```CQL
DESCRIBE KEYSPACES;

CREATE KEYSPACE db1 WITH replication = { 'replication_factor': 1, 'class': 'SimpleStrategy' };
-- do not try on astra (new keyspace to be created using gui)

DESCRIBE KEYSPACE db1;

CREATE KEYSPACE db2 WITH replication = { 'replication_factor': 2 };
-- error: giving class is compulsory

USE db1;
```

```CQL
DESCRIBE TABLES;

CREATE TABLE student(
id INT PRIMARY KEY,
name TEXT,
marks DOUBLE
);

DESCRIBE TABLE student;

INSERT INTO student 
VALUES (1, 'Nilesh', 77.0);
-- error

INSERT INTO student(id, name, marks)
VALUES (1, 'Nilesh', 77.0);

INSERT INTO student(id, name, marks)
VALUES (2, 'Nitin', 87.30);

INSERT INTO student(id, name, marks)
VALUES (3, 'Pradnya', 86.90);

INSERT INTO student(id, name, marks)
VALUES (4, 'Girish', 98.09);

INSERT INTO student(id, name, marks)
VALUES (5, 'Suvruda', 98.09);

SELECT * FROM student;
```

```CQL
SELECT * FROM student WHERE id = 4;

SELECT * FROM student WHERE name = 'Nitin';
-- filering on non-indexed column raise error
-- performance is unpredictable

CREATE INDEX ON student(name);

SELECT * FROM student WHERE name = 'Nitin';

SELECT * FROM student WHERE marks > 85.0;
-- filering on non-indexed column raise error
-- performance is unpredictable

SELECT * FROM student WHERE marks > 85.0 ALLOW FILTERING;
-- ALLOW FILTERING enable filtering on non-indexed columns with unpredictable performance

DESCRIBE TABLE student;
-- observe table creation and index info

DROP INDEX student_name_idx;
```

```CQL
SELECT * FROM student;

UPDATE student
SET marks = 78.66
WHERE id = 1;

SELECT * FROM student;

DELETE FROM student
WHERE id = 2;

SELECT * FROM student;
```

* If deleting multiple records, it is equivalent to multiple write operations.
* Individual deletes are slower.
* It is advised to delete the whole partition or whole table for better performance (if feasible).

```CQL
TRUNCATE student;

SELECT * FROM student;

DESCRIBE TABLE student;

DROP TABLE student;

DESCRIBE TABLES;
```

```CQL
CREATE TABLE employee(
id INT,
name TEXT,
email SET<TEXT>,
PRIMARY KEY(id)
);

INSERT INTO employee(id, name, email)
VALUES (1, 'Nilesh', {'nilesh@sunbeaminfo.com', 'ghule.nilesh@gmail.com'});

INSERT INTO employee(id, name, email)
VALUES (2, 'Nitin', {'nitin@sunbeaminfo.com'});

ALTER TABLE employee
ADD dept LIST<TEXT>;

UPDATE employee
SET dept = ['ADMIN', 'HR']
WHERE id = 2;

SELECT * FROM employee;
```

```CQL
ALTER TABLE employee
ADD phone MAP<TEXT,TEXT>;

UPDATE employee
SET phone = { 'mobile': '9527331338', 'office': '24260308' }
WHERE id = 2;

SELECT * FROM employee;

UPDATE employee
SET phone = { 'mobile': '9822012345' }
WHERE id = 1;

SELECT * FROM employee;
```

### Cassandra Data Modeling
* YouTube video comments
    * Fields: comment_id, video_id, user_id, creation_time, text.
    * To read comments related to the video efficiently partition them by video id.
        ```CQL
        CREATE TABLE comments_by_video(
            comment_id UUID,
            video_id UUID,
            user_id UUID,
            creation_time TIMESTAMP,
            text TEXT,
            PRIMARY KEY((video_id), creation_time)
        ) WITH CLUSTERING ORDER BY (creation_time DESC);
        ```
    * To read comments related to the user efficiently partition them by user id.
        ```CQL
        CREATE TABLE comments_by_user(
            comment_id UUID,
            video_id UUID,
            user_id UUID,
            creation_time TIMESTAMP,
            text TEXT,
            PRIMARY KEY((user_id), creation_time)
        ) WITH CLUSTERING ORDER BY (creation_time DESC);
        ```

```CQL
CREATE TABLE jeans_by_brand(
id UUID,
brand TEXT,
size INT,
fit TEXT,
color TEXT,
PRIMARY KEY((brand), size, fit, color, id)
)WITH CLUSTERING ORDER BY(size DESC, fit ASC, color ASC);


INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Slim Fit', 'Black');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Regular Fit', 'Sky Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Lee', 38, 'Loose Fit', 'Light Grey');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Regular Fit', 'Navy Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Slim Fit', 'Light Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 38, 'Regular Fit', 'Dark Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Loose Fit', 'Dark Grey');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Slim Fit', 'Black');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Lee', 38, 'Slim Fit', 'Dark Blue');

SELECT * FROM jeans_by_brand;

TRUNCATE jeans_by_brand;

BEGIN BATCH

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Slim Fit', 'Black');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Regular Fit', 'Sky Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Lee', 38, 'Loose Fit', 'Light Grey');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Regular Fit', 'Navy Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Levi', 40, 'Slim Fit', 'Light Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 38, 'Regular Fit', 'Dark Blue');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Loose Fit', 'Dark Grey');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Spykar', 36, 'Slim Fit', 'Black');

INSERT INTO jeans_by_brand(id, brand, size, fit, color)
VALUES(uuid(), 'Lee', 38, 'Slim Fit', 'Dark Blue');

APPLY BATCH;

SELECT * FROM jeans_by_brand;
```

### Cassandra Reading/Reference
* Cassandra Data Modeling: 
    * https://youtu.be/_W5VvxzoS6w
    * https://www.baeldung.com/cassandra-keys
* Cassandra User Defined Data Types:
    * https://www.tutorialspoint.com/cassandra/cassandra_cql_user_defined_datatypes.htm

