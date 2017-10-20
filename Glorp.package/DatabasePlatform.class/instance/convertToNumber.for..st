conversion-numbers
convertToNumber: aNumber for: aType
	"Convert to an arbitrary numeric type. Make sure our precision matches. *Hate* floating point"

	| exponent result |
	aNumber isNil ifTrue: [^nil].
	aType precision isNil ifTrue: [^aNumber].
	(Dialect doesPrecisionOf: aNumber equal: aType precision) ifTrue: [^aNumber].
	exponent := Dialect
		coerceToDoublePrecisionFloat: (10 raisedToInteger: aType precision).
	result := (aNumber * exponent) rounded / exponent.
	^aNumber isInteger ifTrue: [result rounded] ifFalse: [result].