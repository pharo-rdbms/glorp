converting
convert: anObject toDatabaseRepresentationAs: aDatabaseType 
	^stToDb isNil ifTrue: [anObject] ifFalse: [stToDb value: anObject]