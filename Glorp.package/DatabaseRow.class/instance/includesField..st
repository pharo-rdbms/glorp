accessing
includesField: aField
	^(contents at: aField position) ~~ self class emptySlot.