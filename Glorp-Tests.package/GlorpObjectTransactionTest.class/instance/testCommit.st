tests
testCommit
	| array |
	array := #(1 2 3 4 5) copy.
	transaction begin.
	transaction register: array.
	array
		at: 1 put: #one;
		at: 2 put: array.
	transaction commit.
	self
		assert: (array at: 1) == #one;
		assert: (array at: 2) == array