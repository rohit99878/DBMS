# Database Technologies - NoSQL

## Agenda
* Array operators
* Indexes
* Geo-spatial indexes
* Capped Collection

### Mongo aggregation
* SQL: Single row functions
    * Java/Python: map()
    * Mongo: $project, $addFields, ...
* SQL: Multi row functions / Group functions
    * Java/Python: grouping -- collect()
    * Mongo: $group with accumulators
* SQL: Table functions
    * Java/Python: flatMap()
    * Mongo: $unwind
* SQL: WHERE clause / HAVING clause
    * Java/Python: filter()
    * Mongo: $match

### Array elements/operators

```JS
use dbda;

show collections;

db.students.insert({
	"_id": 1,
	"name": "Nilesh",
	"hobbies": ["Programming", "Teaching"],
	"academics": [
		{
			"std": "10th",
			"passing": 1998,
			"marks": 78.66
		},
		{
			"std": "12th",
			"passing": 2000,
			"marks": 77.00
		},
		{
			"std": "B.Sc.",
			"passing": 2004,
			"marks": 60.00
		},
		{
			"std": "M.Sc.",
			"passing": 2008,
			"marks": 59.20
		}
	]
});

db.students.insert({
	"_id": 2,
	"name": "Sameer",
	"hobbies": ["Programming"],
	"academics": [
		{
			"std": "10th",
			"passing": 1998,
			"marks": 98.00
		},
		{
			"std": "12th",
			"passing": 2000,
			"marks": 94.00
		},
		{
			"std": "B.E.",
			"passing": 2004,
			"marks": 75.00
		}
	]
});

db.students.insert({
	"_id": 3,
	"name": "Unknown",
	"hobbies": ["Music", "Sports", "Drawing"],
	"academics": [
		{
			"std": "10th",
			"passing": 2004,
			"marks": 65.00
		},
		{
			"std": "12th",
			"passing": 2006,
			"marks": 64.00
		},
		{
			"std": "B.A.",
			"passing": 2009,
			"marks": 60.00
		}
	]
});

db.students.find();
```

#### Array -- Query operators

```JS
// find all students which have hobbies as array.
db.students.find({
    hobbies: { $type: 4 }
});

db.students.find({
    hobbies: { $type: 'array' }
});

// find all students who have 2 hobbies
db.students.find({
    hobbies: { $size: 2 }
});

// find all students who like 'Programming'
db.students.find({
    hobbies: 'Programming'
});

db.students.find({
    hobbies: {
        $elemMatch: { $eq: 'Programming' }
    }
});
```

```JS
// find all students who passed 12th in year 2000.
db.students.find({
    academics: {
        $elemMatch: {
            $and: [
                { std: '12th' },
                { passing: 2000 }
            ]          
        }
    }
});

// find all students who scores less than 80% in 10th.
db.students.find({
    academics: {
        $elemMatch: {
            $and: [
                { std: '10th' },
                { marks: { $lt: 80.0 } }
            ]
        }
    }
});

// find all students who like Sports and Music
db.students.find({
    $and: [
        { hobbies: { $elemMatch: { $eq: 'Sports' } } },
        { hobbies: { $elemMatch: { $eq: 'Music' } } }
    ]
});

db.students.find({
    hobbies: { $all: [ 'Sports', 'Music' ] }
});
// $all --> $and

// find all students who like Teaching "or" Music.
db.students.find({
    $or: [
        { hobbies: { $elemMatch: { $eq: 'Teaching' } } },
        { hobbies: { $elemMatch: { $eq: 'Music' } } }
    ]
});


db.students.find({
    hobbies: { $in: [ 'Teaching', 'Music' ] }
});

// find all students who don't like Programming
db.students.find({
    hobbies: { $nin: [ 'Programming' ] }
});

// find all students who neither like Teaching nor like Music
db.students.find({
    hobbies: { $nin: [ 'Teaching', 'Music' ] }
});

// find all students who have more than one hobbies
db.students.find({
    $nor: [
        { hobbies: { $size: 0 } },
        { hobbies: { $size: 1 } }
    ]
});

// display student whose 0th hobby is Music
db.students.find({
    'hobbies.0': { $eq: 'Music' }
});

// display student whose 1st hobby is Sports
db.students.find({
    'hobbies.1': { $eq: 'Sports' }
});
```

####  Array -- Projection operators

```JS
// display names of students & their hobbies who don't like Teaching
db.students.find({
    $nor: [
        {
        hobbies: {
            $elemMatch: { $eq: 'Teaching' }
        }
        }
    ]
}, {
    _id: 0,
    name: 1,
    hobbies: 1
});

// $slice: [ start_index, num_of_elems ]

// display name and first hobby of each student
db.students.find({}, {
    name: 1,
    hobbies: { $slice: [0, 1] }
})

// display name and second hobby of each student
db.students.find({}, {
    name: 1,
    hobbies: { $slice: [1, 1] }
})

// display name, std and marks for each student
db.students.find({}, {
    _id: 0,
    name: 1,
    'academics.std': 1,
    'academics.marks': 1
});

// display first academics of each student where he/she got marks more than 70%.
db.students.find({
    academics: {
        $elemMatch: { marks: { $gt: 70 } }
    }
});

db.students.find({
    academics: {
        $elemMatch: { marks: { $gt: 70 } }
    }
}, {
    name: 1,
    'academics.$': 1
});
```
* https://docs.mongodb.com/manual/reference/operator/projection/positional/

#### Array - Update operators

```JS
// add Cooking hobby for Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: 'Cooking'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add Singing hobby for Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: 'Singing'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add Programming hobby for Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: 'Programming'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add Singing hobby for Nilesh -- do not allow duplicates
db.students.updateOne({
    name: 'Nilesh'
}, {
    $addToSet: {
        hobbies: 'Singing'
    }
});

db.students.findOne({
    name: 'Nilesh'
});


// add Reading hobby for Nilesh -- do not allow duplicates
db.students.updateOne({
    name: 'Nilesh'
}, {
    $addToSet: {
        hobbies: 'Reading'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// remove Singing hobby from Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $pull: {
        hobbies: 'Singing'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// remove Programming hobby from Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $pull: {
        hobbies: 'Programming'
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add multiple hobbies for Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $addToSet: {
        hobbies: {
            $each: ['Cooking', 'Reading', 'Programming', 'Music', 'Sports', 'Swimming']
        }
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add hobby Painting for Nilesh at 4th pos.
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: {
            $each: ['Painting'],
            $position: 4
        }
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add hobby Movie for Nilesh and sort all hobbies
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: {
            $each: [ 'Movies' ],
            $sort: 1
        }
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// keep only first 3 hobbies of Nilesh
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: {
            $each: [ ],
            $slice: 3
        }
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// add Programming, Teaching into Nilesh hobbies and keep last 3 hobbies
db.students.updateOne({
    name: 'Nilesh'
}, {
    $push: {
        hobbies: {
            $each: [ 'Programming', 'Teaching' ],
            $sort: 1,
            $slice: -3
        }
    }
});

db.students.findOne({
    name: 'Nilesh'
});

// change 0th hobby of Nilesh to Reading
db.students.updateOne({
    name: 'Nilesh'
}, {
    $set: {
        'hobbies.0': 'Reading'
    }
});

db.students.findOne({
    name: 'Nilesh'
});
```

### Indexes
* Indexes are used to speed-up searching.
* Mongo index types:
    * Simple, Unique, Composite
    * TTL
    * Geo-spatial
* Each mongo collection is indexed over _id field. This index is unique index.

```JS
db.emp.find({ job: 'ANALYST' });

db.emp.find({ job: 'ANALYST' }).explain(true);
// plan -- collection scan

// CREATE INDEX ix_job ON emp(job ASC);
db.emp.createIndex({job: 1});

db.emp.find({ job: 'ANALYST' });

db.emp.find({ job: 'ANALYST' }).explain(true);
// plan -- index scan

db.emp.getIndexes();
```

```JS
// CREATE INDEX ix_deptjob ON emp(deptno ASC, job ASC);
db.emp.createIndex({deptno:1, job:1});

db.emp.getIndexes();

// SELECT * FROM emp WHERE deptno = 20 AND job = 'CLERK';
db.emp.find({
    $and: [
        { deptno: 20 },
        { job: 'CLERK' }
    ]
});

db.emp.find({
    $and: [
        { deptno: 20 },
        { job: 'CLERK' }
    ]
}).explain(false);
```

```JS
// CREATE UNIQUE INDEX ix_name ON emp(ename);
db.emp.createIndex({ ename: 1 }, { unique: true });

db.emp.getIndexes();

db.emp.find({ ename: 'TURNER' });

db.emp.find({ ename: 'TURNER' }).explain(false);

db.emp.insert({ename: 'JAMES', sal: 1200, deptno: 20});
// error: cannot duplicate name due to unique index
```

```JS
// drop asc index on emp - job
db.emp.dropIndex({job: 1});

db.emp.getIndexes();
```

```JS
// TTL: Time To Live (expiration)
db.ttl.insert({_id:1, time: new Date(), msg: 'Message 1'});

db.ttl.insert({_id:2, time: new Date(), msg: 'Message 2'});

db.ttl.insert({_id:3, time: new Date(), msg: 'Message 3'});

db.ttl.insert({_id:4, time: new Date(), msg: 'Message 4'});

db.ttl.find();

db.ttl.createIndex({
    time: 1
}, {
    expireAfterSeconds: 300
});

db.ttl.insert({_id:5, time: new Date(), msg: 'Message 5'});

db.ttl.find();
```
* https://docs.mongodb.com/manual/tutorial/expire-data/

### Geo-spatial indexes
* "Geo" --> Location --> Long Lat.
* Geo locations are "traditionally" represented in longitude & latitude.
* Nowadays location info is used for various purposes
	* To mark some geo location (of a cab, of a building).
	* Driving directions (path -- set of points connected linearly).
	* Find nearby services (search locations/features/services within a radius)
	* To mark some region (rectangle or polygon).
* Geo information is stored as GeoJSON format (specification).
* Browser: geojson.io

* GeoJSON formats
	* type: Point, Line, Polygon
	* coordinates: 
		* Point: [long, lat]
		* Line: [ [long, lat], [long, lat], [long, lat], ... ]
		* Polygon: [ [ [long, lat], [long, lat], [long, lat], [long, lat], [long, lat], [long, lat] ] ]
			* Anti-clockwise coordinates
			* First and Last coordinates must be same

```
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              73.84479761123657,
              18.530255802879157
            ],
            [
              73.83906841278076,
              18.522992405106123
            ],
            [
              73.84677171707153,
              18.515403147338567
            ],
            [
              73.85717868804932,
              18.519574228807464
            ],
            [
              73.85737180709837,
              18.52773297700366
            ],
            [
              73.84479761123657,
              18.530255802879157
            ]
          ]
        ]
      }
    }
  ]
}
```

```JS
db.points.insert({
	name: 'p1',
	location: {
		type: 'Point',
		coordinates: [0.5, 0.5]
	}
});

db.points.insert({
	name: 'p2',
	location: {
		type: 'Point',
		coordinates: [0.75, 0.75]
	}
});

db.points.insert({
	name: 'p3',
	location: {
		type: 'Point',
		coordinates: [0.25, 0.25]
	}
});

db.points.insert({
	name: 'p4',
	location: {
		type: 'Point',
		coordinates: [1.5, 1.5]
	}
});

db.points.find();

db.points.find({
    location: {
        $geoWithin: {
            $geometry: {
                type: 'Polygon',
                coordinates: [
                    [
                        [0.0, 0.0], 
                        [1.0, 0.0], 
                        [1.0, 1.0], 
                        [0.0, 1.0], 
                        [0.0, 0.0]
                    ]
                ]
            }
        }
    }
});

```

* mongoimport -d dbda -c busstops "C:\Nilesh\sep21\DBDA\dbt\Nosql 04\busstops.json"

```JS
show collections;

db.busstops.find().count();

db.busstops.find({
    location: {
        $geoWithin: {
            $geometry: {
        "type": "Polygon",
        "coordinates": [
          [
            [
              73.86408805847168,
              18.490537323264995
            ],
            [
              73.86359453201293,
              18.488217414142486
            ],
            [
              73.87129783630371,
              18.488441266391888
            ],
            [
              73.86831521987915,
              18.491697266046987
            ],
            [
              73.86408805847168,
              18.490537323264995
            ]
          ]
        ]
      }
        }
    }
});
```


```JS
db.busstops.createIndex({ location: '2dsphere' });

db.busstops.find({
    location: {
        $geoNear: {
            $geometry: {
        "type": "Point",
        "coordinates": [
          73.85138511657715,
          18.510580843483456
        ]
      },
          $maxDistance: 300
        }
    }
});
```

### Capped Collection
* Collection with upper cap (limit).

```JS
db.createCollection('logs', {
    capped: true,
    size: 10240, // max size in bytes
    max: 10 // max num of docs
});

show collections;

db.logs.insert({_id: 1, time: new Date(), msg: 'Message 1'})

db.logs.insert({_id: 2, time: new Date(), msg: 'Message 2'})

db.logs.insert({_id: 3, time: new Date(), msg: 'Message 3'})

db.logs.insert({_id: 4, time: new Date(), msg: 'Message 4'})

db.logs.insert({_id: 5, time: new Date(), msg: 'Message 5'})

db.logs.insert({_id: 6, time: new Date(), msg: 'Message 6'})

db.logs.insert({_id: 7, time: new Date(), msg: 'Message 7'})

db.logs.insert({_id: 8, time: new Date(), msg: 'Message 8'})

db.logs.insert({_id: 9, time: new Date(), msg: 'Message 9'})

db.logs.insert({_id: 10, time: new Date(), msg: 'Message 10'})

db.logs.find();

db.logs.insert({_id: 11, time: new Date(), msg: 'Message 11'})

db.logs.find();

db.logs.insert({_id: 12, time: new Date(), msg: 'Message 12'})

db.logs.insert({_id: 13, time: new Date(), msg: 'Message 13'})

db.logs.insert({_id: 14, time: new Date(), msg: 'Message 14'})

db.logs.find();

db.logs.updateOne({
    _id: 5
}, {
    $set: { msg: 'Message A' }
});

db.logs.find();

db.logs.updateOne({
    _id: 6
}, {
    $set: { msg: 'Message ABC' }
});
// Error: Cannot update the record so that size is increased.

db.logs.deleteOne({
    _id: 10
});
// Error: Cannot delete the record

db.logs.drop();
```

### Assigment Solution

```JS
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
    $unwind: '$m'
},
{
    $addFields: {
        edeptno: '$deptno',
        mname: '$m.ename',
        mdeptno: '$m.deptno'
    }
},
{
    $project: {
        ename: 1,
        edeptno: 1,
        mname: 1,
        mdeptno: 1
    }
},
{
    $match: {
        $expr: { $ne: [ '$edeptno', '$mdeptno' ] }
    }
}
]);
```

### Assigments
* Display the an emp in each dept having sal < 1200.0 from "deptemp" collection.
* Create new "stud" collection and add fields like roll, std, name, and marks. Ensure that combination of roll and std is always unique. Hint: create composite unique index on roll and std.


