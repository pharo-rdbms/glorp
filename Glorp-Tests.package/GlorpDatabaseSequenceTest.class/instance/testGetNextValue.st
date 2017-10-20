tests
testGetNextValue
	session platform usesIdentityColumns ifTrue: [^self].
	self assignSequences.
	self assert: self row2Value = (self row1Value + 1).