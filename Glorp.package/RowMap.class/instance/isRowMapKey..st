api
isRowMapKey: anObject
	^anObject class == RowMapKey or: [anObject class == MultipleRowMapKey]