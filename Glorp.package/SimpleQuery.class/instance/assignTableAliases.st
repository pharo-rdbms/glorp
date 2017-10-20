preparing
assignTableAliases
	| tableNumber allExpressions |
	whereClause isJoin ifTrue: [^self].
	tableNumber := 1.
	allExpressions := ExpressionGroup with: whereClause.
	allExpressions addAll: ordering.
	allExpressions addAll: grouping.
	allExpressions addAll: joins.
	builders do: [:each | allExpressions add: each expression].
	allExpressions
		do:
			[:each | tableNumber := each assignTableAliasesStartingAt: tableNumber prefix: self tablePrefix].
	"We've aliased tables, joins may now become independent"
	joins := joins inject: OrderedCollection new into: [:sum :each | (sum addAll: each asIndependentJoins). sum].