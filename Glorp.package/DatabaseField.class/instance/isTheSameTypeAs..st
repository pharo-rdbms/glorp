comparing
isTheSameTypeAs: aDatabaseField
	| myType aType |
	self isPrimaryKey
		ifTrue:
		   [myType := self type.
		   aType := aDatabaseField type.
		   ^(myType = aType 
				or: [(myType isSerial or: [aType isSerial ]) 
					and: [myType impliedSmalltalkType = aType impliedSmalltalkType ]]) ].
		
	^self type = aDatabaseField type