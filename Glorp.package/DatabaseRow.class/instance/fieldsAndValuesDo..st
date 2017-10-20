initializing
fieldsAndValuesDo: aBlock 
	table isNil ifTrue: [^self].
	table fields do: [:each | aBlock value: each value: (self at: each ifAbsent: [self class missingFieldIndicator])]