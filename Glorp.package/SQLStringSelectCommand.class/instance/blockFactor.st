accessing
blockFactor
	blockFactor isNil ifTrue: [
		blockFactor := query isNil ifTrue: [5] ifFalse: [super blockFactor]].
	^blockFactor.