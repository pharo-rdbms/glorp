preparing
joinExpressionFor: targetExpression
	"We're looking for the object represented by this mapping, and we know the object represented by its source. Use our mapping criteria to construct a join that traverses that instance of this relationship.
	Embedded values never induce a join."

	^nil.