converting
asSimpleQueryFor: aClass
	| newQuery newCriteria newBase |
	"Rebuild the expression, because this means a full query is being split into multiple sub-queries, e.g. for an inheritance read. The expression may get prepared differently in each case (e.g. table aliases), so we can't share"
	newBase := BaseExpression new.
	newBase descriptor: (session system descriptorFor: aClass).
	newCriteria := whereClause rebuildOn: newBase startingFrom: newBase withOuterScopeBase: newBase.
	newQuery := SimpleQuery new
		initResultClass: aClass
		whereClause: newCriteria
		singleObject: readsOneObject.
	self copyAttributesTo: newQuery.
	newQuery session: session.
	newQuery setOrdering: ordering.
	newQuery setGrouping: grouping.
	newQuery setUpExpressions.
	newQuery tracing: tracing copy.
	^newQuery.