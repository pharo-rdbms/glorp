converting
converterForStType: aClass
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToStringTF].
	(aClass includesBehavior: Symbol) ifTrue: [^self platform converterNamed: #symbolToString].
	width isNil ifFalse: [
		(aClass includesBehavior: String) ifTrue: [^self platform converterNamed: #stringToString]].
	(aClass includesBehavior: Integer) ifTrue: [^self platform converterNamed: #integerToString].
	^super converterForStType: aClass.