examples
examplePersonRow2

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 4.
	row at: (personTable fieldNamed: 'NAME') put: 'aPerson'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: nil.
	^row.