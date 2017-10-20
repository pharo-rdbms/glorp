tests
testDifferenceFromSameObjectWithChangedComponentAttribute
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example1WithChangedAddress.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1