mapping
extendedJoin
	"In order to do a many-to-many read we need more information than just the write, we need to know 
	the relationship to the other table. Construct that based on the table information"

	| generalMappingCriteria base |
	self usesLinkTable ifFalse: [^self join].
	generalMappingCriteria := self join asGeneralGlorpExpressionWithFields.
	base := generalMappingCriteria ultimateBaseExpression.
	^(self expressionFromLinkToReferenceTableWithBase: base) AND: generalMappingCriteria.