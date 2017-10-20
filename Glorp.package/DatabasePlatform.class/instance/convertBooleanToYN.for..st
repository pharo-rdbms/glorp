conversion-boolean
convertBooleanToYN: aBoolean for: aType
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['Y'] ifFalse: ['N'].