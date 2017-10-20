tests
testReserveEmpty
	session platform usesIdentityColumns ifTrue: [^self].
	sequence reserveSequenceNumbers: 2 in: session for: table.
	session := nil.
	self assignSequences.
	self assert: self row1Value + self increment = self row2Value.