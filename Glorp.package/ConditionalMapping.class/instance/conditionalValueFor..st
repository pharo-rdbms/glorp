mapping
conditionalValueFor: anObject
	^(Dialect isBlock: conditionalMethod)
		ifTrue: [conditionalMethod value: anObject]
		ifFalse: [anObject perform: conditionalMethod]