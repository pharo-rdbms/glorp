tests-transaction wrappers
testinUnitOfWorkUnsuccessful

	| result |
	[session beginTransaction.
	[session inUnitOfWorkDo: [
		session register: (GlorpReservation new id: 345).
		self error: 'aaaagh']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpReservation.
	self assert: result size = 0]
		ensure: [session rollbackTransaction].