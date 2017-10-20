tests-functions
testRegexMatches
	"This will fail on SQLite unless an application-defined SQL function named 'regexp' is added at run-time.  It will likewise fail on DB2 and SQLServer unless both a database function and a glorp reference to its name (which need not be regexp) have been added;  these database do not offer regex support, just the ability to add functions."

	| customers |
	
	session platform isUDBCSQLite3Platform ifTrue: [ ^ self skip. ].
	
	[session beginTransaction.
	session beginUnitOfWork.
	self writeCustomer1Rows.
	session reset.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'aCustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'a*omer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'a?ustomer'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'aCusto(m|e|r)*'].
	self assert: customers size = 1.
	customers := session read: GlorpCustomer where: [:each | each name regexMatches: 'Not a customer'].
	self assert: customers isEmpty.
	] 
			ensure: [session rollbackTransaction]