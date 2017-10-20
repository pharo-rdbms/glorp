examples
examplePersonRowForOrdering1

	| personTable row |
	personTable := self tableNamed: 'PERSON'.
	row := DatabaseRow newForTable: personTable.
	row at: (personTable fieldNamed: 'ID') put: 86.
	row at: (personTable fieldNamed: 'NAME') put: 'person1'.
	row at: (personTable fieldNamed: 'ADDRESS_ID') put: 2.
	^row.