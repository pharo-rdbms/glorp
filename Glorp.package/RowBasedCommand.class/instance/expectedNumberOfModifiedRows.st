executing
expectedNumberOfModifiedRows
	^self hasMultipleRows ifTrue: [allRows size] ifFalse: [1].