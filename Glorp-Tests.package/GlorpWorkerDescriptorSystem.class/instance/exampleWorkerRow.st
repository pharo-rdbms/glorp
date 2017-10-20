examples
exampleWorkerRow

	| table row |
	table := self tableNamed: 'GLORP_WORKER'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: 1234.
	row at: (table fieldNamed: 'NAME') put: 'John Worker'.
	^row.