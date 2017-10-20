enumerating
fieldValuesDo: aBlock 
	contents do: [:each | each == self class emptySlot ifFalse: [aBlock value: each]].