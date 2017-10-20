preparing
availableSubSelectNumber
	availableSubSelectNumber := availableSubSelectNumber isNil ifTrue: [1] ifFalse: [availableSubSelectNumber + 1].
	^availableSubSelectNumber.