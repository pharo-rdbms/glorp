converting
converterForStType: aClass
	aClass = Date ifTrue: [^self platform converterNamed: #timestampToDate].
	^self platform converterNamed: #timestamp.