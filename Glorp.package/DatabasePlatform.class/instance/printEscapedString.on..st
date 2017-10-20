conversion-strings
printEscapedString: aString on: aCommand
	"In this method, aCommand only needs its polymorphic stream protocol, but the parameter is sure to be a command, not a stream, if this method is called."

	| charsToEscape |
	charsToEscape := self charactersThatNeedEscaping.
	1 to: aString size do:
		[:i || char | char := aString at: i.
		(charsToEscape includes: char)
			ifTrue: [aCommand nextPutAll: (self escapeFor: char)]
			ifFalse: [aCommand nextPut: char]].