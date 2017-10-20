SQL
typeString
	typeString isNil
		ifTrue:
			[typeString := self typeName.
			width isNil
				ifFalse: [typeString := typeString , '(' , width printString , ')']].
	^typeString.