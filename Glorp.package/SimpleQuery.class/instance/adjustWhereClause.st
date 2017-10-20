preparing
adjustWhereClause
	"Make any adjustments to the where clause. This includes adjusting direct object equality expressions to be primary key comparisons, removing primary key comparisons where we can compare a foreign key, and condensing boolean constants out of expressions."

	whereClause := whereClause rewriteEquality. "Special because otherwise we'd be throwing away the top-level one"
	whereClause := whereClause rewriteBooleanEquality: nil.
	whereClause do: [:each | each rewriteEqualityExpressions].
	whereClause do: [:each | each condensePrimaryKeyComparisons].
	whereClause := whereClause condensePrimaryKeyComparison.
	whereClause := whereClause condenseBooleanEquality.
	whereClause do: [:each | each condenseBooleanEqualityExpressions].
	(whereClause isConstantExpression and: [whereClause value = true])
		ifTrue: [
			whereClause := EmptyExpression on: whereClause value.
			whereClause base: base.].
	whereClause do: [:each | each rewriteFunctionArguments]