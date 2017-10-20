begin/commit/abort
createMementoRowMapFor: objects 
	"Create a rowmap for the objects whose state was already known. We subtract this from the rowmap of all known objects to get the rows that need to be written. New objects are also registered, so we only generate rows here for non-new objects"

	| localRowMap |
	localRowMap := RowMapForMementos 
				withCorrespondenceMap: self correspondenceMap.
	localRowMap collectionMementos: transaction collectionMementos.
	objects keysAndValuesDo: 
			[:original :memento | 
			(self newObjects includes: original) 
				ifFalse: [session createRowsFor: memento in: localRowMap]].
	^localRowMap