sql generation
printJoinsOn: aCommand
	| noLeadIn|
	self platform supportsANSIJoins ifTrue: [^self].
	joins isEmpty ifTrue: [^self].
	noLeadIn := whereClause isEmptyExpression.
	noLeadIn ifFalse: [aCommand nextPutAll: ' AND ('].
	GlorpHelper 
			do: [:each | each printSQLOn: aCommand withParameters: aCommand parameters]
			for: joins
			separatedBy: [aCommand nextPutAll: ' AND '].
	noLeadIn ifFalse: [aCommand nextPut: $)]