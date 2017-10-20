*Glorp
count: aClass where: anExpression
	| query |
	query := self readOneOf: aClass where: anExpression.
	query retrieve: #countStar.
	^query.