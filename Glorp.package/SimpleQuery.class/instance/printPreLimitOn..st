sql generation
printPreLimitOn: aCommand
	self hasLimit ifFalse: [^self].
	self platform printPreLimit: self limit on: aCommand