tests
testBlockArgumentCount
	self assert: (Dialect argumentCountFor: [3]) = 0.
	self assert: (Dialect argumentCountFor: [:a | 3]) = 1.
	self assert: (Dialect argumentCountFor: [:a :b | a <= b]) = 2.