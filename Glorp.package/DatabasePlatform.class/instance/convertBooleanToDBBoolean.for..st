conversion-boolean
convertBooleanToDBBoolean: aBoolean for: aType
	(self usesNullForFalse and: [aBoolean isNil]) ifTrue: [^false].
	^aBoolean.