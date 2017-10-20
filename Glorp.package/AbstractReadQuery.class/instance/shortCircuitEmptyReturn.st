testing
shortCircuitEmptyReturn
	"If we have a literal false for criteria, we never need to go to the database.
	We also don't need to go to database if limit doesnt make sense in terms of knowing beforehand that no results will be returned"

	(whereClause class == EmptyExpression and: [whereClause isFalse]) ifTrue: [^true].
	self limitMakesSense ifFalse: [^true].
	^false