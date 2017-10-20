support
generateRowMapFor: person 
	| rowMap |
	rowMap := RowMap new.
	self addRowsFor: person to: rowMap.
	person address notNil ifTrue: [self addRowsFor: person address to: rowMap].
	^rowMap