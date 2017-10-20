tests
createRowMap
	rowMap := RowMapForMementos withCorrespondenceMap: transaction undoMap.
	rowMap collectionMementos: transaction collectionMementos.
	newCollection := rowMap collectionMementoFor: collection.