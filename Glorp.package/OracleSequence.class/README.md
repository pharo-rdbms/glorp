This supports Oracle sequence using select nextval from sys.allObjects. It also supports getting multiple sequence numbers at once. Going against AllObjects seemed to work much better than going against any real table.

Instance Variables:
	accessProtect	<RecursionLock | Semaphore>	Mutual exclusion on our sequence allocation, since we may need to protect our cache of already-allocated numbers, and prevent two different processes from going to the database simultaneously. This might want to be pushed up to a superclass so it can be shared.
	count	<Number>	How many identifiers have we gotten in a row without going to the database.
	sequenceIncrement	<SmallInteger>	By how much does the sequence in the database increment on each nextVal call.

