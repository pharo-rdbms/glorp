mapping
extendedJoinFromSource: sourceExpression toTarget: targetExpression
	"In order to do a many-to-many read we need more information than just the write, we need to know 
	the relationship to the other table. Construct that based on the table information"

	| generalMappingCriteria |
	self usesLinkTable 
		ifFalse: [^self join asExpressionJoiningSource: sourceExpression toTarget: targetExpression].

	generalMappingCriteria := self join asExpressionJoiningSource: sourceExpression toTarget: targetExpression.
	^(self expressionFromLinkToReferenceTableWithBase: targetExpression) AND: generalMappingCriteria.