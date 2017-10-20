tests
testCriteriaSetup
	| query |
	query := Query readOneOf: GlorpAddress where: [:each | each id = 12].
	query session: session.
	query setUpExpressions.
	self assert: query whereClause class == RelationExpression.
	self assert: query whereClause ultimateBaseExpression descriptor 
				== (session descriptorFor: GlorpAddress)