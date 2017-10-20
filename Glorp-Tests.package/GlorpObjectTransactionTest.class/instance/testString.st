tests
testString
	| object |
	object := 'Hello, World!' copy.
	transaction begin.
	transaction register: object.
	object
		at: 1 put: $h;
		at: 2 put: $E.
	transaction abort.
	self
		assert: object first  == $H;
		assert: (object at: 2) == $e