mapping
readBackNewRowInformationFor: anObject in: aRowMap 
	anObject yourSelf class == self describedClass ifFalse: [self error: 'wrong descriptor for this object'].
	mappings do: [:each | each readBackNewRowInformationFor: anObject fromRowsIn: aRowMap]