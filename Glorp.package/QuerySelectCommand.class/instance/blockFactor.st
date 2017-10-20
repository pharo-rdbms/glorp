accessing
blockFactor
	blockFactor isNil ifTrue: [blockFactor := query expectedRows].
	^blockFactor.