converting
convert: anObject fromDatabaseRepresentationAs: aDatabaseType 
	^dbToSt isNil ifTrue: [anObject] ifFalse: [dbToSt value: anObject]