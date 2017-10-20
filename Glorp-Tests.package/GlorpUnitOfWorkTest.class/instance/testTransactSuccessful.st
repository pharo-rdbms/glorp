tests-transaction wrappers
testTransactSuccessful
	"This has to test that a transaction completed successfully, so unlike most other tests, we have to clean up the evidence afterwards"

	| result |
	[session transact: [
		session register: (GlorpReservation new id: 345)].
	result := session read: GlorpReservation.
	self assert: result size = 1.
	self assert: result first id = 345]
		ensure: [session transact: [session accessor executeSQLStringNoResult: 'DELETE FROM RESERVATION']].