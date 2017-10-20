tests
computeDifference
	currentObjectRowMap := self generateRowMapFor: currentObject.
	correspondenceMap := self correspond: currentObject to: mementoObject.
	mementoObjectRowMap := self generateMementoRowMapFor: mementoObject withCorrespondenceMap: correspondenceMap.
	differenceMap := currentObjectRowMap differenceFrom: mementoObjectRowMap.