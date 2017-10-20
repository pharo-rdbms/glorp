conversion-boolean
convertBooleanToYesNo: aBoolean for: aType
	aBoolean isNil ifTrue: [^aBoolean].
	^aBoolean ifTrue: ['YES'] ifFalse: ['NO'].