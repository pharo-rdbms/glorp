tests-functions
testSimilarTo
	"Postgres and Firebird (and Sybase) support the ANSI SQL 'SIMILAR TO' form of regex (in which the % and _ of SQL's LIKE predicate replace the corresponding * and ? of regex) but most databases do not."

	| customers |	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1Rows.
	session reset.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'aCustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'a%omer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'a_ustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name similarTo: 'Not a customer'].
	self assert: customers isEmpty.
	] 
			ensure: [session rollbackTransaction]