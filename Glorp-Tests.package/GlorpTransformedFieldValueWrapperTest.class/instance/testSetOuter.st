tests
testSetOuter
	self deny: inner hasValue.
	self deny: outer hasValue.
	outer contents: 8.
	self assert: outer contents = 8.
	self assert: inner contents = 4.
	self assert: inner hasValue.
	self assert: outer hasValue.