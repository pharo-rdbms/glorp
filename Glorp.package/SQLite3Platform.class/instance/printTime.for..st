conversion-times
printTime: aTimeString for: aType
	"SQLite does not suppport any time-related types.  We convert them all to strings via the to... methods, so parameters to this method should be Strings of the form 10:20:23."

	aTimeString isNil ifTrue: [^'NULL'].
	"The next line is checking code and can be dropped when SQLite is sufficiently tested."
	aTimeString class = Time ifTrue: [self error: 'SQLite does not support time types;  this should have been a String'].
	^aTimeString printString