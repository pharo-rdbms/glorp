mapping
convertValueToDatabaseForm: aValue
	
	converter isNil ifTrue: [^aValue].
	^converter convertedDbValueOf: aValue