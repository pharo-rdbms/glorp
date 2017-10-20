preparing
aliasedTableFor: aDatabaseTable ifAbsent: aBlock
	^self controlsTables 
		ifTrue: [super aliasedTableFor: aDatabaseTable ifAbsent: aBlock]
		ifFalse: [base aliasedTableFor: aDatabaseTable ifAbsent: aBlock]