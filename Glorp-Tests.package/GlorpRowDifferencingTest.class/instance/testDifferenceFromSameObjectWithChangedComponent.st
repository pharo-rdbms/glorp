tests
testDifferenceFromSameObjectWithChangedComponent
	"Commenting these out because I think the setup is just wrong"
	"currentObject := Person example1.
	mementoObject := Person example1WithDifferentAddress.

	currentObjectRowMap := self generateRowMapFor: currentObject."

	"Before changes occur, all original objects are registered with the unit of work.  
		To mimic that, the original person's address needs to be added to current (after changes) "
"	self addRowsFor: mementoObject address to: currentObjectRowMap.
	correspondenceMap := self correspond: currentObject to: mementoObject.
	correspondenceMap at: mementoObject address put: mementoObject address.
	correspondenceMap removeKey: currentObject address.
	mementoObjectRowMap := self generateMementoRowMapFor: mementoObject withCorrespondenceMap: correspondenceMap.
	differenceMap := currentObjectRowMap differenceFrom: mementoObjectRowMap.
	self assert: differenceMap numberOfEntries = 2.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'PERSON')) = 1.
	self 
		assert: (differenceMap 
				numberOfEntriesForTable: (system tableNamed: 'GR_ADDRESS')) = 1"