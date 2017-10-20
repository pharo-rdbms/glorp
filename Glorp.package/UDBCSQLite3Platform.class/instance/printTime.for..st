conversion-times
printTime: aTimeString for: aType
	
	aTimeString isNil ifTrue: [^'NULL'].
	^ String streamContents: [ :str |
		str nextPut: $".
		aTimeString printOn: str.
		str nextPut: $" ]
