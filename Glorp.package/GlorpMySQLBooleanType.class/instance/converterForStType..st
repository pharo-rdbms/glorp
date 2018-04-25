converting
converterForStType: aClass
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToInteger].
	^self platform nullConverter.