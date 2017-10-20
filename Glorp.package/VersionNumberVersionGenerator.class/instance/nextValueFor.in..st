sequencing
nextValueFor: aField in: aRow
	| oldValue |
	oldValue := aRow at: aField ifAbsent: [0].
	^(oldValue isNil ifTrue: [0] ifFalse: [oldValue]) + 1