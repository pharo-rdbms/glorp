accessing
collectionMementoFor: anObject
	anObject isNil ifTrue: [^#()].
	^collectionMementos at: anObject ifAbsent: [self mementoFor: anObject]