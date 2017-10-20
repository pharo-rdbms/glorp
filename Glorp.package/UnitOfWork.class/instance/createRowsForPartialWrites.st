begin/commit/abort
createRowsForPartialWrites
	| registeredObjectsRowMap mementoObjectsRowMap |
	registeredObjectsRowMap := self createRowMapFor: self registeredObjects.
	deletedObjects 
		do: [:eachObject | session createDeleteRowsFor: eachObject in: registeredObjectsRowMap].
	mementoObjectsRowMap := self createMementoRowMapFor: self mementoObjects.
	rowMap := registeredObjectsRowMap differenceFrom: mementoObjectsRowMap