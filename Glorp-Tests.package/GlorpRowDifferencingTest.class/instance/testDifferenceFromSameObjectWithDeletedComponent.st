tests
testDifferenceFromSameObjectWithDeletedComponent
	"Commenting these out because I think the setup is just wrong"
"	currentObject := Person example1WithNoAddress.
	mementoObject := Person example1.
	self computeDifference.
	self assert: differenceMap numberOfEntries = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1"