support
checkExpiryTime
	""
	| rowToWrite address modifiedRow expiryTime newExpiryTime |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	expiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	(Delay forSeconds: 1) wait.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	newExpiryTime := ((session cacheFor: address) basicAt: 123 ifAbsent: [#(nil)]) at: 1.
	self assert: newExpiryTime > expiryTime.
	self assert: address street = 'Paseo Montril'] 
			ensure: [session rollbackTransaction].