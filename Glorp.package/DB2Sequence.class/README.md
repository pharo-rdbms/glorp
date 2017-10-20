DB2Sequence implements DB2 sequences using nextVal. The mechanism is similar to that of Postgres.
Get a sequence number using a query like this. 
	SELECT NEXT VALUE FOR my_sequence.
Note that DB2 sequences are only supported in single partition databases.

Instance Variables
	accessProtect	<RecursionLock | Semaphore>	Mutual exclusion on our sequence allocation, since we may need to protect our cache of already-allocated numbers, and prevent two different processes from going to the database simultaneously. This might want to be pushed up to a superclass so it can be shared.
	count	<Number>	How many identifiers have we gotten in a row without going to the database.
	sequenceIncrement	<SmallInteger>	By how much does the sequence in the database increment on each nextVal call.

