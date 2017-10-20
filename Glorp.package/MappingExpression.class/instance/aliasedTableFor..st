fields
aliasedTableFor: aDatabaseTable 
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable]
		ifFalse: [base aliasedTableFor: (self mapping translateTable: aDatabaseTable)]