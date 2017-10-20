tests
testReadEmpty
	| results |
	results := self accessor
				executeSQLString: 'SELECT * FROM PERSON'.
	self assert: results size = 0