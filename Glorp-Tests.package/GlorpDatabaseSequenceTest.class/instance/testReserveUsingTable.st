tests
testReserveUsingTable
	session platform usesIdentityColumns ifTrue: [^self].
	[session beginTransaction.
	self writeTransactionRow: 65.
	self writeTransactionRow: 66.
	self writeTransactionRow: 67.
	sequence reserveSequenceNumbers: 7 in: session for: table]
		ensure: [session rollbackTransaction].
	session := nil.
	self assignSequences.
	self assert: self row1Value + self increment = self row2Value.