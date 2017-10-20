examples
exampleJobRow: anInteger finished: aBoolean

	| table row |
	table := self tableNamed: 'GLORP_JOB'.
	row := DatabaseRow newForTable: table.
	row at: (table fieldNamed: 'ID') put: anInteger.
	row at: (table fieldNamed: 'DESCRIPTION') put: 'Job ', anInteger printString.
	row at: (table fieldNamed: 'FINISHED') put: (aBoolean ifTrue: ['Y'] ifFalse: ['N']).
	row at: (table fieldNamed: 'OWNER_ID') put: 1234.

	^row.