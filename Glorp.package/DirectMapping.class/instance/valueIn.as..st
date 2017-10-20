mapping
valueIn: anElementBuilder as: anExpression
	| dbValue valueToGet |
	valueToGet := anExpression canTranslateFields 
		ifTrue: [anExpression translateField: field] 
		ifFalse: [anExpression].
	dbValue := anElementBuilder
		valueOfField: valueToGet.
	^self convertedStValueOf: dbValue