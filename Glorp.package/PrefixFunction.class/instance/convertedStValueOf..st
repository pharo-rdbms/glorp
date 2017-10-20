converting
convertedStValueOf: anObject
	"This assumes that functions that do conversions have already had their effect in the database, and all we're concerned with is the fundamental data type conversion"
	^base convertedStValueOf: anObject.