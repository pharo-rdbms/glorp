sql generation
printOffsetOn: aCommand
	self hasOffset ifFalse: [^self].
	self platform printOffset: self offset on: aCommand