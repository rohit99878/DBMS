# Database Technologies -- NoSQL

## Agenda
* Mongo - Delete operation
* Mongo - Update/Upsert operation
* Mongo - Aggregation pipeline
* Mongo - Array operators

### Delete operation
* db.collection.remove({criteria});
* db.collection.deleteOne({criteria});
* db.collection.deleteMany({criteria});

```JS
use dbda;

show collections;

db.people.find();

db.people.find({address: 'Pune'});

db.people.deleteOne({address: 'Pune'});

db.people.find({address: 'Pune'});

db.people.find({ email: { $exists: true } });

db.people.deleteMany({ email: { $exists: true } });

db.people.deleteMany({});
// delete all documents

show collections;

db.people.find();

db.people.drop();
// drop the collection (and all docs in it)

show collections;
```

### Update operation
* db.collection.update({criteria}, {modified doc});
    * Overwrite new object data on the old object data.
* db.collection.updateOne({criteria}, {modifications});
* db.collection.updateMany({criteria}, {modifications});

```JS
db.contacts.insert({
    _id: 1,
    name: 'Nitin',
    email: 'nitin@sunbeaminfo.com',
    mobile: '9881208115'
});

db.contacts.insert({
    _id: 2,
    name: 'Prashant',
    email: 'prashant@sunbeaminfo.com',
    mobile: '9881208114'
});

db.contacts.insert({
    _id: 3,
    name: 'Nilesh',
    email: 'nilesh@sunbeaminfo.com',
    mobile: '9527331338'
});

db.contacts.insert({
    _id: 4,
    name: 'Amit',
    email: 'amit@sunbeaminfo.com'
});

db.contacts.insert({
    _id: 5,
    name: 'Pradnya',
    email: 'pradnya@sunbeaminfo.com'
});

db.contacts.find();

db.contacts.update({
    _id: 4
}, {
    email: 'amit.kulkarni@sunbeaminfo.com'
});

db.contacts.findOne({_id: 4});

db.contacts.findOne({ _id: 3 });

db.contacts.update({
    _id: 3 
}, {
    mobile: '919527331338'
});

db.contacts.findOne({ _id: 3 });

db.contacts.findOne({ _id: 1 });

// UPDATE contacts SET mobile = '919881208115' WHERE _id = 1;
db.contacts.update({
    _id: 1
}, {
    $set: {
        mobile: '919881208115'
    }
});

db.contacts.findOne({ _id: 1 });

db.contacts.updateOne({
    _id: 1
}, {
    $set: {
        mobile: '09881208115'
    }
});

db.contacts.findOne({ _id: 1 });

db.contacts.insert({
    _id: 7,
    name: 'James Bond',
    age: 35
})

db.contacts.update({
    _id: 7
}, {
   $inc: { age: +1 } 
});

db.contacts.findOne({ _id: 7 });

db.contacts.update({
    _id: 7
}, {
   $inc: { age: -1 } 
});

db.contacts.findOne({ _id: 7 });
```

* db.collection.update({criteria}, {update specs}, upsert=true/false, multi=true/false)
    * arg1: Criteria (like WHERE clause)
    * arg2: new object or the changes using $set, $inc, ...
    * arg3: upsert -- default = false
        * false: if no matching record is found, do not update it.
        * true: if no matching record is found, create a new record as per given criteria and update it. 
    * arg4: multi -- default = true
        * if true, modify all matching records.
        * if false, modify only one record.

```JS
db.contacts.update({
    _id: 8,
    name: 'Girish'
}, {
    $set : {
        email: 'girish@sunbeam.com',
        mobile: '1234567890'
    }
});
// if no record is found, do not modify

db.contacts.update({
    _id: 8,
    name: 'Girish'
}, {
    $set : {
        email: 'girish@sunbeam.com',
        mobile: '1234567890'
    }
},
true);
// if no record found, create new record and modify it.

db.contacts.findOne({ _id: 8 });

db.contacts.update({
    _id: 8
}, {
    $set : {
        age: 35      
    }
});

db.contacts.findOne({ _id: 8 });
```

### Aggregation Pipeline

```JS
// sort emp records on sal
db.emp.aggregate([
{
    $sort: { sal: +1 }
}
]);

// sort emps on deptno and job
db.emp.aggregate([
{
    $sort: { deptno: +1, job: +1 }
}
]);
```

```JS
// display name, job, sal of all emp
db.emp.aggregate([
{
    $project: {ename: 1, job: 1, sal: 1} 
}
]);

db.emp.aggregate([
{
    $project: {_id: 0, ename: 1, job: 1, sal: 1} 
}
]);
```

```JS
// find emp with highest sal.
    // stage1: sort by sal in desc order
    // stage2: limit 1 record
db.emp.aggregate([
{
    $sort: { sal: -1 }
},
{
    $limit: 1
}
]);

// find emp name and sal with second lowest sal.
    // stage1: sort by sal in asc order
    // stage2: skip 1
    // stage3: limit 1
    // stage4: projection
db.emp.aggregate([
{
    $sort: { sal: +1 }
},
{
    $skip: 1
},
{
    $limit: 1
},
{
    $project: { ename: 1, sal: 1 }
}
]);
```

```JS
db.emp.aggregate([
{
    $addFields: {
        cnt: 1
    }
}
]);

// SQL -- IFNULL(comm, 0) --> if comm is null, return 0; otherwise return comm.
// Mongo -- $ifNull: [ '$comm', 0 ] --> if comm field value is null, then 0; otherwise comm value.

db.emp.aggregate([
{
    $addFields: {
        commission: { $ifNull: [ '$comm', 0 ] }
    }
},
{
    $addFields: {
        income: { $add: [ '$sal', '$commission' ] }
    }
},
{
    $project: { ename: 1, sal: 1, income: 1 }
}
]);

db.emp.aggregate([
{
    $addFields: {
        income: { $add: [ '$sal', { $ifNull: [ '$comm', 0 ] } ] }
    }
},
{
    $project: { ename: 1, sal: 1, income: 1 }
}
]);
```

```JS
// display all emps with deptno=20
db.emp.aggregate([
{
    $match: { deptno: 20 }
}
]);

// display all emps whose name is of 4 letters.
db.emp.aggregate([
{
    $match: { 
        ename: { $regex: /^.{4}$/ } 
    }
}
]);

// display all managers in deptno 30.
db.emp.aggregate([
{
    $match: { 
        $and: [
            { deptno: 30 },
            { job: 'MANAGER' }
        ]
    }
}
]);
```

```JS
// SELECT deptno, SUM(sal) sumsal FROM emp GROUP BY deptno;
db.emp.aggregate([
{
    $group: {
        _id: '$deptno',
        sumsal: { $sum: '$sal' }
    }
}
]);

// SELECT job, SUM(sal) sumsal, AVG(sal) avgsal, MAX(sal) maxsal, MIN(sal) minsal FROM emp GROUP BY job;
db.emp.aggregate([
{
    $group: {
        _id: '$job',
        sumsal: { $sum: '$sal' },
        avgsal: { $avg: '$sal' },
        maxsal: { $max: '$sal' },
        minsal: { $min: '$sal' }
    }
}
]);

// SELECT deptno, job, COUNT(*) cnt FROM emp GROUP deptno, job;
db.emp.find({}, {deptno:1, job:1}).sort({deptno:1, job:1});

db.emp.aggregate([
{
    $addFields: { cnt: 1 }
},
{
    $group: {
        _id: [ '$deptno', '$job' ],
        count: { $sum: '$cnt' }
    }
} 
]);

// SELECT DISTINCT job FROM emp;
// SELECT job FROM emp GROUP BY job;
db.emp.aggregate([
{
    $group: {
        _id: '$job'
    }
}
]);
```

```JS
// display emp and dept in which he is working
//      $lookup
//          from --> name of collection to join
//          localField --> name of field in current collection
//          foreignField --> name of corresponding field in given 'from' collection 
//          as --> name of new field (join result)
db.emp.aggregate([
{
    $lookup: {
        from: 'dept',
        localField: 'deptno',
        foreignField: '_id',
        as: 'd'
    }
}
]);

// display depts and all emps in that dept.
db.dept.aggregate([
{
    $lookup: {
        from: 'emp',
        localField: '_id',
        foreignField: 'deptno',
        as: 'emplist'
    }
}
]);

// SELECT e.ename, d.dname FROM emp e LEFT JOIN dept e ON e.deptno = d.id;

db.emp.aggregate([
{
    $lookup: {
        from: 'dept',
        localField: 'deptno',
        foreignField: '_id',
        as: 'd'
    }
},
{
    $project: {
        _id: 0, ename: 1, 'd.dname': 1
    }
}
]);

// display name of emp along with his manager name.
// SELECT e.ename, m.ename FROM emp e LEFT JOIN emp m ON e.mgr = m._id;

db.emp.aggregate([
{
    $lookup: {
        from: 'emp',
        localField: 'mgr',
        foreignField: '_id',
        as: 'm'
    }
},
{
    $project: { _id:0, ename:1, 'm.ename': 1}
}
]);
```


```JS
show collections;

db.emp.aggregate([
{
    $project: { ename: 1, sal: 1, job: 1 }
},
{
    $out: 'temp'
}
]);

show collections;

db.temp.find();


db.dept.aggregate([
{
    $lookup: {
        from: 'emp',
        localField: '_id',
        foreignField: 'deptno',
        as: 'emplist'
    }
},
{
    $out: 'deptemp'
}
]);

show collections;

db.deptemp.find();

db.deptemp.find().count();
```

* SQL functions
    * Scalar functions (Single row fns)
    * Group functions (Multi-row fns)
    * Table functions 

```JS
db.deptemp.find();

db.deptemp.aggregate([
{
    $count: 'record_count'
}
]);

db.deptemp.aggregate([
{
    $unwind: '$emplist'
}
]);

db.deptemp.aggregate([
{
    $unwind: '$emplist'
},
{
    $count: 'record_count'
}
]);

db.deptemp.aggregate([
{
    $unwind: '$emplist'
},
{
    $project: { _id:0, dname:1, 'emplist.ename':1 }
}
]);

db.deptemp.aggregate([
{
    $unwind: '$emplist'
},
{
    $project: { _id:0, dname:1, 'emplist.ename':1 }
},
{
    $addFields: {
        ename: '$emplist.ename'
    }
},
{
    $project: { emplist: 0 }
}
]);
```

### Assignment
* Find total, avg, min and max income (sal + comm) for each dept.
* Find the job that has min avg sal.
    * [ {group & avg sal}, {sort asc of total sal}, { limit 1 } ]
* Display name of all emps and their managers if their manager is not working in their dept.

