tests
testDifferenceFromSameObjectWithChangedAttribute
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1WithDifferentName.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1