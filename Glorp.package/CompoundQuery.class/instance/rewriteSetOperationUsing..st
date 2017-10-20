sql generation
rewriteSetOperationUsing: aSelector
	"Rewrite any INTERSECT OR EXCEPT operation we have into a correlated EXISTS or NOT EXISTS test, respectively. We take the sub-query, and AND into it a constraint that its base expression is equal to the first queries base expression, and then do either an exists: or a notExists:, depending on aSelector."
	
	| newQuery |
	newQuery := queries first copy.
	2 to: queries size do: [:i | | q expression mainExpression |
		q := (queries at: i) copy.
		expression := RelationExpression new outerJoin: false; relation: #=; leftChild: newQuery baseExpression; rightChild: q baseExpression.
		mainExpression := RelationExpression new outerJoin: false; relation: #AND; leftChild: q whereClause; rightChild: expression.
		q whereClause: mainExpression.
		newQuery AND: [:each | each perform: aSelector with: q]].
	^newQuery