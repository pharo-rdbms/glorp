helpers
compareFloatInModel: read with: original
	read isNil ifTrue: [^false].
	read test = original ifTrue: [^true].
	read test isNil ifTrue: [^false].
	^(read test - original) abs <= 0.00001.