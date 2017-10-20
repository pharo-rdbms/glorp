api-aggregates
existenceCheck: anExpression as: functionName
	"Make a subselect of the expression that is our argument, returning it wrapped in either an exists or a not exists, e.g. 
	session read: GlorpCustomer where: 	[:each |  
		each existenceCheck: eachCust accounts as: #exists:].
	This is the most general form of existence checking convenience method, others are implemented in terms of it. It's very similar to aggregate:as:where:, but simpler."

	| q expression next objectExpression |
	"We may be passed an expression corresponding to either a field, or to a full object, depending on the aggregate function. In either case, build backwards from the first full object"
	objectExpression := anExpression mapping isRelationship 
		ifTrue: [anExpression] ifFalse: [anExpression base].
	q := Query read: objectExpression mapping referenceClass.
	expression := q baseExpression.
	next := objectExpression.
	[next base isNil] whileFalse: [
		expression := next mapping addPhantomMappingExpressionOn: expression.
		next := next base].
	"We have to force construct the equality expression, because we don't want 'self' rebuilt onto the other base"
	expression := RelationExpression new outerJoin: false; relation: #=; leftChild: expression; rightChild: self.
	q whereClause: expression.
	"Just read back a literal constant, we don't actually care about the data"
	q retrieve: ([:each | 'x' ] asGlorpExpression getFunction: #distinct withArguments: #()).
	^self get: functionName withArguments: (Array with: (q asGlorpExpressionOn: self ultimateBaseExpression)).