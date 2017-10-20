examples
exampleFrequentFlyerRow2
	| ffTable row |
	ffTable := self tableNamed: 'FREQUENT_FLYER'.
	row := DatabaseRow newForTable: ffTable.
	row at: (ffTable fieldNamed: 'ID') put: 2.
	row at: (ffTable fieldNamed: 'POINTS') put: 7.
	row at: (ffTable fieldNamed: 'AIRLINE_ID') put: nil.
	^row.