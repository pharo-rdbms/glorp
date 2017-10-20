preparing
joinExpressionFor: targetExpression
	"We're looking for the object represented by this mapping, and we know the object represented by its source. Use our mapping criteria to construct a join that traverses that instance of this relationship"

	| sourceExpression |
	(self controlsTables not and: [self classModel describedClass == Association]) ifTrue: [^nil].
	sourceExpression := targetExpression base.
	^self extendedJoinFromSource: sourceExpression toTarget: targetExpression.