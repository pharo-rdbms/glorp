tests-transaction wrappers
testinUnitOfWorkSuccessful

	| result |
	[session beginTransaction.
	session inUnitOfWorkDo: [
		session register: (GlorpReservation new id: 345)].
	result := session read: GlorpReservation.
	self assert: result size = 1.
	self assert: result first id = 345]
		ensure: [session rollbackTransaction].