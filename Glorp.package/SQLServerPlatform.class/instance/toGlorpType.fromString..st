conversion-strings
toGlorpType: aGlorpType fromString: aString
	"Since SQL-Server wraps the string in parentheses, uwrap it first."

	^super
		toGlorpType: aGlorpType
		fromString: (self removeNestedParensFromString: aString)