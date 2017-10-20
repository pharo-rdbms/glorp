tests
testReservedNumberAllocation
	session := nil.
	sequence reservedNumbers add: 23; add: 24.
	self assignSequences.
	self assert: self row1Value = 23.
	self assert: self row2Value = 24.