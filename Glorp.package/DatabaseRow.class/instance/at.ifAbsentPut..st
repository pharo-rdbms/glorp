accessing
at: aField ifAbsentPut: absentBlock

	| old |
	old := contents at: aField position.
	old == self class emptySlot 
		ifTrue: absentBlock
		ifFalse: [^old contents].