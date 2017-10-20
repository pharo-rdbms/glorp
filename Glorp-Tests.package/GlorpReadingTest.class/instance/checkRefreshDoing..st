support
checkRefreshDoing: aBlock
	"Check that we refresh correctly doing the action specified by aBlock"
	| rowToWrite address modifiedRow |
	
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	address := session readOneOf: GlorpAddress
				where: [:each | each id = 123].
	modifiedRow := session system exampleModifiedAddressRow.
	modifiedRow owner: address. "Otherwise it thinks it's an insert"
	session writeRow: modifiedRow.
	aBlock value: address.
	self assert: address street = 'Something Else'.] 
			ensure: [session rollbackTransaction].