# Database Technologies

### Redis

#### Installation & Usage

```sh
terminal> sudo apt update

terminal> sudo apt install redis-server redis-tools

terminal> sudo systemctl status redis

terminal> redis-cli
```

#### Information

```
PING

INFO

CONFIG GET *

CONFIG GET bind

CONFIG GET loglevel
```

#### Strings

```
KEYS *

SET dbda_01_name "James Bond"
SET dbda_01_batch "Sep 2021"
SET dbda_01_email "james@bond.com"

KEYS *

GET dbda_01_name
GET dbda_01_batch
GET dbda_01_email

DEL dbda_01_batch

KEYS *

GET dbda_01_batch
```

#### Lists

```
LPUSH hobbies Action
LPUSH hobbies Adventure Travel
RPUSH hobbies Sports

LRANGE hobbies 0 -1
LRANGE hobbies 1 3

LPOP hobbies
RPOP hobbies

LRANGE hobbies 0 -1

RPUSH hobbies Adventure

LRANGE hobbies 0 -1

KEYS *
```

#### Sets

```
SADD fruits Orange

SADD fruits Mango Grapes Watermelon

SMEMBERS fruits

SADD fruits Mango

SMEMBERS fruits

SISMEMBER fruits Mango

SISMEMBER fruits Banana
```

#### Sorted Sets

```
ZADD friends 2 Sameer

ZADD friends 4 Rahul

ZADD friends 1 Vishal 6 Soham 3 Nitin

ZRANGE friends 0 -1

ZRANGE friends 0 -1 WITHSCORES

ZPOPMIN friends 
// delete record with min score

ZPOPMIN friends 4
// delete 4 records with min score

ZRANGE friends 0 -1

ZADD friends 2 Sameer

ZADD friends 4 Rahul

ZADD friends 1 Vishal 6 Soham 3 Nitin

ZRANGE friends 0 -1

ZREM friends Rahul

ZRANGE friends 0 -1
```

#### Hashes

```
HMSET person1 name "Bill Gates"

HMSET person1 age 60

HMSET person1 address "USA"

HMSET person1 company "Microsoft"

HGETALL person1

HMGET person1 name

HMGET person1 company

KEYS *
```

person1 = {
    name: "Bill Gates",
    age: 60,
    address: "USA",
    company: "Microsoft"
}



