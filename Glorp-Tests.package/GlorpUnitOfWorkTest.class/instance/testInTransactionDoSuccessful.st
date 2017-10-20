tests-transaction wrappers
testInTransactionDoSuccessful
	"This has to test that a transaction completed successfully, so unlike most other tests, we have to clean up the evidence afterwards"

	| result endResult |
	[session inTransactionDo: [
		session writeRow: session system exampleAddressRow].
	result := session read: GlorpAddress.
	self assert: result size = 1.
	self assert: result first id = 123]
		ensure: [session inTransactionDo: [session accessor executeSQLStringNoResult: 'DELETE FROM GR_ADDRESS']].
	endResult := session read: GlorpAddress.
	self assert: endResult size = 0.