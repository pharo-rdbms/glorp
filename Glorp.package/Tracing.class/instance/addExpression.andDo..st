accessing
addExpression: anExpression andDo: aBlock
	| exp |
	exp := anExpression asGlorpExpressionOn: self base in: query.
	(allTracings includes: exp) ifFalse: [
		allTracings add: exp.
		aBlock value: exp]