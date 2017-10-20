examples
exampleLinkRow2

	| table row |
	table := self tableNamed: 'GLORP_WORKER_JOB_LINK'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'WORKER_ID') put: 1234.
	row at: (table fieldNamed: 'JOB_ID') put: 3.
	row at: (table fieldNamed: 'PRIORITY') put: 'Y'.
	^row.