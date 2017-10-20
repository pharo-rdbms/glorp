examples
examplePersonRowForOrdering3

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 88.
	row at: (personTable fieldNamed: 'NAME') put: 'person3'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 1.
	^row.