tests
testReadAddressProxy
	| object query results rowToWrite proxy | 

	[session beginTransaction.
		rowToWrite := session system exampleAddressRow.
		session writeRow: rowToWrite.
		query := (Query
			read: GlorpAddress
			where: ([:address | address id = 123]) ) returnProxies: true.
		results := query executeIn: session.
		self assert: (results size = 1).
		proxy := results first.
		object := proxy getValue]
	ensure: [session rollbackTransaction].

	self assert: (proxy isGlorpProxy).
	self assert: (object class = GlorpAddress).
	self assert: (object id = 123).
	self assert: (object street = 'Paseo Montril').
	self assert: (object number = '10185').