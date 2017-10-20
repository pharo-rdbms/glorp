tests
testBecome
	| object |
	object := 'hello' copy.
	transaction begin.
	transaction register: object.
	object become: Set new.
	transaction abort.
	self 
		assert: object class == '' class;
		assert: object = 'hello'.