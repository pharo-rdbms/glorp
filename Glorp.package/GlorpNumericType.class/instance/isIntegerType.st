testing
isIntegerType
	"If we have no precision and no scale, we're effectively an Integer"
	^self precision isNil and: [self scale isNil]