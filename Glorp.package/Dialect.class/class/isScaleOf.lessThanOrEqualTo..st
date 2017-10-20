numbers
isScaleOf: aNumber lessThanOrEqualTo: aScale
	^aNumber class == self fixedPointClass and: [aNumber scale <= aScale].