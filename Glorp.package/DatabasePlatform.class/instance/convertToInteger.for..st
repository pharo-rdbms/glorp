conversion-numbers
convertToInteger: aNumber for: aType 
	^aNumber isNil ifTrue: [aNumber] ifFalse: [aNumber asNumber asInteger].