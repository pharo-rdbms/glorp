numbers
doesPrecisionOf: aNumber equal: aPrecision
	^aNumber class == self fixedPointClass and: [aNumber scale = aPrecision]