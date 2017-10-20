conversion-boolean
convertBooleanToTF: aBoolean for: aType
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['T'] ifFalse: ['F'].