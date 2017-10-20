tests
testReadAddressSubstring
	| object query results rowToWrite results2 |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress
				where: [:address | (address street copyFrom: 1 to: 5) = 'Paseo'].
	results := query executeIn: session.
	query := Query read: GlorpAddress
				where: [:address | (address street copyFrom: 7 to: 13) = 'Montril'].
	results2 := query executeIn: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'.
	self assert: results2 size = 1.
	self assert: results2 first = results first.