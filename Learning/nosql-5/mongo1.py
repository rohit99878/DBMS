
from pymongo import MongoClient

# create mongo connection
client = MongoClient('mongodb://localhost:27017')

# get the required database
db = client['dbda']

# get the required collection
emp = db['emp']

# call find() on collection with required criteria
cr = { 'job': 'MANAGER' }
cursor = emp.find(cr)

# access docs one by one from the cursor
for e in cursor:
    print(int(e['_id']), ', ', e['ename'], ', ', e['job'], ', ', e['sal'], ', ', int(e['deptno']))

# close mongo connection
client.close()