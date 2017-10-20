tests-sql
testReadAddressWithCustomSQLBinding
	"Test that we can bind to custom SQL. If not binding, don't run this test."
	| object query results rowToWrite |
	
	session useBinding ifFalse: [^self].
	[session beginTransaction.
	rowToWrite := session system exampleAddressRow.
	session writeRow: rowToWrite.
	query := Query read: GlorpAddress.
	query sql: 'select id, street, house_num from gr_address where id = ?'.
	results := query executeWithParameters: #(123) in: session] 
			ensure: [session rollbackTransaction].
	self assert: results size = 1.
	object := results first.
	self assert: object class = GlorpAddress.
	self assert: object id = 123.
	self assert: object street = 'Paseo Montril'.
	self assert: object number = '10185'