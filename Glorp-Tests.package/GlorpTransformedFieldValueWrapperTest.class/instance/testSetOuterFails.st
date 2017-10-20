tests
testSetOuterFails
	self deny: inner hasValue.
	self deny: outer hasValue.
	outer contents: 8.
	self should: [outer contents: 9] raise: Dialect error.
	self assert: outer contents = 8.
	self assert: inner contents = 4.
	self assert: inner hasValue.
	self assert: outer hasValue.