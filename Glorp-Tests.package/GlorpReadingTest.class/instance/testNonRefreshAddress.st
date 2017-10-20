tests-refreshing
testNonRefreshAddress
	"Test that if we don't set the refresh flag on the query we don't re-read the data"
	| query rowToWrite address modifiedRow |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	query := Query readOneOf: GlorpAddress where: [:each | each id = 123].
	query executeIn: session.
	self assert: address street = 'Paseo Montril'.] 
			ensure: [session rollbackTransaction].