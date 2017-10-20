transactions
beginTransaction
	self log: 'Begin Transaction'.
	isInTransaction := true.
	self databaseDriver beginTransaction