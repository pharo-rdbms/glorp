conversion-times
printDate: aDateString for: aType

	aDateString isNil ifTrue: [^'NULL'].
	^ String streamContents: [ :str |
		str nextPut: $".
		aDateString printOn: str.
		str nextPut: $" ]
