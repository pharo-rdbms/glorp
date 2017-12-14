conversion-numbers
convertToDecimal: aNumber for: type

 	aNumber isNil ifTrue: [^nil].
	^ScaledDecimal newFromNumber: aNumber scale: type scale.