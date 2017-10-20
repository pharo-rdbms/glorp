tests
testArray
	| object |
	object := #(1 2 3 4 5) copy.
	transaction begin.
	transaction register: object.
	object
		at: 1 put: #one;
		at: 2 put: object.
	transaction abort.
	self
		assert: (object at: 1) == 1;
		assert: (object at: 2) == 2