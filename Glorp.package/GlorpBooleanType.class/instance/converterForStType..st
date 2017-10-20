converting
converterForStType: aClass
	(aClass includesBehavior: Boolean) ifTrue: [^self platform converterNamed: #booleanToBoolean].
	^self platform nullConverter.