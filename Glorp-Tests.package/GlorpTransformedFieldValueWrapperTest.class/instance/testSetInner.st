tests
testSetInner
	self deny: inner hasValue.
	self deny: outer hasValue.
	inner contents: 3.
	self assert: outer contents = 6.
	self assert: inner contents = 3.
	self assert: inner hasValue.
	self assert: outer hasValue.