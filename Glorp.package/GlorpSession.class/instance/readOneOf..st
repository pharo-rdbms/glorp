api/queries
readOneOf: aClass
	"Return a single instance of aClass from a row of its table."

	^self execute: (SimpleQuery readOneOf: aClass)