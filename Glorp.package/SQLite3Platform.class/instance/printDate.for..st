conversion-times
printDate: aDateString for: aType
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form '1959-09-30'."

	aDateString isNil ifTrue: [^'NULL'].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aDateString class = Date ifTrue: [self error: 'SQLite does not support date types;  this should have been a String'].
	^aDateString printString