preparing
additionalExpressionsIn: aQuery 
	"Return the collection of additional expressions (representing joins) that this expression tree requires. Because some additional expressions may in turn have their own additional expressions (mapping joins represented by general expressions), repeat until we don't get any more."

	| allExpressions newExpressions allNewExpressions expressionsConsidered |
	allExpressions := ExpressionGroup with: self.
	allExpressions addAll: aQuery ordering.
	allExpressions addAll: aQuery grouping.
	allExpressions addAll: aQuery tracing additionalExpressions.
	expressionsConsidered := IdentitySet new.
	allNewExpressions := OrderedCollection new.
	newExpressions := nil.
	[newExpressions := (newExpressions isNil ifTrue: [allExpressions] ifFalse: [newExpressions])
		inject: ExpressionGroup new 
		into: [:sum :each | 
			((expressionsConsidered includes: each) not and: [
				each queryLevelBaseExpression == aQuery baseExpression]) ifTrue: [
					sum addAll: each additionalExpressions.
					expressionsConsidered add: each].
			sum].
	allNewExpressions addAll: newExpressions children.
	newExpressions isEmpty] whileFalse.
	^allNewExpressions.