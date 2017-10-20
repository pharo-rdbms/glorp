instance creation
value: anObject as: aDatabaseType
	self error: 'this is work in progress, you probably shouldn''t use it yet'.
	(anObject isNil or: [anObject isGlorpExpression and: [anObject isConstantExpression and: [anObject value isNil]]])
		ifTrue: [^anObject].
	^self new base: anObject asGlorpExpression; arguments: (Array with: aDatabaseType asGlorpExpression)