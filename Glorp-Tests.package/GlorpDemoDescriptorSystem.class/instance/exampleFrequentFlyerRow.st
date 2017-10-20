examples
exampleFrequentFlyerRow
	| ffTable row |
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	row := DatabaseRow newForTable: ffTable.
	row at: (ffTable fieldNamed: 'ID') put: 1.
	row at: (ffTable fieldNamed: 'POINTS') put: 10000.
	row at: (ffTable fieldNamed: 'AIRLINE_ID') put: nil.
	^row.