# Database Technologies -- NoSQL

## Agenda
* JSON
* Mongo Basics
    * Server Client
* Mongo Documents
* Mongo CRUD

### Getting Started
* On terminal start mongo shell.
    * cmd> mongo

```JS
show databases;

db

use dbda;

db

db.people.insert({'name': 'Nilesh', 'address': 'Katraj, Pune', 'age': 38});

show databases;

show collections;

db.people.insert({'name': 'Amit', 'address': 'Pune'});
db.people.insertOne({'name': 'Pradnya', 'address': 'Pune', 'email': 'pradnya@sunbeam.com'});

db.people.insertMany([
{
    name: 'Nitin',
    mobile: '9881208115',
    email: 'nitin@sunbeaminfo.com'
},
{
    name: 'Prashant',
    mobile: '9881208114',
    email: 'prashant@sunbeaminfo.com'
},
{
    name: 'Vishal',
    email: 'vishal@sunbeaminfo.com'
} 
]);
```

* In JSON (in JS), keys are string and values can be of any type. Keys must be enclosed in quotes.
* In Mongo JSON, keys are string and values can be of any type. However using quotes for keys are optional. If key contains space or special chars they only quotes are mandetory.
* JSON values
    * strings --> "..." or '...' (quotes are compulsory)
    * numbers --> 123, 3.145 (no quotes)
    * boolean --> true, false (no quotes)
    * null (no quotes)
    * array --> [ ... ]
    * object --> { ... }
* JS is case sensitive.
* Syntax of Mongo queries:
    * db.collection.method(arguments);
        * db --> keyword --> represents current database
        * collection --> name of the collection
            * If no collection with that name is present, a new collection will be auto created.
        * method --> function/operation on the collection
            * insert(), insertMany(), insertOne()
            * find(), findOne(), ...
            * remove(), deleteOne(), deleteMany(), ...

* All inserted records are stored into mongo data directory. Default location: C:\Program Files\MongoDB\Server\5.0\data.

```JS
db.people.find();

db.people.insertOne({ _id: 1, name: 'Girish', address: 'Pune' });

db.people.find();

db.people.insertOne({ _id: 1, name: 'Suvrunda', address: 'Pune' });
// ERROR: E11000 duplicate key error collection: dbda.people

db.people.insertOne({ _id: 2, name: 'Suvrunda', address: 'Pune' });

db.people.find();
```

### Run JS script to import the data
* Exit from mongo shell (if already logged in).
* cmd> mongo dbname /path/to/js/file
    * dbname = dbda
    * JS file = C:\Nilesh\sep21\DBDA\dbt\Nosql 02\empdept.js

    ```sh
    mongo dbda "C:\Nilesh\sep21\DBDA\dbt\Nosql 02\empdept.js"
    ```
* Login into mongo shell again
    * cmd> mongo

```JS
use dbda;

show collections;

db.dept.find();

db.emp.find();

db.emp.findOne();
```

### Mongo Cursor
* db.collection.find() --> returns cursor

```JS
db.emp.find();
// displays first 20 records

db.emp.find().count();

db.emp.find().pretty();

// SELECT * FROM emp LIMIT 3;
db.emp.find().limit(3);

// SELECT * FROM emp LIMIT 2,3;
db.emp.find().skip(2).limit(3);

db.emp.find().skip(2).limit(3).pretty();
```

```JS
// SELECT * FROM emp ORDER BY ename;
db.emp.find().sort({ ename: 1 });

// SELECT * FROM emp ORDER BY job DESC;
db.emp.find().sort({ job: -1 });

// SELECT * FROM emp ORDER BY deptno ASC, sal DESC;
db.emp.find().sort({ deptno: 1, sal: -1 });
```

```JS
// find emp with lowest sal
db.emp.find().sort({sal : 1}).limit(1);

// find top 3 emps (w.r.t sal)
db.emp.find().sort({sal : -1}).limit(3);
```

### Projection
* db.collection.find(criteria, projection);
    * arg1: criteria -- like WHERE clause -- if not given or empty criteria means select all.
    * arg2: *projection* -- like specify columns in SELECT -- if not given, get all columns

```JS
// SELECT ename, job, sal FROM emp;
db.emp.find({}, {ename: 1, job: 1, sal: 1});
// inclusion projection -- which fields to be included in projection

db.emp.find({}, {ename: true, job: true, sal: true});
// by default _id field is also displayed

db.emp.find({}, {hire: 0, job: 0, mgr: 0, comm: 0});
// exclusion projection -- which fields NOT to be included in projection

db.emp.find({}, {_id: 0, hire: 0, job: 0, mgr: 0, comm: 0});

db.emp.find({}, {ename:1, job:1, sal:1, comm:0, hire:0, mgr:0});
// Error: cannot mix inclusion and exclusion projection (except for _id).

db.emp.find({}, {_id:0, ename: 1, job: 1, sal: 1});
// _id (special field) can be excluded from inclusion projection
```

### Criteria
* Filtering records based on some condition.
* condition is given using reltional and logical operators.
    * Relational operators: $lt, $gt, $lte, $gte, $eq, $ne, $in, $nin, $type, $regex, $exists, ...
    * Logical operators: $and, $or, $nor
* db.collection.find(criteria, projection);
    * arg1: *criteria* -- like WHERE clause -- if not given or empty criteria means select all.
    * arg2: projection -- like specify columns in SELECT -- if not given, get all columns

```JS
// SELECT * FROM emp WHERE ename = 'KING';
db.emp.find({
    ename: 'KING'
});

// SELECT * FROM emp WHERE job = 'CLERK';
db.emp.find({
    job: 'CLERK'
});

db.emp.find({
    job: { $eq: 'CLERK' }
});

// SELECT * FROM emp WHERE sal < 1200.0;
db.emp.find({
    sal: { $lt: 1200.0 }
});

// SELECT * FROM emp WHERE deptno != 30;
db.emp.find({
    deptno: { $ne: 30 }
});

// SELECT * FROM emp WHERE job IN ('MANAGER', 'ANALYST');
db.emp.find({
    job: { $in: [ 'MANAGER', 'ANALYST' ] }
});

// Count number of emps doing jobs other than salesman and manager.
db.emp.find({
    job: { $nin: [ 'SALESMAN', 'MANAGER' ] }
}).count();

// find emp with lowsest sal in dept 20.
db.emp.find({
    deptno: 20
}).sort({sal: 1}).limit(1);

// display name of emp with highest sal in dept 10
db.emp.find({
    deptno: 10
}, {
    ename: 1, _id: 0
}).sort({
    sal: -1
}).limit(1);
```

```JS
// SELECT * FROM emp WHERE sal >= 900 AND sal <= 1000;
db.emp.find({
    sal: { $gte: 900.0, $lte: 1000.0 }
});

db.emp.find({
    $and: [
        { sal: { $gte: 900.0 } },
        { sal: { $lte: 1000.0 } }
    ]
});

// SELECT * FROM emp WHERE job = 'CLERK' AND deptno = 20;
db.emp.find({
    $and: [
        { job: 'CLERK' },
        { deptno: 20 }
    ]
});

// SELECT * FROM emp WHERE job='MANAGER' OR sal > 2800.0;
db.emp.find({
    $or: [
        { job: 'MANAGER' },
        { sal: { $gt: 2800.0 } }
    ]
});

// SELECT * FROM emp WHERE NOT (deptno = 30);
db.emp.find({
    $nor: [
        { deptno: 30 }
    ]
});
```

```JS
// display all emps which have comm field.
db.emp.find({
    comm: { $exists: true }
});

// display all emps where comm is null
db.emp.find({
    $and: [
        { comm: { $exists: true } },
        { comm: null }
    ]
});

db.emp.find({
    comm: { $type: 10 }
});

db.emp.find({
    comm: { $type: 'null' }
});

// display all emps who get some comm.
db.emp.find({
    comm: { $gt: 0 }
});
```

### Regex
* Used for data searching based on some pattern.
* Available in all tech/languages like bash shell, python, Java, RDBMS, NoSQL, ...
* The regex patterns are made up of special chars called as wild-card chars.
    * $ -- ending with
    * ^ -- starting with
    * . -- any single char
    * [] -- char set (e.g. [a-z])
    * * -- 0 or more occurrences of prev char
    * ? -- 0 or 1 occurrence of prev char
    * + -- 1 or more occurrences of prev char
    * {,n} -- max n occurrences of prev char
    * {m,} -- min m occurrences of prev char 
    * {m,n} -- min m and max n occurrences of prev char
    * () -- group of chars
    * \ -- to nullify effect of wildcard chars

```JS
// find all emp names which ends with R.
db.emp.find({
    ename: { $regex: /R$/ }
}, {
    ename: 1, _id: 0
});

// find all emp names whose name contains A.
db.emp.find({
    ename: { $regex: /A/ }
}, {
    ename: 1, _id: 0
});

// find all emp names whose name contains A more than once.
// SELECT * FROM emp WHERE ename LIKE '%A%A%';
db.emp.find({
    ename: { $regex: /.*A.*A.*/ }
}, {
    ename: 1, _id: 0
});

// find emp with name "Ford"
db.emp.find({
    ename: 'Ford'
});
// do not display any result -- string comparision is case sensitive

db.emp.find({
    ename: { $regex: /Ford/i }
});
// /.../i is case-insensitive comparision

```









