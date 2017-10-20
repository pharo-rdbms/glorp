preparing
aliasedTableFor: aDatabaseTable 
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable]
		ifFalse: [base aliasedTableFor: aDatabaseTable]