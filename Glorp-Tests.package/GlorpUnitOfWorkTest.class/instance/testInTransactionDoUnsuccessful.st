tests-transaction wrappers
testInTransactionDoUnsuccessful

	| result initial|
	initial := session read: GlorpAddress.
	self assert: initial isEmpty.
	[session inTransactionDo: [
		session writeRow: session system exampleAddressRow.
		self error: 'no you don''t']] on: Dialect error do: [:ex | ex return: nil].
	result := session read: GlorpAddress.
	self assert: result size = 0.