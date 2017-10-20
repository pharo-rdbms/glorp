fields
removeFieldNamed: aString
	^self removeFieldNamed: aString ifAbsent: [self error: 'No such field'].