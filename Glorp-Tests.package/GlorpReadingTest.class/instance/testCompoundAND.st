tests
testCompoundAND
	| object query results rowToWrite |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress
				where: [:address | address id < 124 AND: (address id  > 122) AND: (address id ~= nil)].
	results := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'