numbers
isFloatingPoint: aNumber
	^aNumber class == self doublePrecisionFloatClass or: [aNumber class == Float]