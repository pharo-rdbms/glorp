tests
testReadAllAddress
	| object results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	results := session read: GlorpAddress] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'