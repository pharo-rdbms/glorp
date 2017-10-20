api-aggregates
aggregate: anExpression as: aggregateFunctionName where: whereExpression
	"Make a subselect of the expression that is our argument, returning an aggregated value. e.g.
session read: GlorpCustomer where: 	[:each |  
	(each aggregate: eachCust accounts as: #countStar where: [:acct | acct price > 1000]]) = 1].
	This is the most general form of aggregation convenience method, and everything else is implemented in terms of it"

	| q expression next objectExpression retrievalExpression basicExpression |
	"We may be passed an expression corresponding to either a field, or to a full object, depending on the aggregate function. In either case, build backwards from the first full object"
	objectExpression := anExpression mapping isRelationship 
		ifTrue: [anExpression] ifFalse: [anExpression base].
	q := Query read: objectExpression referenceClass.
	expression := q baseExpression.
	next := objectExpression.
	[next base isNil] whileFalse: [
		expression := next mapping addPhantomMappingExpressionOn: expression.
		next := next base].
	"We have to force construct the equality expression, because we don't want 'self' rebuilt onto the other base"
	expression := RelationExpression new outerJoin: false; relation: #=; leftChild: expression; rightChild: self.
	q whereClause: expression.
	"We need to rebuild the thing we're using to retrieve in the right context. Also, if we're called directly, the symbol may be wrapped as a constantExpression. Unwrap it"
	basicExpression := anExpression rebuildOn: q baseExpression startingFrom: objectExpression.
	retrievalExpression := (basicExpression get: aggregateFunctionName asGlorpExpression value).
	q retrieve: retrievalExpression.
	whereExpression == nil ifFalse: [
		q AND: (whereExpression asGlorpExpressionOn: basicExpression)].
	^q asGlorpExpressionOn: self ultimateBaseExpression.