tests
testDescriptorAssignmentToCriteria

	| query |
	query := SimpleQuery readOneOf: GlorpAddress where: [:each | each id = 1].
	query session: session.
	query setUpExpressions.
	self assert: query whereClause ultimateBaseExpression descriptor == (session descriptorFor: GlorpAddress).