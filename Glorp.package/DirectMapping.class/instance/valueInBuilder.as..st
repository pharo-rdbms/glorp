mapping
valueInBuilder: anElementBuilder as: anExpression
	| dbValue |
	dbValue := anElementBuilder valueOfField: anExpression.
	^self convertedStValueOf: dbValue