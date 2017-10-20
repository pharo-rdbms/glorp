accessing
contentsAt: aField ifAbsentPut: absentBlock

	| old newValue |
	old := contents at: aField position.
	^old == self class emptySlot 
		ifTrue: [
			newValue := absentBlock value.
			contents at: aField position put: newValue.
			newValue]
		ifFalse: [old].