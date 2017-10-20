instance creation
for: aSymbol withArguments: anArray basedOn: anExpression
	| base system |
	base := anExpression ultimateBaseExpression.
	system := base isNil ifTrue: [nil] ifFalse: [base system].	
	^self for: aSymbol withArguments: anArray basedOn: anExpression system: system