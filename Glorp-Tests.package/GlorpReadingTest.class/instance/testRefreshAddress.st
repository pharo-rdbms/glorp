tests-refreshing
testRefreshAddress
	"Check that we refresh correctly when the refresh flag is set"
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
	query shouldRefresh: true.
	query executeIn: session.
	self assert: address street = 'Something Else'.] 
			ensure: [session rollbackTransaction].