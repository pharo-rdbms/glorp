conversion-strings
removeNestedParensFromString: aString
	"Return a Smalltalk instance of the type indicated by aGlorpType.  SQL-Server wraps aString in parentheses, so uwrap it first.  If aString is nil, ensure we return nil."

	| debracket |
	aString size < 2 ifTrue: [^aString].	"relies on nil size = 0"
	debracket := aString copy.
	[debracket first = $( and: [debracket last = $)]]
		whileTrue: [debracket := debracket copyFrom: 2 to: debracket size - 1].
	^debracket