accessing
numberOfFields
	^contents
		inject: 0
		into:
			[:sum :each | sum + (each == self class emptySlot ifTrue: [0] ifFalse: [1])].