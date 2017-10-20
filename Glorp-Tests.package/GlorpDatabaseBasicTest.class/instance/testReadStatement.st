tests
testReadStatement
	| results |
	results := self accessor
				executeSQLString: 'SELECT * FROM STUFF ORDER BY ID'.
	self assert: results size = 5.
	self assert: results first size = 2.
	self assert: results first last =  'abc'