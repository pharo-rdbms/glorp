internal/writing
createRowsFor: anObject in: rowMap
	| descriptor |
	(descriptor := self descriptorFor: anObject class) isNil
		ifFalse: [descriptor createRowsFor: anObject in: rowMap]