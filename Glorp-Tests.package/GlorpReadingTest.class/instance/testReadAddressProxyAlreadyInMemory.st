tests
testReadAddressProxyAlreadyInMemory
	"Check that if the object is already in memory we don't create a proxy for it, just return the instance Unless explicitly asked, in which case we return a proxy."
	| object object2 query results rowToWrite |

	[session beginTransaction.
		rowToWrite := session system exampleAddressRow.
		session writeRow: rowToWrite.
		object := session readOneOf: GlorpAddress where: [:address | address id = 123].
		self deny: (object class inheritsFrom: Proxy).
		object2 := session readOneOf: GlorpAddress where: [:address | address id = 123].
		self deny: (object class inheritsFrom: Proxy).
		self assert: object2 == object.
		object := nil.
		object2 := nil.
		Dialect garbageCollect.
		(Delay forSeconds: 2) wait.
		query := (Query
			read: GlorpAddress
			where: ([:address | address id = 123]) ) returnProxies: true.
		results := query executeIn: session.
		session accessor denyReads.
		self assert: (results size = 1).
		object := results first]
	ensure: [session rollbackTransaction].

	self assert: (object class = Proxy).
	self deny: object isInstantiated.
	self assert: (object id = 123).
	self assert: (object street = 'Paseo Montril').
	self assert: (object number = '10185').
	session accessor permitEverything.