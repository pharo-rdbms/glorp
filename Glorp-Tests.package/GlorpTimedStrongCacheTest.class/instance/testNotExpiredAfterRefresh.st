tests
testNotExpiredAfterRefresh
	| customer |
	self setUpForRefresh.
	session accessor beginTransaction.
	[session accessor executeSQLStringNoResult: 'INSERT INTO GR_CUSTOMER VALUES (3,''Fred Flintstone'')'.
	customer := session execute: (Query readOneOf: GlorpCustomer where: [:each | each id = 3]).
	(Delay forSeconds: 2) wait.
	self assert: (cache hasExpired: customer).
	self assert: (cache lookupClass: GlorpCustomer key: 3 ifAbsent: [nil]) == customer.
	self deny: (cache hasExpired: customer)]
		ensure: [session accessor rollbackTransaction].