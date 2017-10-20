fields
fieldNamed: aString ifAbsent: aBlock caseSensitive: aBoolean
	| fieldName |
	fieldName := aBoolean ifTrue: [aString asString] ifFalse: [aString asUppercase].
	^fields
		detect:
			[:each | (aBoolean ifTrue: [each name] ifFalse: [each name asUppercase]) = fieldName]
		ifNone: aBlock.