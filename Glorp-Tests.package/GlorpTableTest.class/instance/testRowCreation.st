tests
testRowCreation

	| row |
	row := system examplePersonRow1.
	self assert: (row at: (row table fieldNamed: 'ID')) = 3.