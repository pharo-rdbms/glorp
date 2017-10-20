support
generateMementoRowMapFor: person withCorrespondenceMap: aDictionary
	| rowMap |
	rowMap := RowMapForMementos withCorrespondenceMap: aDictionary.
	self addRowsFor: person to: rowMap.
	(person address notNil and: [(aDictionary at: person address ifAbsent: [nil]) notNil]) ifTrue: [self addRowsFor: (aDictionary at: person address) to: rowMap].
	^rowMap