tests
testDifferenceFromSameObjectWithAddedComponent
"	Commenting these out because I think the setup is just wrong.
currentObject := Person example1.
	mementoObject := Person example1WithNoAddress.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1"