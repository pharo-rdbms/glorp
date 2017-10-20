fields
fieldNamed: aString

	^self fieldNamed: aString ifAbsent: [self error: 'No field ', aString, ' in ', self name].