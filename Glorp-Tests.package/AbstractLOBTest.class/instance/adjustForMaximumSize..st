private
adjustForMaximumSize: aValue
	^aValue ifNotNil: [ 	aValue size > session platform maximumQueryValueSize 
		ifTrue: [(aValue copyFrom: 1 to: session platform maximumQueryValueSize - 2), '%']
		ifFalse: [aValue]]