tests
testRegisteredObjectsDoRecursively

	| link |
	link := 1 -> (2 -> (3 -> (4 ->5))).
	transaction register: link.
	self assert: transaction undoMap size = 1.
	transaction registeredObjectsDo: [:each |
		transaction register: each value].
	self assert: transaction undoMap size = 4.