conversion-boolean
convertBooleanToInteger: aBoolean for: aType
	aBoolean isNil ifTrue: [^nil].
	^aBoolean ifTrue: [1] ifFalse: [0].