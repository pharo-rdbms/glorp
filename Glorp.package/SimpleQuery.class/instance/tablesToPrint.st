sql generation
tablesToPrint
	tablesToPrint isNil ifTrue: [tablesToPrint := self computeTablesToPrint].
	^tablesToPrint.