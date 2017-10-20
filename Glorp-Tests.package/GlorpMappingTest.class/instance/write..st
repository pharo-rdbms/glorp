support
write: anObject

	| descriptor |
	descriptor := system descriptorFor: anObject. 
	descriptor isNil ifTrue: [^self].
	descriptor createRowsFor: anObject in: rowMap.