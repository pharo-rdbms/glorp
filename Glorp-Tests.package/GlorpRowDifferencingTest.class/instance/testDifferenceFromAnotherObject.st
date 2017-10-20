tests
testDifferenceFromAnotherObject
	currentObject := GlorpPerson example1.
	mementoObject := GlorpPerson example2.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1