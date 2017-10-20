tests-transaction wrappers
testTransactUnsuccessful

	| result |
	[session transact: [
		session register: (GlorpReservation new id: 345).
		self error: 'didn''t work']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpReservation.
	self assert: result size = 0.