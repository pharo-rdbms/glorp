examples
examplePersonRowForOrdering2

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 87.
	row at: (personTable fieldNamed: 'NAME') put: 'person2'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 3.
	^row.