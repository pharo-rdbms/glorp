conversion-numbers
convertToDouble: aNumber for: type 

	aNumber isNil ifTrue: [^nil].
	^Dialect coerceToDoublePrecisionFloat: aNumber