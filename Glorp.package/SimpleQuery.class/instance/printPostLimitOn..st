sql generation
printPostLimitOn: aCommand
	self hasLimit ifFalse: [^self].
	self platform printPostLimit: self limit on: aCommand