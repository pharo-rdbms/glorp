support
assert: aBrackettedString equalsIgnoringOuterBrackets: anotherString
	self assert: aBrackettedString =
		(anotherString first = $(
			ifTrue: [anotherString]
			ifFalse: ['(', anotherString, ')'])